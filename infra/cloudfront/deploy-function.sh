#!/bin/bash
# Deploy CloudFront Function: trailing-slash 301 redirect
#
# Idempotent: tworzy/aktualizuje funkcję, testuje, publikuje LIVE,
# asocjuje z viewer-request na default behavior dystrybucji.

set -euo pipefail

FUNCTION_NAME="licencjackie-trailing-slash-301"
DISTRIBUTION_ID="E35P5HJR5VHDCE"
COMMENT="301 redirect for trailing slash (replaces S3 website 302)"
HERE="$(cd "$(dirname "$0")" && pwd)"
CODE_FILE="${HERE}/trailing-slash-301.js"
EVENT_FILE="${HERE}/test-event.json"

# Plik z eventem testowym (CF Functions wymaga fileb://)
cat > "$EVENT_FILE" <<'JSON'
{
  "version": "1.0",
  "context": {
    "distributionDomainName": "www.licencjackie.pl",
    "distributionId": "E35P5HJR5VHDCE",
    "eventType": "viewer-request",
    "requestId": "test-request-id"
  },
  "viewer": { "ip": "1.1.1.1" },
  "request": {
    "method": "GET",
    "uri": "/blog/test-page",
    "querystring": {},
    "headers": { "host": { "value": "www.licencjackie.pl" } },
    "cookies": {}
  }
}
JSON

echo "📦 [1/4] Tworzenie / aktualizacja funkcji ${FUNCTION_NAME}..."

if aws cloudfront describe-function --name "$FUNCTION_NAME" --stage DEVELOPMENT >/dev/null 2>&1; then
  ETAG=$(aws cloudfront describe-function --name "$FUNCTION_NAME" --stage DEVELOPMENT --query 'ETag' --output text)
  aws cloudfront update-function \
    --name "$FUNCTION_NAME" \
    --if-match "$ETAG" \
    --function-config "Comment=${COMMENT},Runtime=cloudfront-js-2.0" \
    --function-code "fileb://${CODE_FILE}" >/dev/null
  echo "   ↻ Zaktualizowana (poprzedni ETag=$ETAG)"
else
  aws cloudfront create-function \
    --name "$FUNCTION_NAME" \
    --function-config "Comment=${COMMENT},Runtime=cloudfront-js-2.0" \
    --function-code "fileb://${CODE_FILE}" >/dev/null
  echo "   ✓ Utworzona"
fi

ETAG=$(aws cloudfront describe-function --name "$FUNCTION_NAME" --stage DEVELOPMENT --query 'ETag' --output text)

echo "🧪 [2/4] Test funkcji (TestFunction)..."
set +e
TEST_JSON=$(aws cloudfront test-function \
  --name "$FUNCTION_NAME" \
  --if-match "$ETAG" \
  --stage DEVELOPMENT \
  --event-object "fileb://${EVENT_FILE}" \
  --output json 2>&1)
TEST_RC=$?
set -e

if [ $TEST_RC -ne 0 ]; then
  echo "❌ test-function CLI error:"
  echo "$TEST_JSON"
  rm -f "$EVENT_FILE"
  exit 1
fi

# Wypisz pełny wynik dla diagnozy
echo "   Compute usage: $(echo "$TEST_JSON" | jq -r '.TestResult.ComputeUtilization // "n/a"')%"
ERRORS=$(echo "$TEST_JSON" | jq -r '.TestResult.FunctionErrorMessage // ""')
if [ -n "$ERRORS" ]; then
  echo "❌ Function runtime error: $ERRORS"
  echo "   Logs:"
  echo "$TEST_JSON" | jq -r '.TestResult.FunctionExecutionLogs[]?' | sed 's/^/     /'
  rm -f "$EVENT_FILE"
  exit 1
fi

FUNC_OUT=$(echo "$TEST_JSON" | jq -r '.TestResult.FunctionOutput')
echo "   Output: $(echo "$FUNC_OUT" | head -c 200)..."
if ! echo "$FUNC_OUT" | jq -e '.response.statusCode == 301' >/dev/null 2>&1; then
  echo "❌ Test nie zwrócił 301 dla /blog/test-page. Pełne logi:"
  echo "$TEST_JSON" | jq -r '.TestResult.FunctionExecutionLogs[]?' | sed 's/^/     /'
  rm -f "$EVENT_FILE"
  exit 1
fi
echo "   ✓ Test PASS (301 → $(echo "$FUNC_OUT" | jq -r '.response.headers.location.value'))"

rm -f "$EVENT_FILE"

echo "🚀 [3/4] Publikacja LIVE..."
aws cloudfront publish-function --name "$FUNCTION_NAME" --if-match "$ETAG" >/dev/null
FUNCTION_ARN=$(aws cloudfront describe-function --name "$FUNCTION_NAME" --stage LIVE --query 'FunctionSummary.FunctionMetadata.FunctionARN' --output text)
echo "   ARN: ${FUNCTION_ARN}"

echo "🔗 [4/4] Asocjacja z dystrybucją ${DISTRIBUTION_ID} (default behavior, viewer-request)..."
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

aws cloudfront get-distribution-config --id "$DISTRIBUTION_ID" > "$TMP/full.json"
ETAG_DIST=$(jq -r '.ETag' "$TMP/full.json")

jq '.DistributionConfig
    | .DefaultCacheBehavior.FunctionAssociations = {
        Quantity: 1,
        Items: [{ FunctionARN: "'"$FUNCTION_ARN"'", EventType: "viewer-request" }]
      }' "$TMP/full.json" > "$TMP/config.json"

aws cloudfront update-distribution \
  --id "$DISTRIBUTION_ID" \
  --if-match "$ETAG_DIST" \
  --distribution-config "file://$TMP/config.json" >/dev/null

echo ""
echo "✅ Gotowe. Dystrybucja: InProgress → Deployed (~3-8 min)."
echo "   Weryfikacja:"
echo "   curl -sI https://www.licencjackie.pl/blog/struktura-pracy-licencjackiej | head -3"
echo "   (oczekiwane: HTTP/1.1 301, location: /blog/struktura-pracy-licencjackiej/)"

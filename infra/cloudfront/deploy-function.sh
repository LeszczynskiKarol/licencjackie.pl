#!/bin/bash
# Deploy CloudFront Function: trailing-slash 301 redirect
#
# RUN ONCE (idempotent): tworzy CF function jeśli nie istnieje,
# publikuje LIVE, asocjuje z viewer-request na default behavior
# dystrybucji E35P5HJR5VHDCE.
#
# Po uruchomieniu CloudFront sam podbije status do "Deployed" (~3-8 min).

set -euo pipefail

FUNCTION_NAME="licencjackie-trailing-slash-301"
DISTRIBUTION_ID="E35P5HJR5VHDCE"
COMMENT="301 redirect for trailing slash (replaces S3 website 302)"
CODE_FILE="$(dirname "$0")/trailing-slash-301.js"

echo "📦 [1/4] Tworzenie / aktualizacja funkcji ${FUNCTION_NAME}..."

# Sprawdź czy istnieje
if aws cloudfront describe-function --name "$FUNCTION_NAME" --stage DEVELOPMENT >/dev/null 2>&1; then
  ETAG=$(aws cloudfront describe-function --name "$FUNCTION_NAME" --stage DEVELOPMENT --query 'ETag' --output text)
  aws cloudfront update-function \
    --name "$FUNCTION_NAME" \
    --if-match "$ETAG" \
    --function-config "Comment=${COMMENT},Runtime=cloudfront-js-2.0" \
    --function-code "fileb://${CODE_FILE}" >/dev/null
  echo "   ↻ Zaktualizowana (ETag=$ETAG)"
else
  aws cloudfront create-function \
    --name "$FUNCTION_NAME" \
    --function-config "Comment=${COMMENT},Runtime=cloudfront-js-2.0" \
    --function-code "fileb://${CODE_FILE}" >/dev/null
  echo "   ✓ Utworzona"
fi

echo "🧪 [2/4] Test funkcji (TestFunction)..."
ETAG=$(aws cloudfront describe-function --name "$FUNCTION_NAME" --stage DEVELOPMENT --query 'ETag' --output text)
TEST_EVENT='{"version":"1.0","context":{"distributionId":"'${DISTRIBUTION_ID}'"},"viewer":{"ip":"1.1.1.1"},"request":{"method":"GET","uri":"/blog/test-page","querystring":{},"headers":{"host":{"value":"www.licencjackie.pl"}},"cookies":{}}}'
TEST_RESULT=$(aws cloudfront test-function --name "$FUNCTION_NAME" --if-match "$ETAG" --stage DEVELOPMENT --event-object "$TEST_EVENT" --query 'TestResult.FunctionOutput' --output text)
echo "   Test /blog/test-page → ${TEST_RESULT:0:120}"
if ! echo "$TEST_RESULT" | grep -q '"statusCode":301'; then
  echo "❌ Test nie zwrócił 301. Przerywam."
  exit 1
fi

echo "🚀 [3/4] Publikacja LIVE..."
aws cloudfront publish-function --name "$FUNCTION_NAME" --if-match "$ETAG" >/dev/null
LIVE_ETAG=$(aws cloudfront describe-function --name "$FUNCTION_NAME" --stage LIVE --query 'ETag' --output text)
FUNCTION_ARN=$(aws cloudfront describe-function --name "$FUNCTION_NAME" --stage LIVE --query 'FunctionSummary.FunctionMetadata.FunctionARN' --output text)
echo "   ARN: ${FUNCTION_ARN}"

echo "🔗 [4/4] Asocjacja z dystrybucją ${DISTRIBUTION_ID} (default behavior, viewer-request)..."
# Pobierz aktualny config
TMP=$(mktemp -d)
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

rm -rf "$TMP"

echo ""
echo "✅ Gotowe. Status: InProgress → Deployed (~3-8 min)."
echo "   Test: curl -sI https://www.licencjackie.pl/blog/struktura-pracy-licencjackiej | head -5"
echo "   (oczekiwane: HTTP/1.1 301, location: /blog/struktura-pracy-licencjackiej/)"

#!/bin/bash
# Deploy CloudFront Function: trailing-slash 301 redirect
#
# Idempotent: tworzy/aktualizuje funkcję, testuje, publikuje LIVE,
# asocjuje z viewer-request na default behavior dystrybucji.
#
# Wymagania: aws cli, node (jq NIE jest potrzebne).

set -euo pipefail

FUNCTION_NAME="licencjackie-trailing-slash-301"
DISTRIBUTION_ID="E35P5HJR5VHDCE"
COMMENT="301 redirect for trailing slash (replaces S3 website 302)"
HERE="$(cd "$(dirname "$0")" && pwd)"
# AWS CLI na Windows wymaga ścieżek typu D:/... a nie /d/... (MINGW/Git Bash)
if command -v cygpath >/dev/null 2>&1; then
  HERE_FOR_AWS="$(cygpath -m "$HERE")"
else
  HERE_FOR_AWS="$HERE"
fi
CODE_FILE="${HERE_FOR_AWS}/trailing-slash-301.js"
EVENT_FILE_LOCAL="${HERE}/test-event.json"
EVENT_FILE="${HERE_FOR_AWS}/test-event.json"

# Helper: wyciąga pole z JSON-a stdin (bez jq)
# Użycie: echo "$JSON" | json_get "path.to.field"
json_get() {
  node -e "
    let data = '';
    process.stdin.on('data', c => data += c);
    process.stdin.on('end', () => {
      try {
        const obj = JSON.parse(data);
        const path = process.argv[1].split('.');
        let v = obj;
        for (const k of path) { v = v?.[k]; }
        if (v === undefined || v === null) { process.exit(0); }
        if (typeof v === 'object') console.log(JSON.stringify(v));
        else console.log(v);
      } catch(e) { console.error('json_get error:', e.message); process.exit(1); }
    });
  " "$1"
}

# Plik z eventem testowym
cat > "$EVENT_FILE_LOCAL" <<'JSON'
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
  rm -f "$EVENT_FILE_LOCAL"
  exit 1
fi

# Wypisz wynik
COMPUTE=$(echo "$TEST_JSON" | json_get "TestResult.ComputeUtilization")
echo "   Compute usage: ${COMPUTE:-n/a}%"

ERRORS=$(echo "$TEST_JSON" | json_get "TestResult.FunctionErrorMessage")
if [ -n "${ERRORS:-}" ]; then
  echo "❌ Function runtime error: $ERRORS"
  echo "   Logs:"
  echo "$TEST_JSON" | node -e "
    let d=''; process.stdin.on('data',c=>d+=c); process.stdin.on('end',()=>{
      try { const o = JSON.parse(d); (o.TestResult?.FunctionExecutionLogs||[]).forEach(l=>console.log('     '+l)); } catch(e){}
    });
  "
  rm -f "$EVENT_FILE_LOCAL"
  exit 1
fi

FUNC_OUT=$(echo "$TEST_JSON" | json_get "TestResult.FunctionOutput")
echo "   Output: $(echo "$FUNC_OUT" | head -c 200)..."

# Walidacja: czy zwrócił 301?
STATUS=$(echo "$FUNC_OUT" | json_get "response.statusCode")
if [ "${STATUS:-}" != "301" ]; then
  echo "❌ Test nie zwrócił 301 dla /blog/test-page (zwrócił: ${STATUS:-brak})."
  echo "$TEST_JSON" | node -e "
    let d=''; process.stdin.on('data',c=>d+=c); process.stdin.on('end',()=>{
      try { const o = JSON.parse(d); (o.TestResult?.FunctionExecutionLogs||[]).forEach(l=>console.log('     '+l)); } catch(e){}
    });
  "
  rm -f "$EVENT_FILE_LOCAL"
  exit 1
fi

LOCATION=$(echo "$FUNC_OUT" | json_get "response.headers.location.value")
echo "   ✓ Test PASS (301 → ${LOCATION})"

rm -f "$EVENT_FILE_LOCAL"

echo "🚀 [3/4] Publikacja LIVE..."
aws cloudfront publish-function --name "$FUNCTION_NAME" --if-match "$ETAG" >/dev/null
FUNCTION_ARN=$(aws cloudfront describe-function --name "$FUNCTION_NAME" --stage LIVE --query 'FunctionSummary.FunctionMetadata.FunctionARN' --output text)
echo "   ARN: ${FUNCTION_ARN}"

echo "🔗 [4/4] Asocjacja z dystrybucją ${DISTRIBUTION_ID} (default behavior, viewer-request)..."
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
if command -v cygpath >/dev/null 2>&1; then
  TMP_FOR_AWS="$(cygpath -m "$TMP")"
else
  TMP_FOR_AWS="$TMP"
fi

aws cloudfront get-distribution-config --id "$DISTRIBUTION_ID" > "$TMP/full.json"
ETAG_DIST=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$TMP_FOR_AWS/full.json','utf8')).ETag)")

# Wstrzykuje FunctionAssociations bez nadpisywania reszty configa
node -e "
  const fs = require('fs');
  const full = JSON.parse(fs.readFileSync('$TMP_FOR_AWS/full.json','utf8'));
  const cfg = full.DistributionConfig;
  cfg.DefaultCacheBehavior.FunctionAssociations = {
    Quantity: 1,
    Items: [{ FunctionARN: '$FUNCTION_ARN', EventType: 'viewer-request' }]
  };
  fs.writeFileSync('$TMP_FOR_AWS/config.json', JSON.stringify(cfg));
"

aws cloudfront update-distribution \
  --id "$DISTRIBUTION_ID" \
  --if-match "$ETAG_DIST" \
  --distribution-config "file://${TMP_FOR_AWS}/config.json" >/dev/null

echo ""
echo "✅ Gotowe. Dystrybucja: InProgress → Deployed (~3-8 min)."
echo "   Weryfikacja po deploy:"
echo "   curl -sI https://www.licencjackie.pl/blog/struktura-pracy-licencjackiej | head -3"
echo "   (oczekiwane: HTTP/1.1 301, location: /blog/struktura-pracy-licencjackiej/)"

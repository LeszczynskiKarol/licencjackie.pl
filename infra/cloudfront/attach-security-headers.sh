#!/bin/bash
# Tworzy/aktualizuje CloudFront Response Headers Policy z security headers
# i przypina ją do default behavior dystrybucji E35P5HJR5VHDCE.
#
# Idempotent: jeśli policy o nazwie 'licencjackie-security-headers' istnieje,
# pobiera jej ID; w przeciwnym razie ją tworzy. Następnie wstrzykuje
# ResponseHeadersPolicyId w default behavior bez nadpisywania pozostałych pól.
#
# Headers:
#   Strict-Transport-Security: max-age=63072000; includeSubDomains; preload  (2 lata)
#   X-Content-Type-Options: nosniff
#   Referrer-Policy: strict-origin-when-cross-origin
#   X-Frame-Options: SAMEORIGIN
#
# Wymagania: aws cli, node.

set -euo pipefail

POLICY_NAME="licencjackie-security-headers"
DISTRIBUTION_ID="E35P5HJR5VHDCE"
HERE="$(cd "$(dirname "$0")" && pwd)"
if command -v cygpath >/dev/null 2>&1; then
  HERE_FOR_AWS="$(cygpath -m "$HERE")"
else
  HERE_FOR_AWS="$HERE"
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
if command -v cygpath >/dev/null 2>&1; then
  TMP_FOR_AWS="$(cygpath -m "$TMP")"
else
  TMP_FOR_AWS="$TMP"
fi

# JSON config policy (tworzony w temp file; CLI wymaga file://)
cat > "$TMP/policy.json" <<'JSON'
{
  "Name": "licencjackie-security-headers",
  "Comment": "HSTS + nosniff + referrer-policy + frame-options for licencjackie.pl",
  "SecurityHeadersConfig": {
    "StrictTransportSecurity": {
      "Override": true,
      "AccessControlMaxAgeSec": 63072000,
      "IncludeSubdomains": true,
      "Preload": true
    },
    "ContentTypeOptions": {
      "Override": true
    },
    "ReferrerPolicy": {
      "Override": true,
      "ReferrerPolicy": "strict-origin-when-cross-origin"
    },
    "FrameOptions": {
      "Override": true,
      "FrameOption": "SAMEORIGIN"
    }
  }
}
JSON

echo "📦 [1/3] Tworzenie / pobieranie policy ${POLICY_NAME}..."

# Szukamy istniejącej policy po nazwie
EXISTING=$(aws cloudfront list-response-headers-policies --output json 2>/dev/null \
  | node -e "
    let d=''; process.stdin.on('data',c=>d+=c); process.stdin.on('end',()=>{
      try {
        const o = JSON.parse(d);
        const items = o.ResponseHeadersPolicyList?.Items || [];
        const hit = items.find(i => i.ResponseHeadersPolicy?.ResponseHeadersPolicyConfig?.Name === '${POLICY_NAME}');
        if (hit) console.log(hit.ResponseHeadersPolicy.Id);
      } catch(e) { process.exit(1); }
    });
  ")

if [ -n "$EXISTING" ]; then
  POLICY_ID="$EXISTING"
  echo "   ↻ Policy istnieje, ID=${POLICY_ID}"
else
  CREATE_OUT=$(aws cloudfront create-response-headers-policy \
    --response-headers-policy-config "file://${TMP_FOR_AWS}/policy.json" \
    --output json)
  POLICY_ID=$(echo "$CREATE_OUT" | node -e "
    let d=''; process.stdin.on('data',c=>d+=c); process.stdin.on('end',()=>{
      console.log(JSON.parse(d).ResponseHeadersPolicy.Id);
    });
  ")
  echo "   ✓ Policy utworzona, ID=${POLICY_ID}"
fi

echo "🔗 [2/3] Pobieranie konfiguracji dystrybucji ${DISTRIBUTION_ID}..."
aws cloudfront get-distribution-config --id "$DISTRIBUTION_ID" > "$TMP/full.json"

ETAG_DIST=$(node -e "
  console.log(JSON.parse(require('fs').readFileSync('${TMP_FOR_AWS}/full.json','utf8')).ETag);
")

# Sprawdź czy już przypięta — uniknij niepotrzebnego update
ALREADY=$(node -e "
  const o = JSON.parse(require('fs').readFileSync('${TMP_FOR_AWS}/full.json','utf8'));
  console.log(o.DistributionConfig.DefaultCacheBehavior.ResponseHeadersPolicyId || '');
")

if [ "$ALREADY" = "$POLICY_ID" ]; then
  echo "   ✓ Policy już przypięta do default behavior — nic do roboty."
  exit 0
fi

echo "   Aktualnie przypięta policy: '${ALREADY:-(brak)}'  →  podmieniam na ${POLICY_ID}"

# Wstrzykujemy ResponseHeadersPolicyId, zachowując pozostały config
node -e "
  const fs = require('fs');
  const full = JSON.parse(fs.readFileSync('${TMP_FOR_AWS}/full.json','utf8'));
  full.DistributionConfig.DefaultCacheBehavior.ResponseHeadersPolicyId = '${POLICY_ID}';
  fs.writeFileSync('${TMP_FOR_AWS}/config.json', JSON.stringify(full.DistributionConfig));
"

echo "🚀 [3/3] Update dystrybucji..."
aws cloudfront update-distribution \
  --id "$DISTRIBUTION_ID" \
  --if-match "$ETAG_DIST" \
  --distribution-config "file://${TMP_FOR_AWS}/config.json" >/dev/null

echo ""
echo "✅ Gotowe. Dystrybucja: InProgress → Deployed (~3-8 min)."
echo "   Weryfikacja po deploy:"
echo "   curl -sI https://www.licencjackie.pl/ | grep -iE 'strict-transport|x-content-type|referrer-policy|x-frame'"

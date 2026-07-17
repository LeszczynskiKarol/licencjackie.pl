#!/usr/bin/env bash
# Buduje stronę promo (PDF) i dokleja ją na koniec każdego wzoru w public/pobierz/.
# Pomija oświadczenie o samodzielności (formalny dokument do podpisu).
# Idempotentność: uruchamiać tylko na PDF-ach bez strony promo (skrypt sam NIE wykrywa duplikatów).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
POBIERZ="$ROOT/public/pobierz"
PROMO="$HERE/promo-licencjackie.pdf"

echo "→ Buduję stronę promo"
pandoc "$HERE/promo-page.md" \
  --pdf-engine=xelatex \
  -H "$HERE/header.tex" \
  --lua-filter="$HERE/center.lua" \
  -V lang=pl \
  -o "$PROMO"

for pdf in "$POBIERZ"/*.pdf; do
  base="$(basename "$pdf")"
  if [[ "$base" == oswiadczenie* ]]; then
    echo "– pomijam: $base"
    continue
  fi
  tmp="$(mktemp --suffix=.pdf)"
  pdfunite "$pdf" "$PROMO" "$tmp"
  mv "$tmp" "$pdf"
  echo "✓ $base"
done
echo "Gotowe."

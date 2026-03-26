#!/bin/bash
S3_BUCKET="www.licencjackie.pl"
CLOUDFRONT_ID="E35P5HJR5VHDCE"

cd /d/licencjackie.pl

echo "============================================"
echo " Deploy: licencjackie.pl"
echo " Region: $REGION"
echo "============================================"
echo ""


echo "📦 Pushing to GitHub..."
git add .
git commit -m "git push from local"
git push origin main

if [ $? -ne 0 ]; then
  echo "❌ Git push failed!"
  exit 1
fi


npm run build
aws s3 sync dist/ s3://${S3_BUCKET} --delete
aws cloudfront create-invalidation --distribution-id ${CLOUDFRONT_ID} --paths "/*"
echo "✅ Deployed to https://www.licencjackie.pl"

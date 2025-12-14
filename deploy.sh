#!/bin/bash
S3_BUCKET="www.licencjackie.pl"
CLOUDFRONT_ID="E35P5HJR5VHDCE"

cd /d/licencjackie.pl
npm run build
aws s3 sync dist/ s3://${S3_BUCKET} --delete
aws cloudfront create-invalidation --distribution-id ${CLOUDFRONT_ID} --paths "/*"
echo "✅ Deployed to https://www.licencjackie.pl"

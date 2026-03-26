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

# Generate sitemap.xml post-build
node -e "
const fs = require('fs');
const path = require('path');
const site = 'https://www.licencjackie.pl';
const dist = './dist';

function getPages(dir, base = '') {
  let pages = [];
  for (const f of fs.readdirSync(dir, {withFileTypes: true})) {
    if (f.isDirectory()) pages.push(...getPages(path.join(dir, f.name), base + '/' + f.name));
    else if (f.name === 'index.html') pages.push(base + '/');
  }
  return pages;
}

const pages = getPages(dist)
  .filter(p => !p.includes('/category/') && !p.match(/^\/(ankieta|badania|bibliografia|konspekt|materialy|obrona|pisanie-prac|podsumowanie|przypisy|statystyka|streszczenie|struktura|temat|wstep|wybor|znaczenie|analiza)/))
  .sort();

const xml = '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n' +
  pages.map(p => '  <url><loc>' + site + p + '</loc></url>').join('\n') + '\n</urlset>';

fs.writeFileSync('./dist/sitemap-0.xml', xml);
fs.writeFileSync('./dist/sitemap-index.xml',
  '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n  <sitemap><loc>' + site + '/sitemap-0.xml</loc></sitemap>\n</sitemapindex>');
console.log('✅ Sitemap generated: ' + pages.length + ' pages');
"

aws s3 sync dist/ s3://${S3_BUCKET} --delete
aws cloudfront create-invalidation --distribution-id ${CLOUDFRONT_ID} --paths "/*"
echo "✅ Deployed to https://www.licencjackie.pl"

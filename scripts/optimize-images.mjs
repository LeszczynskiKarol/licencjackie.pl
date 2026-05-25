// scripts/optimize-images.mjs
//
// Optymalizacja obrazów blogowych:
//   - public/blog/*.jpg → resize do 1200×630 (cover/center), re-kompresja q=85
//   - public/blog/*.webp ← wygenerowane z tych samych JPG, q=82
//
// Idempotent: jeśli .orig/ ma już backup, nie nadpisujemy oryginału ponownie.
// Po pierwszym uruchomieniu .orig/ trzyma niezmienione źródła (gitignored).
//
// Uruchomienie: `node scripts/optimize-images.mjs` (autorun w `npm run prebuild`).

import { readdir, stat, mkdir, copyFile, access } from "node:fs/promises";
import path from "node:path";
import sharp from "sharp";

const ROOT = process.cwd();
const BLOG_DIR = path.join(ROOT, "public/blog");
const ORIG_DIR = path.join(BLOG_DIR, ".orig");

const WIDTH = 1200;
const HEIGHT = 630;
const JPG_QUALITY = 85;
const WEBP_QUALITY = 82;

await mkdir(ORIG_DIR, { recursive: true });

const files = await readdir(BLOG_DIR);
const jpgs = files.filter(
  (f) => f.toLowerCase().endsWith(".jpg") || f.toLowerCase().endsWith(".jpeg"),
);

let totalSaved = 0;
let processed = 0;

for (const file of jpgs) {
  const jpgPath = path.join(BLOG_DIR, file);
  const origPath = path.join(ORIG_DIR, file);
  const stem = file.replace(/\.jpe?g$/i, "");
  const webpPath = path.join(BLOG_DIR, `${stem}.webp`);

  // 1) Backup oryginału (jednorazowo)
  let origExists = false;
  try {
    await access(origPath);
    origExists = true;
  } catch {}

  if (!origExists) {
    await copyFile(jpgPath, origPath);
  }

  // 2) Czy webp istnieje i jest nowszy niż backup → skip
  let needsRegen = true;
  try {
    const [webpStat, origStat] = await Promise.all([
      stat(webpPath),
      stat(origPath),
    ]);
    if (webpStat.mtimeMs >= origStat.mtimeMs) needsRegen = false;
  } catch {}

  if (!needsRegen) continue;

  const sizeBefore = (await stat(jpgPath)).size;

  // 3) Resize + re-kompresja JPG (na bazie backupu, nie zoptymalizowanego pliku)
  await sharp(origPath)
    .resize(WIDTH, HEIGHT, { fit: "cover", position: "center" })
    .jpeg({ quality: JPG_QUALITY, mozjpeg: true })
    .toFile(jpgPath + ".tmp");
  await sharp(origPath)
    .resize(WIDTH, HEIGHT, { fit: "cover", position: "center" })
    .webp({ quality: WEBP_QUALITY })
    .toFile(webpPath);

  // atomic rename (sharp blokowałby plik gdyby pisał na siebie)
  const fs = await import("node:fs/promises");
  await fs.rename(jpgPath + ".tmp", jpgPath);

  const sizeAfter = (await stat(jpgPath)).size;
  const webpSize = (await stat(webpPath)).size;
  const saved = sizeBefore - sizeAfter;
  totalSaved += saved;
  processed++;

  console.log(
    `  ${file}: ${(sizeBefore / 1024).toFixed(0)}KB → JPG ${(sizeAfter / 1024).toFixed(0)}KB + WebP ${(webpSize / 1024).toFixed(0)}KB  (saved ${(saved / 1024).toFixed(0)}KB)`,
  );
}

console.log(
  `\n✓ Przetworzono ${processed} obrazów. Łącznie zaoszczędzono: ${(totalSaved / 1024 / 1024).toFixed(2)} MB.`,
);
console.log(`  Backup oryginałów: ${ORIG_DIR} (gitignored)`);

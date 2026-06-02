import sitemap from "@astrojs/sitemap";
import tailwind from "@astrojs/tailwind";
import { defineConfig } from "astro/config";

export default defineConfig({
  site: "https://www.licencjackie.pl",
  integrations: [
    tailwind(),
    sitemap({
      changefreq: "weekly",
      priority: 0.7,
      lastmod: new Date(),
      filter: (page) => !/\/ebook\/(sukces|anulowano)\/?$/.test(page),
    }),
  ],
  output: "static",
  trailingSlash: "always",
  build: { format: "directory" },

  // Legacy redirects (stare WP URLs, literówki, kategorie) zostały przeniesione
  // do CloudFront Function: infra/cloudfront/trailing-slash-301.js
  // Powód: Astro static redirects generują pliki HTML z meta-refresh (HTTP 200),
  // co dla SEO daje słabszy sygnał niż HTTP 301 i wymusza dodatkowy hop dla
  // targetów bez trailing slash. CF Function = pojedynczy 301 z trailing slash.
});

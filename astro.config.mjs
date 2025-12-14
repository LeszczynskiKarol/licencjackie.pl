import tailwind from "@astrojs/tailwind";
import { defineConfig } from "astro/config";

export default defineConfig({
  site: "https://licencjackie.pl",
  integrations: [tailwind()],
  output: "static",

  redirects: {
    // === ARTYKUŁY (66) ===
    "/ankieta-w-pracy-magisterskiej/": "/blog/ankieta-w-pracy-magisterskiej",
    "/badania-w-pracy-magisterskiej/": "/blog/badania-w-pracy-magisterskiej",
    "/bibliografia-pracy-licencjackiej/":
      "/blog/bibliografia-pracy-licencjackiej",
    "/bibliografia-w-pracy-magisterskiej/":
      "/blog/bibliografia-w-pracy-magisterskiej",
    "/konspekt-pracy-dyplomowej/": "/blog/konspekt-pracy-dyplomowej",
    "/konspekt-pracy-magisterskiej/": "/blog/konspekt-pracy-magisterskiej",
    "/materialy-do-pracy-magisterskiej/":
      "/blog/materialy-do-pracy-magisterskiej",
    "/obrona-pracy-licencjackiej/": "/blog/obrona-pracy-licencjackiej",
    "/pisanie-pracy-dyplomowej/": "/blog/pisanie-pracy-dyplomowej",
    "/podsumowanie-pracy-licencjackiej/":
      "/blog/podsumowanie-pracy-licencjackiej",
    "/przypisy-w-pracy-magisterskiej/": "/blog/przypisy-w-pracy-magisterskiej",
    "/statystyka-praca-licencjacka/": "/blog/statystyka-praca-licencjacka",
    "/streszczenie-pracy-magisterskiej/":
      "/blog/streszczenie-pracy-magisterskiej",
    "/struktura-pracy-licencjackiej/": "/blog/struktura-pracy-licencjackiej",
    "/temat-pracy-licencjackiej/": "/blog/temat-pracy-licencjackiej",
    "/temat-pracy-magisterskiej/": "/blog/temat-pracy-magisterskiej",
    "/wstep-pracy-licencjackiej/": "/blog/wstep-pracy-licencjackiej",
    "/wybor-tematu-pracy-dyplomowej/": "/blog/wybor-tematu-pracy-dyplomowej",
    "/znaczenie-i-rola-bibliografii/": "/blog/znaczenie-i-rola-bibliografii",
    "/analiza-i-ocena-zrodel/": "/blog/analiza-i-ocena-zrodel",

    // Kierunki
    "/pisanie-prac-magisterskich-z-administracji/":
      "/blog/pisanie-prac-magisterskich-z-administracji",
    "/pisanie-prac-magisterskich-z-bezpieczenstwa-wewnetrznego/":
      "/blog/pisanie-prac-magisterskich-z-bezpieczenstwa-wewnetrznego",
    "/pisanie-prac-magisterskich-z-dietetyki/":
      "/blog/pisanie-prac-magisterskich-z-dietetyki",
    "/pisanie-prac-magisterskich-z-geografii/":
      "/blog/pisanie-prac-magisterskich-z-geografii",
    "/pisanie-prac-magisterskich-z-historii/":
      "/blog/pisanie-prac-magisterskich-z-historii",
    "/pisanie-prac-magisterskich-z-kosmetologii/":
      "/blog/pisanie-prac-magisterskich-z-kosmetologii",
    "/pisanie-prac-magisterskich-z-kryminologii/":
      "/blog/pisanie-prac-magisterskich-z-kryminologii",
    "/pisanie-prac-magisterskich-z-logistyki/":
      "/blog/pisanie-prac-magisterskich-z-logistyki",
    "/pisanie-prac-magisterskich-z-marketingu/":
      "/blog/pisanie-prac-magisterskich-z-marketingu",
    "/pisanie-prac-magisterskich-z-pedagogiki/":
      "/blog/pisanie-prac-magisterskich-z-pedagogiki",
    "/pisanie-prac-magisterskich-z-pielegniarstwa/":
      "/blog/pisanie-prac-magisterskich-z-pielegniarstwa",
    "/pisanie-prac-magisterskich-z-politologii/":
      "/blog/pisanie-prac-magisterskich-z-politologii",
    "/pisanie-prac-magisterskich-z-prawa/":
      "/blog/pisanie-prac-magisterskich-z-prawa",
    "/pisanie-prac-magisterskich-z-psychologii/":
      "/blog/pisanie-prac-magisterskich-z-psychologii",
    "/pisanie-prac-magisterskich-z-ratownictwa-medycznego/":
      "/blog/pisanie-prac-magisterskich-z-ratownictwa-medycznego",
    "/pisanie-prac-magisterskich-z-socjologii/":
      "/blog/pisanie-prac-magisterskich-z-socjologii",
    "/pisanie-prac-magisterskich-z-turystyki/":
      "/blog/pisanie-prac-magisterskich-z-turystyki",
    "/pisanie-prac-magisterskich-z-zarzadzania/":
      "/blog/pisanie-prac-magisterskich-z-zarzadzania",

    // === KATEGORIE WP → ASTRO ===
    "/category/praca-licencjacka/": "/blog/kategoria/poradniki",
    "/category/praca-magisterska/": "/blog/kategoria/poradniki",
    "/category/praca-magisterska-2/": "/blog/kategoria/poradniki",
    "/category/obrona-pracy-licencjackiej/": "/blog/kategoria/obrona-pracy",
    "/category/statystyka-w-pracy-licencjackiej/":
      "/blog/kategoria/metodologia",
    "/category/tematy-prac-licencjackich/":
      "/blog/kategoria/tematy-prac-licencjackich",
    "/category/tematy-prac-licencjackich-z-administracji/":
      "/blog/kategoria/pisanie-prac-z-administracji",
    "/category/tematy-prac-licencjackich/tematy-parc-z-pielegniarstwa/":
      "/blog/kategoria/pisanie-prac-z-pielegniarstwa",
    "/category/tematy-prac-licencjackich/tematy-prac-z-historii/":
      "/blog/kategoria/pisanie-prac-z-historii",
    "/category/tematy-prac-licencjackich/tematy-prac-z-pedagogiki/":
      "/blog/kategoria/pisanie-prac-z-pedagogiki",
    "/category/tematy-prac-licencjackich/tematy-prac-z-prawa/":
      "/blog/kategoria/pisanie-prac-z-prawa",
    "/category/tematy-prac-licencjackich/tematy-prac-z-psychologii/":
      "/blog/kategoria/pisanie-prac-z-psychologii",
    "/category/baza-serwisow/": "/blog",
  },
});

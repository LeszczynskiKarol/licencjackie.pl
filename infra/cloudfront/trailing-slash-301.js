// CloudFront Function (viewer-request)
// Wymusza 301 redirect:
//  1) apex licencjackie.pl → www.licencjackie.pl
//  2) Legacy URLs (stare WP + literówki) → docelowe /blog/... (single-hop, z trailing slash)
//  3) URL bez trailing slash → URL z trailing slash (pomija pliki z rozszerzeniem)
//
// Replaces S3 website endpoint's default 302 with proper 301 (SEO-friendly).
// Mapa REDIRECTS zastępuje wcześniejsze meta-refresh stuby z `astro.config.mjs`
// (jeden 301 zamiast 200+meta-refresh → 301).

var REDIRECTS = {
  // === literówki w slugach ===
  "/blog/finanse-i-rachonkowosc-tematy-mgr/": "/blog/finanse-i-rachunkowosc-tematy-mgr/",
  "/blog/socjlogia-tematy-mgr/": "/blog/socjologia-tematy-mgr/",
  "/blog/pisanie-prac-licencjackich-z-zarządzania/": "/blog/pisanie-prac-licencjackich-z-zarzadzania/",

  // === ARTYKUŁY (stare WP → /blog/) ===
  "/ankieta-w-pracy-magisterskiej/": "/blog/ankieta-w-pracy-magisterskiej/",
  "/badania-w-pracy-magisterskiej/": "/blog/badania-w-pracy-magisterskiej/",
  "/bibliografia-pracy-licencjackiej/": "/blog/bibliografia-pracy-licencjackiej/",
  "/bibliografia-w-pracy-magisterskiej/": "/blog/bibliografia-w-pracy-magisterskiej/",
  "/konspekt-pracy-dyplomowej/": "/blog/konspekt-pracy-dyplomowej/",
  "/konspekt-pracy-magisterskiej/": "/blog/konspekt-pracy-magisterskiej/",
  "/materialy-do-pracy-magisterskiej/": "/blog/materialy-do-pracy-magisterskiej/",
  "/obrona-pracy-licencjackiej/": "/blog/obrona-pracy-licencjackiej/",
  "/pisanie-pracy-dyplomowej/": "/blog/pisanie-pracy-dyplomowej/",
  "/podsumowanie-pracy-licencjackiej/": "/blog/podsumowanie-pracy-licencjackiej/",
  "/przypisy-w-pracy-magisterskiej/": "/blog/przypisy-w-pracy-magisterskiej/",
  "/statystyka-praca-licencjacka/": "/blog/statystyka-praca-licencjacka/",
  "/streszczenie-pracy-magisterskiej/": "/blog/streszczenie-pracy-magisterskiej/",
  "/struktura-pracy-licencjackiej/": "/blog/struktura-pracy-licencjackiej/",
  "/temat-pracy-licencjackiej/": "/blog/temat-pracy-licencjackiej/",
  "/temat-pracy-magisterskiej/": "/blog/temat-pracy-magisterskiej/",
  "/wstep-pracy-licencjackiej/": "/blog/wstep-pracy-licencjackiej/",
  "/wybor-tematu-pracy-dyplomowej/": "/blog/wybor-tematu-pracy-dyplomowej/",
  "/znaczenie-i-rola-bibliografii/": "/blog/znaczenie-i-rola-bibliografii/",
  "/analiza-i-ocena-zrodel/": "/blog/analiza-i-ocena-zrodel/",

  // === Kierunki (stare WP) ===
  "/pisanie-prac-magisterskich-z-administracji/": "/blog/pisanie-prac-magisterskich-z-administracji/",
  "/pisanie-prac-magisterskich-z-bezpieczenstwa-wewnetrznego/": "/blog/pisanie-prac-magisterskich-z-bezpieczenstwa-wewnetrznego/",
  "/pisanie-prac-magisterskich-z-dietetyki/": "/blog/pisanie-prac-magisterskich-z-dietetyki/",
  "/pisanie-prac-magisterskich-z-geografii/": "/blog/pisanie-prac-magisterskich-z-geografii/",
  "/pisanie-prac-magisterskich-z-historii/": "/blog/pisanie-prac-magisterskich-z-historii/",
  "/pisanie-prac-magisterskich-z-kosmetologii/": "/blog/pisanie-prac-magisterskich-z-kosmetologii/",
  "/pisanie-prac-magisterskich-z-kryminologii/": "/blog/pisanie-prac-magisterskich-z-kryminologii/",
  "/pisanie-prac-magisterskich-z-logistyki/": "/blog/pisanie-prac-magisterskich-z-logistyki/",
  "/pisanie-prac-magisterskich-z-marketingu/": "/blog/pisanie-prac-magisterskich-z-marketingu/",
  "/pisanie-prac-magisterskich-z-pedagogiki/": "/blog/pisanie-prac-magisterskich-z-pedagogiki/",
  "/pisanie-prac-magisterskich-z-pielegniarstwa/": "/blog/pisanie-prac-magisterskich-z-pielegniarstwa/",
  "/pisanie-prac-magisterskich-z-politologii/": "/blog/pisanie-prac-magisterskich-z-politologii/",
  "/pisanie-prac-magisterskich-z-prawa/": "/blog/pisanie-prac-magisterskich-z-prawa/",
  "/pisanie-prac-magisterskich-z-psychologii/": "/blog/pisanie-prac-magisterskich-z-psychologii/",
  "/pisanie-prac-magisterskich-z-ratownictwa-medycznego/": "/blog/pisanie-prac-magisterskich-z-ratownictwa-medycznego/",
  "/pisanie-prac-magisterskich-z-socjologii/": "/blog/pisanie-prac-magisterskich-z-socjologii/",
  "/pisanie-prac-magisterskich-z-turystyki/": "/blog/pisanie-prac-magisterskich-z-turystyki/",
  "/pisanie-prac-magisterskich-z-zarzadzania/": "/blog/pisanie-prac-magisterskich-z-zarzadzania/",

  // === Kategorie WP → Astro ===
  "/category/praca-licencjacka/": "/blog/kategoria/poradniki/",
  "/category/praca-magisterska/": "/blog/kategoria/poradniki/",
  "/category/praca-magisterska-2/": "/blog/kategoria/poradniki/",
  "/category/obrona-pracy-licencjackiej/": "/blog/kategoria/obrona-pracy/",
  "/category/statystyka-w-pracy-licencjackiej/": "/blog/kategoria/metodologia/",
  "/category/tematy-prac-licencjackich/": "/blog/kategoria/tematy-prac-licencjackich/",
  "/category/tematy-prac-licencjackich-z-administracji/": "/blog/kategoria/pisanie-prac-z-administracji/",
  "/category/tematy-prac-licencjackich/tematy-parc-z-pielegniarstwa/": "/blog/kategoria/pisanie-prac-z-pielegniarstwa/",
  "/category/tematy-prac-licencjackich/tematy-prac-z-historii/": "/blog/kategoria/pisanie-prac-z-historii/",
  "/category/tematy-prac-licencjackich/tematy-prac-z-pedagogiki/": "/blog/kategoria/pisanie-prac-z-pedagogiki/",
  "/category/tematy-prac-licencjackich/tematy-prac-z-prawa/": "/blog/kategoria/pisanie-prac-z-prawa/",
  "/category/tematy-prac-licencjackich/tematy-prac-z-psychologii/": "/blog/kategoria/pisanie-prac-z-psychologii/",
  "/category/baza-serwisow/": "/blog/",
};

function handler(event) {
  var request = event.request;
  var uri = request.uri;
  var host = request.headers.host && request.headers.host.value;

  // Zbuduj querystring 1:1 (CF Function input)
  var qs = "";
  if (request.querystring) {
    var parts = [];
    for (var k in request.querystring) {
      var v = request.querystring[k];
      if (v.multiValue) {
        for (var i = 0; i < v.multiValue.length; i++) {
          parts.push(k + "=" + v.multiValue[i].value);
        }
      } else if (v.value !== undefined) {
        parts.push(v.value === "" ? k : k + "=" + v.value);
      }
    }
    if (parts.length) qs = "?" + parts.join("&");
  }

  // 1) apex → www
  if (host && host === "licencjackie.pl") {
    return {
      statusCode: 301,
      statusDescription: "Moved Permanently",
      headers: {
        location: {
          value: "https://www.licencjackie.pl" + uri + qs,
        },
      },
    };
  }

  // 2) Legacy redirects (single-hop 301)
  if (REDIRECTS[uri]) {
    return {
      statusCode: 301,
      statusDescription: "Moved Permanently",
      headers: {
        location: { value: REDIRECTS[uri] + qs },
      },
    };
  }

  // 3) Pominięcie plików z rozszerzeniem (np. .xml, .jpg, .css, .js, .ico)
  var lastSegment = uri.split("/").pop();
  if (lastSegment.indexOf(".") !== -1) {
    return request;
  }

  // 4) URL bez trailing slash → 301 do wersji z trailing slash
  if (uri.length > 1 && !uri.endsWith("/")) {
    return {
      statusCode: 301,
      statusDescription: "Moved Permanently",
      headers: {
        location: {
          value: uri + "/" + qs,
        },
      },
    };
  }

  return request;
}

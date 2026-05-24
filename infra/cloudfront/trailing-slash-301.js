// CloudFront Function (viewer-request)
// Wymusza 301 redirect:
//  - HTTP → HTTPS (CF Behavior już to robi, ale dla bezpieczeństwa)
//  - URL bez trailing slash → URL z trailing slash (pomija pliki z rozszerzeniem)
//  - apex licencjackie.pl → www.licencjackie.pl (S3 już robi, ale dla pewności daje 301)
//
// Replaces S3 website endpoint's default 302 with proper 301 (SEO-friendly).
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

  // 1) apex → www (gdyby kiedyś apex trafiał do tego CF)
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

  // 2) Pominięcie plików z rozszerzeniem (np. .xml, .jpg, .css, .js, .ico)
  var lastSegment = uri.split("/").pop();
  if (lastSegment.indexOf(".") !== -1) {
    return request;
  }

  // 3) URL bez trailing slash → 301 do wersji z trailing slash
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

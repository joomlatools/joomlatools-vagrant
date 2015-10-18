# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

import std;

backend default {
    .host = "127.0.0.1";
    .port = "8080";
    .probe = {
      .url = "/varnish-enabled";
      .interval = 1s;
      .timeout = 1s;
    }
}

backend alternative {
    .host = "127.0.0.1";
    .port = "8080";
}

sub vcl_recv {
        # Forward client's IP to backend
        unset req.http.X-Forwarded-For;
        set req.http.X-Forwarded-For = client.ip;

        set req.http.X-Forwarded-By = server.ip;
        set req.http.X-Forwarded-Port = 80;

        # Check if we've still enabled Varnish, if not, passthrough every request
        if (! std.healthy(req.backend_hint))
        {
            set req.backend_hint = alternative;
            return (pass);
        }

        # Do not cache phpmyadmin
        if (req.http.host == "phpmyadmin.joomla.box") {
            return (pass);
        }

        # Do not cache system tools on joomla.box:
        if (req.http.host == "joomla.box")
        {
            if (req.url == "/apc" || req.url == "/phpinfo" || req.url == "/pimpmylog") {
                return (pass);
            }
        }

        # Proxy (pass) any request that goes to the backend admin,
        # the banner component links or any post requests
   		# You can add more pages or entire URL structure in the end of the "if"
        if(req.http.cookie ~ "userID" || req.url ~ "^/administrator" || req.url ~ "^/component/banners" || req.method == "POST") {
                return (pass);
        }

        # Check for the custom "x-logged-in" header to identify if the visitor is a guest,
        # then unset any cookie (including session cookies) provided it's not a POST request
        if(req.http.x-logged-in == "False" && req.method != "POST"){
                unset req.http.cookie;
        }

        # Properly handle different encoding types
        if (req.http.Accept-Encoding) {
          if (req.url ~ "\.(jpg|jpeg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|swf)$") {
            # No point in compressing these
            unset req.http.Accept-Encoding;
          } elsif (req.http.Accept-Encoding ~ "gzip") {
            set req.http.Accept-Encoding = "gzip";
          } elsif (req.http.Accept-Encoding ~ "deflate") {
            set req.http.Accept-Encoding = "deflate";
          } else {
            # unknown algorithm (aka crappy browser)
            unset req.http.Accept-Encoding;
          }
        }

		# Cache files with these extensions
        if (req.url ~ "\.(js|css|jpg|jpeg|png|gif|gz|tgz|bz2|tbz|mp3|ogg|swf)$") {
                return (hash);
        }

        return (hash);
}

sub vcl_backend_response {
        # Check for the custom "x-logged-in" header to identify if the visitor is a guest,
        # then unset any cookie (including session cookies) provided it's not a POST request
        set beresp.do_esi = true;

        if(bereq.method != "POST" && beresp.http.x-logged-in == "False") {
                unset beresp.http.Set-Cookie;
        }

        # Allow items to be stale if needed (this value should be the same as with "set req.grace"
        # inside the sub vcl_recv {.} block (the 2nd part of the if/else statement)
        set beresp.grace = 1h;

        # Serve pages from the cache should we get a sudden error and re-check in one minute
        if (beresp.status == 503 || beresp.status == 502 || beresp.status == 501 || beresp.status == 500) {
          set beresp.grace = 60s;
          return (retry);
        }

        # Unset the "etag" header (suggested)
        unset beresp.http.etag;

        # This is Joomla! specific: fix stupid "no-cache" header sent by Joomla! even
        # when caching is on - make sure to replace 300 with the number of seconds that
        # you want the browser to cache content
        if(beresp.http.Cache-Control ~ "no-cache" || beresp.http.Cache-Control == ""){
                set beresp.http.Cache-Control = "max-age=300, public, must-revalidate";
        }

        # This is how long Varnish will cache content
        set beresp.ttl = 1w;

        return (deliver);
}
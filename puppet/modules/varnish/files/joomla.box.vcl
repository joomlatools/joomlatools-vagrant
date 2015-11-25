vcl 4.0;

# This Varnish configuration is a very basic template to get started with caching Joomla sites.
# In no way is this configuration complete: every site is unique and needs customisation!
# For demonstration purposes this VCL will cache all front-end pages (including pages with cookies).

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
            if (req.url ~ "^/apc" || req.url ~ "^/phpinfo" || req.url ~ "^/pimpmylog" || req.url ~ "^/dashboard") {
                return (pass);
            }
        }

        # Do not cache ZendServer endpoint
        if (req.url ~ "^/ZendServer") {
            return (pass);
        }

        # Do not cache POST requests
        if (req.method == "POST") {
            return (pass);
        }

        # Proxy (pass) any request that goes to the backend admin, the banner component links, ..
        if(req.url ~ "/administrator" || req.url ~ "/component/banners" || req.url ~ "/component/users" || req.url ~ "/installation") {
            return (pass);
        }

        # Do not cache if user is logged in
        if (req.http.Authorization || req.http.Authenticate) {
            return (pass);
        }

        # Don't cache ajax requests
        if(req.http.X-Requested-With == "XMLHttpRequest" || req.url ~ "nocache") {
            return (pass);
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

        return (hash);
}

sub vcl_backend_response {
        # Unset the "etag" header (suggested)
        unset beresp.http.etag;

        # This is Joomla! specific: fix stupid "no-cache" header sent by Joomla! even
        # when caching is on - make sure to replace 300 with the number of seconds that
        # you want the browser to cache content
        if(beresp.http.Cache-Control ~ "no-cache" || beresp.http.Cache-Control == ""){
            set beresp.http.Cache-Control = "max-age=300, public, must-revalidate";
        }

        # Check for the custom "x-Logged-In" header to identify if the visitor is a guest,
        # then unset any cookie (including session cookies) provided it's not a POST request.
        if(bereq.method != "POST" && beresp.http.X-Logged-In == "false") {
            unset beresp.http.Set-Cookie;
        }

        # This is how long Varnish will cache content
        set beresp.ttl = 1w;

        return (deliver);
}

sub vcl_hash
{
    hash_data(req.url);

    if (req.http.host) {
        hash_data(req.http.host);
    } else {
        hash_data(server.ip);
    }

    # Hash cookies for requests that have them
    if (req.http.Cookie) {
        hash_data(req.http.Cookie);
    }
}

sub vcl_deliver {
        if (resp.http.x-varnish ~ " ") {
            set resp.http.X-Varnish-Status = "HIT";
        } else {
            set resp.http.X-Varnish-Status = "MISS";
        }

        # Please note that obj.hits behaviour changed in 4.0, now it counts per objecthead, not per object
        # and obj.hits may not be reset in some cases where bans are in use. See bug 1492 for details.
        # So take hits with a grain of salt
        set resp.http.X-Varnish-Hits = obj.hits;
}
server { # full PostgREST, db0 endpoint
        server_name test.pauldellinger.com;
        access_log /var/log/nginx/test.pauldellinger.com.access_log;
        location / {
          proxy_pass http://localhost:3000/; #  PostgREST instance
        }
}

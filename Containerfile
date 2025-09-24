FROM alpine:latest

RUN apk add --no-cache php php-session php-openssl

RUN wget -qO squirrelmail.tar.gz "http://snapshots.squirrelmail.org/squirrelmail-20250924_0200-SVN.stable.tar.gz" && \
    gzip -dck | tar xf - < squirrelmail.tar.gz && \
    rm -f squirrelmail.tar.gz && \
    mv squirrelmail.stable/squirrelmail / && \
    rmdir squirrelmail.stable

RUN mkdir /squirrelmail/data/ || true
RUN mkdir /squirrelmail/attach/ || true

RUN cp squirrelmail/config/config_default.php squirrelmail/config/config.php

COPY config_x.php /squirrelmail/config/

RUN cat /squirrelmail/config/config_x.php >> /squirrelmail/config/config.php

VOLUME ["/squirrelmail/data", "/squirrelmail/attach"]

ENTRYPOINT ["/usr/bin/env", "php", "-S", "0.0.0.0:80", "-t", "/squirrelmail"]

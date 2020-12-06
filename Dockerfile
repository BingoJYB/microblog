FROM python:3.8-alpine

RUN apk update && apk upgrade
RUN apk add --no-cache bash\
    pkgconfig \
    git \
    gcc \
    openldap \
    libcurl \
    python3-dev \
    gpgme-dev \
    libc-dev \
    && rm -rf /var/cache/apk/*

RUN adduser -D microblog

WORKDIR /home/microblog

COPY requirements.txt requirements.txt
RUN python -m venv venv
RUN venv/bin/pip install -r requirements.txt
RUN venv/bin/pip install gunicorn pymysql

COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./
RUN chmod +x boot.sh

ENV FLASK_APP microblog.py

RUN chown -R microblog:microblog ./
USER microblog

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
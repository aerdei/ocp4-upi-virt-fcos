FROM httpd:2.4
RUN apt-get update -y && apt-get install -y net-tools dnsutils curl iputils-ping && rm -rf /var/lib/apt/lists/*
COPY ./public-html/ /usr/local/apache2/htdocs/

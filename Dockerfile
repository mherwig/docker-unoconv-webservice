FROM node:10.4.1-alpine

ENV UNO_URL https://raw.githubusercontent.com/dagwieers/unoconv/release-0.8/unoconv

RUN apk --no-cache add bash \
    git \
    curl \
    msttcorefonts-installer \
    fontconfig \
    libreoffice-common \
    libreoffice-writer \
&& curl -Ls $UNO_URL -o /usr/local/bin/unoconv \
&& chmod +x /usr/local/bin/unoconv \
&& ln -s /usr/bin/python3 /usr/bin/python \
&& rm -rf /var/cache/apk/*

RUN update-ms-fonts && fc-cache -f

RUN git clone https://github.com/mherwig/tfk-api-unoconv.git unoconvservice

WORKDIR /unoconvservice

RUN npm install --production

ENV SERVER_PORT 3000
ENV PAYLOAD_MAX_SIZE 1048576
ENV TIMEOUT_SERVER 120000
ENV TIMEOUT_SOCKET 140000

EXPOSE 3000

ENTRYPOINT /usr/local/bin/unoconv --listener --server=0.0.0.0 --port=2002 & node standalone.js

# Monitor.
FROM alpine:3.15

RUN apk add --no-cache bash curl git bind-tools jq make

RUN mkdir /usr/src
RUN git clone https://github.com/Pupmos/datadog /usr/src/datadog

COPY entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT '/usr/bin/entrypoint.sh'

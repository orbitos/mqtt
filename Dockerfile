FROM alpine:3.14

RUN apk --no-cache add mosquitto mosquitto-clients
EXPOSE 1883
VOLUME /mosquitto/conf
VOLUME /mosquitto/data
COPY mosquitto.conf /mosquitto/conf/mosquitto.conf
ENV PATH /usr/sbin:$PATH
USER nobody
ENTRYPOINT ["/usr/sbin/mosquitto", "-c", "/mosquitto/conf/mosquitto.conf"]

HEALTHCHECK --interval=10s --timeout=10s --retries=3 \
    CMD timeout 10 mosquitto_sub -h localhost -p 1883 -t 'topic' -E -i probe  || exit 1

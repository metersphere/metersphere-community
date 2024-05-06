ARG IMG_TAG=v3.x
ARG PKG_TYPE=enterprise

FROM registry.cn-qingdao.aliyuncs.com/metersphere/metersphere:${IMG_TAG}-${PKG_TYPE} as metersphere
FROM registry.cn-qingdao.aliyuncs.com/metersphere/task-runner:${IMG_TAG} as task-runner
FROM registry.cn-qingdao.aliyuncs.com/metersphere/result-hub:${IMG_TAG} as result-hub
FROM registry.cn-qingdao.aliyuncs.com/metersphere/alpine-openjdk21-jre as builder

COPY --from=metersphere /app /metersphere
COPY --from=task-runner /app /task-runner
COPY --from=result-hub /app /result-hub

COPY shells /shells
RUN chmod +x /shells/comm.sh && /shells/comm.sh

#
FROM registry.cn-qingdao.aliyuncs.com/metersphere/alpine-openjdk21-jre

COPY --from=builder /standalone /standalone  
COPY --from=builder /metersphere /metersphere
COPY --from=builder /task-runner /task-runner
COPY --from=builder /result-hub /result-hub

COPY --from=task-runner /opt/jmeter /opt/jmeter
COPY --from=metersphere /tmp/MS_VERSION /tmp/MS_VERSION

ENV AB_OFF=true
ENV MS_PACKAGE_TYPE=enterprise
ENV JAVA_OPTIONS="-Dfile.encoding=utf-8 -Djava.awt.headless=true --add-opens java.base/jdk.internal.loader=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.io=ALL-UNNAMED"

COPY shells /shells
RUN apk add libc6-compat && chmod +x /shells/*.sh

ENTRYPOINT ["sh", "/shells/start.sh"]


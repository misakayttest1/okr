FROM nginx:latest
EXPOSE 80
WORKDIR /app
USER root

COPY nginx.conf /etc/nginx/nginx.conf
COPY config.yaml ./
COPY entrypoint.sh ./
COPY web ./

RUN apt-get update && apt-get install -y wget unzip iproute2 systemctl && \
    chmod -v 755 web entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
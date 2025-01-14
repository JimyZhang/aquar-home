ARG NPM_REGISTRY=https://registry.npm.taobao.org
FROM node:14-slim
ARG NPM_REGISTRY
RUN apt-get update && apt-get install -y python3 && apt-get install -y rsync && npm install -g pm2
WORKDIR /app/aquar_home/aquar_home_front
COPY ./aquar_home_front/ ./
RUN npm install --registry ${NPM_REGISTRY} && npm run build
WORKDIR /app/aquar_home/aquar_home_server
COPY ./aquar_home_server/ ./
RUN npm install --unsafe-perm --registry ${NPM_REGISTRY}
WORKDIR /app/aquar_home
RUN rm -rf ./aquar_home_server/public/ && mkdir -p aquar_home_server/public/ && cp -r ./aquar_home_front/dist/* ./aquar_home_server/public/ 
EXPOSE 8172
VOLUME ["/var/aquardata"]
VOLUME ["/opt/aquarpool"]
VOLUME ["/root/.pm2/logs"]

CMD ["/bin/sh", "-c", "cd /app/aquar_home/aquar_home_server/ && mkdir -p /var/aquardata/log/ && npm run dcprd > /root/.pm2/logs/aquar_home.log 2>&1"]

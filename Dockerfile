FROM node:lts as build

RUN apt-get update \
  && apt-get install -y build-essential python perl-modules

RUN deluser --remove-home node \
  && groupadd --gid 1000 nodered \
  && useradd --gid nodered --uid 1000 --shell /bin/bash --create-home nodered 

RUN mkdir -p /data1 && chown 1000 /data1

USER 1000


WORKDIR /data1

COPY ./package.json /data1/
RUN npm install

## Release image
FROM build


WORKDIR /data1 */

COPY ./server.js /data1/
COPY ./settings.js /data1/
COPY ./flows.json /data1/
COPY ./flows_cred.json /data1/
COPY ./package.json /data1/
COPY ./assets/tekos-logo.png /data1/assets/
COPY ./assets/theme.css /data1/assets/
COPY ./editor.json /usr/local/lib/node_modules/node-red/node_modules/@node-red/editor-client/locales/en-US/
COPY --from=build /data1/node_modules /data1/node_modules




USER 1000


ENV PORT 1880
ENV NODE_ENV=production
ENV NODE_PATH=/data1/node_modules
EXPOSE 1880

CMD ["node", "/data1/server.js", "/data1/flows.json"]

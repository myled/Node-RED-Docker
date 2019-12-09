FROM node:lts as build

RUN apt-get update \
  && apt-get install -y build-essential python perl-modules

RUN deluser --remove-home node \
  && groupadd --gid 1000 nodered \
  && useradd --gid nodered --uid 1000 --shell /bin/bash --create-home nodered 


USER 1000

RUN mkdir -p /dir2/home/nodered/.node-red \
&& chown -R nodered: /dir2/home/nodered/.node-red

WORKDIR /dir2/home/nodered/.node-red

COPY ./package.json /dir2/home/nodered/.node-red/
RUN npm install

## Release image
FROM build


WORKDIR /dir2/home/nodered/.node-red */

COPY ./server.js /dir2/home/nodered/.node-red/
COPY ./settings.js /dir2/home/nodered/.node-red/
COPY ./flows.json /dir2/home/nodered/.node-red/
COPY ./flows_cred.json /dir2/home/nodered/.node-red/
COPY ./package.json /dir2/home/nodered/.node-red/
COPY ./assets/tekos-logo.png /dir2/home/nodered/.node-red/assets/
COPY ./assets/theme.css /dir2/home/nodered/.node-red/assets/
COPY ./editor.json /usr/local/lib/node_modules/node-red/node_modules/@node-red/editor-client/locales/en-US/
COPY --from=build /dir2/home/nodered/.node-red/node_modules /dir2/home/nodered/.node-red/node_modules




USER 1000


ENV PORT 1880
ENV NODE_ENV=production
ENV NODE_PATH=/dir2/home/nodered/.nodered/node_modules
EXPOSE 1880

CMD ["node", "/dir2/home/nodered/.node-red/server.js", "/dir2/home/nodered/.node-red/flows.json"]

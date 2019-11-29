FROM node:lts as build

RUN apt-get update \
  && apt-get install -y build-essential python perl-modules

RUN deluser --remove-home node \
  && groupadd --gid 1000 nodered \
  && useradd --gid nodered --uid 1000 --shell /bin/bash --create-home nodered 


USER 1000

RUN mkdir -p /home/nodered/.node-red \
&& chown -R nodered: /home/nodered/.node-red

WORKDIR /home/nodered/.node-red

COPY ./package.json /home/nodered/.node-red/
RUN npm install



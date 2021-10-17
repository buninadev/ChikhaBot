FROM tarampampam/node:16.8-alpine

RUN npm install pm2 -g
RUN apk update \
    && apk add --no-cache libsodium-dev

WORKDIR /app

COPY package.json ./
COPY yarn.lock ./
COPY ecosystem.config.js ./

RUN apk --no-cache --virtual build-dependencies add \
    python3 py3-pip \
    make \
    g++ \
    && ln -s /usr/bin/python3 /usr/local/bin/python \
    && yarn install --non-interactive \
    && apk del build-dependencies

COPY ./dist ./dist

CMD ["pm2-runtime", "start", "ecosystem.config.js"]
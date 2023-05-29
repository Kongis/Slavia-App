FROM node:16-alpine3.15 as ts-compiler

WORKDIR /usr/src/app
COPY package*.json ./
COPY tsconfig*.json ./

RUN npm install

# If you are building your code for production
# RUN npm ci --only=production

COPY . .
RUN npm run build

FROM node:16-alpine3.15 as ts-remover
WORKDIR /usr/src/app
COPY --from=ts-compiler /usr/src/app/package*.json ./
COPY --from=ts-compiler /usr/src/app/build/ ./
RUN npm install --only=production


EXPOSE 8000

CMD [ "node", "index.js" ]

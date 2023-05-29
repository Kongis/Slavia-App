FROM node:16-alpine3.15 as ts-compiler

WORKDIR /usr/src/app

#Install python/pip
ENV PYTHONUNBUFFERED=1

RUN apk add --update --no-cache python3  && ln -sf python3 /usr/bin/python
#RUN apt-get update && apt-get install -y python3
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN pip3 install scrapy requests google-search-results
COPY package*.json ./
COPY tsconfig*.json ./

RUN npm install

# If you are building your code for production
# RUN npm ci --only=production

COPY . .
RUN npm run build
RUN mkdir build/src
RUN cp -r src/Python build/src
FROM node:16-alpine3.15 as ts-remover
WORKDIR /usr/src/app
RUN apk add --update --no-cache python3  && ln -sf python3 /usr/bin/python
#RUN apt-get update && apt-get install -y python3
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN pip3 install scrapy requests google-search-results
COPY --from=ts-compiler /usr/src/app/package*.json ./
COPY --from=ts-compiler /usr/src/app/build/ ./
RUN npm install --only=production


#EXPOSE 8000

CMD ["node", "index.js"]

FROM python

WORKDIR /usr/src/app


# If you are building your code for production
# RUN npm ci --only=production
RUN pip3 install scrapy requests scrapetube
COPY . .


CMD [ "python", "main.py" ]

from concurrent.futures import process
from re import search
import codecs
import DateTime
import scrapy
from scrapy.crawler import CrawlerProcess
import datetime
from datetime import date
from datetime import datetime
from yaml import parse
import json
import time
import sys
import requests
Headers = {"Content-Type": "application/json"}
posts = [] 
last_count_posts = 0
last_day =  None
last_title_post = ""
last_title_comment = ""


def main():
  while True:
    global last_day
    global last_count_posts
    now = datetime.today().strftime('%d/%m/%Y')
    last_day = datetime.strptime(now, "%d/%m/%Y")
    process = CrawlerProcess()
    process.crawl(PostSpider)
    process.start()
    posts.reverse()
    json_data = {
        "posts": posts 
    }
    z = json.dumps(json_data)
    #print(z)
    #r = requests.post(url = "http://0.0.0.0:8000/api/additional/posts", data = z, headers= Headers)
    r = requests.post(url = "http://10.143.103.78:8000/api/additional/posts", data = z, headers= Headers)
    time.sleep(86400)
    #sys.exit()




class PostSpider(scrapy.Spider):
    name = 'post_spider'
    start_urls = [
        'https://www.slavia.cz/archive',
    ]
    def parse(self, response):
        global last_title_post
        global posts
        posts = []
        first = 0 
        first_title = ""
        for quote in response.css('div.item-list__item'):
            current_title = quote.xpath('.//h3[@class="item-list__header"]//a//text()').get()
            end_url = quote.xpath('.//h3[@class="item-list__header"]//a/@href').get()
            image_url_raw = quote.xpath('.//div[@class="col-12 col-sm-4 col-md-4"]/a/img/@data-src').get()
            image_url_raw = image_url_raw[12:]
            image_url = str(image_url_raw).partition('&')[0] 
            url = "https://www.slavia.cz/" +  end_url
            print(url, "000000000000000000000000000000000000000000000000")
            if current_title == last_title_post:
                last_title_post = first_title
                return None
            else:
                if first == 0:
                    first_title = current_title
                    first = 1
                dictionary =  {
                    'title': quote.xpath('.//h3[@class="item-list__header"]//a//text()').get(),
                    'date': quote.css('div.item-list__date::text').get(),
                    'text': quote.css('div.item-list__perex::text').get(),
                    'tag': quote.css('.tag::text').get(),
                    'image_url': image_url,
                    'url': url,
                }
                posts.append(dictionary)




main()
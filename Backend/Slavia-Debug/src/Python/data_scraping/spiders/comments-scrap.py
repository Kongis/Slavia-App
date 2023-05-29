from concurrent.futures import process
from re import search
import scrapy
from scrapy.crawler import CrawlerProcess
import datetime
from datetime import date
from datetime import datetime
from yaml import parse
import json
import time
from serpapi import GoogleSearch
import sys
import requests
Headers = {"Content-Type": "application/json"}

url = ""
last_count_posts = 0
last_day =  None
last_title_post = ""
last_title_comment = ""




class CommentSpider(scrapy.Spider):
    name = 'comments_spider'
    start_urls = [
        url
    ]
    #url = i
    def parse(self, response):
        global last_title_comment
        first = 0
        comments = [] 
        now_title = ""
        while True:
            for quote in response.xpath('//div[@class="football"]/div[2]/*'):
                data_text = ""
                current_title = quote.xpath('.//div[3]/text()').get()
                data_time = quote.xpath('.//div[@class="event-part event-time"]/text()').get()
                if current_title == last_title_comment:
                    last_title_comment = now_title
                    time.sleep(30)
                    break
                else:
                    data_text_raw = quote.xpath('.//div[3]/text()').getall()
                    data_time = quote.xpath('.//div[@class="event-part event-time"]/text()').get()
                    #data_symbol = quote.xpath('.//div[@class="event-part event-text"]/text()').get()#xpath('/div"]').extract()#css('div.event-part event-text::text').get(),
                    n = len(quote.xpath('.//div[3]/text()'))
                    if n > 1:
                        for x in data_text_raw:
                            data_text = data_text + " "+ x
                    if n == 1:
                        data_text = data_text_raw[0]
                    data_text = data_text.replace("\n", "")
                    data_time = data_time.replace("\n", "")
                    data_time = data_time.replace(" ", "")
                    if len(data_time) == 0:
                        continue
                    if first == 0:
                        now_title = current_title
                        first = 1
                    dictionary =  {
                        'time': data_time,
                        'text': data_text,
                    }
                    comments.append(dictionary)
            if len(comments) == 0:
                time.sleep(30)
            else:
                comments.reverse()
                print(comments)
                json_data = {
                    "comments": comments
                }
                z = json.dumps(json_data)
                r = requests.post(url = "http://localhost:8000/api/additional/posts", data = z, timeout=1 , headers=Headers)
                time.sleep(30) 

def Url():
    global url
    x = sys.args[1]
    search = GoogleSearch({"q": x, "location": "Prague,Czechia", "api_key": "66f32e6a375e96019c1445bf64685188fe9171b621f1118e1f43f54f32ca883e"})
    result = search.get_dict()
    link = result.get("organic_results")[0]
    url = link["link"]
    while True:
        process = CrawlerProcess()
        process.crawl(CommentSpider)
        process.start()

Url()


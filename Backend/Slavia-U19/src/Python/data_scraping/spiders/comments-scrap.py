import scrapy
from scrapy.crawler import CrawlerProcess
import datetime
from datetime import date
from datetime import datetime
import json
import time
from serpapi import GoogleSearch
import sys
import requests 
Headers = {"Content-Type": "application/json"}

#url = ""
last_count_posts = 0
last_day =  None
last_title_post = ""
last_title_comment = ""
fixture_id = 0


def Url():
    #global url
    global fixture_id
    x = "isport blesk fotbal slavia vs bohemians online přenos" #sys.argv[1]
    fixture_id = sys.argv[2]
    past_match = bool(sys.argv[3])
    #search = GoogleSearch({"q": x, "location": "Prague,Czechia", "api_key": "66f32e6a375e96019c1445bf64685188fe9171b621f1118e1f43f54f32ca883e"})
    #result = search.get_dict()
    #link = result.get("organic_results")[0]
    #url = "https://isport.blesk.cz/fotbal/fortuna-liga-skupina-o-titul-2022-2023/slavia-bohemians/online-prenos?match=338206"#link["link"]
    if (past_match == False):
        while True:
            process = CrawlerProcess()
            process.crawl(CommentSpider)
            process.start()
            time.sleep(10)
    else:
        process = CrawlerProcess()
        process.crawl(CommentSpider)
        process.start() 
        return





class CommentSpider(scrapy.Spider):
    x = sys.argv[1]
    search = GoogleSearch({"q": x, "location": "Prague,Czechia", "api_key": "24329eaf7e26eafa3009fa9780b2e034093214897fd438f89ba7221146507af1"}) # Kongis API key - 66f32e6a375e96019c1445bf64685188fe9171b621f1118e1f43f54f32ca883e    //  KOngtuber API key - 24329eaf7e26eafa3009fa9780b2e034093214897fd438f89ba7221146507af1
    result = search.get_dict()
    link = result.get("organic_results")[0]
    url = link["link"]
    #print(url + "          00000000000000000000000000000000000000000000000000000000000000000000")
    name = 'comments_spider'
    start_urls = [
        url
        #"https://isport.blesk.cz/fotbal/fortuna-liga-skupina-o-titul-2022-2023/slavia-bohemians/online-prenos?match=338206"
    ]
    #url = i
    def parse(self, response):

        global last_title_comment
        global fixture_id
        first = 0
        comments = [] 
        now_title = ""
        for quote in response.xpath('//div[@id="bb-feeds-view"]/*'):#'//div[@class="football"]/div[2]/*'):
            
            print(quote.xpath("@class").get())
            data_type = ""
            data_type = quote.xpath("@class").get()
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
                #if len(data_time) == 0:
                #    continue
                if first == 0:
                    now_title = current_title
                    first = 1
                print(data_text)
                dictionary =  {
                    'time': data_time,
                    'text': data_text,
                    'type': data_type
                }
                comments.append(dictionary)
        if len(comments) == 0:
            time.sleep(30)
        else:
            comments.reverse()
            #print(comments)
            json_data = {
                "fixture_id": fixture_id,
                "comments": comments
            }
            #print(json_data)
            #with open('comment.json', 'w') as f:
            #    json.dump(json_data, f, ensure_ascii=False)
            z = json.dumps(json_data)#ensure_ascii=False
            
            r = requests.post(url = "http://slavia-api:8000/api/additional/comments", data = z, timeout=1 , headers=Headers)
            #time.sleep(30) 

Url()
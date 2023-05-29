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

url = ""
last_count_posts = 0
last_day =  None
last_title_post = ""#"U18 zakončila podzim bez jediné porážky. Béčko opět bodovalo"#"B-tým po podzimu: Síla na Xaverově, železný muž Labík"
last_title_comment = ""#"Zbrojovka bude zahrávat další standardku." 


def main():
    global last_day
    global last_count_posts
    now = datetime.today().strftime('%d/%m/%Y')
    last_day = datetime.strptime(now, "%d/%m/%Y")
    while(True):
        process = CrawlerProcess()
        #process.crawl(PostSpider) #process.crawl(QuotesSpider)
        #process.crawl(CommentSpider)
        process.crawl(UrlSpider)
        process.start()
        print("Finish")
        #time.sleep(86400)




class PostSpider(scrapy.Spider):
    name = 'post_spider'
    start_urls = [
        'https://www.slavia.cz/archive',
    ]
    def parse(self, response):
        global last_title_post
        first = 0 
        now_title = ""
        for quote in response.css('div.item-list__item'):
            current_title = quote.xpath('.//h3[@class="item-list__header"]//a//text()').get()
            end_url = quote.xpath('.//h3[@class="item-list__header"]//a/@href').get(),
            url = "https://www.slavia.cz/" +  end_url[0]
            if current_title == last_title_post:
                last_title_post = now_title
                return None
            else:
                if first == 0:
                    now_title = current_title
                    first = 1
                dictionary =  {
                    'title': quote.xpath('.//h3[@class="item-list__header"]//a//text()').get(),
                    'date': quote.css('div.item-list__date::text').get(),
                    'text': quote.css('div.item-list__perex::text').get(),
                    'tag1': quote.css('.tag::text').get(),
                    #'tag2': quote.css('div.item-list__type tag::text').get(),
                    #'tag3': quote.xpath('//a[@class="item-list__image"]//div//text()').get(),
                    'url': url,
                }
                print(dictionary)
                with open('post.json', 'a', encoding='utf-8') as outfile:
                    json.dump(dictionary, outfile, ensure_ascii=False),
                    outfile.write('\n')
                continue
#//div[@id="rso"]/div[1]/div[2]//div[1]/div/a/@href

            
class UrlSpider(scrapy.Spider):
    name = 'comments_spider'
    #i = input()
    start_urls = [
        #'https://www.slavia.cz/archive',
        #"https://www.google.com/search?q=isport+blesk+fotbal+slovan+liberec+sigma+olomouc+26.11+2022+online"
        #i
        #'https://isport.blesk.cz/fotbal/mol-cup-2022-2023/teplice-brno/online-prenos?match=334758'
        #'https://www.idnes.cz/fotbal/online-fc-trinity-zlin-sk-slavia-praha.BU310175'
    ]
    #url = i
    def parse(self, response):
        #request = urllib.request.Request("https://www.google.com/search?q=isport+blesk+fotbal+slovan+liberec+sigma+olomouc+26.11+2022+online")
        #request.add_header('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36')
        #raw_response = urllib.request.urlopen(request).read()
        #html = raw_response.decode("utf-8")
        #print(html)
        search = GoogleSearch({"q": "isport blesk fotbal slovan liberec sigma olomouc 26.11 2022 online", "location": "Prague,Czechia", "api_key": "66f32e6a375e96019c1445bf64685188fe9171b621f1118e1f43f54f32ca883e"})
        #result = search.get_dict()
        #y = search.organic_results[1].link
        #//json_formatted_str = json.dumps(result, indent=2)
        print(search)
        #xlink = LinkExtractor()
        #y = xlink.extract_links(response)[1]
        #x = response.xpath('//div[@id="rso"]/div[1]/div[2]/div/div[1]/div/a/@href').get()
        #url = x.css('::attr(href)').get()
        #print(y, "0000000000000000000000000000000000")

class CommentSpider(scrapy.Spider):
    name = 'comments_spider'
    #i = input()
    start_urls = [
        #'https://www.slavia.cz/archive',
        url
        #'https://isport.blesk.cz/fotbal/mol-cup-2022-2023/teplice-brno/online-prenos?match=334758'
        #'https://www.idnes.cz/fotbal/online-fc-trinity-zlin-sk-slavia-praha.BU310175'
    ]
    #url = i
    def parse(self, response):
        global last_title_comment
        while True:
            first = 0
            comments = [] 
            now_title = ""
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
                    with open('comment.json', 'a', encoding='utf-8') as outfile:
                        json.dump(dictionary, outfile, ensure_ascii=False),
                        outfile.write('\n')
                        outfile.close()
                    continue
            if len(comments) == 0:
                time.sleep(30)
                break 
            else:
                comments.reverse()
                print(comments)
                #r = requests.post(url = "", data = comments)
                time.sleep(30) 

def Url():
    global url
    x = sys.args[1]
    search = GoogleSearch({"q": x, "location": "Prague,Czechia", "api_key": "66f32e6a375e96019c1445bf64685188fe9171b621f1118e1f43f54f32ca883e"})
    result = search.get_dict()
    link = result.get("organic_results")[0]
    url = link["link"]
    process = CrawlerProcess()
    process.crawl(CommentSpider)
    process.start()

Url()
#main()



# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

from cgitb import text
import scrapy


class DataScrapingItem(scrapy.Item):
    # define the fields for your item here like:
    title = scrapy.Field()
    tag = scrapy.Field()
    date = scrapy.Field()
    text = scrapy.Field()

    

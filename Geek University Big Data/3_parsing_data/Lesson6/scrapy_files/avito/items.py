# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy
from scrapy.loader.processors import MapCompose, TakeFirst


def cleaner_photo(values):
    if values[:2] == '//':
        return f'http:{values}'
    return values


def offer_to_int(values):
    try:
        values = values.replace(" ", "")
        values = int(values)
    except ValueError:
        values = 0
    return values


def remove_f(values):
    values = [values[i] for i in range(0, len(values)) if i % 2]
    return values


def remove_spc(values):
    values = values.lstrip().rstrip()
    return values


class AvitoItem(scrapy.Item):
    # define the fields for your item here like:
    _id = scrapy.Field()
    photos = scrapy.Field(input_processor=MapCompose(cleaner_photo))
    title = scrapy.Field(output_processor=TakeFirst())
    address = scrapy.Field(input_processor=MapCompose(remove_spc), output_processor=TakeFirst())
    params = scrapy.Field()
    value_params = scrapy.Field()
    offer = scrapy.Field(input_processor=MapCompose(offer_to_int), output_processor=TakeFirst())
    url = scrapy.Field(output_processor=TakeFirst())
    website = scrapy.Field(output_processor=TakeFirst())



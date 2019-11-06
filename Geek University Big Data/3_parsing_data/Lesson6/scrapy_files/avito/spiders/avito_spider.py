# -*- coding: utf-8 -*-
import scrapy
from scrapy.http import HtmlResponse
from avito.items import AvitoItem
from scrapy.loader import ItemLoader


class AvitoSpiderSpider(scrapy.Spider):
    name = 'avito_spider'
    allowed_domains = ['avito.ru']
    start_urls = ['https://www.avito.ru/rossiya/avtomobili?q=mini']

    def parse(self, response: HtmlResponse):
        ads_links = response.xpath('//a[@class="item-description-title-link"]/@href').extract()
        for link in ads_links:
            yield response.follow(link, self.parse_ads)

    def parse_ads(self, response: HtmlResponse):
        # photos = response.xpath('//div[contains(@class, "gallery-img-wrapper")]//div[contains(@class, "gallery-img-frame")]/@data-url').extract()
        # temp = AvitoItem(photos=photos)
        # yield temp
        loader = ItemLoader(item=AvitoItem(), response=response)
        loader.add_xpath('photos',
                         '//div[contains(@class, "gallery-img-wrapper")]//div[contains(@class, "gallery-img-frame")]/@data-url')
        loader.add_css('title', 'h1.title-info-title span.title-info-title-text::text')
        loader.add_xpath('address',
                         '//div[contains(@class, "item-address")]//span[contains(@class, "item-address__string")]/text()')
        loader.add_css('value_params', 'div.item-params li.item-params-list-item::text')
        loader.add_css('params', 'div.item-params li.item-params-list-item span.item-params-label::text')
        loader.add_xpath('offer',
                         '//div[contains(@class, "item-price")]//span[contains(@class, "js-item-price")]/@content')
        loader.add_value('url', response.url)
        loader.add_value('website', self.start_urls)
        yield loader.load_item()


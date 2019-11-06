# -*- coding: utf-8 -*-
import scrapy
from scrapy.http import HtmlResponse
from webparser.items import WebparserItem


class HhruSpider(scrapy.Spider):
    name = 'hhru'
    allowed_domains = ['hh.ru']
    start_urls = ['https://spb.hh.ru/search/vacancy?area=113&st=searchVacancy&text=python/']

    def parse(self, response):
        next_page = response.css('a.HH-Pager-Controls-Next::attr(href)').extract_first()
        yield response.follow(next_page, callback=self.parse)
        vacancy = response.css(
            'div.vacancy-serp div.vacancy-serp-item div.vacancy-serp-item__row_header a.bloko-link::attr(href)').extract()
        for link in vacancy:
            yield response.follow(link, self.vacancy_parse)

    def vacancy_parse(self, response: HtmlResponse):
        name = response.css('div.vacancy-title h1.header::text').extract_first()
        salary = response.css('div.vacancy-title p.vacancy-salary::text').extract_first()
        salary_min = response.css('div.vacancy-title meta[itemprop="minValue"]::attr(content)').extract()
        salary_max = response.css('div.vacancy-title meta[itemprop="maxValue"]::attr(content)').extract()
        url = response.css('div.bloko-column_xs-4 div[itemscope="itemscope"] meta[itemprop="url"]::attr(content)').extract()
        yield WebparserItem(name=name, salary=salary, salary_min=salary_min, salary_max=salary_max, url=url,
                            site=self.start_urls[0])

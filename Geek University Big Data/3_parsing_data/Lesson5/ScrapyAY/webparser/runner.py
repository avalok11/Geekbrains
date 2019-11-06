from scrapy.crawler import CrawlerProcess
from scrapy.settings import Settings

from webparser import settings
from webparser.spiders.hhru import HhruSpider
from webparser.spiders.superjobru import SuperjobruSpider


if __name__ == '__main__':
    crawler_settings = Settings()
    crawler_settings.setmodule(settings)
    process = CrawlerProcess(settings=crawler_settings)
    process.crawl(SuperjobruSpider)
    #process.crawl(HhruSpider)
    process.start()

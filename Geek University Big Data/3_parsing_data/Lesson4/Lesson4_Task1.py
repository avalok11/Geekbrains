#!/usr/local/bin/python
# Написать приложение, которое собирает основные новости с сайтов mail.ru, lenta.ru, yandex-новости.
#
# Для парсинга использовать xpath. Структура данных должна содержать:
#   •	название источника,
#   •	наименование новости,
#   •	ссылку на новость,
#   •	дата публикации


from lxml import html
import requests
from datetime import datetime
import pandas as pd
import re
from pymongo import MongoClient


def data_collection(name_list, link_list, source, date_list):
    # создаем датафрем для мейл ру
    df = pd.DataFrame()
    for i in range(len(name_list)):
        df = df.append({'Название источника': source,
                        'Наименование новости': name_list[i],
                        'Ссылка на новость': link_list[i],
                        'Дата публикации': date_list[i]}, ignore_index=True)
    return df


def main():
    header = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                            'Chrome/77.0.3865.120 Safari/537.36'}
    df = pd.DataFrame()
    motnh_dict = {'января': '01', 'февраля': '02', 'марта': '03', 'апреля': '04', 'мая': '05', 'июня': '06',
                  'июля': '07', 'августа': '08', 'сентября': '09', 'октября': '10', 'ноября': '11', 'декабря': '12'}

    # MAIL RU
    url = 'https://mail.ru'
    request = requests.get(url, headers=header)
    root = html.fromstring(request.text)
    name_list = root.xpath("//h3[@class='news-item__title i-link-deco']/text() | "
                           "//div[@class='news-item__inner']/"
                           "a[not(contains(@class,'news-item__label i-color-black i-inline'))]/text()")

    link_list = root.xpath("//div[@class='news-item o-media news-item_media news-item_main']/a/@href | "
                           "//div[@class='news-item__inner']/"
                           "a[not(contains(@class, 'news-item__label i-color-black i-inline'))]/@href")
    date_list = [datetime.now().strftime('%Y-%m-%d %H.%M:%S') for i in range(len(name_list))]
    df = data_collection(name_list, link_list, 'mail.ru', date_list)

    # LENTA RU
    url = 'https://lenta.ru'
    request = requests.get(url, headers=header)
    root = html.fromstring(request.text)
    name_list = root.xpath("//section[@class='row b-top7-for-main js-top-seven']/div/div/h2/a/text() | "
                           "//section[@class='row b-top7-for-main js-top-seven']/div/div/"
                           "a[not(contains(@target, '_blank'))]/text()")
    link_list = root.xpath("//section[@class='row b-top7-for-main js-top-seven']/div/div/h2/a/@href | "
                           "//section[@class='row b-top7-for-main js-top-seven']/div/div/"
                           "a[not(contains(@target, '_blank'))]/@href")
    link_list = [f'{url}{l}' for l in link_list]
    date_list = root.xpath("//section[@class='row b-top7-for-main js-top-seven']/div/div/h2/a/time/@datetime | "
                           "//section[@class='row b-top7-for-main js-top-seven']/div/div/"
                           "a[not(contains(@target, '_blank'))]/time/@datetime")
    date_list_formated = []
    for date in date_list:
        for d in motnh_dict:
            if re.match(rf'.*{d}', date):
                date_list_formated.append(datetime.strptime(re.sub(d, motnh_dict[d], date), ' %H:%M, %d %m %Y'))
    df = df.append(data_collection(name_list, link_list, 'lenta.ru', date_list_formated))

    # сохранение в БД
    client = MongoClient('mongodb://127.0.0.1:27017')
    db = client['news']
    docs = db.docs
    for i in range(len(df)):
        result = docs.insert_one(df.iloc[i].to_dict())
        print(f'New doc: {result.inserted_id}')


if __name__ == "__main__":
    main()


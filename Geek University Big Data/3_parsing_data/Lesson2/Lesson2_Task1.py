# Необходимо собрать информацию о вакансиях на вводимую должность (используем input или через аргументы) с сайта
# superjob.ru и hh.ru. Приложение должно анализировать несколько страниц сайта(также вводим через input или аргументы).
# Получившийся список должен содержать в себе минимум:
#
#         *Наименование вакансии
#         *Предлагаемую зарплату (отдельно мин. и и отдельно макс.)
#         *Ссылку на саму вакансию
#         *Сайт откуда собрана вакансия
# По своему желанию можно добавить еще работодателя и расположение. Данная структура должна быть одинаковая для
# вакансий с обоих сайтов. Общий результат можно вывести с помощью dataFrame через pandas.

import requests
from pprint import pprint
from bs4 import BeautifulSoup as bs
import pandas as pd
import re

headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) '
                         'Chrome/77.0.3865.120 Safari/537.36'}


sj_main_link = 'https://www.superjob.ru'
hh_main_link = 'https://spb.hh.ru'

sj_vc_search = '/vacancy/search/?keywords='
hh_vc_search = '/search/vacancy?area=113&st=searchVacancy&text='

sj_delimiter = '%20'
hh_delimiter = '+'

vacancy = input('Введите название вакансии: ')
pages = input('Введите количество страниц поиска: ')
try:
    pages = int(pages)
except TypeError:
    print('Необходимо ввести количество страниц цифрами.')
    raise SystemExit(1)

sj_vacancy = vacancy.replace(' ', sj_delimiter)
hh_vacancy = vacancy.replace(' ', hh_delimiter)

df = pd.DataFrame()

# HH ru
hh_page = f'{hh_main_link}{hh_vc_search}{hh_vacancy}'
for y in range(pages):
    html = requests.get(f'{hh_page}', headers=headers).text
    parsed_html = bs(html, 'lxml')
    # поиск блока с вакансиями
    vacancy_block = parsed_html.find('div', {'class': 'vacancy-serp'})
    # поиск наименований вакансиц
    name_list = vacancy_block.findAll('a', {'class': 'bloko-link HH-LinkModifier',
                                            'data-qa': 'vacancy-serp__vacancy-title'})
    # поиск зарплат
    salary_list = vacancy_block.findAll('div', {'class': 'vacancy-serp-item__sidebar'})
    # поиск ссылок на описание вакансии
    links_block = vacancy_block.findAll('a', {'class': 'bloko-link HH-LinkModifier',
                                              'data-qa': 'vacancy-serp__vacancy-title'})
    # заполнение датафрейма
    i = 0
    for i in range(len(name_list)):
        # проверка зарплат
        if salary_list[i*2].text == '':
            salary_min = 0
            salary_max = 0
        else:
            salary_min = salary_list[i*2].text.split('-')[0]
            d = re.findall(r'\d', salary_min)
            salary_min = int(''.join(d))
            try:
                salary_max = salary_list[i*2].text.split('-')[1]
                d = re.findall(r'\d', salary_max)
                salary_max = int(''.join(d))
            except IndexError:
                salary_max = salary_min
        # заполнение датафрейма
        df = df.append({'Наименование вакансии': name_list[i].text,
                        'Зарплата MIN': salary_min,
                        'Зарплата MAX': salary_max,
                        'Ссылка вакансию': links_block[i].get('href'),
                        'Сайт': 'HeadHunter'}, ignore_index=True)

        # поиск ссылки на следующую страницу, если ссылка не найдена то заканчиваем поиск
        try:
            next_link = parsed_html.find('a',
                                         {'data-qa': 'pager-next',
                                          'class': 'bloko-button HH-Pager-Controls-Next HH-Pager-Control'}) \
                .get('href')
        except AttributeError:
            break
        sj_page = f'{hh_main_link}{next_link}'

print('Finished with HH.')
# time.sleep(1)

# SuperJob
sj_page = f'{sj_main_link}{sj_vc_search}{sj_vacancy}'
for y in range(pages):
    html = requests.get(f'{sj_page}', headers=headers).text
    parsed_html = bs(html, 'lxml')

    # поиск блока с вакансиями
    vacancy_block = parsed_html.find('div', {'style': 'display:block'})
    # поиск наименований вакансиц
    name_list = vacancy_block.findAll('div', {'class': '_3mfro CuJz5 PlM3e _2JVkc _3LJqf'})
    # поиск зарплат
    salary_list = vacancy_block.findAll('span',
                                        {'class': '_3mfro _2Wp8I f-test-text-company-item-salary PlM3e _2JVkc _2VHxz'})
    # поиск ссылок на описание вакансии
    links_block = vacancy_block.findAll('div', {'class': '_3syPg _1_bQo _2FJA4'})
    link_lists = []
    for link in links_block:
        links = link.find('a').get('href')
        link_lists.append(f'{sj_main_link}{links}')
        None
    # заполнение датафрейма
    i = 0
    for i in range(len(name_list)):
        # проверка зарплат
        if salary_list[i].text == 'По договорённости':
            salary_min = 0
            salary_max = 0
        else:
            salary_min = salary_list[i].text.split(' — ')[0]
            d = re.findall(r'\d', salary_min)
            salary_min = int(''.join(d))
            try:
                salary_max = salary_list[i].text.split(' — ')[1]
                d = re.findall(r'\d', salary_max)
                salary_max = int(''.join(d))
            except IndexError:
                salary_max = salary_min
        # заполнение датафрейма
        df = df.append({'Наименование вакансии': name_list[i].text,
                        'Зарплата MIN': salary_min,
                        'Зарплата MAX': salary_max,
                        'Ссылка вакансию': link_lists[i],
                        'Сайт': 'SuperJob'}, ignore_index=True)

    # поиск ссылки на следующую страницу, если ссылка не найдена то заканчиваем поиск
    try:
        next_link = parsed_html.find('a',
                                     {'rel': 'next',
                                      'class': 'icMQ_ _1_Cht _3ze9n f-test-button-dalshe f-test-link-dalshe'})\
            .get('href')
    except AttributeError:
        break
    sj_page = f'{sj_main_link}{next_link}'

print('Finished with SuperJob.')
print(f'Всего найдено {len(df)} вакансий по имнени \'{vacancy}\'.')

with pd.option_context('display.max_rows', None, 'display.max_columns', 25):
    print(df)



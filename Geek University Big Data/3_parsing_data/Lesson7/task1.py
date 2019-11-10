# 1) Написать программу, которая собирает входящие письма из своего или тестового почтового ящика и сложить данные о
# письмах в базу данных (от кого, дата отправки, тема письма, текст письма полный)

# реализовал только mail ru и чтение одной страницы со списком сообщений
# очень крутой прктический курс!
# спасибо!

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from pymongo import MongoClient
from datetime import date
import time


client = MongoClient('mongodb://127.0.0.1:27017')
db = client['mails']
docs = db.docs


driver = webdriver.Chrome()
driver.get('https://mail.ru')

elem = driver.find_element_by_id('mailbox:login')
elem.send_keys('')

domain = driver.find_element_by_id('mailbox:domain')
select = Select(driver.find_element_by_id('mailbox:domain'))
select.select_by_visible_text('@list.ru')
domain.submit()

button = driver.find_element_by_class_name('o-control')
button.click()

#elem = driver.find_element_by_id('mailbox:password')
#elem.send_keys('Djljrfyfkvjq10')
#elem.send_keys(Keys.RETURN)

elem = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.ID, 'mailbox:password')))
elem.send_keys('')
elem.send_keys(Keys.RETURN)

while True:
    try:
        button = WebDriverWait(driver, 10).until(
            #EC.element_to_be_clickable((By.CLASS_NAME, 'js-datalist-item'))
            EC.element_to_be_clickable((By.XPATH,
                                        '//div[contains(@class, "b-datalist__body")]'
                                        '//div[contains(@class, "js-datalist-item")]'
                                        '[not(contains(@data-metathread, "newsletters"))]'
                                        '[not(contains(@data-metathread, "social"))]'))
                                        #' and not @data-metathread="newsletters"]'))
            )

        mails = driver.find_elements_by_xpath('//div[contains(@class, "b-datalist__body")]'
                                              '//div[contains(@class, "js-datalist-item")]'
                                              '[not(contains(@data-metathread, "newsletters"))]'
                                              '[not(contains(@data-metathread, "social"))]')
        for mail in mails:
            mail.click()
            try:
                time.sleep(2)
                data = {'From': driver.find_element_by_class_name('b-contact-informer-target').get_attribute(
                    'data-contact-informer-email'),
                    'Date': driver.find_element_by_class_name('b-letter__head__date').text.replace(
                        'Сегодня', date.today().strftime("%Y.%m.%d")),
                    'Subject': driver.find_element_by_class_name('b-letter__head__subj__text').text,
                    'Text': driver.find_element_by_class_name('b-letter__body').text}
                docs.insert_one(data)
                driver.back()
                time.sleep(2)
            except Exception as e:
                print(e)
                break

    except Exception as e:
        print(e)
        break





# 1.	Посмотреть документацию к API GitHub, разобраться как вывести список репозиториев для конкретного пользователя,
# сохранить JSON-вывод в файле *.json.

import json
import requests
from pprint import pprint

username = input("Enter the github username:")

url = 'https://api.github.com/users/'
get = '/repos'
#response = requests.get('https://api.github.com/users/'+username+'/repos')
response = requests.get(f'{url}{username}{get}')


if response.ok:
    data = json.loads(response.text)

    for row in data:
        repos = row['name']

        pprint(repos)

    with open('list_of_reps.json', 'w', encoding='utf-8') as outfile:
        json.dump(data, outfile, ensure_ascii=False, indent=4)




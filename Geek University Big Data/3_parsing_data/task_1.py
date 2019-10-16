# 1.	Посмотреть документацию к API GitHub, разобраться как вывести список репозиториев для конкретного пользователя,
# сохранить JSON-вывод в файле *.json.

import json
import requests
#from pprint import pprint

username = input("Enter the github username:")
response = requests.get('https://api.github.com/users/'+username+'/repos')

if response:
    data = response.json()
    print(response.status_code)

    with open('list_of_reps.json', 'w') as outfile:
        json.dump(data, outfile)





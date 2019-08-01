#!/bin/bash

#а) Написать скрипт, который удаляет из текстового файла пустые строки и заменяет маленькие символы на большие (воспользуйтесь tr или sed)

echo "Введите имя файла: "
read file_name

echo "Имя файла ${file_name}"

sed '/^$/d' "${file_name}" > "${file_name}.result"
cat "${file_name}.result" | tr [a-z] [A-Z] > "${file_name}.result1"
mv "${file_name}.result1" "${file_name}.result"
echo "Удаление строк и преобразование регистра завершено, результат в файле ${file_name}.result"
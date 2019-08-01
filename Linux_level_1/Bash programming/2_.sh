#!/bin/bash

#b) Изменить скрипт мониторинга лога, чтобы он выводил сообщения при попытке неудачной аутентификации пользователя /var/log/auth.log, отслеживая сообщения примерно такого вида:
#May 16 19:45:52 vlamp login[102782]: FAILED LOGIN (1) on '/dev/tty3' FOR 'user', Authentication failure
#Проверить скрипт, выполнив ошибочную регистрацию с виртуального терминала.

tail -f /var/log/auth.log | grep "FAILED LOGIN (1)" &

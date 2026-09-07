# Домашнее задание к занятию `Практическое задание с самопроверкой - Подъем инфраструктуры в облаке`

'При выполнении ДЗ использовались материалы
https://github.com/netology-code/sdvps-homeworks/tree/main/lecture_demos/7-03'

1. Создать сервисный аккаунт в облаке. Выдать права editor
2. Выпустить авторизованный ключ для этого аккаунта и скачать его по пути ~/.authorized_key.json . 
3. Вписать в переменные cloud_id и folder_id в variables.tf
4. Изменить ssh-ключ в файле cloud-init.yml (ssh-keygen -t ed25519). cp terraformrc ~/.terraformrc
5. terraform init && terraform apply
6. rm ~/.ssh/known_hosts. Выполнить playbook ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./hosts.ini test.yml
7. По окончании выполнить terraform destroy

https://www.jeffgeerling.com/blog/2022/using-ansible-playbook-ssh-bastion-jump-host

Настройка доступа по ssh через ssh config: 
~/.ssh/config
```
Host 89.169.142.236  #например адрес вашего бастиона
   User user

Host 10.0.*
        ProxyJump 89.169.142.236
        User user

Host *.ru-central1.internal
        ProxyJump 89.169.142.236
        User user

```
Или более простой для понимания, но менее удобный для частого применения: ssh -J <jump server> <remote server>

### Задание 1
Повторить демонстрацию лекции (развернуть vpc, 2 веб сервера, бастион сервер).
- готово, конфигурация в репозитории

### Задание 2
С помощью ansible подключиться к web-a и web-b , установить на них nginx.(написать нужный ansible playbook)
Провести тестирование и приложить скриншоты развернутых в облаке ВМ, успешно отработавшего ansible playbook.
```
Проведем тестирование успешного подключения
ansible -i hosts.ini webservers -m ping
[WARNING]: Host '10.0.1.25' is using the discovered Python interpreter at '/usr/bin/python3.10', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.19/reference_appendices/interpreter_discovery.html for more information.
10.0.1.25 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}
[WARNING]: Host '10.0.2.21' is using the discovered Python interpreter at '/usr/bin/python3.10', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.19/reference_appendices/interpreter_discovery.html for more information.
10.0.2.21 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}
- успешно

Запускаем основной плейбук
ansible-playbook -i hosts.ini install_nginx.yml 

PLAY [Установка и настройка Nginx на веб-серверах] ************************************************************************

TASK [Gathering Facts] ****************************************************************************************************
[WARNING]: Host '10.0.1.25' is using the discovered Python interpreter at '/usr/bin/python3.10', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.19/reference_appendices/interpreter_discovery.html for more information.
ok: [10.0.1.25]
[WARNING]: Host '10.0.2.21' is using the discovered Python interpreter at '/usr/bin/python3.10', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.19/reference_appendices/interpreter_discovery.html for more information.
ok: [10.0.2.21]

TASK [Обновление кэша пакетов apt] ****************************************************************************************
ok: [10.0.1.25]
ok: [10.0.2.21]

TASK [Установка Nginx] ****************************************************************************************************
changed: [10.0.1.25]
changed: [10.0.2.21]

TASK [Запуск и включение Nginx] *******************************************************************************************
ok: [10.0.1.25]
ok: [10.0.2.21]

TASK [Проверка, что Nginx работает] ***************************************************************************************
ok: [10.0.1.25]
ok: [10.0.2.21]

TASK [Создание тестовой страницы для web-a] *******************************************************************************
skipping: [10.0.1.25]
skipping: [10.0.2.21]

TASK [Создание тестовой страницы для web-b] *******************************************************************************
skipping: [10.0.1.25]
skipping: [10.0.2.21]

TASK [Проверка доступности Nginx (локально)] ******************************************************************************
ok: [10.0.1.25]
ok: [10.0.2.21]

TASK [Вывод информации об успешной установке] *****************************************************************************
ok: [10.0.1.25] => {
    "msg": "Nginx успешно установлен на 10.0.1.25"
}
ok: [10.0.2.21] => {
    "msg": "Nginx успешно установлен на 10.0.2.21"
}

PLAY RECAP ****************************************************************************************************************
10.0.1.25                  : ok=7    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
10.0.2.21                  : ok=7    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
```


### Задание 3*
Выполните действия, приложите скриншот скриптов, скриншот выполненного проекта.

Добавить еще одну виртуальную машину.
Установить на нее любую базу данных.
Выполнить проверку состояния запущенных служб через Ansible.


### Задание 4*
Изучите инструкцию yandex для terraform. Добейтесь работы паплайна с безопасной передачей токена от облака в terraform через переменные окружения.

Для этого:

Настройте профиль для yc tools по инструкции.
Удалите из кода строчку “token = var.yandex_cloud_token”. Terraform будет считывать значение ENV переменной YC_TOKEN.
Выполните команду export YC_TOKEN=$(yc iam create-token) и в том же shell запустите terraform.
Для того чтобы вам не нужно было каждый раз выполнять export - добавьте данную команду в самый конец файла ~/.bashrc
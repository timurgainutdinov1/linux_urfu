#!/bin/bash

# Добавление пользователей в систему,
# пользователь michael добавляется в группу daisy
# для возможности совместной работы 
# (получения прав доступа к файлам проекта)
sudo adduser --disabled-password --gecos "" john
sudo adduser --disabled-password --gecos "" daisy
sudo adduser --ingroup daisy --disabled-password --gecos "" michael

# Создание пользовательских паролей
for items in john:123321 daisy:321123 michael:332211 
do
	echo "$items" | sudo chpasswd
done

# Создание директорий и виртуальных окружений проектов
mkdir /var/tmp/John_App /var/tmp/Application_Main
python3 -m venv /var/tmp/John_App/J_env /var/tmp/Application_Main/D_M_env

# Добавление текущего пользователя в группы 
# для возможности создания файлов .py в директориях проектов
sudo usermod -a -G john $USER
sudo usermod -a -G daisy $USER

# Изменение владельцев и групп владельцев
# директорий проектов и виртуальных окружений
sudo chown john:john /var/tmp/John_App
sudo chown john:john /var/tmp/John_App/J_env
sudo chown daisy:daisy /var/tmp/Application_Main
sudo chown daisy:daisy /var/tmp/Application_Main/D_M_env

# Запуск виртуальных окружений,
# установка необходимых библиотек,
# создание файлов .py и их запуск
# выход из виртуальных окружений

source /var/tmp/John_App/J_env/bin/activate
pip3 install numpy
echo -e "import numpy as np\narr = np.random.randint(0, 10, 10)\nprint(arr)">>/var/tmp/John_App/main.py
python3 /var/tmp/John_App/main.py
deactivate

source /var/tmp/Application_Main/D_M_env/bin/activate
pip3 install requests
echo -e "import requests\nresp = requests.get('https://urfu.ru/ru')\nprint(resp.headers)">>/var/tmp/Application_Main/main.py
python3 /var/tmp/Application_Main/main.py
deactivate

# Изменение владельцев и групп владельцев
# файлов .py
sudo chown john:john /var/tmp/John_App/main.py
sudo chown daisy:daisy /var/tmp/Application_Main/main.py

# Удаление текущего из групп владельцев проектов
# для изъятия прав
sudo deluser $USER daisy
sudo deluser $USER john
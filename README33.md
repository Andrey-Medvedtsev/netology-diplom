1. Регистрация доменного имени
![img_243.png](img_243.png)
делегировано cloud.yandex.net
![img_240.png](img_240.png)
2. Создание инфраструктуры
![img_249.png](img_249.png)
![img_250.png](img_250.png)
при создании бакета ЯО ругается: <br/>
Error: error creating Storage S3 Bucket: BucketAlreadyOwnedByYou: Your previous request to create the named bucket succeeded and you already own it.<br/>
поскольку бакет уже создан и используется<br/>
настройка хостов выполняется через jump host<br/>
![img_252.png](img_252.png)
3. Установка Nginx и LetsEncrypt<br/>
роль для создания reverse proxy с поддержкой TLS разработана и применена к серверу с nginx.<br/>

4. Установка кластера MySQL<br/>
Роль Ansible для установки кластера MySQL разработана и применена к серверам db01 и db02<br/>
В кластере автоматически создаётся база данных c именем wordpress, создаётся пользователь wordpress с полными правами на базу wordpress и паролем wordpress.<br/>
![img_251.png](img_251.png)<br/>
MySQL работает в режиме репликации Master/Slave:<br/>
![img_253.png](img_253.png)
![img_254.png](img_254.png)

5. Установка WordPress
Ansible роль для установки WordPress разработана, применена к серверу app<br/>
![img_241.png](img_241.png)
![img_242.png](img_242.png)
6. Установка Gitlab CE и Gitlab Runner
Установка и настройка Gitlab CE и Gitlab Runner выполнена. <br/>
подготовлен проект wp
![img_255.png](img_255.png)
вручную зарегистрирован runner
![img_256.png](img_256.png)
![img_257.png](img_257.png)
Выполнена настройка pipeline доставки кода в среду эксплуатации, то есть настроен автоматический деплой на сервер www.medvedtsev.ru при коммите в репозиторий с WordPress.<br/>
![img_259.png](img_259.png)
![img_260.png](img_260.png)
![img_261.png](img_261.png)
![img_262.png](img_262.png)
7. Установка Prometheus, Alert Manager, Node Exporter и Grafana

Интерфейсы Prometheus, Alert Manager и Grafana доступны по https.
В доменной зоне настроены A-записи на внешний адрес reverse proxy:
• https://grafana.medvedtsev.ru (Grafana)
• https://prometheus.medvedtsev.ru (Prometheus)
• https://alertmanager.medvedtsev.ru (Alert Manager)
На сервере medvedtsev.ru отредактированы upstreams для выше указанных URL и они смотрят на виртуальную машину на которой установлены Prometheus, Alert Manager и Grafana.
На всех серверах установлен Node Exporter и его метрики доступны Prometheus.
У Alert Manager есть необходимый набор правил для создания алертов.
В Grafana есть дашборд отображающий метрики из Node Exporter по всем серверам.
![img_244.png](img_244.png)
![img_245.png](img_245.png)
![img_248.png](img_248.png)
![img_247.png](img_247.png)
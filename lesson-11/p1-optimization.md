# Оптимизация запросов

## Типы таблиц

`CREATE TABLE ... ENGINE=InnoDB;`

Ядро
кэш запросов
Анализатор - есть ли ошибки в SQL
препроцессор - имена верные, права верные
Оптимизатор - оптимизирует декларативные инструкции.
Далее работать через API движка.

*.frm - описание таблиц для всех движков одинаков.

блокировка на уровне строк

Табличная блокировка.

Blackhole - 

Зачем нужны движки без транзакций? - они быстрые

## Индексы

Индексы позволяют извлекать данные.

Индексы в отсортированном виде. Однако они сами хранятся в
оперативной памяти.

кэши под сортировку данных для сессии,
кэши под индесы для ядра.

ИнноДБ - кластерный сервер, строки

МайИсам - индексы отдельно от таблиц, и их можно разместить в
оперативной памяти, отдельно от данных.

Эффективность индексов.

На каждую операцию чтения приходился одно обращение к диску.
Буферы заняты на половину, поэтому увеличивать буфер не надо.
Буферы бесконечно увеличивать не можем.
Однако если они будут превышены, то будет обращение к свопу,
что очень медленно.

## Оптимизация

Чем меньше данных тем эффективнее.
SELECT * FROM users;

LIMIT - более эффективен без него.

Кроме того типы бывают медленные.

EXPLAIN SELECT ...\G;
Выводит характеристика

При соединении нескольких таблиц, будет несколько строк.

TYPE ALL - все строки
А бывают
1. ALL - full scan - bad. LIMIT - прекращает
2. index
3. range (between, <, >)

EXPLAIN SELECT ...\G;
Выводит характеристики запроса, которые позволяют понять как
выполнился запрос. Чтобы понять, как выполнился запрос, нужно
понимать все допустимые значения. Кроме этого допустимые значения
параметров различаются по лучше, хуже. Как на это влиять абстрактно
и непонятно.

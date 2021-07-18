# Задание 1.

Проанализировать запросы, которые выполнялись на занятии,
определить возможные корректировки и/или улучшения (JOIN
пока не применять).

## Алгоритм

Алгоритм составления вложенного запроса следующий:
1) составление родительского запроса в виде шаблона с константами,
вместо данных, которые заменятся на подзапросы.
2) пройтись по всем константам и заменить их на подзапросы.
3) добавить алиасы на поля для повышения читабельности.
4) Если в подзапросах использовали константы идентификаторов, то их
следует заменить на значение взятое из родительской таблицы в форме:
`parent_tbl.field_id`
5) Запросы трудно читаются, поэтому уделить время на форматирование.

Трудность с `FROM` - изначально не понятно из какой таблицы брать
данные. Возможно, стоит рассматривать подход от частного к общему.
TODO: разобраться и дописать после уроков.

## Улучшения

Я вижу улучшения в скорости составления запроса, в читабельности
запроса и в скорости его выполнения, поэтому все возможные улучшения
касаются этого, ведь остальное закроется навыками для достижения этих
улучшений.

Возможно, параметры запроса, следует брать из переменных, чтобы
не сломать сам запрос при редактировании, кроме того это возможно
задокументирует сам запрос, показав, от чего он зависит, не читая его.

Возможно, перед каждым запросом, хорошо бы документировать что он делает.

Чтобы подзапросы выполнялись быстрее, нужно следить за наличием ключей.

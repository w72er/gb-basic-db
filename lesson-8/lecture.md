чем больше вы практикуетесь, тем больше растут ваши скилы.
домашнего задания к этому уроку не будет.

2
Пусть задан некоторый пользователь. 
Из всех друзей этого пользователя найдите человека,
который больше всех общался с нашим пользователем.

select count(*)
from messages
where from_user_id
мой запрос получился уродливее, поскольку я поле, по которому
можно фильтровать и группировать и упорядочивать, убрано из
селекта, поэтому в каждом нужно было повторить.

with(cte) - перед селектом создать алиас на запрос и потом на него
ссылаться как на таблицу.

3 задание
10 самых молодых
К сожалению, limit 10 в подзапросе не работает, поэтому 
select * from ((select limit 10) as usr )
мы создали таблицу.

У меня получилось сложнее, поскольку я считал лайки из всех
таблиц.

# Сложные запросы

JOINами проще чем с вложенными
union - сверку, а join сбоку
inner join = join

смотрим на запрос и понимаем, где объединение, по какому условию
поэтому
select * from tbl1, tbl2 WHERE tbl.a = tbl.b;


Пользователи, которые не создавали и не администрировали:
SELECT *
FROM users
LEFT JOIN communities ON communities.admin_id = users.id
WHERE communities.name is null;

full outer join
все сообщества в не зависимости от пользоватлей
все пользоватлеи вне зависимости от сообществ.
select * from users LEFT JOIN communities
union
select * from users RIGHT JOIN communities
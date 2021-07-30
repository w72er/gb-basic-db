Хранимая процедура вызывается call

func.sql
```text
create procedure my_version()
begin
    select version(); -- sql commands
end
```

```text
call my_version();
```

SHOW PROCEDURE STATUS LIKE 'my_version'\G
или
mysql.proc

```text
create varchar(255) function get_version() DETERMINSTIC
begin
    return version
end
```

deterministic - если можно кэшировать, если разный результат
то not deterministic

Чтобы в терминале создавать процедуру или функцию,
то точка с запятой внутри begin end, укажет на 
ввод команды, но команда не завершена, поэтому следует
указать новый delimeter. Тогда точка с запятой не
будет являться delimenter и соответственно не завершит
ввод команды.

## Параметры, переменные и ветвления

in out inout - для хранимой процедуры
in - для функции

create procedure set_x (in value int)
begin
    set @x = value;
end//

Если передать в процедуру переменную @y, то она не изменится
переменной in, что бы поменяла свое значение, следует
использовать out.

DECLARE - может быть внутри begin end, при этом действуют
в рамках этого блока, а так же вложенного в нем.

Инициализация переменных
set @var = 100
set @var = @var + 1

select id, data into @x, @y from

17^58
## циклы

* while
* repeat
* loop

cycle: while i > 0 do
    -- body
    leave cycle;
end while cycle

iterate - прерывает текущую итерацию.


## обработка ошибок

declare continue handler for sqlstate '23000' set @error = 'Ошибка вставки значения'

## Курсоры

Курсоры для обхода таблиц
```text
declare curcat cursor for select * from catalogs;
cycle : loop
    fetch curcat into id, name;
    insert into
```

## триггеры

специальная хранимая процедура привязанная к событию 
insert delete or update

Для доступа к старому значению, или новому используем OLD, NEW.
Благодаря этому они могут изменять значения при изменении значений.

coaleasce() - вернуть первый не null параметр.

для присваивания другим столбцам вычисляемые значения. но эту же
задачу можно через stored столбец.

Запретить удалять запись можно генерируя исключение.
before delete 
signal sqlstate '45000'







-- ticker_id получаем от приложения, поскольку ожидаем,
-- что пользователь выставит ticker_id в выпадающем меню
-- в приложении.
INSERT INTO deals (ticker_id, amount, made_at) VALUE
(1, 2, '2021-08-09 20:12:00'); -- купить две доли VTBE
INSERT INTO deals (ticker_id, amount, made_at) VALUE
(1, -1, '2021-08-09 20:13:00'); -- продать одну долю VTBE

SELECT * FROM deals;
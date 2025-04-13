-- використовую PostgreSQl. Дані файлу завантажені в таблицю orders

with users_total_spend as (select id_user, id_region, SUM(amount) as total_spend
                           -- мої дані вже NUMERIC, тобто дробові числа там вже пишуться через крапку.
                           -- Аби колонка була у форматі TEXT, то треба було б прописати SUM(CAST(REPLACE(amount, ',', '.') AS NUMERIC)) AS total_spend
                           from orders
                           where status = 'success'
                           group by id_user, id_region),

regions_avg_spend as (select id_region, AVG(total_spend) as avg_spend
                      from users_total_spend
                      group by id_region)
select u.id_user, u.id_region, u.total_spend as user_total_spend, r.avg_spend as avg_region_spend
from users_total_spend u
join regions_avg_spend r on u.id_region = r.id_region
WHERE u.total_spend > r.avg_spend;
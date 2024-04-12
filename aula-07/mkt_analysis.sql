-- partindo de uma data arbitrária na base de dados (2018-07-01), 
-- determinar quais sellers estão há mais de 90 dias sem pedido
-- e quantos estão há mais tempo sem pedido que sua média entre pedidos

with tb_sellers_last_order as
(
    select
        t2.seller_id,
        max(date(t1.order_approved_at)) as last_order,
        julianday('2018-07-01') - julianday(max(date(t1.order_approved_at))) as days_since_last_order

    from 
        tb_orders t1

    left join tb_order_items t2
        on t1.order_id = t2.order_id

    where
        date(t1.order_approved_at) < '2018-07-01'
        and t1.order_status = 'delivered'

    group by
        t2.seller_id
),

tb_seller_mail_flags as 
(
    select 
        t1.seller_id,
        t2.days_since_last_order,
        case
            when t2.days_since_last_order > 90
            then 1 else 0
        end as flag_over_90_days,
        t3.avg_days_between_orders,
        case
            when t3.avg_days_between_orders < t2.days_since_last_order
            then 1 else 0
        end as flag_over_avg

    from tb_sellers t1

    left join tb_sellers_last_order t2
        on t1.seller_id = t2.seller_id

    left join tb_avg_seller_order t3
        on t1.seller_id = t3.seller_id

    where
        t2.days_since_last_order is not null
)

select 
    flag_over_90_days,
    flag_over_avg,
    count(*)
from 
    tb_seller_mail_flags
group by
    flag_over_90_days,
    flag_over_avg
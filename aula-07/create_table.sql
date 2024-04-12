-- tempo entre vendas dos sellers

-- todos os pedidos por seller

drop table if exists tb_avg_seller_order;
create table tb_avg_seller_order as 

with tb_seller_order as
(
    select
        t1.order_id,
        date(t1.order_approved_at) as order_date,
        t2.seller_id

    from 
        tb_orders t1

    left join tb_order_items t2
        on t1.order_id = t2.order_id

    where t1.order_status = 'delivered'
),

-- conta dias duplicados, para serem removidos
tb_seller_order_sort as
(
    select
        *,
        row_number() over (
            partition by
                seller_id,
                order_date
            ) as order_rank

    from tb_seller_order
),

-- lag na coluna de data, para poder calcular a diferença em dias na mesma linha
tb_seller_order_date_diff as
(
    select 
        order_id,
        order_date,
        seller_id,
        lag(order_date) over (
            partition by
                seller_id
            order by
                order_date asc
            ) as previous_order_date

    from 
        tb_seller_order_sort 
    where 
        order_rank = 1
),

-- calcula diferença do segundo pedido em diante

tb_seller_order_days_diff as 
(
    select
        *,
        julianday(order_date) - julianday(previous_order_date) as days_between_orders

    from
        tb_seller_order_date_diff

    where
        previous_order_date is not null
)


-- calcula média entre tempo de pedidos
select
    seller_id,
    round(avg(days_between_orders), 2) as avg_days_between_orders

from
    tb_seller_order_days_diff

group by
    seller_id
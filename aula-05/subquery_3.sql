-- receita por estado do seller, por produto, da categoria mais vendida
-- considerar apenas pedidos entregues
-- três subqueries separadas, consulta final como resultado de ambas (melhor prática)

with 

tb_top_category as (
    select 
        t2.product_category_name
    from
        tb_order_items t1
    left join tb_products t2 
        on t1.product_id = t2.product_id
    group by
        t2.product_category_name
    order by sum(t1.price) desc
    limit 1
),

tb_delivered_orders as (
    select
        order_id
    from 
        tb_orders
    where
        order_status = 'delivered'
)

tb_revenue_by_state_product as (
    select 
        t2.seller_state,
        t1.product_id, 
        t3.product_category_name,
        sum(t1.price) as total_revenue

    from tb_order_items t1

    left join tb_sellers t2
        on t1.seller_id = t2.seller_id

    left join tb_products t3
        on t1.product_id = t3.product_id

    inner join tb_delivered_orders t4
        on t1.order_id = t4.order_id

    group by
        t1.product_id,
        t2.seller_state,
        t3.product_category_name
)


-- consulta final
select
    t1.*
from
    tb_revenue_by_state_product t1

inner join tb_top_category t2
    on t1.product_category_name = t2.product_category_name


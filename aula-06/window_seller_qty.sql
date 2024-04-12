-- qual o produto mais vendido de cada seller?
-- considere apenas pedidos entregues
-- calcule usando window functions

with tb_seller_product as
(
select
    t1.seller_id,
    t1.product_id,
    count(t1.product_id) as qty_product,
    sum(t1.price) as revenue
from 
    tb_order_items t1

left join tb_orders t2
    on t1.order_id = t2.order_id

where
    t2.order_status = 'delivered'

group by
    t1.seller_id,
    t1.product_id
),

tb_seller_product_sort as
(
    select
        *,
        row_number() over (
            partition by seller_id
            order by
                qty_product desc,
                revenue desc
        ) as product_rank
    from
        tb_seller_product
)

select
    seller_id, 
    product_id, 
    qty_product
from
    tb_seller_product_sort
where
    product_rank = 1
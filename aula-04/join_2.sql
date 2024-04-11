-- qual a receita total por categoria de produto?
-- e quantidade de vendas em unidades e pedidos?
-- considerando apenas pedidos de 2017 entregues

select
    t2.product_category_name,
    round(sum(t1.price), 2) as total_revenue,
    count(t1.product_id) as qty_products,
    count(distinct t1.order_id) as qty_orders,
    round(cast(count(t1.product_id) as float) / count(distinct t1.order_id), 2) as avg_items_per_order
from tb_order_items t1

left join tb_products t2 
    on t1.product_id = t2.product_id

left join tb_orders t3
    on t1.order_id = t3.order_id

where 
    t2.product_category_name is not null
    and t3.order_status = 'delivered'
    and cast(strftime('%Y', t3.order_approved_at) as int) = 2017

group by
    t2.product_category_name

order by avg_items_per_order desc


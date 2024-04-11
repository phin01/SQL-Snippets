-- receita por estado do seller, por produto, da categoria mais vendida
-- condição where usando resultado de outra query (fora das boas práticas)

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

-- subquery para buscar a categoria mais vendida
where
    t3.product_category_name = (
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
    )

group by
    t1.product_id,
    t2.seller_state,
    t3.product_category_name



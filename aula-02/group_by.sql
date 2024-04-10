select 
    product_category_name,
    count(*) as qty_products,
    max(product_weight_g) as max_weight,
    min(product_weight_g) as min_weight,
    avg(product_weight_g) as avg_weight
from
    tb_products
where
    product_category_name is not null
    and product_category_name <> 'automotivo'
group by
    product_category_name
select 
    product_category_name,
    min(product_name_lenght) as min_name_lenght,
    max(product_name_lenght) as max_name_length,
    avg(product_name_lenght) as avg_name_length
from
    tb_products
where 
    product_category_name is not null
    and product_description_lenght > 50
group by
    product_category_name
having
    avg(product_description_lenght) > 200
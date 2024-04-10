select 
    distinct (coalesce(product_category_name, null, null, 'others', null))
    as category_fillna
from
    tb_products
order by 
    category_fillna
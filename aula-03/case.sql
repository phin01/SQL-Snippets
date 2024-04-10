select 
    distinct (
        case
            when product_category_name is null then 'others'
            when product_category_name = 'casa_conforto_2' then 'casa_conforto'
            when product_category_name like '%artigo%' then 'artigos'
            else product_category_name
        end
    ) as category_fillna
from
    tb_products
order by 
    category_fillna
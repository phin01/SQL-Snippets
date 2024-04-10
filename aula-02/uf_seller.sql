select 
    seller_state,
    count(distinct seller_id) as qty_sellers
from
    tb_sellers
where
     seller_state in ('SP', 'RJ', 'MG', 'ES')    
group by
    seller_state
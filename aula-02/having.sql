select 
    seller_state,
    count(distinct seller_id) as qty_sellers
from
    tb_sellers
group by
    seller_state
having
    qty_sellers > 10
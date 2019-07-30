creat view vw_惠我良多 as
select  tel, aa.sum_fee
from(
    select sum(fee) as sum_fee
    from bill
    group by tel
    order by sum_fee desc
    limit 1
)as aa,(
    select tel,sum(fee) as sum_fee
    from bill
    group by tel
)as bb
where aa.sum_fee = bb.sum_fee
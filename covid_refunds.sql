Select
patronId || chr(9) ||
postAmount || chr(9) ||
fineFeeTransactionType || chr(9) ||
fineFeeTransactionMethod || chr(9) ||
fineFeeId
from
(
select distinct
ff.patron_id patronId,
fft.trans_amount/100 postAmount, -- forgive the whole amount
6 fineFeeTransactionType, -- Bursar Refund
0 fineFeeTransactionMethod,
ff.fine_fee_id fineFeeId
from
ucladb.fine_fee_transactions fft,
ucladb.fine_fee ff
where
fft.fine_fee_id = ff.fine_fee_id
and fft.trans_type = 5
and ff.create_date >= trunc(to_date('03/20/2020','MM/DD/YYYY'))
and not exists
(
select
*
from
ucladb.fine_fee_transactions fft2
where
fft.fine_fee_id = fft2.fine_fee_id
and fft2.trans_type = 6 -- Bursar Refund
)
)
;

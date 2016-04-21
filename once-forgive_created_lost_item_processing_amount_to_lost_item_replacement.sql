select 
  patronId || chr(9) ||
  postAmount || chr(9) ||
  fineFeeTransactionType || chr(9) ||
  fineFeeTransactionMethod || chr(9) ||
  fineFeeId
from
(
SELECT DISTINCT
  ff.patron_id patronId,
  case 
    when ff.fine_fee_balance < 1000 then ff.fine_fee_balance/100
    else 10
  end postAmount,
  2 fineFeeTransactionType,
  0 fineFeeTransactionMethod,
  ff.fine_fee_id fineFeeId
FROM 
  ucladb.fine_fee ff 
LEFT OUTER JOIN 
  ucladb.fine_fee_type fftp ON ff.fine_fee_type = fftp.fine_fee_type 
LEFT OUTER JOIN 
  ucladb.fine_fee_transactions fft ON ff.fine_fee_id = fft.fine_fee_id 
LEFT OUTER JOIN
  ucladb.item i ON ff.item_id = i.item_id
WHERE 
  ff.fine_fee_type = 2
  and ff.fine_fee_balance > 0
  and (i.price = 0 or i.price >= 1000)
order by 
  ff.patron_id,
  ff.fine_fee_id
)
;

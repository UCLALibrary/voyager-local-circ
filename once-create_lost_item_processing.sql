select 
  patronId || chr(9) ||
  itemBarcode || chr(9) ||
  fineFeeType || chr(9) ||
  amount
from
(
SELECT DISTINCT
  ff.patron_id patronId,
  ib.item_barcode itemBarcode,
  3 fineFeeType,
  case 
    when ff.fine_fee_balance < 1000 then ff.fine_fee_balance/100
    else 10
  end amount
FROM 
  ucladb.fine_fee ff 
LEFT OUTER JOIN 
  ucladb.fine_fee_type fftp ON ff.fine_fee_type = fftp.fine_fee_type 
LEFT OUTER JOIN 
  ucladb.fine_fee_transactions fft ON ff.fine_fee_id = fft.fine_fee_id 
LEFT OUTER JOIN
  ucladb.item i ON ff.item_id = i.item_id
LEFT OUTER JOIN
  ucladb.item_barcode ib on i.item_id = ib.item_id
WHERE 
  ff.fine_fee_type = 2
  and ff.fine_fee_balance > 0
  and (i.price = 0 or i.price >= 1000)
order by 
  ff.patron_id,
  ib.item_barcode
)
;

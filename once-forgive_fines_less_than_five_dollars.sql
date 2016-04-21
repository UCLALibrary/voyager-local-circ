select 
  patronId || chr(9) ||
  postAmount || chr(9) ||
  fineFeeTransactionType || chr(9) ||
  fineFeeTransactionMethod || chr(9) ||
  fineFeeId || chr(9) ||
  'Fine less than $5 automatically forgiven.'
from
(
SELECT DISTINCT
  ff.patron_id patronId,
  ff.fine_fee_balance/100 postAmount, -- forgive the whole amount
  2 fineFeeTransactionType, -- Forgive
  0 fineFeeTransactionMethod, 
  ff.fine_fee_id fineFeeId
FROM
  ucladb.fine_fee ff
INNER JOIN
  ucladb.item_status itst on ff.item_id = itst.item_id
WHERE
  ff.fine_fee_amount < 500 and
  ff.fine_fee_balance > 0 and
  ff.fine_fee_balance < 500
)
;

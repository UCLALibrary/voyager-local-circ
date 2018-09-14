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
  fft.trans_amount/100 postAmount, -- forgive the whole amount
  6 fineFeeTransactionType, -- refund
  0 fineFeeTransactionMethod, 
  ff.fine_fee_id fineFeeId
FROM
  ucladb.fine_fee ff
  INNER JOIN ucladb.item_status itst on ff.item_id = itst.item_id
  INNER JOIN ucladb.fine_fee_transactions fft ON ff.fine_fee_id = fft.fine_fee_id
WHERE
  ff.fine_fee_type = 2 -- Lost Item Replacement
  AND fft.trans_type = 5 -- Bursar Transfer
  AND fft.trans_note like '%Invoiced in LibBill%'
  AND 
  (
    -- The item has a "discharged" status.
    (
      itst.item_status = 1 or  -- Not Charged
      itst.item_status = 3 or  -- Renewed
      itst.item_status = 7 or  -- On Hold
      itst.item_status = 9 or  -- In Transit Discharged
      itst.item_status = 10 or -- In Transit On Hold
      itst.item_status = 11    -- Discharged
    )
    or
    -- The item is currently charged to another patron.
    -- This takes care of the case when an item is discharged
    -- and charged out before the nightly run of the script.
    exists
    (
      select 
        *
      from
        ucladb.circ_transactions ct
      where
        ff.item_id = ct.item_id and
        ff.patron_id <> ct.patron_id
    )
  )
  AND NOT EXISTS
  (
    select * from ucladb.fine_fee_transactions fft2 where fft2.fine_fee_id = ff.fine_fee_id and fft2.trans_type = 6
  )
)
;

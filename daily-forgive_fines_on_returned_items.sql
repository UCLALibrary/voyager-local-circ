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
  ff.fine_fee_balance/100 postAmount, -- forgive the whole amount
  2 fineFeeTransactionType, -- Forgive
  0 fineFeeTransactionMethod, 
  ff.fine_fee_id fineFeeId
FROM
  ucladb.fine_fee ff
INNER JOIN
  ucladb.item_status itst on ff.item_id = itst.item_id
--LEFT OUTER JOIN
--  ucladb.fine_fee_transactions fft ON ff.fine_fee_id = fft.fine_fee_id
WHERE
  ff.fine_fee_type = 2 -- Lost Item Replacement
  and ff.fine_fee_balance > 0
  and 
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
UNION ALL
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
INNER JOIN
  ucladb.patron_barcode pb on ff.patron_id = pb.patron_id and barcode_status = 1
--LEFT OUTER JOIN
--  ucladb.fine_fee_transactions fft ON ff.fine_fee_id = fft.fine_fee_id
WHERE
  ff.fine_fee_type = 3 -- Lost Item Processing
  and 
  (
    pb.patron_group_id = 32 or --ILL UC - Acad and Grads
    pb.patron_group_id = 33 or --ILL UC - Staff and UGs
    pb.patron_group_id = 37 or --Contractual Partners
    pb.patron_group_id = 29 or --ILL - Non UC
    pb.patron_group_id = 30    --Internal Use Only
  )
  and ff.fine_fee_balance > 0
  and 
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
)
;

select 
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
    ucladb.fine_fee ff,
    ucladb.item_status itst,
    ucladb.patron_barcode pb
  where
    ff.patron_id = pb.patron_id and pb.barcode_status = 1
    and ff.item_id = itst.item_id
    and fft.fine_fee_id = ff.fine_fee_id
    and fft.trans_type = 5
    and fft.trans_note is not null 
    AND 
    (
    	--BAR writes-off unpaid charges 180 days after first posting
    	(SUBSTR(fft.trans_note, 10, 11) = 'Sent to BAR'
    	 AND (TRUNC(SYSDATE) - TRUNC(fft.trans_date)) < 180)
    	OR 
	--CSC doesn't do refunds 6 months after fine/fee paid
    	(SUBSTR(fft.trans_note, 10, 11) = 'Paid in BAR'
         AND (TRUNC(SYSDATE) - TRUNC(TO_DATE(SUBSTR(fft.trans_note, 1, 8), 'MM/DD/YY'))) < 180)
    )
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
    and 
    (
      (
        ff.fine_fee_type = 2
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
      or
      (
        ff.fine_fee_type = 3
        and 
        (
          pb.patron_group_id = 32 or --ILL UC - Acad and Grads
          pb.patron_group_id = 33 or --ILL UC - Staff and UGs
          pb.patron_group_id = 37 or --Contractual Partners
          pb.patron_group_id = 29    --ILL - Non UC
        )
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
    )
)
;

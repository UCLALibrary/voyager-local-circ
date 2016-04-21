select
  patronId || chr(9) ||
  postAmount || chr(9) ||
  fineFeeTransactionType || chr(9) ||
  fineFeeTransactionMethod || chr(9) ||
  fineFeeId
from
(
select distinct
  ff2.patron_id patronId,
  ff2.fine_fee_balance/100 postAmount,
  3 fineFeeTransactionType, --Error
  0 fineFeeTransactionMethod,
  ff2.fine_fee_id fineFeeId
--  pb.patron_barcode, 
--  ib.item_barcode, ib.barcode_status,
--  ib2.item_barcode, ib2.barcode_status,
--  ff.*, ff2.*
from 
  ucladb.fine_fee ff
inner join
  ucladb.fine_fee ff2 on 
    ff.patron_id = ff2.patron_id and 
    ff.item_id = ff2.item_id and 
    ff.fine_fee_type = 3 and 
    ff2.fine_fee_type = 3 and 
    ff.fine_fee_id < ff2.fine_fee_id
inner join
  ucladb.patron p on ff.patron_id = p.patron_id
inner join 
  ucladb.patron_barcode pb on p.patron_id = pb.patron_id
inner join
  ucladb.item_barcode ib on ff.item_id = ib.item_id
inner join
  ucladb.item_barcode ib2 on ff2.item_id = ib2.item_id
where
  TO_CHAR(ff.create_date, 'MM/DD/YYYY') = '08/01/2007' and
  TO_CHAR(ff2.create_date, 'MM/DD/YYYY') = '08/01/2007' and
  ib.barcode_status = 1 and
  ib2.barcode_status <> 1
--  not exists
--  (
--    select * from ucladb.item_barcode ib2
--    where ib.item_id = ib2.item_id and ib.item_barcode <> ib2.item_barcode
--  )
--order by pb.patron_barcode, ib.item_barcode, ff.fine_fee_id
)
order by patronId, fineFeeId
;

with bar_charges as
(
select 
  ff.patron_id,
  ff.item_id,
  ff.fine_fee_balance,
  ff.fine_fee_type,
  ff.fine_fee_id,
  sc.subcode,
  row_number() over (partition by ff.patron_id, sc.subcode order by ff.item_id, ff.fine_fee_type, ff.fine_fee_id) ff_order
from 
  ucladb.fine_fee ff
inner join
  ucladb.patron p on ff.patron_id = p.patron_id
-- Join with Voyager's patron_barcode table. Pick only active status barcodes.
inner join 
  ucladb.PATRON_BARCODE pb on pb.patron_id = p.patron_id and pb.barcode_status = 1
-- Join with Voyager's patron_group table.
inner join 
  ucladb.PATRON_GROUP pg on pg.patron_group_id = pb.patron_group_id
-- Join with patron_group_components table.
inner join 
  patron_group_components pgc on pgc.patron_group_id = pg.patron_group_id    
-- Join with Registrar data.
inner join 
  vger_report.CMP_REGISTRAR reg on p.institution_id = reg.university_id
inner join 
  ucladb.item i on ff.item_id = i.item_id
inner join 
  ucladb.location il on i.perm_location = il.location_id
inner join 
  ucladb.circ_policy_locs cpl ON i.perm_location = cpl.location_id
inner join 
  vger_support.cb_subcodes sc ON vger_support.lws_cb.GET_SUBCODE_KEY(cpl.circ_group_id, il.location_code) = sc.circ_group_id and ff.fine_fee_type = sc.fine_fee_type
inner join
  vger_report.cmp_extr_ind ei on p.institution_id = ei.stu_id
where
  -- For the Pilot the criteria is:
  --
  -- Patrons in a student patron group who are in the registrar data who have
  -- a lastname starting A-M.
  --
  -- Pick patrons with lastname starting A-M.
  ascii(substr(p.last_name, 0, 1)) between 65 and 77 -- A-M
  -- Pick only records for students.
  and (pgc.type  = 2 or pgc.type  = 3)
  -- Students in the Registrar data are active if the withdraw field is null.
  and reg.withdraw is null
  and ff.fine_fee_balance > 0
  -- Pick only records who haven't expired.
  and p.expire_date > sysdate
  -- Pick only records that have one active barcode. 
  and not exists 
  (
    SELECT * FROM ucladb.PATRON_BARCODE pb2 
    where 
      pb2.patron_id = p.patron_id 
      and pb2.patron_barcode_id <> pb.patron_barcode_id
      and pb2.barcode_status = 1
  )
order by
  ff.patron_id,
  sc.subcode,
  ff_order
)
select 
  bc.patron_id || chr(9) ||
  bc.fine_fee_balance / 100 || chr(9) ||
  5 || chr(9) ||
  0 || chr(9) ||
  bc.fine_fee_id || chr(9) ||
  to_char(sysdate, 'MM/DD/YY') || ' ' ||
  'Sent to BAR                   ' || 
  vger_support.lws_utility.current_term || ' ' || 
  bc.subcode ||
  to_char
  (
    decode
    (
      (
        select 
          max(to_number(vger_support.lws_cb.get_seqno(ms_fft.trans_note))) max_seqno
        from 
          ucladb.fine_fee ms_ff
        inner join 
          ucladb.fine_fee_transactions ms_fft on ms_ff.fine_fee_id = ms_fft.fine_fee_id
        where 
          ms_ff.patron_id = bc.patron_id and
          vger_support.lws_cb.get_term(ms_fft.trans_note) = vger_support.lws_utility.current_term and 
          vger_support.lws_cb.get_subcode(ms_fft.trans_note) = bc.subcode
      ), null, 0,
      (
        select 
          max(to_number(vger_support.lws_cb.get_seqno(ms_fft.trans_note))) max_seqno
        from 
          ucladb.fine_fee ms_ff
        inner join 
          ucladb.fine_fee_transactions ms_fft on ms_ff.fine_fee_id = ms_fft.fine_fee_id
        where 
          ms_ff.patron_id = bc.patron_id and
          vger_support.lws_cb.get_term(ms_fft.trans_note) = vger_support.lws_utility.current_term and 
          vger_support.lws_cb.get_subcode(ms_fft.trans_note) = bc.subcode
      ) -- end max_seqno subquery
    ) -- end decode
    + bc.ff_order, '0009'
  ) -- end tochar
from 
  bar_charges bc
;

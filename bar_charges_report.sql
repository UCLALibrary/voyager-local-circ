with bar_charges as
(
select
  ff.patron_id,
  p.institution_id,
  ff.item_id,
  ff.fine_fee_balance,
  ff.fine_fee_id,
  ff.fine_fee_type,
  sc.subcode,
  row_number() over (partition by ff.patron_id, sc.subcode order by ff.item_id, ff.fine_fee_type, ff.fine_fee_id) ff_order,
  cpl.circ_group_id,
  i.perm_location 
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
  vger_support.patron_group_components pgc on pgc.patron_group_id = pg.patron_group_id    
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
where
  -- For the Pilot the criteria is:
  --
  -- Patrons in a student patron group who are in the registrar data who have
  -- a lastname starting A-M.
  --
  -- Pick patrons with lastname starting A-M.
  ascii(substr(p.last_name, 0, 1)) between 65 and 77 -- A-M
  --ascii(substr(p.last_name, 0, 1)) between 78 and 90 -- N-Z
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
  cpg.circ_group_name,
  decode(t_l.location_name, null, l.location_name, t_l.location_name) location,
  institution_id as university_id,
  vger_support.lws_utility.current_term as current_term,
  sc.subcode,
  bc.fine_fee_balance / 100 as fine_fee_balance,
  unifix(bt.TITLE) as title,
  unifix(bt.author) as author,
  iv.BARCODE as item_barcode,
  iv.CALL_NO as call_no,
  iv.ENUMERATION as enumeration
from
  bar_charges bc
inner join 
  ucladb.item i on bc.item_id = i.item_id
inner join 
  ucladb.location il on i.perm_location = il.location_id
inner join 
  ucladb.circ_policy_locs cpl ON i.perm_location = cpl.location_id
left outer join
  ucladb.circ_policy_group cpg ON cpl.circ_group_id = cpg.circ_group_id 
left outer join
  ucladb.location l ON i.perm_location = l.location_id
left outer join
  ucladb.location t_l ON i.temp_location = t_l.location_id
inner join 
  vger_support.cb_subcodes sc ON vger_support.lws_cb.GET_SUBCODE_KEY(cpl.circ_group_id, il.location_code) = sc.circ_group_id and bc.fine_fee_type = sc.fine_fee_type
inner join
  ucladb.BIB_ITEM bi on bc.item_id = bi.item_id
inner join
  ucladb.bib_text bt on bi.bib_id = bt.bib_id
inner join
  ucladb.item_vw iv on bi.item_id = iv.item_id
order by
  cpg.circ_group_name,
  decode(t_l.location_name, null, l.location_name, t_l.location_name)
;

with bar_charges as
(
select
  ff.patron_id,
  p.institution_id,
  vger_support.lws_cb.det_extr_ind(reg.major1) as extr_ind, 
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
  -- The criteria is:
  --
  -- Patrons in a student patron group who are in the registrar data.
  --
  -- Pick only records for students.
  (pgc.type  = 2 or pgc.type  = 3)
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
select bar_line from
(
select
  0,0,0,0,0,
  vger_support.LWS_CB.GET_BATCH_HEADER(
    (select count(*) from bar_charges),
    (select sum(bc.fine_fee_balance) from bar_charges bc)
  ) bar_line
  from dual
union all
-- BAR Charges
select
  1,bc.patron_id,bc.item_id,bc.fine_fee_type,bc.fine_fee_id,
  vger_support.LWS_CB.GET_65A(
    bc.extr_ind, -- EXTERNAL ID, blank = student, M = FEMBA/EMBA student
    bc.institution_id, -- UNIVERSITY ID
    sc.subcode,
    vger_support.lws_utility.current_term(bc.institution_id), -- TERM
    bc.fine_fee_balance -- TRAN AMOUNT
  ) || chr(10) ||
  vger_support.LWS_CB.GET_65AT(
    bc.extr_ind, -- EXTERNAL ID, blank = student
    bc.institution_id, -- UNIVERSITY ID
    sc.subcode,
    vger_support.lws_utility.current_term(bc.institution_id), -- TERM
    'Title:     ' || unifix(bt.TITLE) -- TEXT
  ) || chr(10) ||
  vger_support.LWS_CB.GET_65AT(
    bc.extr_ind, -- EXTERNAL ID, blank = student
    bc.institution_id, -- UNIVERSITY ID
    sc.subcode,
    vger_support.lws_utility.current_term(bc.institution_id), -- TERM
    'Author:    ' || unifix(bt.author) -- TEXT
  ) || chr(10) ||
  vger_support.LWS_CB.GET_65AT(
    bc.extr_ind, -- EXTERNAL ID, blank = student
    bc.institution_id, -- UNIVERSITY ID
    sc.subcode,
    vger_support.lws_utility.current_term(bc.institution_id), -- TERM
    'Item ID:   ' || iv.BARCODE -- TEXT
  ) || chr(10) ||
  vger_support.LWS_CB.GET_65AT(
    bc.extr_ind, -- EXTERNAL ID, blank = student
    bc.institution_id, -- UNIVERSITY ID
    sc.subcode,
    vger_support.lws_utility.current_term(bc.institution_id), -- TERM
    'Call #:    ' || iv.CALL_NO -- TEXT
  ) ||
  decode(iv.ENUMERATION, null, '',
    chr(10) || vger_support.LWS_CB.GET_65AT(
      bc.extr_ind, -- EXTERNAL ID, blank = student
      bc.institution_id, -- UNIVERSITY ID
      sc.subcode,
      vger_support.lws_utility.current_term(bc.institution_id), -- TERM
      'Item Desc: ' || iv.ENUMERATION -- TEXT
    )
  ) bar_line
from
  bar_charges bc
inner join 
  ucladb.item i on bc.item_id = i.item_id
inner join 
  ucladb.location il on i.perm_location = il.location_id
inner join 
  ucladb.circ_policy_locs cpl ON i.perm_location = cpl.location_id
inner join 
  vger_support.cb_subcodes sc ON vger_support.lws_cb.GET_SUBCODE_KEY(cpl.circ_group_id, il.location_code) = sc.circ_group_id and bc.fine_fee_type = sc.fine_fee_type
inner join
  ucladb.BIB_ITEM bi on bc.item_id = bi.item_id
inner join
  ucladb.bib_text bt on bi.bib_id = bt.bib_id
inner join
  ucladb.item_vw iv on bi.item_id = iv.item_id
order by 1, 2, 3, 4, 5
)
;

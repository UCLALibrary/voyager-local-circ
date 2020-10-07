with 
bar_reversals as
(
select
  ff.patron_id,
  p.institution_id,
  vger_support.lws_cb.get_extr_ind(fft.trans_note) as extr_ind,
  ff.item_id,
  fft.TRANS_AMOUNT as fine_fee_balance,
  ff.fine_fee_type,
  ff.fine_fee_id,
  sc.subcode,
  fft.trans_note as bursar_transfer_note,
  row_number() over (partition by ff.patron_id, sc.subcode order by ff.item_id, ff.fine_fee_type, ff.fine_fee_id) ff_order
from
  ucladb.fine_fee ff
inner join
  ucladb.patron p on ff.patron_id = p.patron_id
inner join 
  ucladb.item i on ff.item_id = i.item_id
inner join 
  ucladb.location il on i.perm_location = il.location_id
inner join 
  ucladb.circ_policy_locs cpl ON i.perm_location = cpl.location_id
inner join 
  vger_support.cb_subcodes sc ON vger_support.lws_cb.GET_SUBCODE_KEY(cpl.circ_group_id, il.location_code) = sc.circ_group_id and ff.fine_fee_type = sc.fine_fee_type
inner join 
  ucladb.fine_fee_transactions fft on ff.fine_fee_id = fft.fine_fee_id
where
  trunc(fft.trans_date) = trunc(sysdate) 
  and fft.trans_note like '%Sent to BAR%'
  and fft.trans_type = 6
order by
  ff.patron_id,
  vger_support.lws_cb.get_term(fft.trans_note),
  sc.subcode,
  vger_support.lws_cb.get_seqno(fft.trans_note)
)
select bar_line from
(
select
  2,0,0,0,0,
  vger_support.LWS_CB.GET_65C(
    br.extr_ind, -- EXTERNAL ID, blank = student
    institution_id, -- UNIVERSITY ID
    vger_support.lws_cb.get_subcode(bursar_transfer_note), -- SUBCODE
    vger_support.lws_cb.get_term(bursar_transfer_note), -- TERM
    vger_support.lws_cb.get_seqno(bursar_transfer_note) -- SEQUENCE NUMBER
  ),
  vger_support.LWS_CB.GET_65C(
    br.extr_ind, -- EXTERNAL ID, blank = student
    institution_id, -- UNIVERSITY ID
    vger_support.lws_cb.get_subcode(bursar_transfer_note), -- SUBCODE
    vger_support.lws_cb.get_term(bursar_transfer_note), -- TERM
    vger_support.lws_cb.get_seqno(bursar_transfer_note) -- SEQUENCE NUMBER
  ) bar_line
from 
  bar_reversals br
order by 1, 2, 3, 4, 5, 6
)
;

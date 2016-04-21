update 
  ucladb.fine_fee_transactions fft
set 
  trans_note = 
  (
    select 
        to_char(b.trans_paid_dt, 'MM/DD/YY') || ' ' || -- should this be sysdate?
        'Paid in BAR                   ' || 
        vger_support.lws_cb.get_term(fft.trans_note) || ' ' || 
        vger_support.lws_cb.get_subcode(fft.trans_note) || ' ' || 
        vger_support.lws_cb.get_seqno(fft.trans_note)
    from
      ucladb.fine_fee ff, 
      ucladb.patron p, 
      vger_report.cmp_bar b
    where
      fft.fine_fee_id = ff.fine_fee_id and
      substr(fft.trans_note, 10, 11) = 'Sent to BAR' and
      ff.patron_id = p.patron_id and 
      p.institution_id = b.stu_id and 
      vger_support.lws_cb.get_subcode(fft.trans_note) = b.br_subcode_num and
      vger_support.lws_cb.get_term(fft.trans_note) = b.acad_term and
      vger_support.lws_cb.get_seqno(fft.trans_note) = br_seq_num and
      b.paid_appld_amt > 0 and b.processed is null
  )
where
  exists
  (
    select 
      *
    from
      ucladb.fine_fee ff, 
      ucladb.patron p, 
      vger_report.cmp_bar b
    where
      fft.fine_fee_id = ff.fine_fee_id and
      substr(fft.trans_note, 10, 11) = 'Sent to BAR' and
      ff.patron_id = p.patron_id and 
      p.institution_id = b.stu_id and 
      vger_support.lws_cb.get_subcode(fft.trans_note) = b.br_subcode_num and
      vger_support.lws_cb.get_term(fft.trans_note) = b.acad_term and
      vger_support.lws_cb.get_seqno(fft.trans_note) = br_seq_num and
      b.paid_appld_amt > 0 and b.processed is null
  )
;


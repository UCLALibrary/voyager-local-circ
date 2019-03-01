update 
  ucladb.fine_fee_transactions fft_br
set 
  trans_note = 
  (
    select 
      to_char(b.trans_paid_dt, 'MM/DD/YY') || ' ' ||
      'Credited in BAR               ' || 
      vger_support.lws_cb.get_term(fft_bt.trans_note) || ' ' || 
      vger_support.lws_cb.get_subcode(fft_bt.trans_note) || 
      -- Calculate sequence numbers for reversals.
      -- to_char puts a space in front of regular numbers.
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
              ms_ff.patron_id = ff.patron_id and
              vger_support.lws_cb.get_subcode(ms_fft.trans_note) = vger_support.lws_cb.get_subcode(fft_bt.trans_note) and
              vger_support.lws_cb.get_term(ms_fft.trans_note) = vger_support.lws_cb.get_term(fft_bt.trans_note)
          ), null, 0,
          (
            select 
              max(to_number(vger_support.lws_cb.get_seqno(ms_fft.trans_note))) max_seqno
            from 
              ucladb.fine_fee ms_ff
            inner join 
              ucladb.fine_fee_transactions ms_fft on ms_ff.fine_fee_id = ms_fft.fine_fee_id
            where 
              ms_ff.patron_id = ff.patron_id and
              vger_support.lws_cb.get_subcode(ms_fft.trans_note) = vger_support.lws_cb.get_subcode(fft_bt.trans_note) and
              vger_support.lws_cb.get_term(ms_fft.trans_note) = vger_support.lws_cb.get_term(fft_bt.trans_note)
          ) -- end max_seqno subquery
        ) -- end decode
        +1, '0009'
      ) -- end tochar
    from
      ucladb.fine_fee ff,
      ucladb.fine_fee_transactions fft_bt,
      ucladb.patron p, 
      vger_report.cmp_bar b
    where
      ff.patron_id = p.patron_id and 
      p.institution_id = b.stu_id and 
      ff.fine_fee_id = fft_bt.fine_fee_id and fft_bt.trans_type = 5 and -- Bursar Transfer
      ff.fine_fee_id = fft_br.fine_fee_id and fft_br.trans_type = 6 and -- Bursar Refund
      vger_support.lws_cb.get_subcode(fft_bt.trans_note) = b.br_subcode_num and
      vger_support.lws_cb.get_term(fft_bt.trans_note) = b.acad_term and
      b.paid_appld_amt < 0 and b.processed is null and
      -- Exclude reversals which have already been credited in BAR.
      (nvl(substr(fft_br.trans_note, 10, 15), '<NULL>') <> 'Credited in BAR')
	  -- exclude libbill refunds
	  and (nvl(fft_br.trans_note, '<NULL>') not like '%LibBill%')
  )
where 
  exists 
  (
    select 
      *
    from
      ucladb.fine_fee ff,
      ucladb.fine_fee_transactions fft_bt,
      ucladb.patron p, 
      vger_report.cmp_bar b
    where
      ff.patron_id = p.patron_id and 
      p.institution_id = b.stu_id and 
      ff.fine_fee_id = fft_bt.fine_fee_id and fft_bt.trans_type = 5 and -- Bursar Transfer
      ff.fine_fee_id = fft_br.fine_fee_id and fft_br.trans_type = 6 and -- Bursar Refund
      vger_support.lws_cb.get_subcode(fft_bt.trans_note) = b.br_subcode_num and
      vger_support.lws_cb.get_term(fft_bt.trans_note) = b.acad_term and
      b.paid_appld_amt < 0 and b.processed is null and
      -- Exclude reversals which have already been credited in BAR.
      (nvl(substr(fft_br.trans_note, 10, 15), '<NULL>') <> 'Credited in BAR')
	  and (nvl(fft_br.trans_note, '<NULL>') not like '%LibBill%')
  )
;

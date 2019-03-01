update 
  ucladb.fine_fee_transactions fft_br_upd
set 
  trans_note = 
  (
    select 
      new_trans_note
    from
    (
      select 
        fft_br.fine_fee_trans_id,
        to_char(sysdate, 'MM/DD/YY') || 
        vger_support.lws_cb.get_extr_ind(fft_bt.trans_note) ||
        'Sent to BAR                   ' || 
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
          + row_number() over (partition by vger_support.lws_cb.get_term(fft_bt.trans_note), ff.patron_id, sc.subcode order by vger_support.lws_cb.get_seqno(fft_bt.trans_note)), '0009'
        ) new_trans_note -- end tochar
      from
        ucladb.fine_fee_transactions fft_br,
        ucladb.fine_fee ff,
        ucladb.fine_fee_transactions fft_bt,
        ucladb.item i,
        ucladb.location il,
        ucladb.circ_policy_locs cpl,
        vger_support.cb_subcodes sc
      where
        ff.fine_fee_id = fft_bt.fine_fee_id and fft_bt.trans_type = 5 and -- Bursar Transfer
        ff.fine_fee_id = fft_br.fine_fee_id and fft_br.trans_type = 6 and -- Bursar Refund
        -- BAR can only reverse complete charges so we only want to get the ones that are for the full amount transferred.
        fft_bt.trans_amount = fft_br.trans_amount and
        ff.item_id = i.item_id and
        i.perm_location = il.location_id and
        i.perm_location = cpl.location_id and
        vger_support.lws_cb.GET_SUBCODE_KEY(cpl.circ_group_id, il.location_code) = sc.circ_group_id and ff.fine_fee_type = sc.fine_fee_type and
        -- Exclude reversals which have already been sent to BAR.
        (nvl(substr(fft_br.trans_note, 10, 11), '<NULL>') <> 'Sent to BAR') and
        -- Exclude reversals which have already been credited in BAR.
        (nvl(substr(fft_br.trans_note, 10, 15), '<NULL>') <> 'Credited in BAR')
        -- Exclude LibBill refunds
        and (nvl(fft_br.trans_note, '<NULL>') not like '%LibBill%')
        -- Exclude any accidental duplicate reversals a staff member may have created.
        -- These are for the full fine amount.
        and not exists
        (
          select 
            * 
          from 
          ucladb.fine_fee_transactions fft_br2
            where 
              fft_br.fine_fee_id = fft_br2.fine_fee_id
              and fft_br2.trans_type = 6 -- Bursar Refund
              and fft_bt.trans_amount = fft_br2.trans_amount
              and fft_br.fine_fee_trans_id < fft_br2.fine_fee_trans_id
        )
    ) tmp
    where
      fine_fee_trans_id = fft_br_upd.fine_fee_trans_id
  )
where 
  exists 
  (
    select
      *
    from
      ucladb.fine_fee ff,
      ucladb.fine_fee_transactions fft_bt,
      ucladb.item i,
      ucladb.location il,
      ucladb.circ_policy_locs cpl,
      vger_support.cb_subcodes sc
    where
      ff.fine_fee_id = fft_bt.fine_fee_id and fft_bt.trans_type = 5 and -- Bursar Transfer
      ff.fine_fee_id = fft_br_upd.fine_fee_id and fft_br_upd.trans_type = 6 and -- Bursar Refund
      -- BAR can only reverse complete charges so we only want to get the ones that are for the full amount transferred.
      fft_bt.trans_amount = fft_br_upd.trans_amount and
      ff.item_id = i.item_id and
      i.perm_location = il.location_id and
      i.perm_location = cpl.location_id and
      vger_support.lws_cb.GET_SUBCODE_KEY(cpl.circ_group_id, il.location_code) = sc.circ_group_id and ff.fine_fee_type = sc.fine_fee_type and
      -- Exclude reversals which have already been sent to BAR.
      (nvl(substr(fft_br_upd.trans_note, 10, 11), '<NULL>') <> 'Sent to BAR') and
      -- Exclude reversals which have already been credited in BAR.
      (nvl(substr(fft_br_upd.trans_note, 10, 15), '<NULL>') <> 'Credited in BAR')
      -- Exclude LibBill refunds
      and (nvl(fft_br_upd.trans_note, '<NULL>') not like '%LibBill%')
      -- Exclude any accidental duplicate reversals a staff member may have created.
      -- These are for the full fine amount.
      and not exists
      (
        select 
          * 
        from 
        ucladb.fine_fee_transactions fft_br2
          where 
            fft_br_upd.fine_fee_id = fft_br2.fine_fee_id
            and fft_br2.trans_type = 6 -- Bursar Refund
            and fft_bt.trans_amount = fft_br2.trans_amount
            and fft_br_upd.fine_fee_trans_id < fft_br2.fine_fee_trans_id
      )
  )
;

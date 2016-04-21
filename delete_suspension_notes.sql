select 
  pn.patron_note_id
from 
  ucladb.patron_notes pn
where 
  note like 'Automated suspension: % in BAR'
and not exists
  (
    select
      patron_id || chr(9) ||
      TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ' 23:59:59' || chr(9) ||
      'More than $100 in BAR'
    from
    (
    select 
      ff.patron_id, fft.trans_amount
    from
      ucladb.fine_fee_transactions fft
    inner join ucladb.fine_fee ff on fft.fine_fee_id = ff.fine_fee_id
    where
      substr(fft.trans_note, 10, 11) = 'Sent to BAR'
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
    )
    where 
      patron_id = pn.patron_id
    group by
      patron_id
    having 
      sum(trans_amount) / 100 >= 100
  )
;

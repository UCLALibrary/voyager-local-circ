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
  fft.trans_note is not null 
  -- Give the patron a chance to see the charge in BAR and pay it.
  and to_date(substr(fft.trans_note, 1, 8), 'MM/DD/YY') <= trunc(sysdate)-4
  and substr(fft.trans_note, 10, 11) = 'Sent to BAR'
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
group by
  patron_id
having 
  sum(trans_amount) / 100 >= 100
;

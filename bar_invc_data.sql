select
br_subcode_num, stu_id, acad_term, br_seq_num, br_invc_num, convert(varchar,trans_paid_dt, 100) as trans_paid_dt, paid_appld_amt
from dbo.br_bill_detl bbd
where
  (user_dept_cd = '5415' or user_dept_cd = '5420' or user_dept_cd = '5445' or user_dept_cd = '5400' or user_dept_cd = '5465') and
  ((br_subcode_num between '22643' and '22678') or br_subcode_num in ('22417','22418')) and 
  not exists
  (
  select * 
  from dbo.br_bill_detl bbd2 
  where
  bbd.stu_id = bbd2.stu_id
  and bbd.br_invc_num = bbd2.br_invc_num
  and bbd2.br_subcode_num in ('99972','99973','99953','99954','99952','99964')
  )
go


-- This query gets the University IDs and latest external indicator for BAR users.
select 
	sb1.stu_id, 
	sb1.extr_ind
from 
	dbo.br_stu_billing sb1
where 
	(sb1.extr_ind = ' ' or sb1.extr_ind = 'M') and
	not exists
	(
		select 
			*
		from 
			dbo.br_stu_billing sb2
		where 
			(sb2.extr_ind = ' ' or sb2.extr_ind = 'M') and
 			sb1.stu_id = sb2.stu_id and 
			sb2.stu_billing_seq_num > sb1.stu_billing_seq_num
	)
order by
	sb1.stu_id
go

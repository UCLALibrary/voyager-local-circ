select 
	sb1.stu_id, 
	sp.last_trm_reg,
	sp.degr_expct_trm
from 
	dbo.br_stu_billing sb1
inner join
	dbo.br_stu_profile sp on sb1.stu_id = sp.stu_id
where 
	(sb1.extr_ind = 'S') and
	not exists
	(
		select 
			*
		from 
			dbo.br_stu_billing sb2
		where 
			(sb2.extr_ind = ' ' or sb2.extr_ind = 'M') and
 			sb1.stu_id = sb2.stu_id and 
			sb2.stu_billing_seq_num <> sb1.stu_billing_seq_num
	)
order by
	sb1.stu_id
go

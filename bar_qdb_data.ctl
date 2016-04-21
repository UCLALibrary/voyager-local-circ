OPTIONS (SKIP=5)
LOAD DATA
REPLACE INTO TABLE CMP_BAR
FIELDS TERMINATED BY '	'
(
	br_subcode_num,
	stu_id,
	acad_term,
	br_seq_num,
	trans_paid_dt DATE "Mon DD YYYY HH:Mi AM",
	paid_appld_amt
)

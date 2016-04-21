OPTIONS (SKIP=5)
LOAD DATA
REPLACE INTO TABLE TMP_CMP_BAR_INVC
FIELDS TERMINATED BY '	'
(
	br_subcode_num,
	stu_id,
	acad_term,
	br_seq_num,
	br_invc_num,
	trans_paid_dt DATE "Mon DD YYYY HH:Mi AM",
	paid_appld_amt
)

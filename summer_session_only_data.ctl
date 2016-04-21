OPTIONS (SKIP=3)
LOAD DATA
REPLACE INTO TABLE TMP_SSO
FIELDS TERMINATED BY '	'
(
	stu_id,
	last_trm_reg nullif (last_trm_reg = "NULL"),
	degr_expct_trm nullif (degr_expct_trm = "NULL")
)

WITH fined AS
(
	SELECT
		TO_CHAR(ff.create_date, 'fmmm') datamonth,
		TO_CHAR(ff.create_date, 'yyyy') datayear,
		cast(NVL(vu.unitid, 'ukn') AS CHAR(50)) loc,
		COUNT(DISTINCT ff.item_id) AS fined
	FROM
		ucladb.fine_fee ff
		inner join ucladb.circ_policy_locs cpl ON ff.fine_fee_location = cpl.location_id
		inner join vger_support.pss_voyunit vu ON cpl.circ_group_id = vu.circ_group_id
	WHERE
		ff.fine_fee_type = 1
		AND TRUNC(ff.create_date) BETWEEN TRUNC(TO_DATE(&1, 'yyyymmdd')) AND TRUNC(TO_DATE(&2, 'yyyymmdd'))
		AND NOT EXISTS
		(
			SELECT * FROM ucladb.fine_fee ff2
			WHERE
			TRUNC(ff2.create_date) BETWEEN TRUNC(TO_DATE(&1, 'yyyymmdd')) AND TRUNC(TO_DATE(&2, 'yyyymmdd'))
			AND ff.patron_id = ff2.patron_id AND ff.item_id = ff2.item_id AND ff.fine_fee_type != ff2.fine_fee_type
		)
	GROUP BY
		ff.create_date,
		vu.unitid
),
fined_paid AS
(
	SELECT
		CASE
			WHEN fft.trans_type = 1 THEN TO_CHAR(fft.trans_date, 'fmmm')
			ELSE TO_CHAR(TO_DATE(SUBSTR(fft.trans_note,1,8),'MM/DD/YY'), 'fmmm')
		END AS datamonth,
		CASE
			WHEN fft.trans_type = 1 THEN TO_CHAR(fft.trans_date, 'yyyy')
			ELSE TO_CHAR(TO_DATE(SUBSTR(fft.trans_note,1,8),'MM/DD/YY'), 'yyyy')
		END AS datayear,
		cast(NVL(vu.unitid, 'ukn') AS CHAR(50)) loc,
		COUNT(DISTINCT ff.item_id) AS fined_paid
	FROM
		ucladb.fine_fee ff
		inner join ucladb.fine_fee_transactions fft ON ff.fine_fee_id = fft.fine_fee_id
		inner join ucladb.circ_policy_locs cpl ON ff.fine_fee_location = cpl.location_id
		inner join vger_support.pss_voyunit vu ON cpl.circ_group_id = vu.circ_group_id
	WHERE
		ff.fine_fee_type = 1
		AND TRUNC(ff.create_date) BETWEEN TRUNC(TO_DATE(&1, 'yyyymmdd')) AND TRUNC(TO_DATE(&2, 'yyyymmdd'))
		AND (fft.trans_type = 1 OR (fft.trans_type = 5 AND SUBSTR(fft.trans_note, 10, 11) = 'Paid in BAR'))
		AND NOT EXISTS
		(
			SELECT * FROM ucladb.fine_fee ff2
			WHERE
			TRUNC(ff2.create_date) BETWEEN TRUNC(TO_DATE(&1, 'yyyymmdd')) AND TRUNC(TO_DATE(&2, 'yyyymmdd'))
			AND ff.patron_id = ff2.patron_id AND ff.item_id = ff2.item_id AND ff.fine_fee_type != ff2.fine_fee_type
		)
		AND NOT EXISTS
		(
		 	SELECT * FROM ucladb.fine_fee_transactions fft2 WHERE ff.fine_fee_id = fft2.fine_fee_id AND fft2.TRANS_TYPE IN (2,4,6)
		)
	GROUP BY
		fft.trans_date,
		fft.trans_note,
		fft.trans_type,
		vu.unitid
),
fined_forgiven AS
(
	SELECT
		CASE
			WHEN (fft_br.trans_note IS NULL) THEN TO_CHAR(fft_f.trans_date, 'fmmm')
			WHEN (LTRIM(RTRIM(fft_br.trans_note)) = '' ) THEN TO_CHAR(fft_f.trans_date, 'fmmm')
			WHEN (fft_br.trans_note NOT LIKE '%BAR%') THEN TO_CHAR(fft_f.trans_date, 'fmmm')
			ELSE TO_CHAR(TO_DATE(SUBSTR(fft_br.trans_note,1,8),'MM/DD/YY'), 'fmmm')
		END AS datamonth,
		CASE
			WHEN (fft_br.trans_note IS NULL) THEN TO_CHAR(fft_f.trans_date, 'yyyy')
			WHEN (LTRIM(RTRIM(fft_br.trans_note)) = '' ) THEN TO_CHAR(fft_f.trans_date, 'yyyy')
			WHEN (fft_br.trans_note NOT LIKE '%BAR%') THEN TO_CHAR(fft_f.trans_date, 'yyyy')
			ELSE TO_CHAR(TO_DATE(SUBSTR(fft_br.trans_note,1,8),'MM/DD/YY'), 'yyyy')
		END AS datayear,
		cast(NVL(vu.unitid, 'ukn') AS CHAR(50)) loc,
		COUNT(DISTINCT ff.item_id) AS fined_forgiven
	FROM
		ucladb.fine_fee ff
		inner join ucladb.fine_fee_transactions fft_f ON ff.fine_fee_id = fft_f.fine_fee_id AND fft_f.trans_type = 2
		left outer join ucladb.fine_fee_transactions fft_r ON fft_f.fine_fee_id = fft_r.fine_fee_id AND fft_r.trans_type = 4
		left outer join ucladb.fine_fee_transactions fft_br ON fft_f.fine_fee_id = fft_br.fine_fee_id AND fft_br.trans_type = 6
		inner join ucladb.circ_policy_locs cpl ON ff.FINE_FEE_LOCATION = cpl.LOCATION_ID
		inner join vger_support.pss_voyunit vu ON cpl.circ_group_id = vu.circ_group_id
	WHERE
		ff.fine_fee_type = 1
		AND TRUNC(ff.create_date) BETWEEN TRUNC(TO_DATE(&1, 'yyyymmdd')) AND TRUNC(TO_DATE(&2, 'yyyymmdd'))
		AND NOT EXISTS
		(
			SELECT * FROM ucladb.fine_fee ff2
			WHERE
			TRUNC(ff2.create_date) BETWEEN TRUNC(TO_DATE(&1, 'yyyymmdd')) AND TRUNC(TO_DATE(&2, 'yyyymmdd'))
			AND ff.patron_id = ff2.patron_id AND ff.item_id = ff2.item_id AND ff.fine_fee_type != ff2.fine_fee_type
		)
	GROUP BY
		fft_f.trans_date,
		fft_br.trans_note,
		vu.unitid
),
replacement AS
(
	SELECT
		TO_CHAR(ff.create_date, 'fmmm') datamonth,
		TO_CHAR(ff.create_date, 'yyyy') datayear,
		cast(NVL(vu.unitid, 'ukn') AS CHAR(50)) loc,
		COUNT(DISTINCT ff.item_id) AS replacement
	FROM
		ucladb.fine_fee ff
		inner join ucladb.circ_policy_locs cpl ON ff.fine_fee_location = cpl.location_id
		inner join vger_support.PSS_VOYUNIT vu ON cpl.circ_group_id = vu.circ_group_id
	WHERE
		ff.fine_fee_type = 2
		AND TRUNC(ff.create_date) BETWEEN TRUNC(TO_DATE(&1, 'yyyymmdd')) AND TRUNC(TO_DATE(&2, 'yyyymmdd'))
	GROUP BY
		ff.create_date,
		ff.fine_fee_location,
		vu.unitid
),
replacement_paid AS
(
	SELECT
		CASE
			WHEN fft.trans_type = 1 THEN TO_CHAR(fft.trans_date, 'fmmm')
			ELSE TO_CHAR(TO_DATE(SUBSTR(fft.trans_note,1,8),'MM/DD/YY'), 'fmmm')
		END AS datamonth,
		CASE
			WHEN fft.trans_type = 1 THEN TO_CHAR(fft.trans_date, 'yyyy')
			ELSE TO_CHAR(TO_DATE(SUBSTR(fft.trans_note,1,8),'MM/DD/YY'), 'yyyy')
		END AS datayear,
		cast(NVL(vu.unitid, 'ukn') AS CHAR(50)) loc,
		COUNT(DISTINCT ff.item_id) AS replacement_paid
	FROM
		ucladb.fine_fee ff
		inner join ucladb.fine_fee_transactions fft ON ff.fine_fee_id = fft.fine_fee_id
		inner join ucladb.circ_policy_locs cpl ON ff.fine_fee_location = cpl.location_id
		inner join vger_support.PSS_VOYUNIT vu ON cpl.circ_group_id = vu.circ_group_id
	WHERE
		ff.fine_fee_type = 2
		AND TRUNC(ff.create_date) BETWEEN TRUNC(TO_DATE(&1, 'yyyymmdd')) AND TRUNC(TO_DATE(&2, 'yyyymmdd'))
		AND (fft.trans_type = 1 OR (fft.trans_type = 5 AND SUBSTR(fft.trans_note, 10, 11) = 'Paid in BAR'))
		AND NOT EXISTS
		(
			SELECT * FROM ucladb.fine_fee_transactions fft2 WHERE fft.fine_fee_id = fft2.fine_fee_id AND fft2.trans_type IN (2,4,6)
		)
	GROUP BY
		fft.trans_date,
		fft.trans_note,
		fft.trans_type,
		vu.unitid
),
replacement_forgiven AS
(
	SELECT
		CASE
			WHEN (fft_br.trans_note IS NULL) THEN TO_CHAR(fft_f.trans_date, 'fmmm')
			WHEN (LTRIM(RTRIM(fft_br.trans_note)) = '' ) THEN TO_CHAR(fft_f.trans_date, 'fmmm')
			WHEN (fft_br.trans_note NOT LIKE '%BAR%') THEN TO_CHAR(fft_f.trans_date, 'fmmm')
			ELSE TO_CHAR(TO_DATE(SUBSTR(fft_br.trans_note,1,8),'MM/DD/YY'), 'fmmm')
		END AS datamonth,
		CASE
			WHEN (fft_br.trans_note IS NULL) THEN TO_CHAR(fft_f.trans_date, 'yyyy')
			WHEN (LTRIM(RTRIM(fft_br.trans_note)) = '' ) THEN TO_CHAR(fft_f.trans_date, 'yyyy')
			WHEN (fft_br.trans_note NOT LIKE '%BAR%') THEN TO_CHAR(fft_f.trans_date, 'yyyy')
			ELSE TO_CHAR(TO_DATE(SUBSTR(fft_br.trans_note,1,8),'MM/DD/YY'), 'yyyy')
		END AS datayear,
		cast(NVL(vu.unitid, 'ukn') AS CHAR(50)) loc,
		COUNT(DISTINCT ff.item_id) AS replacement_forgiven
	FROM
		ucladb.fine_fee ff
		inner join ucladb.fine_fee_transactions fft_f ON ff.fine_fee_id = fft_f.fine_fee_id AND fft_f.trans_type = 2
		left outer join ucladb.fine_fee_transactions fft_r ON fft_f.fine_fee_id = fft_r.fine_fee_id AND fft_r.trans_type = 4
		left outer join ucladb.fine_fee_transactions fft_br ON fft_f.fine_fee_id = fft_br.fine_fee_id AND fft_br.trans_type = 6
		inner join ucladb.circ_policy_locs cpl ON ff.fine_fee_location = cpl.location_id
		inner join vger_support.PSS_VOYUNIT vu ON cpl.circ_group_id = vu.circ_group_id
	WHERE
		ff.fine_fee_type = 2
		AND TRUNC(ff.create_date) BETWEEN TRUNC(TO_DATE(&1, 'yyyymmdd')) AND TRUNC(TO_DATE(&2, 'yyyymmdd'))
	GROUP BY
		fft_f.trans_date,
		fft_br.trans_note,
		vu.unitid
	ORDER BY
		 fft_f.trans_date ASC,
		 loc
)
SELECT
	categoryid || loc || cast(SUM(items) AS CHAR(38)) || cast(datamonth AS CHAR(2)) || cast(datayear AS CHAR(4)) data
FROM
(
	SELECT '058' categoryid, loc, fined items, datamonth, datayear FROM fined
	UNION ALL
	SELECT '082' categoryid, loc, fined_paid items, datamonth, datayear FROM fined_paid
	UNION ALL
	SELECT '083' categoryid, loc, fined_forgiven items, datamonth, datayear FROM fined_forgiven
	UNION ALL
	SELECT '059' categoryid, loc, replacement items, datamonth, datayear FROM replacement
	UNION ALL
	SELECT '084' categoryid, loc, replacement_paid items, datamonth, datayear FROM replacement_paid
	UNION ALL
	SELECT '060' categoryid, loc, replacement_forgiven items, datamonth, datayear FROM replacement_forgiven
)
GROUP BY
	datayear,
	datamonth,
	categoryid,
	loc
;

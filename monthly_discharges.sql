-- Get monthly Circulation statistics from Voyager
--  to put into the Statistics server.
-- &1: 1st day of the month (YYYYMMDD)
--
-- (will convert this to procedures when done testing)
--

SELECT
  loc ||
  category ||
  cast(sum(discharge) as char(38)) ||
  report_date data
FROM
(
SELECT
-- CIRC_TRANS_ARCHIVE for Discharges
  CAST(vu.unitid AS CHAR(50)) loc,
  CAST(decode(cta.patron_group_id,   0,   'No Group',   report_group_desc) AS CHAR(50)) category,
  1 discharge,
  to_char(trunc(to_date(&1, 'YYYYMMDD')),   'YYYY-MM-DD HH24:MI:SS') report_date
FROM
  ucladb.circ_trans_archive cta
LEFT OUTER JOIN
  ucladb.location tl ON tl.location_id = cta.discharge_location
LEFT OUTER JOIN
  ucladb.item i ON i.item_id = cta.item_id
LEFT OUTER JOIN
  ucladb.location il ON il.location_id = i.perm_location
LEFT OUTER JOIN
  ucladb.patron_group pg ON pg.patron_group_id = cta.patron_group_id
LEFT OUTER JOIN
  vger_support.csc_patron_group_map pgm ON pg.patron_group_id = pgm.patron_group_id
LEFT OUTER JOIN
  vger_support.csc_report_group rg ON pgm.report_group_id = rg.report_group_id
LEFT OUTER JOIN
  ucladb.circ_policy_locs cpl ON cta.discharge_location = cpl.location_id
LEFT OUTER JOIN
  ucladb.circ_policy_group cpg ON cpl.circ_group_id = cpg.circ_group_id
LEFT OUTER JOIN
  vger_support.PSS_VOYUNIT vu on cpl.circ_group_id = vu.circ_group_id
WHERE cta.discharge_date BETWEEN trunc(to_date(&1, 'YYYYMMDD'))
 AND trunc(last_day(to_date(&1, 'YYYYMMDD'))+1)
)
group by
  loc,
  category,
  discharge,
  report_date
;

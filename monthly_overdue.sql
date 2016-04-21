SELECT
  report_date ||
  loc ||
  cast(sum(overdue) as char(38)) data
FROM
(
-- CIRC_TRANS_ARCHIVE for Overdue
SELECT 
  to_char(trunc(to_date(TO_CHAR(cta.overdue_notice_date, 'YYYY')||TO_CHAR(cta.overdue_notice_date, 'MM')||'01', 'YYYYMMDD')),   'YYYY-MM-DD HH24:MI:SS') report_date,
  CAST(nvl(vu.unitid, 'UKN') AS CHAR(10)) loc,
  1 AS overdue
FROM ucladb.circ_trans_archive cta 
-- Join with circ_policy_locs so we can get circ_group_name in 
-- circ_policy_group.
LEFT OUTER JOIN ucladb.circ_policy_locs cpl ON cta.charge_location = cpl.location_id
LEFT OUTER JOIN
  vger_support.PSS_VOYUNIT vu on cpl.circ_group_id = vu.circ_group_id
WHERE cta.overdue_notice_date BETWEEN to_date(&1,   'YYYYMMDD')
 AND to_date(&2,   'YYYYMMDD')
UNION ALL
-- CIRC_TRANSACTIONS for Overdue
SELECT 
  to_char(trunc(to_date(TO_CHAR(ct.overdue_notice_date, 'YYYY')||TO_CHAR(ct.overdue_notice_date, 'MM')||'01', 'YYYYMMDD')),   'YYYY-MM-DD HH24:MI:SS') report_date,
  CAST(nvl(vu.unitid, 'UKN') AS CHAR(10)) loc,
  1 AS overdue
FROM ucladb.circ_transactions ct
-- Join with circ_policy_locs so we can get circ_group_name in 
-- circ_policy_group.
LEFT OUTER JOIN ucladb.circ_policy_locs cpl ON ct.charge_location = cpl.location_id
LEFT OUTER JOIN
  vger_support.PSS_VOYUNIT vu on cpl.circ_group_id = vu.circ_group_id
WHERE ct.overdue_notice_date BETWEEN to_date(&1,   'YYYYMMDD')
 AND to_date(&2,   'YYYYMMDD')
)
group by
  report_date,
  loc
;

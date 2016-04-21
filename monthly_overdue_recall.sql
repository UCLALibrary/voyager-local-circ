SELECT
  categoryid || 
  loc ||
  cast(SUM(overdue_recall) as char(38)) ||
  cast(dataMonth as char(2)) ||
  cast(dataYear as char(4)) data
FROM
(
-- CIRC_TRANS_ARCHIVE for Overdue Recall
SELECT 
  '087' categoryid,
  CAST(nvl(vu.unitid, 'UKN') AS CHAR(50)) loc,
  1 AS overdue_recall,
  TO_CHAR(cta.over_recall_notice_date, 'fmMM') dataMonth,
  TO_CHAR(cta.over_recall_notice_date, 'YYYY') dataYear
FROM ucladb.circ_trans_archive cta 
-- Join with circ_policy_locs so we can get circ_group_name in 
-- circ_policy_group.
LEFT OUTER JOIN ucladb.circ_policy_locs cpl ON cta.charge_location = cpl.location_id
LEFT OUTER JOIN
  vger_support.PSS_VOYUNIT vu on cpl.circ_group_id = vu.circ_group_id
WHERE cta.over_recall_notice_date BETWEEN to_date(&1,   'YYYYMMDD')
 AND to_date(&2,   'YYYYMMDD')
UNION ALL
-- CIRC_TRANSACTIONS for Overdue Recall
SELECT 
  '087' categoryid,
  CAST(nvl(vu.unitid, 'UKN') AS CHAR(50)) loc,
  1 AS overdue_recall,
  TO_CHAR(ct.over_recall_notice_date, 'fmMM') dataMonth,
  TO_CHAR(ct.over_recall_notice_date, 'YYYY') dataYear
FROM ucladb.circ_transactions ct
-- Join with circ_policy_locs so we can get circ_group_name in 
-- circ_policy_group.
LEFT OUTER JOIN ucladb.circ_policy_locs cpl ON ct.charge_location = cpl.location_id
LEFT OUTER JOIN
  vger_support.PSS_VOYUNIT vu on cpl.circ_group_id = vu.circ_group_id
WHERE ct.over_recall_notice_date BETWEEN to_date(&1,   'YYYYMMDD')
 AND to_date(&2,   'YYYYMMDD')
)
group by
  dataYear,
  dataMonth,
  categoryid,
  loc
;

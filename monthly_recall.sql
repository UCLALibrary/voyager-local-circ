SELECT
  categoryid || 
  loc ||
  cast(SUM(recall) as char(38)) ||
  cast(dataMonth as char(2)) ||
  cast(dataYear as char(4)) data
FROM
(
-- CIRC_TRANS_ARCHIVE for Recall
SELECT 
  '086' categoryid,
  CAST(nvl(vu.unitid, 'UKN') AS CHAR(50)) loc,
  1 AS recall,
  TO_CHAR(cta.recall_date, 'fmMM') dataMonth,
  TO_CHAR(cta.recall_date, 'YYYY') dataYear
FROM ucladb.circ_trans_archive cta 
-- Join with circ_policy_locs so we can get circ_group_name in 
-- circ_policy_group.
LEFT OUTER JOIN ucladb.circ_policy_locs cpl ON cta.charge_location = cpl.location_id
LEFT OUTER JOIN
  vger_support.PSS_VOYUNIT vu on cpl.circ_group_id = vu.circ_group_id
WHERE cta.recall_date BETWEEN to_date(&1,   'YYYYMMDD')
 AND to_date(&2,   'YYYYMMDD')
UNION ALL
-- CIRC_TRANSACTIONS for Recall
SELECT 
  '086' categoryid,
  CAST(nvl(vu.unitid, 'UKN') AS CHAR(50)) loc,
  1 AS recall,
  TO_CHAR(ct.recall_date, 'fmMM') dataMonth,
  TO_CHAR(ct.recall_date, 'YYYY') dataYear
FROM ucladb.circ_transactions ct
-- Join with circ_policy_locs so we can get circ_group_name in 
-- circ_policy_group.
LEFT OUTER JOIN ucladb.circ_policy_locs cpl ON ct.charge_location = cpl.location_id
LEFT OUTER JOIN
  vger_support.PSS_VOYUNIT vu on cpl.circ_group_id = vu.circ_group_id
WHERE ct.recall_date BETWEEN to_date(&1,   'YYYYMMDD')
 AND to_date(&2,   'YYYYMMDD')
)
group by
  dataYear,
  dataMonth,
  categoryid,
  loc
;

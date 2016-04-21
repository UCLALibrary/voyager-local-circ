-- Get monthly Circulation statistics from Voyager
--  to put into the Statistics server.
-- &1: 1st day of the month (YYYYMMDD)
--
-- (will convert this to procedures when done testing)
--

SELECT
  loc ||
  category ||
  cast(sum(renewal) as char(38)) ||
  web ||
  report_date data
FROM
(
SELECT
-- CIRC_TRANS_ARCHIVE for Renewals
  CAST(vu.unitid AS CHAR(50)) loc,
  CAST(decode(cta.patron_group_id,   0,   'No Group',   report_group_desc) AS CHAR(50)) category,
  1 renewal,
  vger_support.LWS_CSC.IS_WEB_RENEWAL(rta.renew_oper_id) web,
  to_char(trunc(to_date(&1, 'YYYYMMDD')),   'YYYY-MM-DD HH24:MI:SS') report_date
FROM
  ucladb.circ_trans_archive cta
LEFT OUTER JOIN
  ucladb.patron_group pg ON pg.patron_group_id = cta.patron_group_id
LEFT OUTER JOIN
  vger_support.csc_patron_group_map pgm ON pg.patron_group_id = pgm.patron_group_id
LEFT OUTER JOIN
  vger_support.csc_report_group rg ON pgm.report_group_id = rg.report_group_id
INNER JOIN 
  ucladb.renew_trans_archive rta ON cta.circ_transaction_id = rta.circ_transaction_id 
LEFT OUTER JOIN
  ucladb.circ_policy_locs cpl ON rta.renew_location = cpl.location_id
LEFT OUTER JOIN
  ucladb.circ_policy_group cpg ON cpl.circ_group_id = cpg.circ_group_id
LEFT OUTER JOIN
  vger_support.PSS_VOYUNIT vu on cpl.circ_group_id = vu.circ_group_id
WHERE rta.renew_date BETWEEN trunc(to_date(&1, 'YYYYMMDD'))
 AND trunc(last_day(to_date(&1, 'YYYYMMDD'))+1)
UNION ALL
SELECT
-- CIRC_TRANSACTIONS for Renewals
  CAST(vu.unitid AS CHAR(50)) loc,
  CAST(decode(ct.patron_group_id,   0,   'No Group',   report_group_desc) AS CHAR(50)) category,
  1 renewal,
  vger_support.LWS_CSC.IS_WEB_RENEWAL(rt.renew_oper_id) web,
  to_char(trunc(to_date(&1, 'YYYYMMDD')),   'YYYY-MM-DD HH24:MI:SS') report_date
FROM
  ucladb.circ_transactions ct
LEFT OUTER JOIN
  ucladb.patron_group pg ON pg.patron_group_id = ct.patron_group_id
LEFT OUTER JOIN
  vger_support.csc_patron_group_map pgm ON pg.patron_group_id = pgm.patron_group_id
LEFT OUTER JOIN
  vger_support.csc_report_group rg ON pgm.report_group_id = rg.report_group_id
INNER JOIN 
  ucladb.renew_transactions rt ON ct.circ_transaction_id = rt.circ_transaction_id 
LEFT OUTER JOIN
  ucladb.circ_policy_locs cpl ON rt.renew_location = cpl.location_id
LEFT OUTER JOIN
  ucladb.circ_policy_group cpg ON cpl.circ_group_id = cpg.circ_group_id
LEFT OUTER JOIN
  vger_support.PSS_VOYUNIT vu on cpl.circ_group_id = vu.circ_group_id
WHERE rt.renew_date BETWEEN trunc(to_date(&1, 'YYYYMMDD'))
 AND trunc(last_day(to_date(&1, 'YYYYMMDD'))+1)
)
group by
  loc,
  category,
  renewal,
  web,
  report_date
;

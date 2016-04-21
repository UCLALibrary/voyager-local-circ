-- Circulation statistics from Voyager
--  to put into the Statistics server.
-- &1: 1st day of the month (YYYYMMDD)
--
-- (will convert this to procedures when done testing)
--
 
SELECT
  loc ||
  category ||
  CAST (SUM(charge) AS CHAR(38)) ||
  reserve ||
  self ||
  report_date data
FROM
(
SELECT
-- CIRC_TRANS_ARCHIVE for Chargeouts
  CAST(vu.unitid AS CHAR(50)) loc,
  CAST(DECODE(cta.patron_group_id,   0,   'No Group',   report_group_desc) AS CHAR(50)) category,
  1 charge,
  DECODE(cta.circ_transaction_id,   NULL,   0,   vger_support.lws_csc.IS_RESERVE_CHARGE(cta.charge_location, rst.on_reserve)) reserve,
  DECODE(cta.circ_transaction_id,   NULL,   0,   vger_support.LWS_CSC.IS_SELF_CHARGE(cta.charge_location)) self,
  TO_CHAR(TRUNC(TO_DATE(&1, 'YYYYMMDD')),   'YYYY-MM-DD HH24:MI:SS') report_date
FROM
  ucladb.circ_trans_archive cta
LEFT OUTER JOIN
  ucladb.patron_group pg ON pg.patron_group_id = cta.patron_group_id
LEFT OUTER JOIN
  vger_support.csc_patron_group_map pgm ON pg.patron_group_id = pgm.patron_group_id
LEFT OUTER JOIN
  vger_support.csc_report_group rg ON pgm.report_group_id = rg.report_group_id
LEFT OUTER JOIN
  ucladb.circ_policy_locs cpl ON cta.charge_location = cpl.location_id
LEFT OUTER JOIN
  ucladb.circ_policy_group cpg ON cpl.circ_group_id = cpg.circ_group_id
LEFT OUTER JOIN
  vger_support.PSS_VOYUNIT vu ON cpl.circ_group_id = vu.circ_group_id
LEFT OUTER JOIN
  vger_report.ucladb_reserve_trans rst ON cta.circ_transaction_id = rst.circ_transaction_id
  AND cta.item_id = rst.item_id
WHERE cta.charge_date BETWEEN TRUNC(TO_DATE(&1, 'YYYYMMDD'))
 AND TRUNC(LAST_DAY(TO_DATE(&1, 'YYYYMMDD'))+1)
UNION ALL
-- CIRC_TRANSACTIONS for Chargeouts
SELECT
  CAST(vu.unitid AS CHAR(50)) loc,
  CAST(DECODE(ct.patron_group_id,   0,   'No Group',   report_group_desc) AS CHAR(50)) category,
  1 charge,
  DECODE(ct.circ_transaction_id,   NULL,   0,   vger_support.lws_csc.IS_RESERVE_CHARGE(ct.charge_location, rst.on_reserve)) reserve,
  DECODE(ct.circ_transaction_id,   NULL,   0,   vger_support.LWS_CSC.IS_SELF_CHARGE(ct.charge_location)) self,
  TO_CHAR(TRUNC(TO_DATE(&1, 'YYYYMMDD')),   'YYYY-MM-DD HH24:MI:SS') report_date
FROM ucladb.circ_transactions ct
LEFT OUTER JOIN
  ucladb.patron_group pg ON pg.patron_group_id = ct.patron_group_id
LEFT OUTER JOIN
  vger_support.csc_patron_group_map pgm ON pg.patron_group_id = pgm.patron_group_id
LEFT OUTER JOIN
  vger_support.csc_report_group rg ON pgm.report_group_id = rg.report_group_id
LEFT OUTER JOIN
  ucladb.circ_policy_locs cpl ON ct.charge_location = cpl.location_id
LEFT OUTER JOIN
  ucladb.circ_policy_group cpg ON cpl.circ_group_id = cpg.circ_group_id
LEFT OUTER JOIN
  vger_support.PSS_VOYUNIT vu ON cpl.circ_group_id = vu.circ_group_id
LEFT OUTER JOIN
  vger_report.ucladb_reserve_trans rst ON ct.circ_transaction_id = rst.circ_transaction_id
  AND ct.item_id = rst.item_id
WHERE ct.charge_date BETWEEN TRUNC(TO_DATE(&1, 'YYYYMMDD'))
 AND TRUNC(LAST_DAY(TO_DATE(&1, 'YYYYMMDD'))+1)
)
GROUP BY
  loc,
  category,
  charge,
  reserve,
  self,
  report_date
;

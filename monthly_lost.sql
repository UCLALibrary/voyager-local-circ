-- Get monthly Circulation statistics from Voyager
--  to put into the Statistics server.
-- &1: 1st day of the month (YYYYMMDD)
--
-- (will convert this to procedures when done testing)
--

SELECT
  '061' ||
  loc ||
  cast(count(*) as char(38)) ||
  cast(dataMonth as char(2)) ||
  cast(dataYear as char(4)) data
FROM
(
  select 
    CAST(nvl(vu.unitid, 'UKN') AS CHAR(50)) loc,
    TO_CHAR(ff.fine_fee_notice_date, 'fmMM') dataMonth,
    TO_CHAR(ff.fine_fee_notice_date, 'YYYY') dataYear
  -- Start with item table.
  from ucladb.item i
  -- Join with location so we can get location_id.
  LEFT OUTER JOIN ucladb.location l ON l.location_id = i.PERM_LOCATION
  -- Join with circ_policy_locs so we can get circ_group_name in 
  -- circ_policy_group.
  LEFT OUTER JOIN ucladb.circ_policy_locs cpl ON l.location_id = cpl.location_id
  LEFT OUTER JOIN
    vger_support.PSS_VOYUNIT vu on cpl.circ_group_id = vu.circ_group_id
  -- Join with fine_fee to get fine fields. Pick only "Lost Item Replacement"
  inner join ucladb.fine_fee ff on i.item_id = ff.item_id and ff.fine_fee_type = 2
  WHERE 
  -- Pick out the date range we're interested in
    ff.fine_fee_notice_date BETWEEN trunc(to_date(&1, 'YYYYMMDD')) and trunc(to_date(&2, 'YYYYMMDD'))
  -- Pick the latest entry from the fine_fee table
  and not exists
    (
      select * from ucladb.fine_fee ff2
      where i.item_id = ff2.item_id and ff2.fine_fee_type = 2
      and (
            ff2.fine_fee_notice_date > ff.fine_fee_notice_date  or 
            (ff2.fine_fee_notice_date = ff.fine_fee_notice_date and ff2.fine_fee_id > ff.fine_fee_id)
          )
    )
)
group by
  dataYear,
  dataMonth,
  loc
;

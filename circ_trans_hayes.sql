select 
  -- ID (Bar Code)
  ib.item_barcode barcode,
  -- Transcation Date / Time
  cta.charge_date transaction_date,
  -- Transaction Code
  'C' transaction_code,
  -- Unit Owning Item
  vu_own.unitid unit_owning_item, 
  -- Unit Circulating Item
  vu_trans.unitid unit_circulating_item, 
  -- Physical Medium Code
  it.item_type_code physical_medium_code, 
  -- Partial Call Number
  mm.display_call_no call_no,
  -- Patron Rank
  rg.report_group_desc patron_rank, 
  -- User Category
  pg.patron_group_code user_category, 
  -- Institution
  decode(p.name_type, 1, 'Individual', p.name_type) institution,
  -- Voyager Item ID
  cta.item_id voyager_item_id,
  -- Discharge date and time
  cta.discharge_date,
  -- Renewal Count
  cta.renewal_count
from 
  ucladb.circ_trans_archive cta
-- Get the item information.
left outer join
  ucladb.item i on cta.item_id = i.item_id
left outer join
  ucladb.item_barcode ib on cta.item_id = ib.item_id
left outer join
  ucladb.item_type it on i.item_type_id = it.item_type_id
-- Join with bib info to get call number.
left outer join
  ucladb.mfhd_item mi on cta.item_id = mi.item_id
left outer join
	ucladb.mfhd_master mm on mi.mfhd_id = mm.mfhd_id 
-- Get the owning location.
left outer join 
  ucladb.circ_policy_locs cpl_own ON i.perm_location = cpl_own.location_id
left outer join 
  ucladb.circ_policy_group cpg_own ON cpl_own.circ_group_id = cpg_own.circ_group_id
left outer join 
  vger_support.pss_voyunit vu_own on cpl_own.circ_group_id = vu_own.circ_group_id
-- Get the transaction location.
left outer join 
  ucladb.circ_policy_locs cpl_trans ON cta.charge_location = cpl_trans.location_id
left outer join 
  ucladb.circ_policy_group cpg_trans ON cpl_trans.circ_group_id = cpg_trans.circ_group_id
left outer join 
  vger_support.pss_voyunit vu_trans on cpl_trans.circ_group_id = vu_trans.circ_group_id
-- Get patron information.
left outer join
  ucladb.patron p on cta.patron_id = p.patron_id
left outer join
  ucladb.patron_group pg on cta.patron_group_id = pg.patron_group_id
left outer join
  vger_support.csc_patron_group_map pgm ON pg.patron_group_id = pgm.patron_group_id
left outer join
  vger_support.csc_report_group rg ON pgm.report_group_id = rg.report_group_id
where
  -- Pick the lowest item barcode status. 
  not exists 
  (
    SELECT * FROM ucladb.item_barcode ib2
    where 
      ib.item_id = ib2.item_id
      and ib.barcode_status > ib2.barcode_status
  )
order by
  ib.item_barcode,
  cta.charge_date
;

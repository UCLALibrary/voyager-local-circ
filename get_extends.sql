SELECT
    ct.circ_transaction_id || ',' || 
    pb.patron_barcode || ',' ||
    ib.item_barcode AS charges
FROM
    ucladb.circ_transactions ct
    inner join ucladb.patron p on ct.patron_id = p.patron_id
    inner join ucladb.item i on ct.item_id = i.item_id
    left join ucladb.patron_barcode pb on ct.patron_id = pb.patron_id and pb.barcode_status = 1
    left join ucladb.item_barcode ib on ct.item_id = ib.item_id and ib.barcode_status = 1
WHERE
    ct.current_due_date < to_date('2021-04-30','YYYY-MM-DD')
    AND p.expire_date >= sysdate
	-- Exclude various CLICC equipment - see VBT-1681 for item type names
    and i.item_type_id not in (49,50,51,52,53,60,65,68,70,72,80,81,82,83,84,85)
	-- Exclude Lost--Library Applied and Lost--System Applied items
    and not exists (select * from ucladb.item_status ist where ct.item_id = ist.item_id and
        item_status in (13, 14))
;

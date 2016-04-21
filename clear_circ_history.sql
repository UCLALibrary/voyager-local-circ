UPDATE 
  ucladb.circ_trans_archive 
SET 
  patron_id = NULL 
WHERE 
  circ_transaction_id IN 
  (
    SELECT 
      cta.circ_transaction_id 
    FROM 
      ucladb.circ_trans_archive cta 
    WHERE 
      cta.discharge_date < (SYSDATE - &1) 
      AND NOT EXISTS 
      (
        SELECT 
          * 
        FROM 
          ucladb.fine_fee ff 
        WHERE 
          ff.patron_id = cta.patron_id 
          AND ff.item_id = cta.item_id 
          AND ff.orig_charge_date = cta.charge_date
      )
  )
;

--------------------------------------------------------
--  File created - Tuesday-December-12-2017   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body LWS_CSC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "VGER_SUPPORT"."LWS_CSC" AS
/*  The LWS_CSC package collects together stored procedures and functions
    that are of use to CSC reports of data in Voyager Integrated Library System.
    
    Last revised: 2008-07-02 chunt
*/

  /*  The OVERDUE_PAYMENT function takes a fine fee type and fine fee 
      transaction type as input, and returns a 1 formatted as an integer if the 
      fee type is 1 (Overdue) and the transaction type is 1 (Payment). Otherwise 
      it returns 0 formatted as an integer.
      
      Last revised: 2006-11-17 chunt
  */
  FUNCTION OVERDUE_PAYMENT(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF p_fine_fee_type = 1 AND p_trans_type = 1 THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The OVERDUE_FORGIVE function takes a fine fee type and fine fee 
      transaction type as input, and returns a 1 formatted as an integer if the 
      fee type is 1 (Overdue) and the transaction type is 2 (Forgive). Otherwise 
      it returns 0 formatted as an integer.
      
      Last revised: 2006-11-17 chunt
  */
  FUNCTION OVERDUE_FORGIVE(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF p_fine_fee_type = 1 AND p_trans_type = 2 THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The LOST_PAYMENT function takes a fine fee type and fine fee 
      transaction type as input, and returns a 1 formatted as an integer if the 
      fee type is 2 (Lost Item Replacement) and the transaction type is 1 
      (Payment). Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2006-11-17 chunt
  */
  FUNCTION LOST_PAYMENT(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF p_fine_fee_type = 2 AND p_trans_type = 1 THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The LOST_FORGIVE function takes a fine fee type and fine fee 
      transaction type as input, and returns a 1 formatted as an integer if the 
      fee type is 2 (Lost Item Replacement) and the transaction type is 1 
      (Forgive). Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2006-11-17 chunt
  */
  FUNCTION LOST_FORGIVE(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF p_fine_fee_type  = 2 AND p_trans_type = 2 THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The LOSTPROCESSING_PAYMENT function takes a fine fee type and fine fee 
      transaction type as input, and returns a 1 formatted as an integer if the 
      fee type is 3 (Lost Item Processing) and the transaction type is 1 
      (Payment). Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-07-02 chunt
  */
  FUNCTION LOSTPROCESSING_PAYMENT(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF p_fine_fee_type = 3 AND p_trans_type = 1 THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The LOSTPROCESSING_FORGIVE function takes a fine fee type and fine fee 
      transaction type as input, and returns a 1 formatted as an integer if the 
      fee type is 3 (Lost Item Processing) and the transaction type is 1 
      (Forgive). Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-07-02 chunt
  */
  FUNCTION LOSTPROCESSING_FORGIVE(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF p_fine_fee_type = 3 AND p_trans_type = 2 THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The BAR_OVERDUE_OUTSTANDING function takes a fine fee type, a fine fee 
      transaction type, and a transaction note as input, and returns a 1 
      formatted as an integer if the fee type is 1 (Overdue), the transaction
      type is 5 (Bursar Transfer) and the transaction has not yet been paid in 
      BAR. Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-07-09 chunt
  */
  FUNCTION BAR_OVERDUE_OUTSTANDING(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type,
    p_trans_note ucladb.fine_fee_transactions.TRANS_NOTE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF 
      p_fine_fee_type = 1 AND
      p_trans_type = 5 AND 
      substr(p_trans_note, 10, 11) = 'Sent to BAR' THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;

  /*  The BAR_OVERDUE_PAYMENT function takes a fine fee type, a fine fee 
      transaction type, and a transaction note as input, and returns a 1 
      formatted as an integer if the fee type is 1 (Overdue), the transaction
      type is 5 (Bursar Transfer) and the transaction has been paid in BAR. 
      Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-07-09 chunt
  */
  FUNCTION BAR_OVERDUE_PAYMENT(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type,
    p_trans_note ucladb.fine_fee_transactions.TRANS_NOTE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF 
      p_fine_fee_type = 1 AND
      p_trans_type = 5 AND 
      substr(p_trans_note, 10, 11) = 'Paid in BAR' THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The BAR_OVERDUE_REFUND function takes a fine fee type, a fine fee 
      transaction type, and a transaction note as input, and returns a 1 
      formatted as an integer if the fee type is 1 (Overdue), the transaction
      type is 6 (Bursar Refund). Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-07-09 chunt
  */
  FUNCTION BAR_OVERDUE_REFUND(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type,
    p_trans_note ucladb.fine_fee_transactions.TRANS_NOTE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF 
      p_fine_fee_type = 1 AND
      p_trans_type = 6 THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The BAR_LOSTPROCESSING_OUTSTANDING function takes a fine fee type, a fine 
      fee transaction type, and a transaction note as input, and returns a 1 
      formatted as an integer if the fee type is 3 (Lost Item Processing), the 
      transaction type is 5 (Bursar Transfer) and the transaction has not yet 
      been paid in BAR. Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-07-09 chunt
  */
  FUNCTION BAR_LOSTPROCESSING_OUTSTANDING(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type,
    p_trans_note ucladb.fine_fee_transactions.TRANS_NOTE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF
      p_fine_fee_type = 3 AND
      p_trans_type = 5 AND 
      substr(p_trans_note, 10, 11) = 'Sent to BAR' THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;

  /*  The BAR_LOSTPROCESSING_PAYMENT function takes a fine fee type, a fine fee 
      transaction type, and a transaction note as input, and returns a 1 
      formatted as an integer if the fee type is 3 (Lost Item Processing), the 
      transaction type is 5 (Bursar Transfer) and the transaction has been paid 
      in BAR. Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-07-09 chunt
  */
  FUNCTION BAR_LOSTPROCESSING_PAYMENT(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type,
    p_trans_note ucladb.fine_fee_transactions.TRANS_NOTE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF 
      p_fine_fee_type = 3 AND
      p_trans_type = 5 AND 
      substr(p_trans_note, 10, 11) = 'Paid in BAR' THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The BAR_LOSTPROCESSING_REFUND function takes a fine fee type, a fine fee 
      transaction type, and a transaction note as input, and returns a 1 
      formatted as an integer if the fee type is 3 (Lost Item Processing), the 
      transaction type is 6 (Bursar Refund). Otherwise it returns 0 formatted as 
      an integer.
      
      Last revised: 2007-07-09 chunt
  */
  FUNCTION BAR_LOSTPROCESSING_REFUND(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type,
    p_trans_note ucladb.fine_fee_transactions.TRANS_NOTE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF 
      p_fine_fee_type = 3 AND
      p_trans_type = 6 THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The BAR_LOST_OUTSTANDING function takes a fine fee type, a fine fee 
      transaction type, and a transaction note as input, and returns a 1 
      formatted as an integer if the fee type is 2 (Lost Item Replacement), the 
      transaction type is 5 (Bursar Transfer) and the transaction has not yet 
      been paid in BAR. Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-07-09 chunt
  */
  FUNCTION BAR_LOST_OUTSTANDING(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type,
    p_trans_note ucladb.fine_fee_transactions.TRANS_NOTE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF
      p_fine_fee_type = 2 AND
      p_trans_type = 5 AND 
      substr(p_trans_note, 10, 11) = 'Sent to BAR' THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;

  /*  The BAR_LOST_PAYMENT function takes a fine fee type, a fine fee 
      transaction type, and a transaction note as input, and returns a 1 
      formatted as an integer if the fee type is 2 (Lost Item Replacement), the 
      transaction type is 5 (Bursar Transfer) and the transaction has been paid 
      in BAR. Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-07-09 chunt
  */
  FUNCTION BAR_LOST_PAYMENT(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type,
    p_trans_note ucladb.fine_fee_transactions.TRANS_NOTE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF 
      p_fine_fee_type = 2 AND
      p_trans_type = 5 AND 
      substr(p_trans_note, 10, 11) = 'Paid in BAR' THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The BAR_LOST_REFUND function takes a fine fee type, a fine fee 
      transaction type, and a transaction note as input, and returns a 1 
      formatted as an integer if the fee type is 3 (Lost Item Replacement), the 
      transaction type is 6 (Bursar Refund). Otherwise it returns 0 formatted as 
      an integer.
      
      Last revised: 2007-07-09 chunt
  */
  FUNCTION BAR_LOST_REFUND(
    p_fine_fee_type ucladb.FINE_FEE.FINE_FEE_TYPE%type,
    p_trans_type ucladb.fine_fee_transactions.TRANS_TYPE%type,
    p_trans_note ucladb.fine_fee_transactions.TRANS_NOTE%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF 
      p_fine_fee_type = 2 AND
      p_trans_type = 6 THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The CONCAT_STAT_CATS function takes a patron id as input, and returns a 
      string that is the patron's concatenated statistical categories.
      
      Last revised: 2007-03-01 chunt
  */
  FUNCTION CONCAT_STAT_CATS(
    p_patron_id ucladb.PATRON.PATRON_ID%type
  ) 
  RETURN VARCHAR2 IS
    ret  VARCHAR2(4000);
    hold VARCHAR2(4000);
    cur  sys_refcursor;
   BEGIN
     OPEN cur FOR 
      SELECT psc.patron_stat_desc
      FROM ucladb.patron_stats ps
      INNER JOIN ucladb.patron_stat_code psc
      ON ps.patron_stat_id = psc.patron_stat_id
      where ps.patron_id = p_patron_id
      order by psc.patron_stat_desc;
     LOOP
       FETCH cur INTO hold;
       EXIT WHEN cur%NOTFOUND;
       IF ret IS NULL THEN
         ret := hold;
       ELSE
         ret := ret || ',' || hold;
       END IF;
     END LOOP;
     RETURN ret;
   END;

  /*  The IS_RESERVE_CHARGE function takes a location id and on_reserve flag 
      as input, and returns a 1 formatted as an integer if the location id 
      corresponds to one that only charges reserve materials (211) or if the 
      on_reserve flag is set to 1. Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-04-09 chunt
  */
  FUNCTION IS_RESERVE_CHARGE(
    p_location_id ucladb.location.location_id%type,
    p_on_reserve vger_report.UCLADB_RESERVE_TRANS.on_reserve%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF p_location_id = 211 THEN
      v_output := 1;
    ELSE
      IF p_on_reserve = 'Y' THEN
        v_output := 1;
      ELSE
        v_output := 0;
      END IF;
    END IF;
    RETURN v_output;
  END;
  
  /*  The IS_NOT_RESERVE_CHARGE function takes a location id and on_reserve flag 
      as input, and returns the inverse of the IS_RESERVE_CHARGE function.
      
      Last revised: 2007-07-20 chunt
  */
  FUNCTION IS_NOT_RESERVE_CHARGE(
    p_location_id ucladb.location.location_id%type,
    p_on_reserve vger_report.UCLADB_RESERVE_TRANS.on_reserve%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    -- We want the boolean inverse of the IS_RESERVE_CHARGE function. 
    -- 1->0, 0->1.
    v_output := POWER(IS_RESERVE_CHARGE(p_location_id, p_on_reserve) - 1, 2); 
    RETURN v_output;
  END;
  
  /*  The IS_SELF_CHARGE function takes a location id as input, and returns a 1 
      formatted as an integer if the location id corresponds to a self-charging 
      location. Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-04-09 chunt
  */
  FUNCTION IS_SELF_CHARGE(
    p_location_id ucladb.location.location_id%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF p_location_id = 631 OR 
        p_location_id = 632 OR 
        p_location_id = 633 THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The IS_STAFF_CHARGE function takes a location id as input, and returns a 1 
      formatted as an integer if the location id doesn't correspond to a 
      self-charging location. Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-07-20 chunt
  */
  FUNCTION IS_STAFF_CHARGE(
    p_location_id ucladb.location.location_id%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    -- We want the boolean inverse of the IS_SELF_CHARGE function. 1->0, 0->1.
    v_output := POWER(IS_SELF_CHARGE(p_location_id) - 1, 2); 
    RETURN v_output;
  END;
  
  /*  The IS_WEB_RENEWAL function takes an operator id as input, and returns a 1 
      formatted as an integer if the operator id corresponds to a web renewal 
      operator (currently 'OPAC'). Otherwise it returns 0 formatted as an integer.
      
      Last revised: 2007-04-16 chunt
  */
  FUNCTION IS_WEB_RENEWAL(
    p_operator_id ucladb.operator.OPERATOR_ID%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    IF p_operator_id IS NULL OR p_operator_id = 'OPAC' THEN
      v_output := 1;
    ELSE
      v_output := 0;
    END IF;
    RETURN v_output;
  END;
  
  /*  The IS_STAFF_RENEWAL function takes an operator id as input, and returns 
      the inverse of the IS_WEB_RENEWAL function.
      
      Last revised: 2007-07-20 chunt
  */
  FUNCTION IS_STAFF_RENEWAL(
    p_operator_id ucladb.operator.OPERATOR_ID%type
  ) 
  RETURN NUMBER AS 
    v_output NUMBER(38,0);
  BEGIN
    -- We want the boolean inverse of the IS_SELF_CHARGE function. 1->0, 0->1.
    v_output := POWER(IS_WEB_RENEWAL(p_operator_id) - 1, 2); 
    RETURN v_output;
  END;
  
 /*  The INSERT_RESERVE_TRANS procedure runs a query and adds reserve status
      of items from the previous day to the UCLADB_RESERVE_TRANS table in the
      vger_report schema.

      Last revised: 2006-11-15 chunt
  */
  PROCEDURE INSERT_RESERVE_TRANS AS
  BEGIN
    insert into vger_report.UCLADB_RESERVE_TRANS
    (circ_transaction_id, item_id, on_reserve, month, res_id, modify_date)
    SELECT
          circ_transaction_id,
          item_id,
          on_reserve,
          to_char(trunc(sysdate)-1, 'YYYYMM'),
          u_reserve_trans_seq.nextval,
          sysdate
    FROM
    (       SELECT
                    CT.circ_transaction_id
            ,       CT.item_id
            ,       I.on_reserve
            FROM ucladb.circ_transactions CT
            INNER JOIN ucladb.item I
                    ON CT.item_id = I.item_id
            WHERE charge_date >= trunc(sysdate)-1
            AND charge_date < trunc(sysdate)
            UNION ALL
            SELECT
                    CTA.circ_transaction_id
            ,       CTA.item_id
            ,       I.on_reserve
            FROM ucladb.circ_trans_archive CTA
            INNER JOIN ucladb.item I
                    ON CTA.item_id = I.item_id
            WHERE charge_date >= trunc(sysdate)-1
            AND charge_date < trunc(sysdate)
    ) union_query
    ;
  END;
END;

/

  GRANT EXECUTE ON "VGER_SUPPORT"."LWS_CSC" TO "UCLA_PREADDB";
  GRANT EXECUTE ON "VGER_SUPPORT"."LWS_CSC" TO "VGER_REPORT";

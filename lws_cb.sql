--------------------------------------------------------
--  File created - Tuesday-December-12-2017   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body LWS_CB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "VGER_SUPPORT"."LWS_CB" AS
/*  The LWS_CB package collects together stored procedures and functions
    that are of use to the Circulation Billing Project which sends fee/fine
    information to the BAR system.
    
    Last revised: 2008-11-14 chunt
*/

  /*  The GET_BATCH_HEADER_ORDER function takes a type as input, and returns 
      the order of batch header fields based on that type.
      
      Last revised: 2007-10-31 chunt
  */
  FUNCTION GET_BATCH_HEADER_FIELD_ORDER
  RETURN fields_order_type AS 
    batch_header_fields_order fields_order_type;
  BEGIN
    batch_header_fields_order(1)  := 'transaction code';
    batch_header_fields_order(2)  := 'batch id';
    batch_header_fields_order(3)  := 'date batch';
    batch_header_fields_order(4)  := 'description batch';
    batch_header_fields_order(5)  := 'list option batch';
    batch_header_fields_order(6)  := 'user code';
    batch_header_fields_order(7)  := 'trans count submitted';
    batch_header_fields_order(8)  := 'absolute amount submitted';
    batch_header_fields_order(9)  := 'not used1';
    batch_header_fields_order(10)  := 'originator';
    batch_header_fields_order(11) := 'not used2';
--    batch_header_fields_order(12) := 'award year sc b';
--    batch_header_fields_order(13) := 'session sc b';
--    batch_header_fields_order(14) := 'print update flag';
--    batch_header_fields_order(15) := 'not used3';
    
    RETURN batch_header_fields_order;
  END;

  /*  The GET_65A_FIELD_ORDER function takes a type as input, and returns 
      the order of batch 65A fields based on that type.
      
      Last revised: 2007-10-31 chunt
  */
  FUNCTION GET_65A_FIELD_ORDER
  RETURN fields_order_type AS 
    batch65a_fields_order fields_order_type;
  BEGIN
    batch65a_fields_order(1)  := 'transaction code';
    batch65a_fields_order(2)  := 'external id';
    batch65a_fields_order(3)  := 'university id';
    batch65a_fields_order(4)  := 'subcode';
    batch65a_fields_order(5)  := 'term';
    batch65a_fields_order(6)  := 'effective date';
    batch65a_fields_order(7)  := 'tran amount';
    batch65a_fields_order(8)  := 'la county sales tax amount';
    batch65a_fields_order(9)  := 'non-la county sales tax amount';
    batch65a_fields_order(10) := 'not used';
    
    RETURN batch65a_fields_order;
  END;

  /*  The GET_65AT_FIELD_ORDER function takes a type as input, and returns 
      the order of batch 65AT fields based on that type.
      
      Last revised: 2007-10-31 chunt
  */
  FUNCTION GET_65AT_FIELD_ORDER
  RETURN fields_order_type AS 
    batch65at_fields_order fields_order_type;
  BEGIN
    batch65at_fields_order(1)  := 'transaction code';
    batch65at_fields_order(2)  := 'external id';
    batch65at_fields_order(3)  := 'university id';
    batch65at_fields_order(4)  := 'subcode';
    batch65at_fields_order(5)  := 'term';
    batch65at_fields_order(6)  := 'text indicator';
    batch65at_fields_order(7)  := 'text';
    batch65at_fields_order(8)  := 'not used';
    
    RETURN batch65at_fields_order;
  END;

  /*  The GET_65C_FIELD_ORDER function takes a type as input, and returns 
      the order of batch 65C fields based on that type.
      
      Last revised: 2007-10-31 chunt
  */
  FUNCTION GET_65C_FIELD_ORDER
  RETURN fields_order_type AS 
    batch65c_fields_order fields_order_type;
  BEGIN
    batch65c_fields_order(1)  := 'transaction code';
    batch65c_fields_order(2)  := 'external id';
    batch65c_fields_order(3)  := 'university id';
    batch65c_fields_order(4)  := 'subcode';
    batch65c_fields_order(5)  := 'term';
    batch65c_fields_order(6)  := 'sequence number';
    batch65c_fields_order(10) := 'not used';
    
    RETURN batch65c_fields_order;
  END;

  /*  The GET_BATCH_HEADER function takes a transaction count and amount and 
      formats and returns a string representing a BAR BATCH HEADER.
      
      Last revised: 2007-10-30 chunt
  */
  FUNCTION GET_BATCH_HEADER(
    p_trans_count number,
    p_absolute_amount number
  )
  RETURN varchar2 AS 
    idx pls_integer;
    batch_header_fields fields_type;
    batch_header_fields_order fields_order_type;
    v_batch_header varchar2(128);
    v_absolute_batch_number natural;
  BEGIN
    v_batch_header := '';
    batch_header_fields('transaction code') := '$$$';
    -- The Library's batch numbers are 966-970.
    -- A sequence has been created bar_seq which is used to see which batch
    -- number should be used. Take it mod 5 and add 966.
    select bar_seq.nextval into v_absolute_batch_number from dual;
    batch_header_fields('batch id') := 'BAR' || to_char(966 + mod(v_absolute_batch_number, 5));
    batch_header_fields('date batch') := to_char(sysdate, 'MMDDYYYY');
    -- Following field is 14 characters in the example in the documentation.
    batch_header_fields('description batch') := rpad('Fines / Fees', 15, ' ');
    batch_header_fields('list option batch') := 'N';
    -- Need to check what user code will be.
    batch_header_fields('user code') := 'MS';
    -- This will be passed.
    batch_header_fields('trans count submitted') := to_char(p_trans_count, 'fm09999');
    batch_header_fields('absolute amount submitted') := to_char(p_absolute_amount, 'fm09999999999');
    -- Following field shows as length 3 in documentation but is actually 4.
    batch_header_fields('not used1') := rpad(' ', 4, ' ');
    batch_header_fields('originator') := rpad('CWH', 8, ' ');
    -- Everything after 63 should be blank.
    batch_header_fields('not used2') := rpad(' ', 65, ' ');

    -- Order the fields used for the batch header.
    batch_header_fields_order := GET_BATCH_HEADER_FIELD_ORDER;
    -- Loop through the fields and set them (in the right order).
    idx := batch_header_fields_order.FIRST;
    WHILE idx IS NOT NULL
    LOOP
      v_batch_header := v_batch_header || batch_header_fields(batch_header_fields_order(idx));
      idx := batch_header_fields_order.NEXT(idx);
    END LOOP;
    
    return v_batch_header;
  END;

  /*  The GET_65A function takes a transaction count and amount and 
      formats and returns a string representing a BAR 65A Batch Transaction.
      
      Last revised: 2007-10-31 chunt
  */
  FUNCTION GET_65A(
    p_external_id char,
    p_university_id varchar2,
    p_subcode number,
    p_term varchar2,
    p_tran_amount number
  )
  RETURN varchar2 AS 
    idx pls_integer;
    batch65a_fields fields_type;
    batch65a_fields_order fields_order_type;
    v_batch65a varchar2(128);
  BEGIN
    v_batch65a := '';
    batch65a_fields('transaction code') := '65A';
    batch65a_fields('external id') := p_external_id;
    batch65a_fields('university id') := p_university_id;
    batch65a_fields('subcode') :=  to_char(p_subcode, 'fm09999');
    batch65a_fields('term') := p_term;
    batch65a_fields('effective date') := to_char(sysdate, 'MMDDYYYY');
    batch65a_fields('tran amount') := to_char(p_tran_amount, 'fm099999999');
    batch65a_fields('la county sales tax amount') := rpad('0', 9, '0');
    batch65a_fields('non-la county sales tax amount') := rpad('0', 9, '0');
    batch65a_fields('not used') := rpad(' ', 72, ' ');

    -- Order the fields used for the batch header.
    batch65a_fields_order := GET_65A_FIELD_ORDER;
    -- Loop through the fields and set them (in the right order).
    idx := batch65a_fields_order.FIRST;
    WHILE idx IS NOT NULL
    LOOP
      v_batch65a := v_batch65a || batch65a_fields(batch65a_fields_order(idx));
      idx := batch65a_fields_order.NEXT(idx);
    END LOOP;
    
    return v_batch65a;
  END;

  /*  The GET_65AT function takes a transaction count and amount and 
      formats and returns a string representing a BAR 65AT Batch Transaction.
      
      Last revised: 2007-10-31 chunt
  */
  FUNCTION GET_65AT(
    p_external_id char,
    p_university_id varchar2,
    p_subcode number,
    p_term varchar2,
    p_text varchar2
  )
  RETURN varchar2 AS 
    idx pls_integer;
    batch65at_fields fields_type;
    batch65at_fields_order fields_order_type;
    v_batch65at varchar2(128);
  BEGIN
    v_batch65at := '';
    batch65at_fields('transaction code') := '65A';
    batch65at_fields('external id') := p_external_id;
    batch65at_fields('university id') := p_university_id;
    batch65at_fields('subcode') :=  to_char(p_subcode, 'fm09999');
    batch65at_fields('term') := p_term;
    batch65at_fields('text indicator') := 'T';
    batch65at_fields('text') := rpad(p_text, 60, ' ');
    batch65at_fields('not used') := rpad(' ', 46, ' ');

    -- Order the fields used for the batch header.
    batch65at_fields_order := GET_65AT_FIELD_ORDER;
    -- Loop through the fields and set them (in the right order).
    idx := batch65at_fields_order.FIRST;
    WHILE idx IS NOT NULL
    LOOP
      v_batch65at := v_batch65at || batch65at_fields(batch65at_fields_order(idx));
      idx := batch65at_fields_order.NEXT(idx);
    END LOOP;
    
    return v_batch65at;
  END;

  /*  The GET_65C function takes a transaction count and amount and 
      formats and returns a string representing a BAR 65C Batch Transaction.
      
      Last revised: 2007-10-31 chunt
  */
  FUNCTION GET_65C(
    p_external_id char,
    p_university_id varchar2,
    p_subcode number,
    p_term varchar2,
    p_sequence_number number
  )
  RETURN varchar2 AS 
    idx pls_integer;
    batch65c_fields fields_type;
    batch65c_fields_order fields_order_type;
    v_batch65c varchar2(1000);
  BEGIN
    v_batch65c := '';
    batch65c_fields('transaction code') := '65C';
    batch65c_fields('external id') := p_external_id;
    batch65c_fields('university id') := p_university_id;
    batch65c_fields('subcode') :=  to_char(p_subcode, 'fm09999');
    batch65c_fields('term') := p_term;
    batch65c_fields('sequence number') := to_char(p_sequence_number, 'fm0999');
    batch65c_fields('not used') := rpad(' ', 102, ' ');

    -- Order the fields used for the batch header.
    batch65c_fields_order := GET_65C_FIELD_ORDER;
    -- Loop through the fields and set them (in the right order).
    idx := batch65c_fields_order.FIRST;
    WHILE idx IS NOT NULL
    LOOP
      v_batch65c := v_batch65c || batch65c_fields(batch65c_fields_order(idx));
      idx := batch65c_fields_order.NEXT(idx);
    END LOOP;
    
    return v_batch65c;
  END;

  /*  The GET_BATCH_ID function returns the BAR batch id corresponding to the 
      current day of the week:
      966=Mon, 967=Tue, 968=Wed, 969=Thu, 970=Fri
      
      Last revised: 2007-11-15 chunt
  */
  FUNCTION GET_BATCH_ID
  RETURN varchar2 AS 
    v_batchid varchar2(3);
  BEGIN
    v_batchid := to_char(to_number(to_char(sysdate, 'D')) + 964);
    return v_batchid;
  END;

  /*  The GET_TERM function takes a trans_note field of a fine fee transaction 
      and returns the term if it exists.
      
      Last revised: 2007-12-10 chunt
  */
  FUNCTION GET_TERM(
    p_trans_note ucladb.FINE_FEE_TRANSACTIONS.TRANS_NOTE%type
  )
  RETURN varchar2 AS 
  BEGIN
    return substr(p_trans_note, 40, 3);
  END;

  /*  The GET_DATE function takes a trans_note field of a fine fee transaction 
      and returns the date of the BAR transaction.  It uses a regular expression
      to constrain the data to valid dates in the given format.
      
      Last revised: 2017-12-12 akohler
  */
  FUNCTION GET_DATE(
    p_trans_note ucladb.FINE_FEE_TRANSACTIONS.TRANS_NOTE%type
  )
  RETURN date AS 
    v_date date;
  BEGIN
    select to_date(substr(p_trans_note, 1, 8), 'MM/DD/YY') into v_date
    from dual
    where regexp_like(p_trans_note, '^\d{2}/\d{2}/\d{2}'); -- start of note is not 2 digits slash 2 digits slash 2 digits

    return v_date;
  END;

  /*  The GET_SUBCODE function takes a trans_note field of a fine fee 
      transaction and returns the subcode if it exists.
      
      Last revised: 2007-12-10 chunt
  */
  FUNCTION GET_SUBCODE(
    p_trans_note ucladb.FINE_FEE_TRANSACTIONS.TRANS_NOTE%type
  )
  RETURN varchar2 AS 
  BEGIN
    return substr(p_trans_note, 44, 5);
  END;

  /*  The GET_SEQNO function takes a trans_note field of a fine fee transaction 
        and returns the sequence number if it exists.
      
      Last revised: 2007-12-10 chunt
  */
  FUNCTION GET_SEQNO(
    p_trans_note ucladb.FINE_FEE_TRANSACTIONS.TRANS_NOTE%type
  )
  RETURN varchar2 AS 
  BEGIN
    return substr(p_trans_note, 50, 4);
  END;

  /*  The GET_SUBCODE_KEY function takes circ_group_id and location_code fields
        and returns the circ_group_id unless the location_code matches the East
        Asian Library in which case it returns -1.
      
      Last revised: 2008-03-04 chunt
  */
  FUNCTION GET_SUBCODE_KEY(
    p_circ_group_id ucladb.circ_policy_locs.circ_group_id%type,
    p_location_code ucladb.location.location_code%type
  )
  RETURN number AS 
  BEGIN
    if upper(substr(p_location_code, 0, 2)) = 'EA' then
      return -1;
    else
      return p_circ_group_id;
    end if;
  END;

  /*  The DET_EXTR_IND function takes a trans_note field of a fine fee  and 
        returns the external indicator.
      
      Last revised: 2008-11-14 chunt
  */
  FUNCTION GET_EXTR_IND(
    p_trans_note ucladb.FINE_FEE_TRANSACTIONS.TRANS_NOTE%type
  )
  RETURN varchar2 AS 
  BEGIN
    return substr(p_trans_note, 9, 1);
  END;

  /*  The DET_EXTR_IND function takes a major1 field of a student's registrar 
        data, determines, and returns the student's external indicator.
      
      Last revised: 2008-11-14 chunt
  */

  FUNCTION DET_EXTR_IND(
    p_major1 vger_report.cmp_registrar.major1%type
  )
  RETURN varchar2 AS 
    v_output varchar2(1);
  BEGIN
    -- The major code of FEMBA/EMBA students is 602.
    -- These get the 'M' external indicator.
    IF p_major1 = '602' THEN
      v_output := 'M';
    ELSE
      v_output := ' ';
    END IF;
    RETURN v_output;
  END;

END LWS_CB;

/

  GRANT EXECUTE ON "VGER_SUPPORT"."LWS_CB" TO "UCLA_PREADDB";
  GRANT EXECUTE ON "VGER_SUPPORT"."LWS_CB" TO "UCLADB";

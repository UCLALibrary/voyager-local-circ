--------------------------------------------------------
--  File created - Tuesday-December-12-2017   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body LWS_PATRON
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "VGER_SUPPORT"."LWS_PATRON" AS
/*  The LWS_PATRON package collects together stored procedure and functions
    that are of use to manage patrons in the Voyager Integrated Library System.
    
    Last revised: 2008-11-05 chunt
*/


  /*  The GET_VOYAGER_FIELD_ORDER function takes a type as input, and returns 
      the order of Voyager fields based on that type.
      
      Last revised: 2006-08-28 chunt
  */
  FUNCTION GET_VOYAGER_FIELD_ORDER(
    p_address_order number default 0
  ) 
  RETURN voyager_fields_order_type AS 
    voyager_fields_order voyager_fields_order_type;
  BEGIN
    -- The difference in order is going to be changing the order of address 
    -- records. The basic order is p-t-e, permanent, temporary, e-mail. The 
    -- alternate order puts e-mail before temporary address.
    voyager_fields_order(1) := 'patron id';
    voyager_fields_order(2) := 'patron barcode id 1';
    voyager_fields_order(3) := 'patron barcode 1';
    voyager_fields_order(4) := 'patron group 1';
    voyager_fields_order(5) := 'barcode status 1';
    voyager_fields_order(6) := 'barcode modified date 1';
    voyager_fields_order(7) := 'patron barcode id 2';
    voyager_fields_order(8) := 'patron barcode 2';
    voyager_fields_order(9) := 'patron group 2';
    voyager_fields_order(10) := 'barcode status 2';
    voyager_fields_order(11) := 'barcode modified date 2';
    voyager_fields_order(12) := 'patron barcode id 3';
    voyager_fields_order(13) := 'patron barcode 3';
    voyager_fields_order(14) := 'patron group 3';
    voyager_fields_order(15) := 'barcode status 3';
    voyager_fields_order(16) := 'barcode modified date 3';
    voyager_fields_order(17) := 'registration date';
    voyager_fields_order(18) := 'patron expiration date';
    voyager_fields_order(19) := 'patron purge date';
    voyager_fields_order(20) := 'voyager date';
    voyager_fields_order(21) := 'voyager updated';
    voyager_fields_order(22) := 'circulation happening location code';
    voyager_fields_order(23) := 'institution ID ';
    voyager_fields_order(24) := 'ssn';
    voyager_fields_order(25) := 'statistical category 1';
    voyager_fields_order(26) := 'statistical category 2';
    voyager_fields_order(27) := 'statistical category 3';
    voyager_fields_order(28) := 'statistical category 4';
    voyager_fields_order(29) := 'statistical category 5';
    voyager_fields_order(30) := 'statistical category 6';
    voyager_fields_order(31) := 'statistical category 7';
    voyager_fields_order(32) := 'statistical category 8';
    voyager_fields_order(33) := 'statistical category 9';
    voyager_fields_order(34) := 'statistical category 10';
    voyager_fields_order(35) := 'name type';
    voyager_fields_order(36) := 'surname';
    voyager_fields_order(37) := 'first name';
    voyager_fields_order(38) := 'middle name';
    voyager_fields_order(39) := 'title';
    voyager_fields_order(40) := 'historical charges';
    voyager_fields_order(41) := 'claims returned';
    voyager_fields_order(42) := 'count selfshelved count';
    voyager_fields_order(43) := 'lost items count';
    voyager_fields_order(44) := 'late media returns';
    voyager_fields_order(45) := 'historical bookings';
    voyager_fields_order(46) := 'canceled bookings';
    voyager_fields_order(47) := 'unclaimed bookings';
    voyager_fields_order(48) := 'historical callslips';
    voyager_fields_order(49) := 'historical distributions';
    voyager_fields_order(50) := 'historical short loans';
    voyager_fields_order(51) := 'unclaimed short loans';
    voyager_fields_order(52) := 'address count';
    voyager_fields_order(53) := 'perm address id';
    voyager_fields_order(54) := 'perm address type';
    voyager_fields_order(55) := 'perm address status code';
    voyager_fields_order(56) := 'perm address begin date';
    voyager_fields_order(57) := 'perm address end date';
    voyager_fields_order(58) := 'perm address line 1';
    voyager_fields_order(59) := 'perm address line 2';
    voyager_fields_order(60) := 'perm address line 3';
    voyager_fields_order(61) := 'perm address line 4';
    voyager_fields_order(62) := 'perm address line 5';
    voyager_fields_order(63) := 'perm city';
    voyager_fields_order(64) := 'perm state (province) code';
    voyager_fields_order(65) := 'perm zipcode/postal code';
    voyager_fields_order(66) := 'perm country';
    voyager_fields_order(67) := 'perm phone (primary)';
    voyager_fields_order(68) := 'perm phone (mobile)';
    voyager_fields_order(69) := 'perm phone (fax)';
    voyager_fields_order(70) := 'perm phone (other)';
    voyager_fields_order(71) := 'perm date added/updated';
    if p_address_order = 1 then
      voyager_fields_order(72) := 'email address id';
      voyager_fields_order(73) := 'email address type';
      voyager_fields_order(74) := 'email address status code';
      voyager_fields_order(75) := 'email address begin date';
      voyager_fields_order(76) := 'email address end date';
      voyager_fields_order(77) := 'email address line 1';
      voyager_fields_order(78) := 'email address line 2';
      voyager_fields_order(79) := 'email address line 3';
      voyager_fields_order(80) := 'email address line 4';
      voyager_fields_order(81) := 'email address line 5';
      voyager_fields_order(82) := 'email city';
      voyager_fields_order(83) := 'email state (province) code';
      voyager_fields_order(84) := 'email zipcode/postal code';
      voyager_fields_order(85) := 'email country';
      voyager_fields_order(86) := 'email phone (primary)';
      voyager_fields_order(87) := 'email phone (mobile)';
      voyager_fields_order(88) := 'email phone (fax)';
      voyager_fields_order(89) := 'email phone (other)';
      voyager_fields_order(90) := 'email date added/updated';
      voyager_fields_order(91) := 'temp address id';
      voyager_fields_order(92) := 'temp address type';
      voyager_fields_order(93) := 'temp address status code';
      voyager_fields_order(94) := 'temp address begin date';
      voyager_fields_order(95) := 'temp address end date';
      voyager_fields_order(96) := 'temp address line 1';
      voyager_fields_order(97) := 'temp address line 2';
      voyager_fields_order(98) := 'temp address line 3';
      voyager_fields_order(99) := 'temp address line 4';
      voyager_fields_order(100) := 'temp address line 5';
      voyager_fields_order(101) := 'temp city';
      voyager_fields_order(102) := 'temp state (province) code';
      voyager_fields_order(103) := 'temp zipcode/postal code';
      voyager_fields_order(104) := 'temp country';
      voyager_fields_order(105) := 'temp phone (primary)';
      voyager_fields_order(106) := 'temp phone (mobile)';
      voyager_fields_order(107) := 'temp phone (fax)';
      voyager_fields_order(108) := 'temp phone (other)';
      voyager_fields_order(109) := 'temp date added/updated';
    else
      voyager_fields_order(72) := 'temp address id';
      voyager_fields_order(73) := 'temp address type';
      voyager_fields_order(74) := 'temp address status code';
      voyager_fields_order(75) := 'temp address begin date';
      voyager_fields_order(76) := 'temp address end date';
      voyager_fields_order(77) := 'temp address line 1';
      voyager_fields_order(78) := 'temp address line 2';
      voyager_fields_order(79) := 'temp address line 3';
      voyager_fields_order(80) := 'temp address line 4';
      voyager_fields_order(81) := 'temp address line 5';
      voyager_fields_order(82) := 'temp city';
      voyager_fields_order(83) := 'temp state (province) code';
      voyager_fields_order(84) := 'temp zipcode/postal code';
      voyager_fields_order(85) := 'temp country';
      voyager_fields_order(86) := 'temp phone (primary)';
      voyager_fields_order(87) := 'temp phone (mobile)';
      voyager_fields_order(88) := 'temp phone (fax)';
      voyager_fields_order(89) := 'temp phone (other)';
      voyager_fields_order(90) := 'temp date added/updated';
      voyager_fields_order(91) := 'email address id';
      voyager_fields_order(92) := 'email address type';
      voyager_fields_order(93) := 'email address status code';
      voyager_fields_order(94) := 'email address begin date';
      voyager_fields_order(95) := 'email address end date';
      voyager_fields_order(96) := 'email address line 1';
      voyager_fields_order(97) := 'email address line 2';
      voyager_fields_order(98) := 'email address line 3';
      voyager_fields_order(99) := 'email address line 4';
      voyager_fields_order(100) := 'email address line 5';
      voyager_fields_order(101) := 'email city';
      voyager_fields_order(102) := 'email state (province) code';
      voyager_fields_order(103) := 'email zipcode/postal code';
      voyager_fields_order(104) := 'email country';
      voyager_fields_order(105) := 'email phone (primary)';
      voyager_fields_order(106) := 'email phone (mobile)';
      voyager_fields_order(107) := 'email phone (fax)';
      voyager_fields_order(108) := 'email phone (other)';
      voyager_fields_order(109) := 'email date added/updated';
    end if;
    
    RETURN voyager_fields_order;
  END;
  
  /*  The GET_PATRON_GROUP function takes a set of registrar data fields as 
      input, calculates and returns a patron group based on those parameters.
      
      Last revised: 2006-08-16 chunt
  */
  FUNCTION GET_PATRON_GROUP(
    P_CAREER VGER_REPORT.CMP_REGISTRAR.CAREER%TYPE,
    P_CLASS VGER_REPORT.CMP_REGISTRAR.CLASS%TYPE,
    P_COLL1 VGER_REPORT.CMP_REGISTRAR.COLL1%TYPE,
    P_DEG1 VGER_REPORT.CMP_REGISTRAR.DEG1%TYPE,
    P_DEPT1 VGER_REPORT.CMP_REGISTRAR.DEPT1%TYPE,
    P_DIV1 VGER_REPORT.CMP_REGISTRAR.DIV1%TYPE,
    P_RT340 VGER_REPORT.CMP_REGISTRAR.RT340%TYPE
  ) 
  RETURN VARCHAR2 AS 
    V_PATRON_GROUP VARCHAR2(10);
  BEGIN
    -- Start with students whose career field is 'G' or 'P'.
    -- SRDB2 UPDATE comment out next line & uncomment following on 20091026 drickard
    --IF P_CAREER = 'G' or P_CAREER = 'P' THEN
    IF P_CAREER = 'G' OR P_CAREER = 'M' OR P_CAREER = 'D' THEN
      -- Start them out as a graduate student.
      V_PATRON_GROUP := 'UG';
      -- However, being in the Law School trumps being a regular graduate student.
    -- SRDB2 UPDATE comment out next 3 lines on 20091026 drickard
      /*
      IF P_COLL1 = 'LW' THEN
        V_PATRON_GROUP := 'UGL';
      END IF;
      */
      -- Also, being in one of the Music departments trumps being a regular graduate student.
      IF P_DEPT1 = 'MUSCLGY' or P_DEPT1 = 'MUSIC' or P_DEPT1 = 'ETHNOMUS' or P_DEPT1 = 'ETHNOMU' THEN
        V_PATRON_GROUP := 'UGMU';
      END IF;
      -- Finally, students with PhD's in the Management School have their own group.
      IF P_DEG1 = 'PHD' and P_DIV1 = 'MG' THEN
        V_PATRON_GROUP := 'UGM';
      END IF;
    -- SRDB2 UPDATE enable next 3 lines on 20091026 drickard 
    -- (20091026 akohler: there were only 2 lines to enable; replaced 2nd line "PATRON GROUP" with V_PATRON_GROUP)
    ELSIF P_CAREER = 'L' or P_DEG1 = 'JD'  THEN
	    V_PATRON_GROUP := 'UGL';
    -- Now consider undergraduates students.
    ELSIF P_CAREER = 'U' OR P_CAREER = 'I' OR P_CAREER = 'J' THEN
      -- Start them out as a regular undergraduate student.
      V_PATRON_GROUP := 'UU';
      -- However, being in one of the Music departments trumps being a regular undergraduate student.
      IF P_DEPT1 = 'MUSCLGY' or P_DEPT1 = 'MUSIC' or P_DEPT1 = 'ETHNOMUS' or P_DEPT1 = 'ETHNOMU' THEN
        V_PATRON_GROUP := 'UUMU';
      END IF;
      -- Honor students are put in the regular graduate student patron group.
      IF P_RT340 = 'HON' THEN
        V_PATRON_GROUP := 'UG';
      END IF;
    -- Now consider staff members.
    ELSIF P_CAREER = 'P' and P_CLASS = 'PR' THEN
      V_PATRON_GROUP := 'US';
    -- This case catches if a patron falls through the cracks. Since this is an
    -- invalid patron group if this SIF record is run it will be flagged as an 
    -- error.
    ELSE
      V_PATRON_GROUP := 'XXX';
    END IF;
    
    RETURN V_PATRON_GROUP;
  END;
  
  /*  The GET_PATRON_GROUP2 function takes Registrar and QDB group, type, and 
      school information as input and calculates and returns a patron group 
      based on those parameters.
      
      Last revised: 2008-11-05 chunt
  */
  FUNCTION GET_PATRON_GROUP2(
    P_REG_GROUP ucladb.patron_group.PATRON_GROUP_CODE%type,
    P_REG_TYPE VGER_SUPPORT.PATRON_GROUP_COMPONENTS.TYPE%TYPE,
    P_QDB_TYPE VGER_SUPPORT.PATRON_GROUP_COMPONENTS.TYPE%TYPE,
    P_LAW VGER_REPORT.CMP_QDB.LAW%TYPE
  ) 
  RETURN VARCHAR2 AS 
    V_PATRON_GROUP VARCHAR2(10);
    V_MAX_TYPE VGER_SUPPORT.PATRON_GROUP_COMPONENTS.TYPE%TYPE;
    V_REG_TYPE VGER_SUPPORT.PATRON_GROUP_COMPONENTS.TYPE%TYPE;
    V_QDB_TYPE VGER_SUPPORT.PATRON_GROUP_COMPONENTS.TYPE%TYPE;
    V_LAW VGER_REPORT.CMP_QDB.LAW%TYPE;
  BEGIN
    -- School is a factor for group determination.
    -- For academic and staff groups only Law is a factor.
    -- For graduate groups Law, Management, and Music is a factor.
    -- For undergraduate groups only Music is a factor.
    -- 
    -- School is one of:
    -- 1=Regular
    -- 2=Law
    -- 3=Management
    -- 4=Music

    -- P_REG_GROUP has already been calculated based on Registrar data.
    IF P_REG_TYPE IS NULL THEN
      V_REG_TYPE := 0;
    ELSE
      V_REG_TYPE := P_REG_TYPE;
    END IF;
    IF P_QDB_TYPE IS NULL THEN
      V_QDB_TYPE := 0;
    ELSE
      V_QDB_TYPE := P_QDB_TYPE;
    END IF;
    IF P_LAW IS NULL THEN
      V_LAW := 0;
    ELSE
      V_LAW := P_LAW;
    END IF;
    V_MAX_TYPE := V_REG_TYPE;
    IF V_QDB_TYPE > V_MAX_TYPE THEN
      V_MAX_TYPE := V_QDB_TYPE;
    END IF;

    IF V_MAX_TYPE = 1 THEN
      IF V_LAW = 1 THEN
        V_PATRON_GROUP := 'USL';
      -- There's no special staff besides Law.
      ELSE
        V_PATRON_GROUP := 'US';
      END IF;
    ELSIF V_MAX_TYPE = 2 THEN
      -- If someone is an undergrad they should be in the Registrar data.
      -- If someone's school is Music this will already be set in the group.
      V_PATRON_GROUP := P_REG_GROUP;
    ELSIF V_MAX_TYPE = 3 THEN
      -- Are there postdoc Law people?
      -- If so they are taken care of here.
      IF V_LAW = 1 and V_QDB_TYPE = 3 THEN
        V_PATRON_GROUP := 'UGL';
      ELSE
        -- What about postdoc Management or Music?
        -- They are not accounted for. We make them generic UG.
        -- What about UUMU? Is it better to be UUMU or UG? We assume UUMU.
        IF P_REG_GROUP is null THEN
          V_PATRON_GROUP := 'UG';
        ELSIF P_REG_GROUP = 'UU' THEN
          V_PATRON_GROUP := 'UG';
        ELSE 
          V_PATRON_GROUP := P_REG_GROUP;
        END IF;
      END IF;
    ELSIF V_MAX_TYPE = 4 THEN
      -- There's no special academic patrons besides Law.
      IF V_LAW = 1 THEN
        V_PATRON_GROUP := 'UAL';
      ELSE
        V_PATRON_GROUP := 'UA';
      END IF;
    END IF;
    RETURN V_PATRON_GROUP;
  END;

  /*  The GET_PATRON_SIF function takes a set of data fields corresponding to 
      fields required to create a SIF record as input, formats and returns a 
      string representing a SIF record that can be used to create or update that 
      patron in the Voyager Integrated Library System.
      
      Last revised: 2006-09-06 chunt
  */
  FUNCTION GET_PATRON_SIF(
  -- The parameter list contains the maximal possible fields to create the SIF
  -- record. SIF fields which can't or shouldn't be changed are not included. In
  -- particular, only two barcodes are used although it's possible for a SIF record
  -- to have three.
    p_sifr sif_record
  ) 
  return varchar2 as 
    idx pls_integer;
    v_address_count number;
    v_sif varchar2(2000);
    v_has_perm_add number := 0;
    v_has_temp_add number := 0;
    v_has_email_add number := 0;
    v_process number := 1;
    voyager_fields voyager_fields_type;
    voyager_fields_order voyager_fields_order_type;
  BEGIN
    -- Start with an empty string and initialize the address count.
    V_SIF := '';
    V_ADDRESS_COUNT := 0;
    -- Keep track if someone has an e-mail address.
    IF p_sifr.perm_address_line1 is not null THEN
      v_has_perm_add := 1;
    END IF;
    IF p_sifr.temp_address_line1 is not null THEN
      v_has_temp_add := 1;
    END IF;
    IF p_sifr.email is not null THEN
      v_has_email_add := 1;
    END IF;
    -- Count up how many addresses there are.
    V_ADDRESS_COUNT := V_HAS_PERM_ADD + V_HAS_TEMP_ADD + v_has_email_add;
    -- Order the fields used for the SIF record.
    voyager_fields_order := GET_VOYAGER_FIELD_ORDER(p_sifr.address_order);
    -- Store values of the fields in an associative array. All fields should be
    -- of a certain length. Some fields are filled with blanks to indicate 
    -- a field with data that hasn't changed or where 
    voyager_fields('patron id') := rpad('0',   10,   '0');
    voyager_fields('patron barcode id 1') := rpad('0',   10,   '0');
    voyager_fields('patron barcode 1') := rpad(NVL(p_sifr.patron_barcode, ' '),   25,   ' ');
    voyager_fields('patron group 1') := rpad(NVL(p_sifr.patron_group, ' '), 10, ' ');
    voyager_fields('barcode status 1') := NVL(to_char(p_sifr.barcode_status), ' ');
    voyager_fields('barcode modified date 1') := rpad(' ',   10,   ' ');
    if p_sifr.patron_barcode2 is null then
      voyager_fields('patron barcode id 2') := rpad(' ',   10,   ' ');
    else
      voyager_fields('patron barcode id 2') := rpad('0',   10,   '0');
    end if;
    voyager_fields('patron barcode 2') := rpad(NVL(p_sifr.patron_barcode2, ' '),   25,   ' ');
    voyager_fields('patron group 2') := rpad(NVL(p_sifr.patron_group2, ' '), 10, ' ');
    voyager_fields('barcode status 2') := NVL(to_char(p_sifr.barcode_status2), ' ');
    voyager_fields('barcode modified date 2') := rpad(' ',   10,   ' ');
    voyager_fields('patron barcode id 3') := rpad(' ',   10,   ' ');
    voyager_fields('patron barcode 3') := rpad(' ',   25,   ' ');
    voyager_fields('patron group 3') := rpad(' ',   10,   ' ');
    voyager_fields('barcode status 3') := rpad(' ',   1,   ' ');
    voyager_fields('barcode modified date 3') := rpad(' ',   10,   ' ');
    if p_sifr.registration_date is null then
      voyager_fields('registration date') := rpad(' ',   10,   ' ');
    else
      voyager_fields('registration date') := to_char(p_sifr.registration_date, 'YYYY.MM.DD');
    end if;
    if p_sifr.expire_date is null then
      voyager_fields('patron expiration date') := rpad(' ',   10,   ' ');
    else
      voyager_fields('patron expiration date') := to_char(p_sifr.expire_date, 'YYYY.MM.DD');
    end if;
    if p_sifr.purge_date is null then
      voyager_fields('patron purge date') := rpad(' ',   10,   ' ');
    else
      voyager_fields('patron purge date') := to_char(p_sifr.purge_date, 'YYYY.MM.DD');
    end if;
    voyager_fields('voyager date') := rpad(' ',   10,   ' ');
    voyager_fields('voyager updated') := rpad(' ',   10,   ' ');
    voyager_fields('circulation happening location code') := rpad(' ',   10,   ' ');
    voyager_fields('institution ID ') := rpad(NVL(p_sifr.institution_id, ' '),   30,   ' ');
    voyager_fields('ssn') := rpad(' ',   11,   ' ');
    voyager_fields('statistical category 1') := rpad(NVL(p_sifr.statistical_category_1, ' '),   3,   ' ');
    voyager_fields('statistical category 2') := rpad(NVL(p_sifr.statistical_category_2, ' '),   3,   ' ');
    voyager_fields('statistical category 3') := rpad(NVL(p_sifr.statistical_category_3, ' '),   3,   ' ');
    voyager_fields('statistical category 4') := rpad(NVL(p_sifr.statistical_category_4, ' '),   3,   ' ');
    voyager_fields('statistical category 5') := rpad(NVL(p_sifr.statistical_category_5, ' '),   3,   ' ');
    voyager_fields('statistical category 6') := rpad(NVL(p_sifr.statistical_category_6, ' '),   3,   ' ');
    voyager_fields('statistical category 7') := rpad(NVL(p_sifr.statistical_category_7, ' '),   3,   ' ');
    voyager_fields('statistical category 8') := rpad(NVL(p_sifr.statistical_category_8, ' '),   3,   ' ');
    voyager_fields('statistical category 9') := rpad(NVL(p_sifr.statistical_category_9, ' '),   3,   ' ');
    voyager_fields('statistical category 10') := rpad(NVL(p_sifr.statistical_category_10, ' '),   3,   ' ');
    voyager_fields('name type') := NVL(to_char(p_sifr.name_type), ' ');
    voyager_fields('surname') := rpad(NVL(p_sifr.last_name, ' '),   30,   ' ');
    voyager_fields('first name') := rpad(NVL(p_sifr.first_name, ' '),   20,   ' ');
    voyager_fields('middle name') := rpad(NVL(p_sifr.middle_name, ' '),   20,   ' ');
    voyager_fields('title') := rpad(' ',   10,   ' ');
    voyager_fields('historical charges') := rpad('0',   10,   '0');
    voyager_fields('claims returned') := rpad('0',   5,   '0');
    voyager_fields('count selfshelved count') := rpad('0',   5,   '0');
    voyager_fields('lost items count') := rpad('0',   5,   '0');
    voyager_fields('late media returns') := rpad('0',   5,   '0');
    voyager_fields('historical bookings') := rpad('0',   5,   '0');
    voyager_fields('canceled bookings') := rpad('0',   5,   '0');
    voyager_fields('unclaimed bookings') := rpad('0',   5,   '0');
    voyager_fields('historical callslips') := rpad('0',   5,   '0');
    voyager_fields('historical distributions') := rpad('0',   5,   '0');
    voyager_fields('historical short loans') := rpad('0',   5,   '0');
    voyager_fields('unclaimed short loans') := rpad('0',   5,   '0');
    voyager_fields('address count') := V_ADDRESS_COUNT;
  
    -- The record has a permanent address so set the fields.
    IF V_HAS_PERM_ADD = 1 THEN
      voyager_fields('perm address id') := rpad('0',   10,   '0');
      voyager_fields('perm address type') := '1';
      voyager_fields('perm address status code') := 'N';
      if p_sifr.perm_effect_date is null then
        voyager_fields('perm address begin date') := rpad(' ',   10,   ' ');
      else
        voyager_fields('perm address begin date') := to_char(p_sifr.perm_effect_date, 'YYYY.MM.DD');
      end if;
      if p_sifr.perm_expire_date is null then
        voyager_fields('perm address end date') := rpad(' ',   10,   ' ');
      else
        voyager_fields('perm address end date') := to_char(p_sifr.perm_expire_date, 'YYYY.MM.DD');
      end if;
      voyager_fields('perm address line 1') := rpad(NVL(p_sifr.perm_address_line1, ' '), 50, ' ');
      voyager_fields('perm address line 2') := rpad(NVL(p_sifr.perm_address_line2, ' '), 40, ' ');
      voyager_fields('perm address line 3') := rpad(NVL(p_sifr.perm_address_line3, ' '), 40, ' ');
      voyager_fields('perm address line 4') := rpad(NVL(p_sifr.perm_address_line4, ' '), 40, ' ');
      voyager_fields('perm address line 5') := rpad(NVL(p_sifr.perm_address_line5, ' '), 40, ' ');
      voyager_fields('perm city') := rpad(NVL(p_sifr.PERM_CITY, ' '), 40, ' ');
      voyager_fields('perm state (province) code') := rpad(NVL(p_sifr.PERM_STATE_PROVINCE, ' '), 7, ' ');
      voyager_fields('perm zipcode/postal code') := rpad(NVL(p_sifr.PERM_ZIP_POSTAL, ' '), 10, ' ');
      voyager_fields('perm country') := rpad(NVL(p_sifr.PERM_COUNTRY, ' '), 20, ' ');
      voyager_fields('perm phone (primary)') := rpad(NVL(p_sifr.perm_phone_primary, ' '), 25, ' ');
      voyager_fields('perm phone (mobile)') := rpad(NVL(p_sifr.perm_phone_mobile, ' '), 25, ' ');
      voyager_fields('perm phone (fax)') := rpad(NVL(p_sifr.perm_phone_fax, ' '), 25, ' ');
      voyager_fields('perm phone (other)') := rpad(NVL(p_sifr.perm_phone_other, ' '), 25, ' ');
      voyager_fields('perm date added/updated') := rpad(' ',   10,   ' ');
    -- The record doesn't have a permanent address so don't set the fields.
    ELSE
      voyager_fields('perm address id') := '';
      voyager_fields('perm address type') := '';
      voyager_fields('perm address status code') := '';
      voyager_fields('perm address begin date') := '';
      voyager_fields('perm address end date') := '';
      voyager_fields('perm address line 1') := '';
      voyager_fields('perm address line 2') := '';
      voyager_fields('perm address line 3') := '';
      voyager_fields('perm address line 4') := '';
      voyager_fields('perm address line 5') := '';
      voyager_fields('perm city') := '';
      voyager_fields('perm state (province) code') := '';
      voyager_fields('perm zipcode/postal code') := '';
      voyager_fields('perm country') := '';
      voyager_fields('perm phone (primary)') := '';
      voyager_fields('perm phone (mobile)') := '';
      voyager_fields('perm phone (fax)') := '';
      voyager_fields('perm phone (other)') := '';
      voyager_fields('perm date added/updated') := '';
    END IF;
  
    -- The record has a temporary address so set the fields.
    IF V_HAS_TEMP_ADD = 1 THEN
      voyager_fields('temp address id') := rpad('0',   10,   '0');
      voyager_fields('temp address type') := '2';
      voyager_fields('temp address status code') := 'N';
      if p_sifr.temp_effect_date is null then
        voyager_fields('temp address begin date') := rpad(' ',   10,   ' ');
      else
        voyager_fields('temp address begin date') := to_char(p_sifr.temp_effect_date, 'YYYY.MM.DD');
      end if;
      if p_sifr.temp_expire_date is null then
        voyager_fields('temp address end date') := rpad(' ',   10,   ' ');
      else
        voyager_fields('temp address end date') := to_char(p_sifr.temp_expire_date, 'YYYY.MM.DD');
      end if;
      voyager_fields('temp address line 1') := rpad(NVL(p_sifr.temp_address_line1, ' '), 50, ' ');
      voyager_fields('temp address line 2') := rpad(NVL(p_sifr.temp_address_line2, ' '), 40, ' ');
      voyager_fields('temp address line 3') := rpad(NVL(p_sifr.temp_address_line3, ' '), 40, ' ');
      voyager_fields('temp address line 4') := rpad(NVL(p_sifr.temp_address_line4, ' '), 40, ' ');
      voyager_fields('temp address line 5') := rpad(NVL(p_sifr.temp_address_line5, ' '), 40, ' ');
      voyager_fields('temp city') := rpad(NVL(p_sifr.TEMP_CITY, ' '), 40, ' ');
      voyager_fields('temp state (province) code') := rpad(NVL(p_sifr.TEMP_STATE_PROVINCE, ' '), 7, ' ');
      voyager_fields('temp zipcode/postal code') := rpad(NVL(p_sifr.TEMP_ZIP_POSTAL, ' '), 10, ' ');
      voyager_fields('temp country') := rpad(NVL(p_sifr.TEMP_COUNTRY, ' '), 20, ' ');
      voyager_fields('temp phone (primary)') := rpad(NVL(p_sifr.temp_phone_primary, ' '), 25, ' ');
      voyager_fields('temp phone (mobile)') := rpad(NVL(p_sifr.temp_phone_mobile, ' '), 25, ' ');
      voyager_fields('temp phone (fax)') := rpad(NVL(p_sifr.temp_phone_fax, ' '), 25, ' ');
      voyager_fields('temp phone (other)') := rpad(NVL(p_sifr.temp_phone_other, ' '), 25, ' ');
      voyager_fields('temp date added/updated') := rpad(' ',   10,   ' ');
    -- The record doesn't have a temporary address so don't set the fields.
    ELSE
      voyager_fields('temp address id') := '';
      voyager_fields('temp address type') := '';
      voyager_fields('temp address status code') := '';
      voyager_fields('temp address begin date') := '';
      voyager_fields('temp address end date') := '';
      voyager_fields('temp address line 1') := '';
      voyager_fields('temp address line 2') := '';
      voyager_fields('temp address line 3') := '';
      voyager_fields('temp address line 4') := '';
      voyager_fields('temp address line 5') := '';
      voyager_fields('temp city') := '';
      voyager_fields('temp state (province) code') := '';
      voyager_fields('temp zipcode/postal code') := '';
      voyager_fields('temp country') := '';
      voyager_fields('temp phone (primary)') := '';
      voyager_fields('temp phone (mobile)') := '';
      voyager_fields('temp phone (fax)') := '';
      voyager_fields('temp phone (other)') := '';
      voyager_fields('temp date added/updated') := '';
    END IF;
  
    -- The record has an e-mail address so set the fields.
    IF v_has_email_add = 1 THEN
      voyager_fields('email address id') := rpad('0',   10,   '0');
      voyager_fields('email address type') := '3';
      voyager_fields('email address status code') := 'N';
      if p_sifr.email_effect_date is null then
        voyager_fields('email address begin date') := rpad(' ',   10,   ' ');
      else
        voyager_fields('email address begin date') := to_char(p_sifr.email_effect_date, 'YYYY.MM.DD');
      end if;
      if p_sifr.email_expire_date is null then
        voyager_fields('email address end date') := rpad(' ',   10,   ' ');
      else
        voyager_fields('email address end date') := to_char(p_sifr.email_expire_date, 'YYYY.MM.DD');
      end if;
      voyager_fields('email address line 1') := rpad(NVL(p_sifr.email, ' '), 50, ' ');
      voyager_fields('email address line 2') := rpad(' ',   40,   ' ');
      voyager_fields('email address line 3') := rpad(' ',   40,   ' ');
      voyager_fields('email address line 4') := rpad(' ',   40,   ' ');
      voyager_fields('email address line 5') := rpad(' ',   40,   ' ');
      voyager_fields('email city') := rpad(' ',   40,   ' ');
      voyager_fields('email state (province) code') := rpad(' ',   7,   ' ');
      voyager_fields('email zipcode/postal code') := rpad(' ',   10,   ' ');
      voyager_fields('email country') := rpad(' ',   20,   ' ');
      voyager_fields('email phone (primary)') := rpad(' ',   25,   ' ');
      voyager_fields('email phone (mobile)') := rpad(' ',   25,   ' ');
      voyager_fields('email phone (fax)') := rpad(' ',   25,   ' ');
      voyager_fields('email phone (other)') := rpad(' ',   25,   ' ');
      voyager_fields('email date added/updated') := rpad(' ',   10,   ' ');
    -- The record doesn't have an e-mail address so don't set the fields.
    ELSE
      voyager_fields('email address id') := '';
      voyager_fields('email address type') := '';
      voyager_fields('email address status code') := '';
      voyager_fields('email address begin date') := '';
      voyager_fields('email address end date') := '';
      voyager_fields('email address line 1') := '';
      voyager_fields('email address line 2') := '';
      voyager_fields('email address line 3') := '';
      voyager_fields('email address line 4') := '';
      voyager_fields('email address line 5') := '';
      voyager_fields('email city') := '';
      voyager_fields('email state (province) code') := '';
      voyager_fields('email zipcode/postal code') := '';
      voyager_fields('email country') := '';
      voyager_fields('email phone (primary)') := '';
      voyager_fields('email phone (mobile)') := '';
      voyager_fields('email phone (fax)') := '';
      voyager_fields('email phone (other)') := '';
      voyager_fields('email date added/updated') := '';
    END IF;
  
    -- Loop through the fields and set them (in the right order).
    idx := voyager_fields_order.FIRST;
    WHILE idx IS NOT NULL
    LOOP
      V_SIF := V_SIF || voyager_fields(voyager_fields_order(idx));
      idx := voyager_fields_order.NEXT(idx);
    END LOOP;
  
    RETURN V_SIF;
  END;
  
  /*  The NEW_PATRON_SIF_FROM_REG function takes a set of registrar data fields 
      as input, formats and returns a string representing a SIF record that can be 
      used to create or update that patron in the Voyager Integrated Library 
      System.
      
      Last revised: 2006-08-16 chunt
  */
  FUNCTION NEW_PATRON_SIF_FROM_REG(
    P_UNIVERSITY_ID VGER_REPORT.CMP_REGISTRAR.UNIVERSITY_ID%TYPE,
    P_LEVEL_OF_ISSUE VGER_REPORT.CMP_BRUINCARD.LEVEL_OF_ISSUE%TYPE,
    P_NAME VGER_REPORT.CMP_REGISTRAR.NAME%TYPE,
    P_PADDR1 VGER_REPORT.CMP_REGISTRAR.PADDR1%TYPE,
    P_PADDR2 VGER_REPORT.CMP_REGISTRAR.PADDR2%TYPE,
    P_PCITY VGER_REPORT.CMP_REGISTRAR.PCITY%TYPE,
    P_PSTATE VGER_REPORT.CMP_REGISTRAR.PSTATE%TYPE,
    P_PZIP VGER_REPORT.CMP_REGISTRAR.PZIP%TYPE,
    P_PCOUNTRY VGER_REPORT.CMP_REGISTRAR.PCOUNTRY%TYPE,
    P_PPHONE VGER_REPORT.CMP_REGISTRAR.PPHONE%TYPE,
    P_TADDR1 VGER_REPORT.CMP_REGISTRAR.TADDR1%TYPE,
    P_TADDR2 VGER_REPORT.CMP_REGISTRAR.TADDR2%TYPE,
    P_TCITY VGER_REPORT.CMP_REGISTRAR.TCITY%TYPE,
    P_TSTATE VGER_REPORT.CMP_REGISTRAR.TSTATE%TYPE,
    P_TZIP VGER_REPORT.CMP_REGISTRAR.TZIP%TYPE,
    P_TCOUNTRY VGER_REPORT.CMP_REGISTRAR.TCOUNTRY%TYPE,
    P_TPHONE VGER_REPORT.CMP_REGISTRAR.TPHONE%TYPE,
    P_EMAILADD VGER_REPORT.CMP_REGISTRAR.EMAILADD%TYPE,
    P_SEX VGER_REPORT.CMP_REGISTRAR.SEX%TYPE,
    P_CAREER VGER_REPORT.CMP_REGISTRAR.CAREER%TYPE,
    P_CLASS VGER_REPORT.CMP_REGISTRAR.CLASS%TYPE,
    P_COLL1 VGER_REPORT.CMP_REGISTRAR.COLL1%TYPE,
    P_DEG1 VGER_REPORT.CMP_REGISTRAR.DEG1%TYPE,
    P_DEPT1 VGER_REPORT.CMP_REGISTRAR.DEPT1%TYPE,
    P_DIV1 VGER_REPORT.CMP_REGISTRAR.DIV1%TYPE,
    P_RT340 VGER_REPORT.CMP_REGISTRAR.RT340%TYPE,
    P_REGISTRATION_DATE UCLADB.PATRON.REGISTRATION_DATE%TYPE,
    P_EXPIRE_DATE UCLADB.PATRON.EXPIRE_DATE%TYPE,
    P_PURGE_DATE UCLADB.PATRON.PURGE_DATE%TYPE
  ) 
  RETURN VARCHAR2 AS 
    V_FIRST_NAME UCLADB.PATRON.FIRST_NAME%TYPE;
    V_MIDDLE_NAME UCLADB.PATRON.MIDDLE_NAME%TYPE;
    V_LAST_NAME UCLADB.PATRON.LAST_NAME%TYPE;
    V_NAMES LWS_PATRON.DICT_30_6;
    v_sifr sif_record;
    v_process number := 1;
  BEGIN
    -- Parse out the first, middle, and last names from the name.
    V_NAMES := lws_patron.PARSE_NAME(P_NAME);
    V_FIRST_NAME := V_NAMES('first');
    V_MIDDLE_NAME := V_NAMES('middle');
    V_LAST_NAME := V_NAMES('last');
    -- The barcode is a concatenation of university id and level of issue.
    v_sifr.patron_barcode := P_UNIVERSITY_ID||P_LEVEL_OF_ISSUE;
    -- Calculate the patron group based on parameters.
    v_sifr.patron_group := GET_PATRON_GROUP(P_CAREER, P_CLASS, P_COLL1, P_DEG1, P_DEPT1, P_DIV1, P_RT340);
    -- A new student patron will start out with active status.
    v_sifr.barcode_status := 1;
    v_sifr.registration_date := P_REGISTRATION_DATE;
    v_sifr.expire_date := P_EXPIRE_DATE;
    v_sifr.purge_date := P_PURGE_DATE;
    v_sifr.institution_id := P_UNIVERSITY_ID;
    -- The first statistical category corresponds directly to division.
    v_sifr.statistical_category_1 := P_DIV1;
    -- The second statistical category corresponds to gender coded in this way.
    if P_SEX = 'M' then
      v_sifr.statistical_category_2 := '501';
    elsif P_SEX = 'F' then
      v_sifr.statistical_category_2 := '502';
    end if;
    -- Set the name fields. This is a normal patron, not an institution.
    v_sifr.name_type := '1';
    v_sifr.last_name := V_LAST_NAME;
    v_sifr.first_name := V_FIRST_NAME;
    v_sifr.middle_name := V_MIDDLE_NAME;
  
    -- Set the address fields.
    v_sifr.perm_address_line1 := p_paddr1;
    v_sifr.perm_address_line2 := p_paddr2;
    v_sifr.perm_city := substr(p_pcity, 0, 30);
    v_sifr.perm_state_province := p_pstate;
    v_sifr.perm_zip_postal := p_pzip;
    v_sifr.perm_country := p_pcountry;
    v_sifr.perm_phone_primary := p_pphone;
  
    v_sifr.temp_address_line1 := p_taddr1;
    v_sifr.temp_address_line2 := p_taddr2;
    v_sifr.temp_city := substr(p_tcity, 0, 30);
    v_sifr.temp_state_province := p_tstate;
    v_sifr.temp_zip_postal := p_tzip;
    v_sifr.temp_country := p_tcountry;
    v_sifr.temp_phone_primary := p_tphone;
    v_sifr.temp_expire_date := p_purge_date;
    v_sifr.email_expire_date := p_purge_date;
    -- The Registrar allows 60 character e-mail addresses but Voyager is limited
    -- to 50. Ideally the calling procedure checks this but we'll cut it off 
    -- here if necessary.
    v_sifr.email := substr(p_emailadd, 0, 50);
  
    -- For the case where a patron doesn't have a permanent address or temporary 
    -- address return null.
    if v_sifr.perm_address_line1 is null and v_sifr.temp_address_line1 is null then
      RETURN null;
    -- For the case where a patron doesn't have a permanent address use the 
    -- corresponding fields from the temporary address and return the SIF record.
    elsif v_sifr.perm_address_line1 is null then
      v_sifr.perm_address_line1 := v_sifr.temp_address_line1;
      v_sifr.perm_address_line2 := v_sifr.temp_address_line2;
      v_sifr.perm_city := v_sifr.temp_city;
      v_sifr.perm_state_province := v_sifr.temp_state_province;
      v_sifr.perm_zip_postal := v_sifr.temp_zip_postal;
      v_sifr.perm_country := v_sifr.temp_country;
      v_sifr.perm_phone_primary := v_sifr.temp_phone_primary;
      v_sifr.temp_address_line1 := null;  
      RETURN GET_PATRON_SIF(v_sifr);
    -- For the cases where a patron only has a permanent address or has both perm
    -- and temp addresses.
    else
      RETURN GET_PATRON_SIF(v_sifr);
    end if;
  END;
  
  /*  The NEW_PATRON_SIF_FROM_QDB function takes a set of QDB data fields as 
      input, formats and returns a string representing a SIF record that can be 
      used to create that patron in the Voyager Integrated Library System.
      
      Last revised: 2007-08-13 chunt
  */
  FUNCTION NEW_PATRON_SIF_FROM_QDB(
    P_EMPLOYEE_ID VGER_REPORT.CMP_QDB.EMPLOYEE_ID%TYPE,
    P_LEVEL_OF_ISSUE VGER_REPORT.CMP_BRUINCARD.LEVEL_OF_ISSUE%TYPE,
    P_EMP_FIRST_NAME VGER_REPORT.CMP_QDB.EMP_FIRST_NAME%TYPE,
    P_EMP_MIDDLE_NAME VGER_REPORT.CMP_QDB.EMP_MIDDLE_NAME%TYPE,
    P_EMP_LAST_NAME VGER_REPORT.CMP_QDB.EMP_LAST_NAME%TYPE,
    P_WORK_ADDR_LINE1 VGER_REPORT.CMP_QDB.WORK_ADDR_LINE1%TYPE,
    P_WORK_ADDR_LINE2 VGER_REPORT.CMP_QDB.WORK_ADDR_LINE2%TYPE,
    P_WORK_ADDR_CITY VGER_REPORT.CMP_QDB.WORK_ADDR_CITY%TYPE,
    P_WORK_ADDR_STATE VGER_REPORT.CMP_QDB.WORK_ADDR_STATE%TYPE,
    P_WORK_ADDR_ZIP VGER_REPORT.CMP_QDB.WORK_ADDR_ZIP%TYPE,
    P_CAMPUS_PHONE VGER_REPORT.CMP_QDB.CAMPUS_PHONE%TYPE,
    P_EMAIL_ADDR VGER_REPORT.CMP_QDB.EMAIL_ADDR%TYPE,
    P_TYPE VGER_REPORT.CMP_QDB.TYPE%TYPE,
    P_LAW VGER_REPORT.CMP_QDB.LAW%TYPE,    
    P_REGISTRATION_DATE UCLADB.PATRON.REGISTRATION_DATE%TYPE,
    P_EXPIRE_DATE UCLADB.PATRON.EXPIRE_DATE%TYPE,
    P_PURGE_DATE UCLADB.PATRON.PURGE_DATE%TYPE
  ) 
  RETURN VARCHAR2 AS 
    v_sifr sif_record;
    v_process number := 1;
  BEGIN
    -- The barcode is a concatenation of university id and level of issue.
    v_sifr.patron_barcode := P_EMPLOYEE_ID||P_LEVEL_OF_ISSUE;
    -- Calculate the patron group based on parameters.
    v_sifr.patron_group := GET_PATRON_GROUP2(null, null, P_TYPE, P_LAW);
    -- A new patron will start out with active status.
    v_sifr.barcode_status := 1;
    v_sifr.registration_date := P_REGISTRATION_DATE;
    v_sifr.expire_date := P_EXPIRE_DATE;
    v_sifr.purge_date := P_PURGE_DATE;
    v_sifr.institution_id := P_EMPLOYEE_ID;
    -- Want to add statistical categories for departments eventually.
    --v_sifr.statistical_category_1 := $department;
    -- Set the name fields. This is a normal patron, not an institution.
    v_sifr.name_type := '1';
    v_sifr.last_name := P_EMP_LAST_NAME;
    v_sifr.first_name := substr(P_EMP_FIRST_NAME, 0, 20);
    v_sifr.middle_name := substr(P_EMP_MIDDLE_NAME, 0, 20);
  
    -- Set the address fields.
    v_sifr.perm_address_line1 := P_WORK_ADDR_LINE1;
    v_sifr.perm_address_line2 := P_WORK_ADDR_LINE2;
    v_sifr.perm_city := substr(P_WORK_ADDR_CITY, 0, 30);
    v_sifr.perm_state_province := P_WORK_ADDR_STATE;
    v_sifr.perm_zip_postal := P_WORK_ADDR_ZIP;
    -- No country with QDB data.
    --v_sifr.perm_country := $country;
    v_sifr.perm_phone_primary := P_CAMPUS_PHONE;
  
    v_sifr.email_expire_date := p_purge_date;
    v_sifr.email := P_EMAIL_ADDR;

    -- Address information from QDB has many blanks to don't return null when 
    -- the first line of the address is blank like when creating new patrons 
    -- from Registrar data.  
    RETURN GET_PATRON_SIF(v_sifr);
  END;
  
  /*  The UPDATE_ADDRESS_FROM_REG function takes a set of Voyager patron fields
      and a set of registrar data fields as input, formats and returns a string 
      representing a SIF record that can be used to create or update that patron
      in the Voyager Integrated Library System.
      
      Last revised: 2006-09-06 chunt
  */
  FUNCTION UPDATE_ADDRESS_FROM_REG
  (
    p_institution_id ucladb.patron.institution_id%type,
    p_patron_barcode ucladb.PATRON_BARCODE.PATRON_BARCODE%type,
    p_patron_group ucladb.patron_group.PATRON_GROUP_CODE%type,
    p_barcode_status ucladb.PATRON_BARCODE.BARCODE_STATUS%type,
    p_last_name ucladb.patron.LAST_NAME%type,
    p_first_name ucladb.patron.FIRST_NAME%type,
    p_middle_name ucladb.patron.MIDDLE_NAME%type,
    p_perm_address_line1 ucladb.patron_address.address_line1%type,
    p_perm_address_line2 ucladb.patron_address.address_line2%type,
    p_perm_city ucladb.patron_address.city%type,
    p_perm_state_province ucladb.patron_address.state_province%type,
    p_perm_zip_postal ucladb.patron_address.zip_postal%type,
    p_perm_country ucladb.patron_address.country%type,
    p_perm_phone_primary ucladb.patron_phone.phone_number%type,
    p_perm_phone_mobile ucladb.patron_phone.phone_number%type,
    p_perm_phone_fax ucladb.patron_phone.phone_number%type,
    p_perm_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_address_line1 ucladb.patron_address.address_line1%type,
    p_temp_address_line2 ucladb.patron_address.address_line2%type,
    p_temp_city ucladb.patron_address.city%type,
    p_temp_state_province ucladb.patron_address.state_province%type,
    p_temp_zip_postal ucladb.patron_address.zip_postal%type,
    p_temp_country ucladb.patron_address.country%type,
    p_temp_phone_primary ucladb.patron_phone.phone_number%type,
    p_temp_phone_mobile ucladb.patron_phone.phone_number%type,
    p_temp_phone_fax ucladb.patron_phone.phone_number%type,
    p_temp_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_effect_date ucladb.patron_address.effect_date%type,
    p_temp_expire_date ucladb.patron_address.expire_date%type,
    p_temp_protect_address ucladb.patron_address.protect_address%type,
    p_email ucladb.patron_address.address_line1%type,
    p_email_effect_date ucladb.patron_address.effect_date%type,
    p_email_expire_date ucladb.patron_address.expire_date%type,
    p_paddr1 vger_report.cmp_registrar.paddr1%type,
    p_paddr2 vger_report.cmp_registrar.paddr2%type,
    p_pcity vger_report.cmp_registrar.pcity%type,
    p_pstate vger_report.cmp_registrar.pstate%type,
    p_pzip vger_report.cmp_registrar.pzip%type,
    p_pcountry vger_report.cmp_registrar.pcountry%type,
    P_pphone VGER_REPORT.CMP_REGISTRAR.PPHONE%TYPE,
    p_taddr1 vger_report.cmp_registrar.taddr1%type,
    p_taddr2 vger_report.cmp_registrar.taddr2%type,
    p_tcity vger_report.cmp_registrar.tcity%type,
    p_tstate vger_report.cmp_registrar.tstate%type,
    p_tzip vger_report.cmp_registrar.tzip%type,
    p_tcountry vger_report.cmp_registrar.tcountry%type,
    p_tphone VGER_REPORT.CMP_REGISTRAR.TPHONE%TYPE,
    p_emailadd vger_report.cmp_registrar.emailadd%type,
    p_purge_date ucladb.patron.purge_date%type
  ) 
  RETURN VARCHAR2 AS 
    v_sifr sif_record;
    v_start_time number;
    v_end_time number;
  BEGIN
    -- Set some of the fields of the record.
    v_sifr.patron_barcode := p_patron_barcode;
    v_sifr.patron_group := p_patron_group;
    v_sifr.barcode_status := p_barcode_status;
    v_sifr.institution_id := p_institution_id;
    
    -- The name is not changed but Voyager requires the name in the SIF record.
    -- If it is blanked indicating that it's not changed the existing values 
    -- will padded with spaces. We just set the values to the passed parameters.
    v_sifr.last_name := p_last_name;
    v_sifr.first_name := p_first_name;
    v_sifr.middle_name := p_middle_name;

    -- Initialize the begin date and end date of the type 2 and 3 address fields
    -- to their values from Voyager.
    v_sifr.temp_effect_date := p_temp_effect_date;
    v_sifr.email_effect_date := p_email_effect_date;
    v_sifr.temp_expire_date := p_temp_expire_date;
    v_sifr.email_expire_date := p_email_expire_date;
  
    -- If there's no temporary address or if the temporary address is protected
    -- we want to set the SIF fields order differently than normal.
    if p_temp_address_line1 is null or p_temp_protect_address = 'Y' then
      v_sifr.address_order := 1;
    end if;
  
    -- Check if any of the perm address fields is different. If so, set the 
    -- fields.
    if (
          nvl(p_perm_address_line1, '[null]') <> p_paddr1 and p_paddr1 is not null or 
          nvl(p_perm_address_line2, '[null]') <> p_paddr2 and p_paddr2 is not null or
          nvl(p_perm_city, '[null]') <> substr(p_pcity, 0, 30) and p_pcity is not null or 
          nvl(p_perm_state_province, '[null]') <> p_pstate and p_pstate is not null or
          nvl(p_perm_zip_postal, '[null]') <> p_pzip and p_pzip is not null or
          nvl(p_perm_country, '[null]') <> p_pcountry and p_pcountry is not null or
          nvl(p_perm_phone_primary, '[null]') <> p_pphone and p_pphone is not null
        ) then
      v_sifr.perm_address_line1 := p_paddr1;
      v_sifr.perm_address_line2 := p_paddr2;
      v_sifr.perm_city := substr(p_pcity, 0, 30);
      v_sifr.perm_state_province := p_pstate;
      v_sifr.perm_zip_postal := p_pzip;
      v_sifr.perm_country := p_pcountry;
      v_sifr.perm_phone_primary := p_pphone;
      -- Pass through the other phone fields.
      v_sifr.perm_phone_mobile := p_perm_phone_mobile;
      v_sifr.perm_phone_fax := p_perm_phone_fax;
      v_sifr.perm_phone_other := p_perm_phone_other;
      -- Initialize the temporary and e-mail addresses to their Voyager values.
      -- If these are different from what's provided they'll be changed in the
      -- next block, but Voyager replaces all addresses with those provided in
      -- the SIF record.
      v_sifr.temp_address_line1 := p_temp_address_line1;
      v_sifr.temp_address_line2 := p_temp_address_line2;
      v_sifr.temp_city := p_temp_city;
      v_sifr.temp_state_province := p_temp_state_province;
      v_sifr.temp_zip_postal := p_temp_zip_postal;
      v_sifr.temp_country := p_temp_country;
      v_sifr.temp_phone_primary := p_temp_phone_primary;
      v_sifr.temp_phone_mobile := p_temp_phone_mobile;
      v_sifr.temp_phone_fax := p_temp_phone_fax;
      v_sifr.temp_phone_other := p_temp_phone_other;
      v_sifr.email := p_email;
      
    end if;  
    -- Check if any of the temp address fields or e-mail address is different. If 
    -- so, set the fields. According to Voyager documentation existing temp 
    -- addresses and e-mail addresses will be deleted and replaced so they are 
    -- grouped together in this way.
    -- Also because of a bug in Voyager if there is no temporary address you must
    -- make sure the e-mail address comes before the temporary address and if 
    -- there's no e-mail address you must make sure the temporary e-mail address 
    -- comes before the e-mail address. If this isn't done a duplicate e-mail 
    -- address may be created.
    if (
          nvl(p_temp_address_line1, '[null]') <> p_taddr1 and p_taddr1 is not null or
          nvl(p_temp_address_line2, '[null]') <> p_taddr2 and p_taddr2 is not null or
          nvl(p_temp_city, '[null]') <> substr(p_tcity, 0, 30) and p_tcity is not null or
          nvl(p_temp_state_province, '[null]') <> p_tstate and p_tstate is not null or
          nvl(p_temp_zip_postal, '[null]') <> p_tzip and p_tzip is not null or
          nvl(p_temp_country, '[null]') <> p_tcountry and p_tcountry is not null or
          nvl(p_temp_phone_primary, '[null]') <> p_tphone and p_tphone is not null
        ) or
        (
          nvl(p_email, '[null]') <> p_emailadd and p_emailadd is not null
        ) then
      -- The temporary address may be null. Since Voyager documentation states it
      -- replaces all type 2 and 3 addresses with provided type 2 and 3 addresses
      -- from the SIF record we should use the original values.
      if p_taddr1 is null then
        v_sifr.temp_address_line1 := p_temp_address_line1;
        v_sifr.temp_address_line2 := p_temp_address_line2;
        v_sifr.temp_city := p_temp_city;
        v_sifr.temp_state_province := p_temp_state_province;
        v_sifr.temp_zip_postal := p_temp_zip_postal;
        v_sifr.temp_country := p_temp_country;
        v_sifr.temp_phone_primary := p_temp_phone_primary;
        v_sifr.temp_phone_mobile := p_temp_phone_mobile;
        v_sifr.temp_phone_fax := p_temp_phone_fax;
        v_sifr.temp_phone_other := p_temp_phone_other;
      else
        v_sifr.temp_expire_date := p_purge_date;
        v_sifr.temp_address_line1 := p_taddr1;
        v_sifr.temp_address_line2 := p_taddr2;
        v_sifr.temp_city := substr(p_tcity, 0, 30);
        v_sifr.temp_state_province := p_tstate;
        v_sifr.temp_zip_postal := p_tzip;
        v_sifr.temp_country := p_tcountry;
        v_sifr.temp_phone_primary := p_tphone;
        -- Pass through the other phone fields.
        v_sifr.temp_phone_mobile := p_temp_phone_mobile;
        v_sifr.temp_phone_fax := p_temp_phone_fax;
        v_sifr.temp_phone_other := p_temp_phone_other;
        -- Temp address is changing so set address begin date to run date and 
        -- end date to purge date.
        v_sifr.temp_effect_date := null;
        v_sifr.temp_expire_date := p_purge_date;
      end if;
      -- The e-mail address may be null. Since Voyager documentation states it
      -- replaces all type 2 and 3 addresses with provided type 2 and 3 addresses
      -- from the SIF record we should use the original value.
      if p_emailadd is null then
        v_sifr.email := p_email;
      else
        -- E-mail address is changing so set address begin date to run date and
        -- end date to purge date.
        -- The Registrar allows 60 character e-mail addresses but Voyager is 
        -- limited to 50. Ideally the calling procedure checks this but we'll 
        -- cut it off here if necessary.
        v_sifr.email := substr(p_emailadd, 0, 50);
        v_sifr.email_effect_date := null;
        v_sifr.email_expire_date := p_purge_date;
      end if;
    end if;
    
    RETURN GET_PATRON_SIF(v_sifr);
  END;
  
  /*  The UPDATE_FSEMAIL function takes a set of Voyager patron fields and an 
      e-mail address from campus Faculty and Staff data as input, formats and 
      returns a string representing a SIF record that can be used to update that 
      patron in the Voyager Integrated Library System.
      
      Last revised: 2006-11-14 chunt
  */
  FUNCTION UPDATE_FSEMAIL
  (
    p_institution_id ucladb.patron.institution_id%type,
    p_patron_barcode ucladb.PATRON_BARCODE.PATRON_BARCODE%type,
    p_patron_group ucladb.patron_group.PATRON_GROUP_CODE%type,
    p_barcode_status ucladb.PATRON_BARCODE.BARCODE_STATUS%type,
    p_last_name ucladb.patron.LAST_NAME%type,
    p_first_name ucladb.patron.FIRST_NAME%type,
    p_middle_name ucladb.patron.MIDDLE_NAME%type,
    p_temp_address_line1 ucladb.patron_address.address_line1%type,
    p_temp_address_line2 ucladb.patron_address.address_line2%type,
    p_temp_city ucladb.patron_address.city%type,
    p_temp_state_province ucladb.patron_address.state_province%type,
    p_temp_zip_postal ucladb.patron_address.zip_postal%type,
    p_temp_country ucladb.patron_address.country%type,
    p_temp_phone_primary ucladb.patron_phone.phone_number%type,
    p_temp_phone_mobile ucladb.patron_phone.phone_number%type,
    p_temp_phone_fax ucladb.patron_phone.phone_number%type,
    p_temp_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_effect_date ucladb.patron_address.effect_date%type,
    p_temp_expire_date ucladb.patron_address.expire_date%type,
    p_temp_protect_address ucladb.patron_address.protect_address%type,
    p_email ucladb.patron_address.address_line1%type,
    p_email_effect_date ucladb.patron_address.effect_date%type,
    p_email_expire_date ucladb.patron_address.expire_date%type,
    p_purge_date ucladb.patron.purge_date%type,
    p_fsemail vger_report.CMP_FSEMAIL.EMAIL%type
  ) 
  RETURN VARCHAR2 AS 
    v_sifr sif_record;
  BEGIN
    -- Set some of the fields of the record.
    v_sifr.patron_barcode := p_patron_barcode;
    v_sifr.patron_group := p_patron_group;
    v_sifr.barcode_status := p_barcode_status;
    v_sifr.institution_id := p_institution_id;
    
    -- The name is not changed but Voyager requires the name in the SIF record.
    -- If it is blanked indicating that it's not changed the existing values 
    -- will padded with spaces. We just set the values to the passed parameters.
    v_sifr.last_name := p_last_name;
    v_sifr.first_name := p_first_name;
    v_sifr.middle_name := p_middle_name;

    -- Initialize the begin date and end date of the type 2 and 3 address fields
    -- to their values from Voyager.
    v_sifr.temp_effect_date := p_temp_effect_date;
    v_sifr.email_effect_date := p_email_effect_date;
    v_sifr.temp_expire_date := p_temp_expire_date;
    v_sifr.email_expire_date := p_email_expire_date;
  
    -- If there's no temporary address or if the temporary address is protected
    -- we want to set the SIF fields order differently than normal.
    if p_temp_address_line1 is null or p_temp_protect_address = 'Y' then
      v_sifr.address_order := 1;
    end if;
  
    -- Set the temp address fields. According to Voyager documentation existing 
    -- temp addresses and e-mail addresses will be deleted and replaced so they 
    -- are grouped together in this way even though we are only changing e-mail
    -- address.
    -- Also because of a bug in Voyager if there is no temporary address you must
    -- make sure the e-mail address comes before the temporary address and if 
    -- there's no e-mail address you must make sure the temporary e-mail address 
    -- comes before the e-mail address. If this isn't done a duplicate e-mail 
    -- address may be created.
    v_sifr.temp_address_line1 := p_temp_address_line1;
    v_sifr.temp_address_line2 := p_temp_address_line2;
    v_sifr.temp_city := p_temp_city;
    v_sifr.temp_state_province := p_temp_state_province;
    v_sifr.temp_zip_postal := p_temp_zip_postal;
    v_sifr.temp_country := p_temp_country;
    v_sifr.temp_phone_primary := p_temp_phone_primary;
    v_sifr.temp_phone_mobile := p_temp_phone_mobile;
    v_sifr.temp_phone_fax := p_temp_phone_fax;
    v_sifr.temp_phone_other := p_temp_phone_other;
    -- The e-mail address may be null. Since Voyager documentation states it
    -- replaces all type 2 and 3 addresses with provided type 2 and 3 addresses
    -- from the SIF record we should use the original value.
    if p_fsemail is null or p_fsemail = p_email then
      v_sifr.email := p_email;
    else
      -- E-mail address is changing so set address begin date to run date and
      -- end date to purge date.
      v_sifr.email := p_fsemail;
      v_sifr.email_effect_date := null;
      v_sifr.email_expire_date := p_purge_date;
    end if;
    
    RETURN GET_PATRON_SIF(v_sifr);
  END;
  
  /*  The UPDATE_BARCODE_FROM_BC function takes BruinCard data and Voyager 
      barcode data as input, formats and returns a string representing a SIF 
      record that can be used to create or update that patron's barcode in the 
      Voyager Integrated Library System.
      
      Last revised: 2008-02-27 chunt
  */
  FUNCTION UPDATE_BARCODE_FROM_BC
  (
    p_university_id vger_report.CMP_BRUINCARD.UNIVERSITY_ID%type,
    p_level_of_issue VGER_REPORT.CMP_BRUINCARD.LEVEL_OF_ISSUE%type,
    p_patron_group ucladb.patron_group.PATRON_GROUP_CODE%type,
    p_barcode_status ucladb.PATRON_BARCODE.BARCODE_STATUS%type,
    p_last_name ucladb.patron.LAST_NAME%type,
    p_first_name ucladb.patron.FIRST_NAME%type,
    p_middle_name ucladb.patron.MIDDLE_NAME%type,
    p_perm_address_line1 ucladb.patron_address.address_line1%type,
    p_perm_address_line2 ucladb.patron_address.address_line2%type,
    p_perm_city ucladb.patron_address.city%type,
    p_perm_state_province ucladb.patron_address.state_province%type,
    p_perm_zip_postal ucladb.patron_address.zip_postal%type,
    p_perm_country ucladb.patron_address.country%type,
    p_perm_phone_primary ucladb.patron_phone.phone_number%type,
    p_perm_phone_mobile ucladb.patron_phone.phone_number%type,
    p_perm_phone_fax ucladb.patron_phone.phone_number%type,
    p_perm_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_address_line1 ucladb.patron_address.address_line1%type,
    p_temp_address_line2 ucladb.patron_address.address_line2%type,
    p_temp_city ucladb.patron_address.city%type,
    p_temp_state_province ucladb.patron_address.state_province%type,
    p_temp_zip_postal ucladb.patron_address.zip_postal%type,
    p_temp_country ucladb.patron_address.country%type,
    p_temp_phone_primary ucladb.patron_phone.phone_number%type,
    p_temp_phone_mobile ucladb.patron_phone.phone_number%type,
    p_temp_phone_fax ucladb.patron_phone.phone_number%type,
    p_temp_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_effect_date ucladb.patron_address.effect_date%type,
    p_temp_expire_date ucladb.patron_address.expire_date%type,
    p_temp_protect_address ucladb.patron_address.protect_address%type,
    p_email ucladb.patron_address.address_line1%type,
    p_email_effect_date ucladb.patron_address.effect_date%type,
    p_email_expire_date ucladb.patron_address.expire_date%type
) 
  RETURN VARCHAR2 AS 
    v_sifr sif_record;
  BEGIN
    -- Set some of the fields of the record.
    v_sifr.patron_barcode := p_university_id || p_level_of_issue;
    v_sifr.patron_group := p_patron_group;
    v_sifr.barcode_status := p_barcode_status;
    v_sifr.institution_id := p_university_id;
    
    -- The name is not changed but Voyager requires the name in the SIF record.
    -- If it is blanked indicating that it's not changed the existing values 
    -- will padded with spaces. We just set the values to the passed parameters.
    v_sifr.last_name := p_last_name;
    v_sifr.first_name := p_first_name;
    v_sifr.middle_name := p_middle_name;

    -- If there's no temporary address or if the temporary address is protected
    -- we want to set the SIF fields order differently than normal.
    if p_temp_address_line1 is null or p_temp_protect_address = 'Y' then
      v_sifr.address_order := 1;
    end if;

    -- The address is not changed but Voyager requires at least one address
    -- field in the SIF record and since everyone has to have a permanent 
    -- address we use that. Since we include permanent address we have to
    -- include the type 2/3 addresses, too, or they will be deleted. Here 
    -- we just set the values to the passed parameters.
    v_sifr.perm_address_line1 := p_perm_address_line1;
    v_sifr.perm_address_line2 := p_perm_address_line2;
    v_sifr.perm_city := p_perm_city;
    v_sifr.perm_state_province := p_perm_state_province;
    v_sifr.perm_zip_postal := p_perm_zip_postal;
    v_sifr.perm_country := p_perm_country;
    v_sifr.perm_phone_primary := p_perm_phone_primary;
    v_sifr.perm_phone_mobile := p_perm_phone_mobile;
    v_sifr.perm_phone_fax := p_perm_phone_fax;
    v_sifr.perm_phone_other := p_perm_phone_other;
    v_sifr.temp_address_line1 := p_temp_address_line1;
    v_sifr.temp_address_line2 := p_temp_address_line2;
    v_sifr.temp_city := p_temp_city;
    v_sifr.temp_state_province := p_temp_state_province;
    v_sifr.temp_zip_postal := p_temp_zip_postal;
    v_sifr.temp_country := p_temp_country;
    v_sifr.temp_phone_primary := p_temp_phone_primary;
    v_sifr.temp_phone_mobile := p_temp_phone_mobile;
    v_sifr.temp_phone_fax := p_temp_phone_fax;
    v_sifr.temp_phone_other := p_temp_phone_other;
    v_sifr.temp_effect_date := p_temp_effect_date;
    v_sifr.temp_expire_date := p_temp_expire_date;
    v_sifr.email := p_email;
    v_sifr.email_effect_date := p_email_effect_date;
    v_sifr.email_expire_date := p_email_expire_date;
  
    RETURN GET_PATRON_SIF(v_sifr);
  END;
  
  /*  The UPDATE_EXPIRATION function an expiration date and Voyager 
      barcode data as input, formats and returns a string representing a SIF 
      record that can be used to create or update that patron's barcode in the 
      Voyager Integrated Library System.
      
      Last revised: 2008-02-27 chunt
  */
  FUNCTION UPDATE_EXPIRATION
  (
    p_institution_id ucladb.patron.institution_id%type,
    p_patron_barcode ucladb.PATRON_BARCODE.PATRON_BARCODE%type,
    p_patron_group ucladb.patron_group.PATRON_GROUP_CODE%type,
    p_barcode_status ucladb.PATRON_BARCODE.BARCODE_STATUS%type,
    p_last_name ucladb.patron.LAST_NAME%type,
    p_first_name ucladb.patron.FIRST_NAME%type,
    p_middle_name ucladb.patron.MIDDLE_NAME%type,
    p_perm_address_line1 ucladb.patron_address.address_line1%type,
    p_perm_address_line2 ucladb.patron_address.address_line2%type,
    p_perm_city ucladb.patron_address.city%type,
    p_perm_state_province ucladb.patron_address.state_province%type,
    p_perm_zip_postal ucladb.patron_address.zip_postal%type,
    p_perm_country ucladb.patron_address.country%type,
    p_perm_phone_primary ucladb.patron_phone.phone_number%type,
    p_perm_phone_mobile ucladb.patron_phone.phone_number%type,
    p_perm_phone_fax ucladb.patron_phone.phone_number%type,
    p_perm_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_address_line1 ucladb.patron_address.address_line1%type,
    p_temp_address_line2 ucladb.patron_address.address_line2%type,
    p_temp_city ucladb.patron_address.city%type,
    p_temp_state_province ucladb.patron_address.state_province%type,
    p_temp_zip_postal ucladb.patron_address.zip_postal%type,
    p_temp_country ucladb.patron_address.country%type,
    p_temp_phone_primary ucladb.patron_phone.phone_number%type,
    p_temp_phone_mobile ucladb.patron_phone.phone_number%type,
    p_temp_phone_fax ucladb.patron_phone.phone_number%type,
    p_temp_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_effect_date ucladb.patron_address.effect_date%type,
    p_temp_expire_date ucladb.patron_address.expire_date%type,
    p_temp_protect_address ucladb.patron_address.protect_address%type,
    p_email ucladb.patron_address.address_line1%type,
    p_email_effect_date ucladb.patron_address.effect_date%type,
    p_email_expire_date ucladb.patron_address.expire_date%type,
    p_expire_date ucladb.patron.expire_date%type
  ) 
  RETURN VARCHAR2 AS 
    v_sifr sif_record;
  BEGIN
    -- Set some of the fields of the record.
    v_sifr.patron_barcode := p_patron_barcode;
    v_sifr.patron_group := p_patron_group;
    v_sifr.barcode_status := p_barcode_status;
    v_sifr.institution_id := p_institution_id;
    v_sifr.expire_date := p_expire_date;
    
    -- The name is not changed but Voyager requires the name in the SIF record.
    -- If it is blanked indicating that it's not changed the existing values 
    -- will padded with spaces. We just set the values to the passed parameters.
    v_sifr.last_name := p_last_name;
    v_sifr.first_name := p_first_name;
    v_sifr.middle_name := p_middle_name;

    -- If there's no temporary address or if the temporary address is protected
    -- we want to set the SIF fields order differently than normal.
    if p_temp_address_line1 is null or p_temp_protect_address = 'Y' then
      v_sifr.address_order := 1;
    end if;

    -- The address is not changed but Voyager requires at least one address
    -- field in the SIF record and since everyone has to have a permanent 
    -- address we use that. Since we include permanent address we have to
    -- include the type 2/3 addresses, too, or they will be deleted. Here 
    -- we just set the values to the passed parameters.
    v_sifr.perm_address_line1 := p_perm_address_line1;
    v_sifr.perm_address_line2 := p_perm_address_line2;
    v_sifr.perm_city := p_perm_city;
    v_sifr.perm_state_province := p_perm_state_province;
    v_sifr.perm_zip_postal := p_perm_zip_postal;
    v_sifr.perm_country := p_perm_country;
    v_sifr.perm_phone_primary := p_perm_phone_primary;
    v_sifr.perm_phone_mobile := p_perm_phone_mobile;
    v_sifr.perm_phone_fax := p_perm_phone_fax;
    v_sifr.perm_phone_other := p_perm_phone_other;
    v_sifr.temp_address_line1 := p_temp_address_line1;
    v_sifr.temp_address_line2 := p_temp_address_line2;
    v_sifr.temp_city := p_temp_city;
    v_sifr.temp_state_province := p_temp_state_province;
    v_sifr.temp_zip_postal := p_temp_zip_postal;
    v_sifr.temp_country := p_temp_country;
    v_sifr.temp_phone_primary := p_temp_phone_primary;
    v_sifr.temp_phone_mobile := p_temp_phone_mobile;
    v_sifr.temp_phone_fax := p_temp_phone_fax;
    v_sifr.temp_phone_other := p_temp_phone_other;
    v_sifr.temp_effect_date := p_temp_effect_date;
    v_sifr.temp_expire_date := p_temp_expire_date;
    v_sifr.email := p_email;
    v_sifr.email_effect_date := p_email_effect_date;
    v_sifr.email_expire_date := p_email_expire_date;
  
    RETURN GET_PATRON_SIF(v_sifr);
  END;
  
  /*  The UPDATE_GROUP function takes a group calculated from Registrar data and 
      Voyager barcode data as input, formats and returns a string representing a 
      SIF record that can be used to update that patron's group in the Voyager 
      Integrated Library System.
      
      Last revised: 2008-02-27 chunt
  */
  FUNCTION UPDATE_GROUP
  (
    p_institution_id ucladb.patron.institution_id%type,
    p_patron_barcode ucladb.PATRON_BARCODE.PATRON_BARCODE%type,
    p_patron_group ucladb.patron_group.PATRON_GROUP_CODE%type,
    p_barcode_status ucladb.PATRON_BARCODE.BARCODE_STATUS%type,
    p_patron_barcode2 ucladb.PATRON_BARCODE.PATRON_BARCODE%type,
    p_patron_group2 ucladb.patron_group.PATRON_GROUP_CODE%type,
    p_barcode_status2 ucladb.PATRON_BARCODE.BARCODE_STATUS%type,
    p_last_name ucladb.patron.LAST_NAME%type,
    p_first_name ucladb.patron.FIRST_NAME%type,
    p_middle_name ucladb.patron.MIDDLE_NAME%type,
    p_perm_address_line1 ucladb.patron_address.address_line1%type,
    p_perm_address_line2 ucladb.patron_address.address_line2%type,
    p_perm_city ucladb.patron_address.city%type,
    p_perm_state_province ucladb.patron_address.state_province%type,
    p_perm_zip_postal ucladb.patron_address.zip_postal%type,
    p_perm_country ucladb.patron_address.country%type,
    p_perm_phone_primary ucladb.patron_phone.phone_number%type,
    p_perm_phone_mobile ucladb.patron_phone.phone_number%type,
    p_perm_phone_fax ucladb.patron_phone.phone_number%type,
    p_perm_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_address_line1 ucladb.patron_address.address_line1%type,
    p_temp_address_line2 ucladb.patron_address.address_line2%type,
    p_temp_city ucladb.patron_address.city%type,
    p_temp_state_province ucladb.patron_address.state_province%type,
    p_temp_zip_postal ucladb.patron_address.zip_postal%type,
    p_temp_country ucladb.patron_address.country%type,
    p_temp_phone_primary ucladb.patron_phone.phone_number%type,
    p_temp_phone_mobile ucladb.patron_phone.phone_number%type,
    p_temp_phone_fax ucladb.patron_phone.phone_number%type,
    p_temp_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_effect_date ucladb.patron_address.effect_date%type,
    p_temp_expire_date ucladb.patron_address.expire_date%type,
    p_temp_protect_address ucladb.patron_address.protect_address%type,
    p_email ucladb.patron_address.address_line1%type,
    p_email_effect_date ucladb.patron_address.effect_date%type,
    p_email_expire_date ucladb.patron_address.expire_date%type
  ) 
  RETURN VARCHAR2 AS 
    v_sifr sif_record;
  BEGIN
    -- Set some of the fields of the record.
    v_sifr.patron_barcode := p_patron_barcode;
    v_sifr.patron_group := p_patron_group;
    v_sifr.barcode_status := p_barcode_status;
    v_sifr.patron_barcode2 := p_patron_barcode2;
    v_sifr.patron_group2 := p_patron_group2;
    v_sifr.barcode_status2 := p_barcode_status2;
    v_sifr.institution_id := p_institution_id;
    
    -- The name is not changed but Voyager requires the name in the SIF record.
    -- If it is blanked indicating that it's not changed the existing values 
    -- will padded with spaces. We just set the values to the passed parameters.
    v_sifr.last_name := p_last_name;
    v_sifr.first_name := p_first_name;
    v_sifr.middle_name := p_middle_name;

    -- If there's no temporary address or if the temporary address is protected
    -- we want to set the SIF fields order differently than normal.
    if p_temp_address_line1 is null or p_temp_protect_address = 'Y' then
      v_sifr.address_order := 1;
    end if;

    -- The address is not changed but Voyager requires at least one address
    -- field in the SIF record and since everyone has to have a permanent 
    -- address we use that. Since we include permanent address we have to
    -- include the type 2/3 addresses, too, or they will be deleted. Here 
    -- we just set the values to the passed parameters.
    v_sifr.perm_address_line1 := p_perm_address_line1;
    v_sifr.perm_address_line2 := p_perm_address_line2;
    v_sifr.perm_city := p_perm_city;
    v_sifr.perm_state_province := p_perm_state_province;
    v_sifr.perm_zip_postal := p_perm_zip_postal;
    v_sifr.perm_country := p_perm_country;
    v_sifr.perm_phone_primary := p_perm_phone_primary;
    v_sifr.perm_phone_mobile := p_perm_phone_mobile;
    v_sifr.perm_phone_fax := p_perm_phone_fax;
    v_sifr.perm_phone_other := p_perm_phone_other;
    v_sifr.temp_address_line1 := p_temp_address_line1;
    v_sifr.temp_address_line2 := p_temp_address_line2;
    v_sifr.temp_city := p_temp_city;
    v_sifr.temp_state_province := p_temp_state_province;
    v_sifr.temp_zip_postal := p_temp_zip_postal;
    v_sifr.temp_country := p_temp_country;
    v_sifr.temp_phone_primary := p_temp_phone_primary;
    v_sifr.temp_phone_mobile := p_temp_phone_mobile;
    v_sifr.temp_phone_fax := p_temp_phone_fax;
    v_sifr.temp_phone_other := p_temp_phone_other;
    v_sifr.temp_effect_date := p_temp_effect_date;
    v_sifr.temp_expire_date := p_temp_expire_date;
    v_sifr.email := p_email;
    v_sifr.email_effect_date := p_email_effect_date;
    v_sifr.email_expire_date := p_email_expire_date;
  
    RETURN GET_PATRON_SIF(v_sifr);
  END;

  /*  The UPDATE_GROUP_AND_EXPIRATION function takes a group calculated from 
      Registrar data, an expiration date, and Voyager barcode data as input, 
      formats and returns a string representing a SIF record that can be used to 
      update that patron's group in the Voyager Integrated Library System.
      
      Last revised: 2008-02-27 chunt
  */
  FUNCTION UPDATE_GROUP_AND_EXPIRATION
  (
    p_institution_id ucladb.patron.institution_id%type,
    p_patron_barcode ucladb.PATRON_BARCODE.PATRON_BARCODE%type,
    p_patron_group ucladb.patron_group.PATRON_GROUP_CODE%type,
    p_barcode_status ucladb.PATRON_BARCODE.BARCODE_STATUS%type,
    p_patron_barcode2 ucladb.PATRON_BARCODE.PATRON_BARCODE%type,
    p_patron_group2 ucladb.patron_group.PATRON_GROUP_CODE%type,
    p_barcode_status2 ucladb.PATRON_BARCODE.BARCODE_STATUS%type,
    p_last_name ucladb.patron.LAST_NAME%type,
    p_first_name ucladb.patron.FIRST_NAME%type,
    p_middle_name ucladb.patron.MIDDLE_NAME%type,
    p_perm_address_line1 ucladb.patron_address.address_line1%type,
    p_perm_address_line2 ucladb.patron_address.address_line2%type,
    p_perm_city ucladb.patron_address.city%type,
    p_perm_state_province ucladb.patron_address.state_province%type,
    p_perm_zip_postal ucladb.patron_address.zip_postal%type,
    p_perm_country ucladb.patron_address.country%type,
    p_perm_phone_primary ucladb.patron_phone.phone_number%type,
    p_perm_phone_mobile ucladb.patron_phone.phone_number%type,
    p_perm_phone_fax ucladb.patron_phone.phone_number%type,
    p_perm_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_address_line1 ucladb.patron_address.address_line1%type,
    p_temp_address_line2 ucladb.patron_address.address_line2%type,
    p_temp_city ucladb.patron_address.city%type,
    p_temp_state_province ucladb.patron_address.state_province%type,
    p_temp_zip_postal ucladb.patron_address.zip_postal%type,
    p_temp_country ucladb.patron_address.country%type,
    p_temp_phone_primary ucladb.patron_phone.phone_number%type,
    p_temp_phone_mobile ucladb.patron_phone.phone_number%type,
    p_temp_phone_fax ucladb.patron_phone.phone_number%type,
    p_temp_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_effect_date ucladb.patron_address.effect_date%type,
    p_temp_expire_date ucladb.patron_address.expire_date%type,
    p_temp_protect_address ucladb.patron_address.protect_address%type,
    p_email ucladb.patron_address.address_line1%type,
    p_email_effect_date ucladb.patron_address.effect_date%type,
    p_email_expire_date ucladb.patron_address.expire_date%type,
    p_expire_date ucladb.patron.expire_date%type
  ) 
  RETURN VARCHAR2 AS 
    v_sifr sif_record;
  BEGIN
    -- Set some of the fields of the record.
    v_sifr.patron_barcode := p_patron_barcode;
    v_sifr.patron_group := p_patron_group;
    v_sifr.barcode_status := p_barcode_status;
    v_sifr.patron_barcode2 := p_patron_barcode2;
    v_sifr.patron_group2 := p_patron_group2;
    v_sifr.barcode_status2 := p_barcode_status2;
    v_sifr.institution_id := p_institution_id;
    v_sifr.expire_date := p_expire_date;
    
    -- The name is not changed but Voyager requires the name in the SIF record.
    -- If it is blanked indicating that it's not changed the existing values 
    -- will padded with spaces. We just set the values to the passed parameters.
    v_sifr.last_name := p_last_name;
    v_sifr.first_name := p_first_name;
    v_sifr.middle_name := p_middle_name;

    -- If there's no temporary address or if the temporary address is protected
    -- we want to set the SIF fields order differently than normal.
    if p_temp_address_line1 is null or p_temp_protect_address = 'Y' then
      v_sifr.address_order := 1;
    end if;

    -- The address is not changed but Voyager requires at least one address
    -- field in the SIF record and since everyone has to have a permanent 
    -- address we use that. Since we include permanent address we have to
    -- include the type 2/3 addresses, too, or they will be deleted. Here 
    -- we just set the values to the passed parameters.
    v_sifr.perm_address_line1 := p_perm_address_line1;
    v_sifr.perm_address_line2 := p_perm_address_line2;
    v_sifr.perm_city := p_perm_city;
    v_sifr.perm_state_province := p_perm_state_province;
    v_sifr.perm_zip_postal := p_perm_zip_postal;
    v_sifr.perm_country := p_perm_country;
    v_sifr.perm_phone_primary := p_perm_phone_primary;
    v_sifr.perm_phone_mobile := p_perm_phone_mobile;
    v_sifr.perm_phone_fax := p_perm_phone_fax;
    v_sifr.perm_phone_other := p_perm_phone_other;
    v_sifr.temp_address_line1 := p_temp_address_line1;
    v_sifr.temp_address_line2 := p_temp_address_line2;
    v_sifr.temp_city := p_temp_city;
    v_sifr.temp_state_province := p_temp_state_province;
    v_sifr.temp_zip_postal := p_temp_zip_postal;
    v_sifr.temp_country := p_temp_country;
    v_sifr.temp_phone_primary := p_temp_phone_primary;
    v_sifr.temp_phone_mobile := p_temp_phone_mobile;
    v_sifr.temp_phone_fax := p_temp_phone_fax;
    v_sifr.temp_phone_other := p_temp_phone_other;
    v_sifr.temp_effect_date := p_temp_effect_date;
    v_sifr.temp_expire_date := p_temp_expire_date;
    v_sifr.email := p_email;
    v_sifr.email_effect_date := p_email_effect_date;
    v_sifr.email_expire_date := p_email_expire_date;
  
    RETURN GET_PATRON_SIF(v_sifr);
  END;

  /*  The PARSE_NAME function takes the name field form the registrar data as 
      input, parses out first, middle, last names and returns them.
      
      Last revised: 2006-08-24 chunt
  */
  FUNCTION PARSE_NAME
  (
    p_name vger_report.cmp_registrar.name%TYPE
  ) 
  RETURN DICT_30_6 AS 
    v_names DICT_30_6;
  BEGIN
    -- The LWS_UTILITY.FIRST and LWS_UTILITY.REST functions split a string by 
    -- a delimiter defaulting to ", " and returns either the part before the 
    -- delimeter (FIRST) or the part after the delimiter (REST).
    -- The following code block processes the registrar's NAME field and 
    -- calculates a student's first name, middle name, and last name from it.
    -- For this first case, the student does not have a suffix like ", JR".
    IF LWS_UTILITY.FIRST(LWS_UTILITY.REST(P_NAME)) = LWS_UTILITY.REST(P_NAME) THEN
      -- The first name is the part between the first "," and the space character.
      v_names('first') := substr(LWS_UTILITY.FIRST(LWS_UTILITY.REST(P_NAME), ' '), 0, 20);
      -- The middle name is what follows the first name.
      v_names('middle') := substr(LWS_UTILITY.REST(LWS_UTILITY.REST(P_NAME), ' '), 0, 20);
      -- The last name is the part before the first ",".
      v_names('last') := substr(LWS_UTILITY.FIRST(P_NAME), 0, 30);
    -- For this first case, the student has a suffix like ", JR".
    ELSE
      -- The first name is the part between the first "," and the space character.
      v_names('first') := substr(LWS_UTILITY.FIRST(LWS_UTILITY.FIRST(LWS_UTILITY.REST(P_NAME)), ' '), 0, 20);
      -- The middle name is what follows the first name before the comma and suffix.
      v_names('middle') := substr(LWS_UTILITY.REST(LWS_UTILITY.FIRST(LWS_UTILITY.REST(P_NAME)), ' '), 0, 20);
      -- The last name is the part before the first ",".
      v_names('last') := substr(LWS_UTILITY.FIRST(P_NAME) ||' '||LWS_UTILITY.REST(LWS_UTILITY.REST(P_NAME)), 0, 30);
    END IF;
    RETURN v_names;
  END;
  
  /*  The FIRST_NAME function takes the name field form the registrar data as 
      input, parses out first name and returns it. This is to be used in SQL
      queries where handling the collection object returned from PARSE_NAME
      would be problematic.
      
      Last revised: 2006-08-24 chunt
  */
  FUNCTION FIRST_NAME
  (
    p_name vger_report.cmp_registrar.name%TYPE
  ) 
  RETURN ucladb.patron.FIRST_NAME%TYPE AS 
    V_NAMES LWS_PATRON.DICT_30_6;
    V_FIRST_NAME ucladb.patron.FIRST_NAME%TYPE;
  BEGIN
    -- Simply call PARSE_NAME and return the appropriate element.
    V_NAMES := lws_patron.PARSE_NAME(P_NAME);
    V_FIRST_NAME := V_NAMES('first');
    RETURN V_FIRST_NAME;
  END;
  
  /*  The MIDDLE_NAME function takes the name field form the registrar data as 
      input, parses out middle name and returns it. This is to be used in SQL
      queries where handling the collection object returned from PARSE_NAME
      would be problematic.
      
      Last revised: 2006-08-24 chunt
  */
  FUNCTION MIDDLE_NAME
  (
    p_name vger_report.cmp_registrar.name%TYPE
  ) 
  RETURN ucladb.patron.MIDDLE_NAME%TYPE AS 
    V_NAMES LWS_PATRON.DICT_30_6;
    V_MIDDLE_NAME ucladb.patron.MIDDLE_NAME%TYPE;
  BEGIN
    -- Simply call PARSE_NAME and return the appropriate element.
    V_NAMES := lws_patron.PARSE_NAME(P_NAME);
    V_MIDDLE_NAME := V_NAMES('middle');
    RETURN V_MIDDLE_NAME;
  END;
  
  /*  The LAST_NAME function takes the name field form the registrar data as 
      input, parses out last name and returns it. This is to be used in SQL
      queries where handling the collection object returned from PARSE_NAME
      would be problematic.
      
      Last revised: 2006-08-24 chunt
  */
  FUNCTION LAST_NAME
  (
    p_name vger_report.cmp_registrar.name%TYPE
  ) 
  RETURN ucladb.patron.LAST_NAME%TYPE AS 
    V_NAMES LWS_PATRON.DICT_30_6;
    V_LAST_NAME ucladb.patron.LAST_NAME%TYPE;
  BEGIN
    -- Simply call PARSE_NAME and return the appropriate element.
    V_NAMES := lws_patron.PARSE_NAME(P_NAME);
    V_LAST_NAME := V_NAMES('last');
    RETURN V_LAST_NAME;
  END;
  
  /*  The GET_PATRON_SIF_CODE function takes three parameters, the first line each
      of permanent, temporary, and e-mail address records, and returns the patron
      sif code based on which of those fields have changed according to this 
      table:
      3.	perm address change
      4.	temp address change
      5.	e-mail address change
      6.	perm and temp address change
      7.	perm and e-mail address change
      8.	temp and e-mail address change
      9.	perm, temp, and e-mail address change
      10. perm, temp, and e-mail address not changed
      
      Last revised: 2006-08-29 chunt
  */
  FUNCTION GET_PATRON_SIF_CODE
  (
    p_perm_address_line1 ucladb.patron_address.address_line1%type,
    p_perm_address_line2 ucladb.patron_address.address_line2%type,
    p_perm_city ucladb.patron_address.city%type,
    p_perm_state_province ucladb.patron_address.state_province%type,
    p_perm_zip_postal ucladb.patron_address.zip_postal%type,
    p_perm_country ucladb.patron_address.country%type,
    p_perm_phone_primary ucladb.patron_phone.phone_number%type,
    p_temp_address_line1 ucladb.patron_address.address_line1%type,
    p_temp_address_line2 ucladb.patron_address.address_line2%type,
    p_temp_city ucladb.patron_address.city%type,
    p_temp_state_province ucladb.patron_address.state_province%type,
    p_temp_zip_postal ucladb.patron_address.zip_postal%type,
    p_temp_country ucladb.patron_address.country%type,
    p_temp_phone_primary ucladb.patron_phone.phone_number%type,
    p_email ucladb.patron_address.address_line1%type,
    p_paddr1 vger_report.cmp_registrar.paddr1%type,
    p_paddr2 vger_report.cmp_registrar.paddr2%type,
    p_pcity vger_report.cmp_registrar.pcity%type,
    p_pstate vger_report.cmp_registrar.pstate%type,
    p_pzip vger_report.cmp_registrar.pzip%type,
    p_pcountry vger_report.cmp_registrar.pcountry%type,
    P_pphone VGER_REPORT.CMP_REGISTRAR.PPHONE%TYPE,
    p_taddr1 vger_report.cmp_registrar.taddr1%type,
    p_taddr2 vger_report.cmp_registrar.taddr2%type,
    p_tcity vger_report.cmp_registrar.tcity%type,
    p_tstate vger_report.cmp_registrar.tstate%type,
    p_tzip vger_report.cmp_registrar.tzip%type,
    p_tcountry vger_report.cmp_registrar.tcountry%type,
    p_tphone VGER_REPORT.CMP_REGISTRAR.TPHONE%TYPE,
    p_emailadd vger_report.cmp_registrar.emailadd%type
  ) 
  RETURN NUMBER AS 
    v_code number;
    v_perm_change boolean := false;
    v_temp_change boolean := false;
    v_email_change boolean := false;
  BEGIN
    -- The permanent address field has changed.
    if (
          nvl(p_perm_address_line1, '[null]') <> p_paddr1 or 
          nvl(p_perm_address_line2, '[null]') <> p_paddr2 or
          nvl(p_perm_city, '[null]') <> substr(p_pcity, 0, 30) or 
          nvl(p_perm_state_province, '[null]') <> p_pstate or
          nvl(p_perm_zip_postal, '[null]') <> p_pzip or
          nvl(p_perm_country, '[null]') <> p_pcountry or
          nvl(p_perm_phone_primary, '[null]') <> p_pphone
        ) and p_paddr1 is not null then
      v_perm_change := true;
    end if;
    -- The temporary address field has changed.
    if (
        nvl(p_temp_address_line1, '[null]') <> p_taddr1 or
        nvl(p_temp_address_line2, '[null]') <> p_taddr2 or
        nvl(p_temp_city, '[null]') <> substr(p_tcity, 0, 30) or
        nvl(p_temp_state_province, '[null]') <> p_tstate or
        nvl(p_temp_zip_postal, '[null]') <> p_tzip or
        nvl(p_temp_country, '[null]') <> p_tcountry or
        nvl(p_temp_phone_primary, '[null]') <> p_tphone
        ) and p_taddr1 is not null then
      v_temp_change := true;
    end if;
    -- The e-mail address field has changed.
    if nvl(p_email, '[null]') <> p_emailadd and p_emailadd is not null then
      v_email_change := true;
    end if;
    --nvl(p_email, '[null]') <> p_emailadd
  
    -- Assign the codes according to which address fields have changed.
    if v_perm_change and v_temp_change and v_email_change then
      v_code := 9;
    elsif v_perm_change and v_temp_change and not v_email_change then
      v_code := 6;
    elsif v_perm_change and not v_temp_change and v_email_change then
      v_code := 7;
    elsif v_perm_change and not v_temp_change and not v_email_change then
      v_code := 3;
    elsif not v_perm_change and v_temp_change and v_email_change then
      v_code := 8;
    elsif not v_perm_change and v_temp_change and not v_email_change then
      v_code := 4;
    elsif not v_perm_change and not v_temp_change and v_email_change then
      v_code := 5;
    elsif not v_perm_change and not v_temp_change and not v_email_change then
      v_code := 10;
    end if;
    RETURN v_code;
  END;
  
  /*  The GET_STAT_CATS function takes optional gender and divisional 
      statistical categories as input, combines them with a patron's other 
      statistical categories and returns the concatenated string.
      
      Last revised: 2006-10-02 chunt
  */
  FUNCTION GET_STAT_CATS(
    p_patron_id ucladb.patron.PATRON_ID%type,
    p_sex VGER_REPORT.CMP_REGISTRAR.SEX%TYPE := null,
    p_div1 VGER_REPORT.CMP_REGISTRAR.DIV1%TYPE := null
  ) 
  RETURN VARCHAR2 AS 
    v_stat_cats VARCHAR2(30);
  BEGIN
    WITH patron_gender_div AS
    (
            SELECT
                    ps.patron_id
            ,	ps.patron_stat_id
            ,	psc.patron_stat_code
            ,	pscm.type
            FROM ucladb.patron_stats ps
            INNER JOIN ucladb.patron_stat_code psc
                    ON ps.patron_stat_id = psc.patron_stat_id
            INNER JOIN vger_support.patron_stat_components pscm
                    ON psc.patron_stat_id = pscm.patron_stat_id
            WHERE ps.patron_id = p_patron_id
    ),
    patron_other_stat_info AS
    (
            SELECT
                    ps.patron_id
            ,	ps.patron_stat_id
            ,	psc.patron_stat_code
            ,       row_number() over (partition by ps.patron_id order by ps.patron_id) sc_order
            FROM ucladb.patron_stats ps
            INNER JOIN ucladb.patron_stat_code psc
                    ON ps.patron_stat_id = psc.patron_stat_id
            WHERE ps.patron_id = p_patron_id
            and NOT EXISTS
            (
              select * from vger_support.patron_stat_components pscm where psc.patron_stat_id = pscm.patron_stat_id
            )
    )
    SELECT
    decode(p_sex, 'M', '501', 'F', '502', null, rpad(NVL((SELECT patron_stat_code FROM patron_gender_div WHERE patron_id = p.patron_id AND TYPE = 1), ' '),   3,   ' ')) ||
    decode(p_div1, null, rpad(NVL((SELECT patron_stat_code FROM patron_gender_div WHERE patron_id = p.patron_id AND TYPE = 2), ' '),   3,   ' '), rpad(p_div1,   3,   ' ')) ||
    rpad(NVL((SELECT patron_stat_code FROM patron_other_stat_info WHERE patron_id = p.patron_id AND sc_order = 1), ' '),   3,   ' ') ||
    rpad(NVL((SELECT patron_stat_code FROM patron_other_stat_info WHERE patron_id = p.patron_id AND sc_order = 2), ' '),   3,   ' ') ||
    rpad(NVL((SELECT patron_stat_code FROM patron_other_stat_info WHERE patron_id = p.patron_id AND sc_order = 3), ' '),   3,   ' ') ||
    rpad(NVL((SELECT patron_stat_code FROM patron_other_stat_info WHERE patron_id = p.patron_id AND sc_order = 4), ' '),   3,   ' ') ||
    rpad(NVL((SELECT patron_stat_code FROM patron_other_stat_info WHERE patron_id = p.patron_id AND sc_order = 5), ' '),   3,   ' ') ||
    rpad(NVL((SELECT patron_stat_code FROM patron_other_stat_info WHERE patron_id = p.patron_id AND sc_order = 6), ' '),   3,   ' ') ||
    rpad(NVL((SELECT patron_stat_code FROM patron_other_stat_info WHERE patron_id = p.patron_id AND sc_order = 7), ' '),   3,   ' ') ||
    rpad(NVL((SELECT patron_stat_code FROM patron_other_stat_info WHERE patron_id = p.patron_id AND sc_order = 8), ' '),   3,   ' ')
    into v_stat_cats FROM ucladb.patron p 
    where p.patron_id = p_patron_id;

    RETURN v_stat_cats;
  END;
  
  /*  The UPDATE_STAT_CATS function takes Voyager barcode data and the combined
      string of statistical categories as input, formats and returns a string 
      representing a SIF record that can be used to create or update that 
      patron's statistical categories in the Voyager Integrated Library System.
      
      Last revised: 2008-02-27 chunt
  */
  FUNCTION UPDATE_STAT_CATS
  (
    p_institution_id ucladb.patron.institution_id%type,
    p_patron_barcode ucladb.PATRON_BARCODE.PATRON_BARCODE%type,
    p_patron_group ucladb.patron_group.PATRON_GROUP_CODE%type,
    p_barcode_status ucladb.PATRON_BARCODE.BARCODE_STATUS%type,
    p_last_name ucladb.patron.LAST_NAME%type,
    p_first_name ucladb.patron.FIRST_NAME%type,
    p_middle_name ucladb.patron.MIDDLE_NAME%type,
    p_perm_address_line1 ucladb.patron_address.address_line1%type,
    p_perm_address_line2 ucladb.patron_address.address_line2%type,
    p_perm_city ucladb.patron_address.city%type,
    p_perm_state_province ucladb.patron_address.state_province%type,
    p_perm_zip_postal ucladb.patron_address.zip_postal%type,
    p_perm_country ucladb.patron_address.country%type,
    p_perm_phone_primary ucladb.patron_phone.phone_number%type,
    p_perm_phone_mobile ucladb.patron_phone.phone_number%type,
    p_perm_phone_fax ucladb.patron_phone.phone_number%type,
    p_perm_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_address_line1 ucladb.patron_address.address_line1%type,
    p_temp_address_line2 ucladb.patron_address.address_line2%type,
    p_temp_city ucladb.patron_address.city%type,
    p_temp_state_province ucladb.patron_address.state_province%type,
    p_temp_zip_postal ucladb.patron_address.zip_postal%type,
    p_temp_country ucladb.patron_address.country%type,
    p_temp_phone_primary ucladb.patron_phone.phone_number%type,
    p_temp_phone_mobile ucladb.patron_phone.phone_number%type,
    p_temp_phone_fax ucladb.patron_phone.phone_number%type,
    p_temp_phone_other ucladb.patron_phone.phone_number%type,
    p_temp_effect_date ucladb.patron_address.effect_date%type,
    p_temp_expire_date ucladb.patron_address.expire_date%type,
    p_temp_protect_address ucladb.patron_address.protect_address%type,
    p_email ucladb.patron_address.address_line1%type,
    p_email_effect_date ucladb.patron_address.effect_date%type,
    p_email_expire_date ucladb.patron_address.expire_date%type,
    p_stat_cats VARCHAR2
  ) 
  RETURN VARCHAR2 AS 
    v_sifr sif_record;
  BEGIN
    -- Set some of the fields of the record.
    v_sifr.patron_barcode := p_patron_barcode;
    v_sifr.patron_group := p_patron_group;
    v_sifr.barcode_status := p_barcode_status;
    v_sifr.institution_id := p_institution_id;
    
    -- The name is not changed but Voyager requires the name in the SIF record.
    -- If it is blanked indicating that it's not changed the existing values 
    -- will padded with spaces. We just set the values to the passed parameters.
    v_sifr.last_name := p_last_name;
    v_sifr.first_name := p_first_name;
    v_sifr.middle_name := p_middle_name;

    -- If there's no temporary address or if the temporary address is protected
    -- we want to set the SIF fields order differently than normal.
    if p_temp_address_line1 is null or p_temp_protect_address = 'Y' then
      v_sifr.address_order := 1;
    end if;

    -- The address is not changed but Voyager requires at least one address
    -- field in the SIF record and since everyone has to have a permanent 
    -- address we use that. Since we include permanent address we have to
    -- include the type 2/3 addresses, too, or they will be deleted. Here 
    -- we just set the values to the passed parameters.
    v_sifr.perm_address_line1 := p_perm_address_line1;
    v_sifr.perm_address_line2 := p_perm_address_line2;
    v_sifr.perm_city := p_perm_city;
    v_sifr.perm_state_province := p_perm_state_province;
    v_sifr.perm_zip_postal := p_perm_zip_postal;
    v_sifr.perm_country := p_perm_country;
    v_sifr.perm_phone_primary := p_perm_phone_primary;
    v_sifr.perm_phone_mobile := p_perm_phone_mobile;
    v_sifr.perm_phone_fax := p_perm_phone_fax;
    v_sifr.perm_phone_other := p_perm_phone_other;
    v_sifr.temp_address_line1 := p_temp_address_line1;
    v_sifr.temp_address_line2 := p_temp_address_line2;
    v_sifr.temp_city := p_temp_city;
    v_sifr.temp_state_province := p_temp_state_province;
    v_sifr.temp_zip_postal := p_temp_zip_postal;
    v_sifr.temp_country := p_temp_country;
    v_sifr.temp_phone_primary := p_temp_phone_primary;
    v_sifr.temp_phone_mobile := p_temp_phone_mobile;
    v_sifr.temp_phone_fax := p_temp_phone_fax;
    v_sifr.temp_phone_other := p_temp_phone_other;
    v_sifr.temp_effect_date := p_temp_effect_date;
    v_sifr.temp_expire_date := p_temp_expire_date;
    v_sifr.email := p_email;
    v_sifr.email_effect_date := p_email_effect_date;
    v_sifr.email_expire_date := p_email_expire_date;
    
    -- Now we want to parse out the statistical categories and set them.
    v_sifr.statistical_category_1 := substr(p_stat_cats, 1, 3);
    v_sifr.statistical_category_2 := substr(p_stat_cats, 4, 3);
    v_sifr.statistical_category_3 := substr(p_stat_cats, 7, 3);
    v_sifr.statistical_category_4 := substr(p_stat_cats, 10, 3);
    v_sifr.statistical_category_5 := substr(p_stat_cats, 13, 3);
    v_sifr.statistical_category_6 := substr(p_stat_cats, 16, 3);
    v_sifr.statistical_category_7 := substr(p_stat_cats, 19, 3);
    v_sifr.statistical_category_8 := substr(p_stat_cats, 22, 3);
    v_sifr.statistical_category_9 := substr(p_stat_cats, 25, 3);
    v_sifr.statistical_category_10 := substr(p_stat_cats, 28, 3);
  
    RETURN GET_PATRON_SIF(v_sifr);
  END;
  
  /*  The INSERT_NEW_SIF procedure runs a query and adds Patron SIF records to
      the PATRON_SIF table. The query gets new patrons who are in the registrar
      data but not in the Voyager data.
      
      Last revised: 2006-09-01 chunt
  */
  PROCEDURE INSERT_NEW_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    select
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.NEW_PATRON_SIF_FROM_REG
    (
      r.UNIVERSITY_ID,
      LEVEL_OF_ISSUE,
      NAME,
      PADDR1,
      PADDR2,
      PCITY,
      PSTATE,
      PZIP,
      PCOUNTRY,
      PPHONE,
      TADDR1,
      TADDR2,
      TCITY,
      TSTATE,
      TZIP,
      TCOUNTRY,
      TPHONE,
      EMAILADD,
      SEX,
      CAREER,
      CLASS,
      COLL1,
      DEG1,
      DEPT1,
      DIV1,
      RT340,
      to_date('2017.07.01', 'YYYY.MM.DD'),
      to_date('2019.01.31', 'YYYY.MM.DD'),
      to_date('2036.12.31', 'YYYY.MM.DD')
    ), 
    -- Date created
    sysdate, 
    -- Type - 1=New Patron
    1
    -- Start with registrar data.
    FROM vger_report.cmp_registrar r 
    -- Join with BruinCard data to get level of issue.
    inner join vger_report.cmp_bruincard b ON b.university_id = r.university_id LEFT
    -- Join with Voyager's patron table.
    OUTER JOIN ucladb.patron p ON p.institution_id = r.university_id
    -- Pick only those who aren't in the patron table and who have not 
    -- withdrawn from school.
    WHERE p.patron_id IS NULL and r.withdraw is null
    -- Ignore entries with blank names.
    and r.name is not null
    -- Ignore entries with e-mail addresses that are too long.
    and length(r.emailadd) <= 50
    -- Require at least one physical address.
    and (paddr1 is not null or taddr1 is not null)
    -- Ignore any cases which cause the function to return null.
    and vger_support.lws_patron.NEW_PATRON_SIF_FROM_REG
    (
      r.UNIVERSITY_ID,
      LEVEL_OF_ISSUE,
      NAME,
      PADDR1,
      PADDR2,
      PCITY,
      PSTATE,
      PZIP,
      PCOUNTRY,
      PPHONE,
      TADDR1,
      TADDR2,
      TCITY,
      TSTATE,
      TZIP,
      TCOUNTRY,
      TPHONE,
      EMAILADD,
      SEX,
      CAREER,
      CLASS,
      COLL1,
      DEG1,
      DEPT1,
      DIV1,
      RT340,
      to_date('2017.07.01', 'YYYY.MM.DD'),
      to_date('2019.01.31', 'YYYY.MM.DD'),
      to_date('2036.12.31', 'YYYY.MM.DD')
    ) is not null
    ;
  END;

  /*  The INSERT_NEW_QDB_SIF procedure runs a query and adds Patron SIF records 
      to the PATRON_SIF table. The query gets new patrons who are in the QDB 
      data but not in the Voyager data.
      
      Last revised: 2007-09-07 chunt
  */
  PROCEDURE INSERT_NEW_QDB_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    select
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.NEW_PATRON_SIF_FROM_QDB
    (
      q.EMPLOYEE_ID,
      b.LEVEL_OF_ISSUE,
      q.EMP_FIRST_NAME,
      q.EMP_MIDDLE_NAME,
      q.EMP_LAST_NAME,
      q.WORK_ADDR_LINE1,
      q.WORK_ADDR_LINE2,
      q.WORK_ADDR_CITY,
      q.WORK_ADDR_STATE,
      q.WORK_ADDR_ZIP,
      q.CAMPUS_PHONE,
      -- If the e-mail address is blank set it to null.
      CASE
        WHEN (q.EMAIL_ADDR like ' %') THEN null
        WHEN (q.EMAIL_ADDR is null) THEN null
        ELSE lower(q.EMAIL_ADDR)
      END,
      q.TYPE,
      q.LAW,
      to_date('2017.07.01', 'YYYY.MM.DD'),
      to_date('2019.01.31', 'YYYY.MM.DD'),
      to_date('2036.12.31', 'YYYY.MM.DD')
    ), 
    -- Date created
    sysdate, 
    -- Type - 1=New Patron
    1
    -- Start with QDB data.
    FROM vger_report.cmp_qdb q 
    -- Join with BruinCard data to get level of issue.
    inner join vger_report.cmp_bruincard b ON b.university_id = q.employee_id
    -- Join with Voyager's patron table.
    LEFT OUTER JOIN ucladb.patron p ON p.institution_id = q.employee_id
    -- Join with Registrar data.
    LEFT OUTER JOIN vger_report.CMP_REGISTRAR reg on p.institution_id = reg.university_id
    -- Pick only those who aren't in the patron table or Registrar data. 
    -- Registrar data has better addresses to it's better to let these get 
    -- created by NEW_PATRON_SIF_FROM_REG if the patron shows up in Registrar
    -- data and QDB data for the first time on the same day.
    WHERE p.patron_id IS NULL and reg.university_id IS NULL
    AND q.WORK_ADDR_LINE1 not like ' %'
    AND q.WORK_ADDR_CITY not like ' %'
    AND q.WORK_ADDR_STATE not like ' %'
    AND q.WORK_ADDR_ZIP not like ' %'
    ;
  END;

  /*  The INSERT_LOI_CHANGE_SIF procedure runs a query and adds Patron SIF 
      records to the PATRON_SIF table. The query gets patrons whose BruinCard
      level of issue in the BruinCard data is different from what's in the 
      Voyager data. When these SIF records are run the status of the existing 
      barcode will be set to 5 ("Other").
      
      Last revised: 2006-09-06 chunt
  */
  PROCEDURE INSERT_LOI_CHANGE_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    SELECT 
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.UPDATE_BARCODE_FROM_BC
    (
      b.UNIVERSITY_ID,
      b.level_of_issue,
      pg.patron_group_code,
      pb.barcode_status,
      p.last_name,
      p.first_name,
      p.middle_name,
      perm_add.address_line1,
      perm_add.address_line2,
      perm_add.city,
      perm_add.STATE_PROVINCE,
      perm_add.ZIP_POSTAL,
      perm_add.COUNTRY,
      perm_phone_primary.phone_number,
      perm_phone_mobile.phone_number,
      perm_phone_fax.phone_number,
      perm_phone_other.phone_number,
      temp_add.address_line1,
      temp_add.address_line2,
      temp_add.city,
      temp_add.STATE_PROVINCE,
      temp_add.ZIP_POSTAL,
      temp_add.COUNTRY,
      temp_phone_primary.phone_number,
      temp_phone_mobile.phone_number,
      temp_phone_fax.phone_number,
      temp_phone_other.phone_number,
      temp_add.effect_date,
      temp_add.expire_date,
      temp_add.protect_address,
      email.address_line1,
      email.effect_date,
      email.expire_date
    ),
    -- Date created
    sysdate, 
    -- Type - 2=New Barcode
    2
    -- Start with BruinCard data.
    FROM vger_report.cmp_bruincard b 
    -- Join with Voyager's patron table.
    inner join ucladb.patron p ON p.institution_id = b.university_id
    -- Join with Voyager's patron_barcode table. Pick only active status barcodes.
    inner join ucladb.PATRON_BARCODE pb on pb.patron_id = p.patron_id and pb.barcode_status = 1
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg on pg.patron_group_id = pb.patron_group_id
    -- Join with Voyager's patron_address table. Pick only permanent address records.
    inner join ucladb.PATRON_ADDRESS perm_add on perm_add.patron_id = p.patron_id and perm_add.address_type = 1
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE perm_phone_primary on perm_phone_primary.address_id = perm_add.address_id and perm_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE perm_phone_mobile on perm_phone_mobile.address_id = perm_add.address_id and perm_phone_primary.phone_type = 2
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE perm_phone_fax on perm_phone_fax.address_id = perm_add.address_id and perm_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE perm_phone_other on perm_phone_other.address_id = perm_add.address_id and perm_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only temporary address records.
    left outer join ucladb.PATRON_ADDRESS temp_add on temp_add.patron_id = p.patron_id and temp_add.address_type = 2
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE temp_phone_primary on temp_phone_primary.address_id = temp_add.address_id and temp_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE temp_phone_mobile on temp_phone_mobile.address_id = temp_add.address_id and temp_phone_primary.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE temp_phone_fax on temp_phone_fax.address_id = temp_add.address_id and temp_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE temp_phone_other on temp_phone_other.address_id = temp_add.address_id and temp_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only e-mail address records.
    left outer join ucladb.PATRON_ADDRESS email on email.patron_id = p.patron_id and email.address_type = 3
    where 
    -- Pick only records whose barcode has changed.
    b.UNIVERSITY_ID || b.level_of_issue <> pb.patron_barcode
    -- Ignore barcodes starting with P or 21158 because they are special.
    and pb.patron_barcode not like 'P%' and pb.patron_barcode not like '21158%' 
    -- Pick only records who haven't expired.
    and p.expire_date > sysdate
    -- Pick only records that have one active barcode. Also, there will be an 
    -- error if the new barcode matches an existing barcode for a patron that 
    -- has Lost (2) or Stolen (3) status so ignore those cases.
    and not exists 
    (
      SELECT * FROM ucladb.PATRON_BARCODE pb2 
      where 
        pb2.patron_id = p.patron_id 
        and pb2.patron_barcode_id <> pb.patron_barcode_id
        and
        (
          ((pb2.barcode_status = 2 or  pb2.barcode_status = 3) and pb2.patron_barcode = b.UNIVERSITY_ID || b.level_of_issue) 
          or pb2.barcode_status = 1
        )        
    )
    ;
  END;

  /*  The INSERT_ADDRESS_CHANGE_SIF procedure runs a query and adds Patron SIF 
      records to the PATRON_SIF table. The query gets patrons whose address 
      fields in the registrar data are different from the Voyager data.
      
      Last revised: 2008-02-27 chunt
  */
  PROCEDURE INSERT_ADDRESS_CHANGE_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    SELECT 
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.UPDATE_ADDRESS_FROM_REG
    (
      r.UNIVERSITY_ID,
      pb.patron_barcode,
      pg.patron_group_code,
      pb.barcode_status,
      p.last_name,
      p.first_name,
      p.middle_name,
      perm_add.address_line1,
      perm_add.address_line2,
      perm_add.city,
      perm_add.STATE_PROVINCE,
      perm_add.ZIP_POSTAL,
      perm_add.COUNTRY,
      perm_phone_primary.phone_number,
      perm_phone_mobile.phone_number,
      perm_phone_fax.phone_number,
      perm_phone_other.phone_number,
      temp_add.address_line1,
      temp_add.address_line2,
      temp_add.city,
      temp_add.STATE_PROVINCE,
      temp_add.ZIP_POSTAL,
      temp_add.COUNTRY,
      temp_phone_primary.phone_number,
      temp_phone_mobile.phone_number,
      temp_phone_fax.phone_number,
      temp_phone_other.phone_number,
      temp_add.effect_date,
      temp_add.expire_date,
      temp_add.protect_address,
      email.address_line1,
      email.effect_date,
      email.expire_date,
      PADDR1,
      PADDR2,
      PCITY,
      PSTATE,
      PZIP,
      PCOUNTRY,
      pphone,
      TADDR1,
      TADDR2,
      TCITY,
      TSTATE,
      TZIP,
      TCOUNTRY,
      tphone,
      EMAILADD,
      p.purge_date
    ),
    -- Date created
    sysdate, 
    -- Type
    vger_support.lws_patron.GET_PATRON_SIF_CODE(
      perm_add.address_line1,
      perm_add.address_line2,
      perm_add.city,
      perm_add.STATE_PROVINCE,
      perm_add.ZIP_POSTAL,
      perm_add.COUNTRY,
      perm_phone_primary.phone_number,
      temp_add.address_line1,
      temp_add.address_line2,
      temp_add.city,
      temp_add.STATE_PROVINCE,
      temp_add.ZIP_POSTAL,
      temp_add.COUNTRY,
      temp_phone_primary.phone_number,
      email.address_line1,
      PADDR1,
      PADDR2,
      PCITY,
      PSTATE,
      PZIP,
      PCOUNTRY,
      pphone,
      TADDR1,
      TADDR2,
      TCITY,
      TSTATE,
      TZIP,
      TCOUNTRY,
      tphone,
      EMAILADD
    )
    -- Start with registrar data
    FROM vger_report.cmp_registrar r LEFT
    -- Join with BruinCard data to get level of issue.
    OUTER JOIN vger_report.cmp_bruincard b ON b.university_id = r.university_id LEFT
    -- Join with Voyager's patron table.
    OUTER JOIN ucladb.patron p ON p.institution_id = r.university_id
    -- Join with Voyager's patron_barcode table. Pick only active status barcodes.
    inner join ucladb.PATRON_BARCODE pb on pb.patron_id = p.patron_id and pb.barcode_status = 1
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg on pg.patron_group_id = pb.patron_group_id
    -- Join with Voyager's patron_address table. Pick only permanent address records.
    inner join ucladb.PATRON_ADDRESS perm_add on perm_add.patron_id = p.patron_id and perm_add.address_type = 1
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE perm_phone_primary on perm_phone_primary.address_id = perm_add.address_id and perm_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE perm_phone_mobile on perm_phone_mobile.address_id = perm_add.address_id and perm_phone_primary.phone_type = 2
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE perm_phone_fax on perm_phone_fax.address_id = perm_add.address_id and perm_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE perm_phone_other on perm_phone_other.address_id = perm_add.address_id and perm_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only temporary address records.
    left outer join ucladb.PATRON_ADDRESS temp_add on temp_add.patron_id = p.patron_id and temp_add.address_type = 2
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE temp_phone_primary on temp_phone_primary.address_id = temp_add.address_id and temp_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE temp_phone_mobile on temp_phone_mobile.address_id = temp_add.address_id and temp_phone_primary.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE temp_phone_fax on temp_phone_fax.address_id = temp_add.address_id and temp_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE temp_phone_other on temp_phone_other.address_id = temp_add.address_id and temp_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only e-mail address records.
    left outer join ucladb.PATRON_ADDRESS email on email.patron_id = p.patron_id and email.address_type = 3
    where 
    -- The first line of non-protected addresses have changed. (Add: check for phone change.)
    -- The new value cannot be null.
    (
      (r.paddr1 is not null and upper(nvl(perm_add.address_line1, 'XXX')) <> upper(r.paddr1) and nvl(perm_add.protect_address, 'N') = 'N')
      or (r.taddr1 is not null and upper(nvl(temp_add.address_line1, 'XXX')) <> upper(r.taddr1) and nvl(temp_add.protect_address, 'N') = 'N')
      or (emailadd is not null and upper(nvl(email.address_line1, 'XXX')) <> upper(emailadd) and nvl(email.protect_address, 'N') = 'N')
    )
    -- Ignore entries with e-mail addresses that are too long.
    and length(r.emailadd) <= 50
    -- Pick only records that have one active barcode. 
    and not exists 
    (
      SELECT * FROM ucladb.PATRON_BARCODE pb2 
      where 
        pb2.patron_id = p.patron_id 
        and pb2.patron_barcode_id <> pb.patron_barcode_id
        and pb2.barcode_status = 1
    )
    -- Ignore records with city of Campus for physical addresses. These should
    -- not be updated automatically.
    and upper(nvl(perm_add.city, 'XXX')) <> 'CAMPUS' and upper(nvl(temp_add.city, 'XXX')) <> 'CAMPUS'
    -- Pick only records who haven't expired.
    and p.expire_date > sysdate
    -- Ignore records with multiple addresses of one type, i.e., two permanent
    -- addresses.
    AND NOT EXISTS (SELECT * FROM ucladb.PATRON_ADDRESS perm_add2 WHERE perm_add2.patron_id = p.patron_id and perm_add2.address_type = 1 and perm_add2.address_id <> perm_add.address_id)
    AND NOT EXISTS (SELECT * FROM ucladb.PATRON_ADDRESS temp_add2 WHERE temp_add2.patron_id = p.patron_id and temp_add2.address_type = 2 and temp_add2.address_id <> temp_add.address_id)
    AND NOT EXISTS (SELECT * FROM ucladb.PATRON_ADDRESS email2 WHERE email2.patron_id = p.patron_id and email2.address_type = 3 and email2.address_id <> email.address_id)
    ;
  END;

  /*  The INSERT_FSEMAIL_CHANGE_SIF procedure runs a query and adds Patron SIF 
      records to the PATRON_SIF table. The query gets patrons whose e-mail 
      address fields in the fsemail (Faculty and Staff e-mail) data are 
      different from the Voyager data.
      
      Last revised: 2008-02-27 chunt
  */
  PROCEDURE INSERT_FSEMAIL_CHANGE_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    SELECT 
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.UPDATE_FSEMAIL
    (
      fse.UNIVERSITYID,
      pb.patron_barcode,
      pg.patron_group_code,
      pb.barcode_status,
      p.last_name,
      p.first_name,
      p.middle_name,
      temp_add.address_line1,
      temp_add.address_line2,
      temp_add.city,
      temp_add.STATE_PROVINCE,
      temp_add.ZIP_POSTAL,
      temp_add.COUNTRY,
      temp_phone_primary.phone_number,
      temp_phone_mobile.phone_number,
      temp_phone_fax.phone_number,
      temp_phone_other.phone_number,
      temp_add.effect_date,
      temp_add.expire_date,
      temp_add.protect_address,
      email.address_line1,
      email.effect_date,
      email.expire_date,
      p.purge_date,
      fse.email
    ),
    -- Date created
    sysdate, 
    -- Type - 16= faculty or staff e-mail change
    16
    -- Start with fsemail data
    FROM vger_report.cmp_fsemail fse LEFT
    -- Join with Voyager's patron table.
    OUTER JOIN ucladb.patron p ON p.institution_id = fse.universityid
    -- Join with Voyager's patron_barcode table. Pick only active status barcodes.
    inner join ucladb.PATRON_BARCODE pb on pb.patron_id = p.patron_id and pb.barcode_status = 1
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg on pg.patron_group_id = pb.patron_group_id
    -- Join with Voyager's patron_address table. Pick only temporary address records.
    left outer join ucladb.PATRON_ADDRESS temp_add on temp_add.patron_id = p.patron_id and temp_add.address_type = 2
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE temp_phone_primary on temp_phone_primary.address_id = temp_add.address_id and temp_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE temp_phone_mobile on temp_phone_mobile.address_id = temp_add.address_id and temp_phone_primary.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE temp_phone_fax on temp_phone_fax.address_id = temp_add.address_id and temp_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE temp_phone_other on temp_phone_other.address_id = temp_add.address_id and temp_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only e-mail address records.
    left outer join ucladb.PATRON_ADDRESS email on email.patron_id = p.patron_id and email.address_type = 3
    where 
    -- Pick only records where e-mail is not null.
    fse.email is not null and
    -- Pick only records whose fsemail email address is different from Voyager
    -- data and the address is not protected.
    (lower(nvl(email.address_line1, 'XXX')) <> lower(nvl(fse.email, 'YYY')) and nvl(email.protect_address, 'N') = 'N')
    -- Pick only records that aren't in the registrar data. Let that be 
    -- authoritative for e-mail address so changes aren't made twice.
    and not exists 
    (
      SELECT * FROM vger_report.CMP_REGISTRAR r
      where 
        fse.universityid = r.university_id
    )
    -- Pick only records that have one active barcode. 
    and not exists 
    (
      SELECT * FROM ucladb.PATRON_BARCODE pb2 
      where 
        pb2.patron_id = p.patron_id 
        and pb2.patron_barcode_id <> pb.patron_barcode_id
        and pb2.barcode_status = 1
    )
    -- Pick only records who haven't expired.
    and p.expire_date > sysdate
    -- Ignore records with multiple type 2 and 3 addresses of one type, i.e., 
    -- two temporary addresses.
    AND NOT EXISTS (SELECT * FROM ucladb.PATRON_ADDRESS temp_add2 WHERE temp_add2.patron_id = p.patron_id and temp_add2.address_type = 2 and temp_add2.address_id <> temp_add.address_id)
    AND NOT EXISTS (SELECT * FROM ucladb.PATRON_ADDRESS email2 WHERE email2.patron_id = p.patron_id and email2.address_type = 3 and email2.address_id <> email.address_id)
    ;
  END;

  /*  The INSERT_EXTEND_EXP_SIF procedure runs a query and adds Patron SIF 
      records to the PATRON_SIF table. The query gets patrons whose patron 
      group corresponds to faculty, staff, or students (types 1 through 4 from
      the patron_groups_components table), who have not already expired, and who
      don't have multiple active barcodes. This is unconditional and should not
      be run as a regular procedure, but as a temporary fix to adjust expiration
      dates.
      
      Last revised: 2008-02-27 chunt
  */
  PROCEDURE INSERT_EXTEND_EXP_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    SELECT 
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.UPDATE_EXPIRATION
    (
      p.institution_id,
      pb.patron_barcode,
      pg.patron_group_code,
      pb.barcode_status,
      p.last_name,
      p.first_name,
      p.middle_name,
      perm_add.address_line1,
      perm_add.address_line2,
      perm_add.city,
      perm_add.STATE_PROVINCE,
      perm_add.ZIP_POSTAL,
      perm_add.COUNTRY,
      perm_phone_primary.phone_number,
      perm_phone_mobile.phone_number,
      perm_phone_fax.phone_number,
      perm_phone_other.phone_number,
      temp_add.address_line1,
      temp_add.address_line2,
      temp_add.city,
      temp_add.STATE_PROVINCE,
      temp_add.ZIP_POSTAL,
      temp_add.COUNTRY,
      temp_phone_primary.phone_number,
      temp_phone_mobile.phone_number,
      temp_phone_fax.phone_number,
      temp_phone_other.phone_number,
      temp_add.effect_date,
      temp_add.expire_date,
      temp_add.protect_address,
      email.address_line1,
      email.effect_date,
      email.expire_date,
      to_date('2019.01.31', 'YYYY.MM.DD')
    ),
    -- Date created
    sysdate, 
    -- Type - 10=extend expiration date
    10
    -- Start with Voyager's patron table.
    from ucladb.patron p
    -- Join with Voyager's patron_barcode table. Pick only active status barcodes.
    inner join ucladb.PATRON_BARCODE pb on pb.patron_id = p.patron_id and pb.barcode_status = 1
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg on pg.patron_group_id = pb.patron_group_id
    -- Join with patron_group_components table.
    inner join patron_group_components pgc on pgc.patron_group_id = pg.patron_group_id    
    -- Join with Voyager's patron_address table. Pick only permanent address records.
    inner join ucladb.PATRON_ADDRESS perm_add on perm_add.patron_id = p.patron_id and perm_add.address_type = 1
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE perm_phone_primary on perm_phone_primary.address_id = perm_add.address_id and perm_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE perm_phone_mobile on perm_phone_mobile.address_id = perm_add.address_id and perm_phone_primary.phone_type = 2
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE perm_phone_fax on perm_phone_fax.address_id = perm_add.address_id and perm_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE perm_phone_other on perm_phone_other.address_id = perm_add.address_id and perm_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only temporary address records.
    left outer join ucladb.PATRON_ADDRESS temp_add on temp_add.patron_id = p.patron_id and temp_add.address_type = 2
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE temp_phone_primary on temp_phone_primary.address_id = temp_add.address_id and temp_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE temp_phone_mobile on temp_phone_mobile.address_id = temp_add.address_id and temp_phone_primary.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE temp_phone_fax on temp_phone_fax.address_id = temp_add.address_id and temp_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE temp_phone_other on temp_phone_other.address_id = temp_add.address_id and temp_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only e-mail address records.
    left outer join ucladb.PATRON_ADDRESS email on email.patron_id = p.patron_id and email.address_type = 3
    where 
    -- Pick only records that don't already have this expiration date set.
    --to_char(p.expire_date, 'YYYY.MM.DD') <> '2008.11.15'
    -- Pick people expiring before 12/18/07 or who were set to 11/15/08
    ( 
      p.expire_date < to_date('2007.12.18', 'YYYY.MM.DD') OR
      to_char(p.expire_date, 'YYYY.MM.DD') = '2008.11.15'
    )
    -- Pick only records for faculty, staff, and students.
    and pgc.type between 1 and 4
    -- Pick only records who haven't expired.
    and p.expire_date > sysdate
    -- Pick only records that have one active barcode. 
    and not exists 
    (
      SELECT * FROM ucladb.PATRON_BARCODE pb2 
      where 
        pb2.patron_id = p.patron_id 
        and pb2.patron_barcode_id <> pb.patron_barcode_id
        and pb2.barcode_status = 1
    )
    ;
  END;
  
  /*  The INSERT_EXTEND_ELIGIBLE_EXP_SIF procedure runs a query and adds Patron 
      SIF records to the PATRON_SIF table. The query gets patrons in the QDB 
      data or Registrar data whose patron group corresponds to faculty, staff, 
      or students (types 1 through 4 from the patron_groups_components table), 
      who have not already expired, who don't have the target expiration date 
      set, and who don't have multiple active barcodes.
      
      Last revised: 2008-02-27 chunt
  */
  PROCEDURE INSERT_EXTEND_ELIGIBLE_EXP_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    SELECT 
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.UPDATE_EXPIRATION
    (
      p.institution_id,
      pb.patron_barcode,
      pg.patron_group_code,
      pb.barcode_status,
      p.last_name,
      p.first_name,
      p.middle_name,
      perm_add.address_line1,
      perm_add.address_line2,
      perm_add.city,
      perm_add.STATE_PROVINCE,
      perm_add.ZIP_POSTAL,
      perm_add.COUNTRY,
      perm_phone_primary.phone_number,
      perm_phone_mobile.phone_number,
      perm_phone_fax.phone_number,
      perm_phone_other.phone_number,
      temp_add.address_line1,
      temp_add.address_line2,
      temp_add.city,
      temp_add.STATE_PROVINCE,
      temp_add.ZIP_POSTAL,
      temp_add.COUNTRY,
      temp_phone_primary.phone_number,
      temp_phone_mobile.phone_number,
      temp_phone_fax.phone_number,
      temp_phone_other.phone_number,
      temp_add.effect_date,
      temp_add.expire_date,
      temp_add.protect_address,
      email.address_line1,
      email.effect_date,
      email.expire_date,
      to_date('2019.01.31', 'YYYY.MM.DD')
    ),
    -- Date created
    sysdate, 
    -- Type - 10=extend expiration date
    10
    -- Start with Voyager's patron table.
    from ucladb.patron p
    -- Join with QDB data to get active staff or faculty. Note that BruinCard 
    -- data is not a good choice for this because it keeps people active after 
    -- they drop out of other data sources.
    left outer join vger_report.CMP_QDB qdb on p.institution_id = qdb.employee_id
    -- Join with Registrar data.
    left outer join vger_report.CMP_REGISTRAR reg on p.institution_id = reg.university_id
    -- Join with Voyager's patron_barcode table. Pick only active status barcodes.
    inner join ucladb.PATRON_BARCODE pb on pb.patron_id = p.patron_id and pb.barcode_status = 1
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg on pg.patron_group_id = pb.patron_group_id
    -- Join with patron_group_components table.
    inner join patron_group_components pgc on pgc.patron_group_id = pg.patron_group_id    
    -- Join with Voyager's patron_address table. Pick only permanent address records.
    inner join ucladb.PATRON_ADDRESS perm_add on perm_add.patron_id = p.patron_id and perm_add.address_type = 1
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE perm_phone_primary on perm_phone_primary.address_id = perm_add.address_id and perm_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE perm_phone_mobile on perm_phone_mobile.address_id = perm_add.address_id and perm_phone_primary.phone_type = 2
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE perm_phone_fax on perm_phone_fax.address_id = perm_add.address_id and perm_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE perm_phone_other on perm_phone_other.address_id = perm_add.address_id and perm_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only temporary address records.
    left outer join ucladb.PATRON_ADDRESS temp_add on temp_add.patron_id = p.patron_id and temp_add.address_type = 2
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE temp_phone_primary on temp_phone_primary.address_id = temp_add.address_id and temp_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE temp_phone_mobile on temp_phone_mobile.address_id = temp_add.address_id and temp_phone_primary.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE temp_phone_fax on temp_phone_fax.address_id = temp_add.address_id and temp_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE temp_phone_other on temp_phone_other.address_id = temp_add.address_id and temp_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only e-mail address records.
    left outer join ucladb.PATRON_ADDRESS email on email.patron_id = p.patron_id and email.address_type = 3
    where 
    -- Pick only patrons that are either in the QDB or Registrar data.
    -- All employess in the QDB data are active.
    -- Students in the Registrar data are active if the withdraw field is null.
    (qdb.employee_id is not null or (reg.university_id is not null and reg.withdraw is null))
    -- Pick only records that don't already have this expiration date set.
    and to_char(p.expire_date, 'YYYY.MM.DD') <> '2019.01.31'
    -- Pick only records for faculty, staff, and students.
    and pgc.type between 1 and 4
    -- Pick only records who haven't expired.
    and p.expire_date > sysdate
    -- Pick only records that have one active barcode. 
    and not exists 
    (
      SELECT * FROM ucladb.PATRON_BARCODE pb2 
      where 
        pb2.patron_id = p.patron_id 
        and pb2.patron_barcode_id <> pb.patron_barcode_id
        and pb2.barcode_status = 1
    )
    ;
  END;
  
  /*  The INSERT_GENDER_CHANGE_SIF procedure runs a query and adds Patron SIF 
      records to the PATRON_SIF table. The query gets patrons whose patron 
      group corresponds to faculty, staff, or students (types 1 through 4 from
      the patron_groups_components table), whose gender statistical category in
      Voyager is different from Registrar data, and who don't have multiple 
      active barcodes.

      Last revised: 2008-02-27 chunt
  */
  PROCEDURE INSERT_GENDER_CHANGE_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    SELECT 
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.UPDATE_STAT_CATS
    (
      p.institution_id,
      pb.patron_barcode,
      pg.patron_group_code,
      pb.barcode_status,
      p.last_name,
      p.first_name,
      p.middle_name,
      perm_add.address_line1,
      perm_add.address_line2,
      perm_add.city,
      perm_add.STATE_PROVINCE,
      perm_add.ZIP_POSTAL,
      perm_add.COUNTRY,
      perm_phone_primary.phone_number,
      perm_phone_mobile.phone_number,
      perm_phone_fax.phone_number,
      perm_phone_other.phone_number,
      temp_add.address_line1,
      temp_add.address_line2,
      temp_add.city,
      temp_add.STATE_PROVINCE,
      temp_add.ZIP_POSTAL,
      temp_add.COUNTRY,
      temp_phone_primary.phone_number,
      temp_phone_mobile.phone_number,
      temp_phone_fax.phone_number,
      temp_phone_other.phone_number,
      temp_add.effect_date,
      temp_add.expire_date,
      temp_add.protect_address,
      email.address_line1,
      email.effect_date,
      email.expire_date,
      vger_support.LWS_PATRON.GET_STAT_CATS(p.patron_id, reg.sex, reg.div1)
    ),
    -- Date created
    sysdate, 
    -- Type - 14=gender change
    14
    -- Start with Voyager's patron table.
    from ucladb.patron p
    -- Join with Voyager's patron_barcode table. Pick only active status barcodes.
    inner join ucladb.PATRON_BARCODE pb on pb.patron_id = p.patron_id and pb.barcode_status = 1
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg on pg.patron_group_id = pb.patron_group_id
    -- Join with patron_group_components table.
    inner join patron_group_components pgc on pgc.patron_group_id = pg.patron_group_id    
    -- Join with Voyager's patron_address table. Pick only permanent address records.
    inner join ucladb.PATRON_ADDRESS perm_add on perm_add.patron_id = p.patron_id and perm_add.address_type = 1
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE perm_phone_primary on perm_phone_primary.address_id = perm_add.address_id and perm_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE perm_phone_mobile on perm_phone_mobile.address_id = perm_add.address_id and perm_phone_primary.phone_type = 2
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE perm_phone_fax on perm_phone_fax.address_id = perm_add.address_id and perm_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE perm_phone_other on perm_phone_other.address_id = perm_add.address_id and perm_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only temporary address records.
    left outer join ucladb.PATRON_ADDRESS temp_add on temp_add.patron_id = p.patron_id and temp_add.address_type = 2
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE temp_phone_primary on temp_phone_primary.address_id = temp_add.address_id and temp_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE temp_phone_mobile on temp_phone_mobile.address_id = temp_add.address_id and temp_phone_primary.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE temp_phone_fax on temp_phone_fax.address_id = temp_add.address_id and temp_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE temp_phone_other on temp_phone_other.address_id = temp_add.address_id and temp_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only e-mail address records.
    left outer join ucladb.PATRON_ADDRESS email on email.patron_id = p.patron_id and email.address_type = 3
    -- Join with Voyager's patron_stats table for statistical category.
    inner join ucladb.patron_stats ps on p.patron_id = ps.patron_id
    -- Join with Voyager's patron_stat_code table for code of statistical category.
    INNER JOIN ucladb.patron_stat_code psc ON ps.patron_stat_id = psc.patron_stat_id
    -- Join with patron_stat_components table to discern category type. Type 1 is gender categories.
    INNER JOIN vger_support.patron_stat_components pscm ON psc.patron_stat_id = pscm.patron_stat_id and pscm.type = 1
    -- Join with Registrar data.
    inner join vger_report.CMP_REGISTRAR reg on p.institution_id = reg.university_id
    -- Pick only records with stat cat different from registrar data (transformed).
    where decode(reg.sex, 'M', '501', 'F', '502') <> psc.patron_stat_code
    -- Pick only records for faculty, staff, and students.
    and pgc.type between 1 and 4
    -- Pick only records who haven't expired.
    and p.expire_date > sysdate
    -- Pick only records that have one active barcode. 
    and not exists 
    (
      SELECT * FROM ucladb.PATRON_BARCODE pb2 
      where 
        pb2.patron_id = p.patron_id 
        and pb2.patron_barcode_id <> pb.patron_barcode_id
        and pb2.barcode_status = 1
    )
    ;
  END;

  /*  The INSERT_DIVISION_CHANGE_SIF procedure runs a query and adds Patron SIF 
      records to the PATRON_SIF table. The query gets patrons whose patron 
      group corresponds to faculty, staff, or students (types 1 through 4 from
      the patron_groups_components table), whose division statistical category 
      in Voyager is different from Registrar data, and who don't have multiple 
      active barcodes.

      Last revised: 2008-02-27 chunt
  */
  PROCEDURE INSERT_DIVISION_CHANGE_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    SELECT 
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.UPDATE_STAT_CATS
    (
      p.institution_id,
      pb.patron_barcode,
      pg.patron_group_code,
      pb.barcode_status,
      p.last_name,
      p.first_name,
      p.middle_name,
      perm_add.address_line1,
      perm_add.address_line2,
      perm_add.city,
      perm_add.STATE_PROVINCE,
      perm_add.ZIP_POSTAL,
      perm_add.COUNTRY,
      perm_phone_primary.phone_number,
      perm_phone_mobile.phone_number,
      perm_phone_fax.phone_number,
      perm_phone_other.phone_number,
      temp_add.address_line1,
      temp_add.address_line2,
      temp_add.city,
      temp_add.STATE_PROVINCE,
      temp_add.ZIP_POSTAL,
      temp_add.COUNTRY,
      temp_phone_primary.phone_number,
      temp_phone_mobile.phone_number,
      temp_phone_fax.phone_number,
      temp_phone_other.phone_number,
      temp_add.effect_date,
      temp_add.expire_date,
      temp_add.protect_address,
      email.address_line1,
      email.effect_date,
      email.expire_date,
      vger_support.LWS_PATRON.GET_STAT_CATS(p.patron_id, reg.sex, reg.div1)
    ),
    -- Date created
    sysdate, 
    -- Type - 15=division change
    15
    -- Start with Voyager's patron table.
    from ucladb.patron p
    -- Join with Voyager's patron_barcode table. Pick only active status barcodes.
    inner join ucladb.PATRON_BARCODE pb on pb.patron_id = p.patron_id and pb.barcode_status = 1
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg on pg.patron_group_id = pb.patron_group_id
    -- Join with patron_group_components table.
    inner join patron_group_components pgc on pgc.patron_group_id = pg.patron_group_id    
    -- Join with Voyager's patron_address table. Pick only permanent address records.
    inner join ucladb.PATRON_ADDRESS perm_add on perm_add.patron_id = p.patron_id and perm_add.address_type = 1
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE perm_phone_primary on perm_phone_primary.address_id = perm_add.address_id and perm_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE perm_phone_mobile on perm_phone_mobile.address_id = perm_add.address_id and perm_phone_primary.phone_type = 2
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE perm_phone_fax on perm_phone_fax.address_id = perm_add.address_id and perm_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE perm_phone_other on perm_phone_other.address_id = perm_add.address_id and perm_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only temporary address records.
    left outer join ucladb.PATRON_ADDRESS temp_add on temp_add.patron_id = p.patron_id and temp_add.address_type = 2
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE temp_phone_primary on temp_phone_primary.address_id = temp_add.address_id and temp_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE temp_phone_mobile on temp_phone_mobile.address_id = temp_add.address_id and temp_phone_primary.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE temp_phone_fax on temp_phone_fax.address_id = temp_add.address_id and temp_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE temp_phone_other on temp_phone_other.address_id = temp_add.address_id and temp_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only e-mail address records.
    left outer join ucladb.PATRON_ADDRESS email on email.patron_id = p.patron_id and email.address_type = 3
    -- Join with Voyager's patron_stats table for statistical category.
    inner join ucladb.patron_stats ps on p.patron_id = ps.patron_id
    -- Join with Voyager's patron_stat_code table for code of statistical category.
    INNER JOIN ucladb.patron_stat_code psc ON ps.patron_stat_id = psc.patron_stat_id
    -- Join with patron_stat_components table to discern category type. Type 2 is division categories.
    INNER JOIN vger_support.patron_stat_components pscm ON psc.patron_stat_id = pscm.patron_stat_id and pscm.type = 2
    -- Join with Registrar data.
    inner join vger_report.CMP_REGISTRAR reg on p.institution_id = reg.university_id
    -- Pick only records with stat cat different from registrar data.
    where reg.div1 <> psc.patron_stat_code
    -- Pick only records for faculty, staff, and students.
    and pgc.type between 1 and 4
    -- Pick only records who haven't expired.
    and p.expire_date > sysdate
    -- Pick only records that have one active barcode. 
    and not exists 
    (
      SELECT * FROM ucladb.PATRON_BARCODE pb2 
      where 
        pb2.patron_id = p.patron_id 
        and pb2.patron_barcode_id <> pb.patron_barcode_id
        and pb2.barcode_status = 1
    )
    ;
  END;

  /*  The INSERT_GROUP_CHANGE_SIF procedure runs a query and adds Patron SIF 
      records to the PATRON_SIF table. The query gets patrons whose patron 
      group corresponds to faculty, staff, or students (types 1 through 4 from
      the patron_groups_components table), whose patron group in Voyager is 
      different from Registrar or QDB data, and who don't have multiple active 
      barcodes.

      Last revised: 2008-02-27 chunt
  */
  PROCEDURE INSERT_GROUP_CHANGE_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    SELECT 
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.UPDATE_GROUP
    (
      p.institution_id,
      pb.patron_barcode,
      -- We get two groups. The first is the one that should be inactivated.
      pg_voy.patron_group_code,
      5, -- Status="Other"
      pb.patron_barcode,
      -- The second is the one that should be active.
      lws_patron.GET_PATRON_GROUP2(pg_reg.patron_group_code, pgc_reg.type, qdb.type, qdb.law),
      1, -- Status="Active"
      p.last_name,
      p.first_name,
      p.middle_name,
      perm_add.address_line1,
      perm_add.address_line2,
      perm_add.city,
      perm_add.STATE_PROVINCE,
      perm_add.ZIP_POSTAL,
      perm_add.COUNTRY,
      perm_phone_primary.phone_number,
      perm_phone_mobile.phone_number,
      perm_phone_fax.phone_number,
      perm_phone_other.phone_number,
      temp_add.address_line1,
      temp_add.address_line2,
      temp_add.city,
      temp_add.STATE_PROVINCE,
      temp_add.ZIP_POSTAL,
      temp_add.COUNTRY,
      temp_phone_primary.phone_number,
      temp_phone_mobile.phone_number,
      temp_phone_fax.phone_number,
      temp_phone_other.phone_number,
      temp_add.effect_date,
      temp_add.expire_date,
      temp_add.protect_address,
      email.address_line1,
      email.effect_date,
      email.expire_date
    ),
    -- Date created
    sysdate, 
    -- Type - 13=group change
    13
    -- Start with Voyager's patron table.
    FROM ucladb.patron p 
    -- Join with registrar data.
    left outer join vger_report.cmp_registrar reg ON p.institution_id = reg.university_id
    -- Join with qdb data.
    left outer join vger_report.cmp_qdb qdb ON p.institution_id = qdb.employee_id
    -- Join with Voyager's patron_barcode table. Pick only active status barcodes.
    inner join ucladb.PATRON_BARCODE pb on pb.patron_id = p.patron_id and pb.barcode_status = 1
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg_voy on pg_voy.patron_group_id = pb.patron_group_id
    -- Join with Voyager's patron_group table.
    left outer join ucladb.PATRON_GROUP pg_reg on lws_patron.GET_PATRON_GROUP(CAREER, CLASS, COLL1, DEG1, DEPT1, DIV1, RT340) = pg_reg.patron_group_code
    -- Join with patron_group_components table.
    inner join patron_group_components pgc_voy on pg_voy.patron_group_id = pgc_voy.patron_group_id 
    -- Join with patron_group_components table.
    left outer join patron_group_components pgc_reg on pg_reg.patron_group_id = pgc_reg.patron_group_id 
    -- Join with Voyager's patron_group table.
    left outer join ucladb.PATRON_GROUP pg_new on lws_patron.GET_PATRON_GROUP2(pg_reg.patron_group_code, pgc_reg.type, qdb.type, qdb.law) = pg_new.patron_group_code
    -- Join with patron_group_components table.
    left outer join patron_group_components pgc_new on pg_new.patron_group_id = pgc_new.patron_group_id 
    -- Join with Voyager's patron_address table. Pick only permanent address records.
    inner join ucladb.PATRON_ADDRESS perm_add on perm_add.patron_id = p.patron_id and perm_add.address_type = 1
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE perm_phone_primary on perm_phone_primary.address_id = perm_add.address_id and perm_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE perm_phone_mobile on perm_phone_mobile.address_id = perm_add.address_id and perm_phone_primary.phone_type = 2
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE perm_phone_fax on perm_phone_fax.address_id = perm_add.address_id and perm_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE perm_phone_other on perm_phone_other.address_id = perm_add.address_id and perm_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only temporary address records.
    left outer join ucladb.PATRON_ADDRESS temp_add on temp_add.patron_id = p.patron_id and temp_add.address_type = 2
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE temp_phone_primary on temp_phone_primary.address_id = temp_add.address_id and temp_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE temp_phone_mobile on temp_phone_mobile.address_id = temp_add.address_id and temp_phone_primary.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE temp_phone_fax on temp_phone_fax.address_id = temp_add.address_id and temp_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE temp_phone_other on temp_phone_other.address_id = temp_add.address_id and temp_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only e-mail address records.
    left outer join ucladb.PATRON_ADDRESS email on email.patron_id = p.patron_id and email.address_type = 3
    where 
    -- Pick only where group is not what's expected.
    (
      pgc_voy.type <> pgc_reg.type
      or pgc_voy.school <> pgc_reg.school
      or pgc_voy.type <> pgc_new.type
    )
    -- The above criteria identifies possible changes. The one below ensures
    -- they are indeed different. 
    and pg_voy.patron_group_code <> lws_patron.GET_PATRON_GROUP2(pg_reg.patron_group_code, pgc_reg.type, qdb.type, qdb.law)
    -- Pick only groups that can be changed.
    and pgc_voy.changeable = 'Y'
    -- Pick only records who haven't expired.
    and p.expire_date > sysdate
    -- Pick only records that have one active barcode. 
    and not exists 
    (
      SELECT * FROM ucladb.PATRON_BARCODE pb2 
      where 
        pb2.patron_id = p.patron_id 
        and pb2.patron_barcode_id <> pb.patron_barcode_id
        and pb2.barcode_status = 1
    )
    ;
  END;

  /*  The INSERT_GROUP_EXP_CHANGE_SIF procedure runs a query and adds Patron SIF 
      records to the PATRON_SIF table. The query gets patrons whose patron 
      group corresponds to faculty, staff, or students (types 1 through 4 from
      the patron_groups_components table), whose patron group in Voyager is 
      different from Registrar data, who don't have multiple active 
      barcodes, and whose account has expired.

      Last revised: 2008-02-27 chunt
  */
  PROCEDURE INSERT_GROUP_EXP_CHANGE_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    SELECT 
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.UPDATE_GROUP_AND_EXPIRATION
    (
      p.institution_id,
      pb.patron_barcode,
      -- We get two groups. The first is the one that should be inactivated.
      pg.patron_group_code,
      5, -- Status="Other"
      pb.patron_barcode,
      -- The second is the one that should be active.
      lws_patron.GET_PATRON_GROUP(CAREER, CLASS, COLL1, DEG1, DEPT1, DIV1, RT340),
      1, -- Status="Active"
      p.last_name,
      p.first_name,
      p.middle_name,
      perm_add.address_line1,
      perm_add.address_line2,
      perm_add.city,
      perm_add.STATE_PROVINCE,
      perm_add.ZIP_POSTAL,
      perm_add.COUNTRY,
      perm_phone_primary.phone_number,
      perm_phone_mobile.phone_number,
      perm_phone_fax.phone_number,
      perm_phone_other.phone_number,
      temp_add.address_line1,
      temp_add.address_line2,
      temp_add.city,
      temp_add.STATE_PROVINCE,
      temp_add.ZIP_POSTAL,
      temp_add.COUNTRY,
      temp_phone_primary.phone_number,
      temp_phone_mobile.phone_number,
      temp_phone_fax.phone_number,
      temp_phone_other.phone_number,
      temp_add.effect_date,
      temp_add.expire_date,
      temp_add.protect_address,
      email.address_line1,
      email.effect_date,
      email.expire_date,
      to_date('2019.01.31', 'YYYY.MM.DD')
    ),
    -- Date created
    sysdate, 
    -- Type - 17=group and expiration change
    17
    -- Start with registrar data.
    FROM vger_report.cmp_registrar reg
    -- Join with Voyager's patron table.
    inner join ucladb.patron p ON p.institution_id = reg.university_id
    -- Join with Voyager's patron_barcode table. Pick only active status barcodes.
    inner join ucladb.PATRON_BARCODE pb on pb.patron_id = p.patron_id and pb.barcode_status = 1
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg on pg.patron_group_id = pb.patron_group_id
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg2 on pg2.patron_group_code = lws_patron.GET_PATRON_GROUP(CAREER, CLASS, COLL1, DEG1, DEPT1, DIV1, RT340)
    -- Join with Voyager's patron_address table. Pick only permanent address records.
    inner join ucladb.PATRON_ADDRESS perm_add on perm_add.patron_id = p.patron_id and perm_add.address_type = 1
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE perm_phone_primary on perm_phone_primary.address_id = perm_add.address_id and perm_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE perm_phone_mobile on perm_phone_mobile.address_id = perm_add.address_id and perm_phone_primary.phone_type = 2
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE perm_phone_fax on perm_phone_fax.address_id = perm_add.address_id and perm_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE perm_phone_other on perm_phone_other.address_id = perm_add.address_id and perm_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only temporary address records.
    left outer join ucladb.PATRON_ADDRESS temp_add on temp_add.patron_id = p.patron_id and temp_add.address_type = 2
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE temp_phone_primary on temp_phone_primary.address_id = temp_add.address_id and temp_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE temp_phone_mobile on temp_phone_mobile.address_id = temp_add.address_id and temp_phone_primary.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE temp_phone_fax on temp_phone_fax.address_id = temp_add.address_id and temp_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE temp_phone_other on temp_phone_other.address_id = temp_add.address_id and temp_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only e-mail address records.
    left outer join ucladb.PATRON_ADDRESS email on email.patron_id = p.patron_id and email.address_type = 3
    where 
    -- Pick only where group is not what's expected.
    (
      pg.patron_group_code <> pg2.patron_group_code
    )
    -- Pick only students who haven't withdrawn.
    and reg.withdraw is null
    -- Pick only records that have expired.
    and p.expire_date <= sysdate
    -- Pick only records that have one active barcode. 
    and not exists 
    (
      SELECT * FROM ucladb.PATRON_BARCODE pb2 
      where 
        pb2.patron_id = p.patron_id 
        and pb2.patron_barcode_id <> pb.patron_barcode_id
        and pb2.barcode_status = 1
    )
    ;
  END;

  /*  The INSERT_EXTEND_EXP_REG_SIF procedure runs a query and adds Patron SIF 
      records to the PATRON_SIF table. The query gets patrons whose patron 
      group corresponds to faculty, staff, or students (types 1 through 4 from
      the patron_groups_components table), whose patron group in Voyager is 
      what's expected from Registrar data, who don't have multiple active 
      barcodes, and whose account has expired.

      Last revised: 2008-02-27 chunt
  */
  PROCEDURE INSERT_EXTEND_EXP_REG_SIF AS
  BEGIN
    insert into vger_report.PATRON_SIF 
    (sif_id, sif_record, created, type)
    SELECT 
    -- Identity field
    patron_sif_seq.nextval, 
    -- Call the function.
    vger_support.lws_patron.UPDATE_EXPIRATION
    (
      p.institution_id,
      pb.patron_barcode,
      pg.patron_group_code,
      pb.barcode_status,
      p.last_name,
      p.first_name,
      p.middle_name,
      perm_add.address_line1,
      perm_add.address_line2,
      perm_add.city,
      perm_add.STATE_PROVINCE,
      perm_add.ZIP_POSTAL,
      perm_add.COUNTRY,
      perm_phone_primary.phone_number,
      perm_phone_mobile.phone_number,
      perm_phone_fax.phone_number,
      perm_phone_other.phone_number,
      temp_add.address_line1,
      temp_add.address_line2,
      temp_add.city,
      temp_add.STATE_PROVINCE,
      temp_add.ZIP_POSTAL,
      temp_add.COUNTRY,
      temp_phone_primary.phone_number,
      temp_phone_mobile.phone_number,
      temp_phone_fax.phone_number,
      temp_phone_other.phone_number,
      temp_add.effect_date,
      temp_add.expire_date,
      temp_add.protect_address,
      email.address_line1,
      email.effect_date,
      email.expire_date,
      to_date('2019.01.31', 'YYYY.MM.DD')
    ),
    -- Date created
    sysdate, 
    -- Type - 10=extend expiration date
    10
    -- Start with registrar data.
    FROM vger_report.cmp_registrar reg
    -- Join with Voyager's patron table.
    inner join ucladb.patron p ON p.institution_id = reg.university_id
    -- Join with Voyager's patron_barcode table. Pick only active status barcodes.
    inner join ucladb.PATRON_BARCODE pb on pb.patron_id = p.patron_id and pb.barcode_status = 1
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg on pg.patron_group_id = pb.patron_group_id
    -- Join with Voyager's patron_group table.
    inner join ucladb.PATRON_GROUP pg2 on pg2.patron_group_code = lws_patron.GET_PATRON_GROUP(CAREER, CLASS, COLL1, DEG1, DEPT1, DIV1, RT340)
    -- Join with Voyager's patron_address table. Pick only permanent address records.
    inner join ucladb.PATRON_ADDRESS perm_add on perm_add.patron_id = p.patron_id and perm_add.address_type = 1
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE perm_phone_primary on perm_phone_primary.address_id = perm_add.address_id and perm_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE perm_phone_mobile on perm_phone_mobile.address_id = perm_add.address_id and perm_phone_primary.phone_type = 2
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE perm_phone_fax on perm_phone_fax.address_id = perm_add.address_id and perm_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE perm_phone_other on perm_phone_other.address_id = perm_add.address_id and perm_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only temporary address records.
    left outer join ucladb.PATRON_ADDRESS temp_add on temp_add.patron_id = p.patron_id and temp_add.address_type = 2
    -- Join with Voyager's patron_phone table for phone (primary).
    left outer join ucladb.PATRON_PHONE temp_phone_primary on temp_phone_primary.address_id = temp_add.address_id and temp_phone_primary.phone_type = 1
    -- Join with Voyager's patron_phone table for phone (mobile).
    left outer join ucladb.PATRON_PHONE temp_phone_mobile on temp_phone_mobile.address_id = temp_add.address_id and temp_phone_primary.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (fax).
    left outer join ucladb.PATRON_PHONE temp_phone_fax on temp_phone_fax.address_id = temp_add.address_id and temp_phone_fax.phone_type = 3
    -- Join with Voyager's patron_phone table for phone (other).
    left outer join ucladb.PATRON_PHONE temp_phone_other on temp_phone_other.address_id = temp_add.address_id and temp_phone_other.phone_type = 4
    -- Join with Voyager's patron_address table. Pick only e-mail address records.
    left outer join ucladb.PATRON_ADDRESS email on email.patron_id = p.patron_id and email.address_type = 3
    where 
    -- Pick only where group is what's expected.
    (
      pg.patron_group_code = pg2.patron_group_code
    )
    -- Pick only students who haven't withdrawn.
    and reg.withdraw is null
    -- Pick only records that have expired.
    and p.expire_date <= sysdate
    -- Pick only records that have one active barcode. 
    and not exists 
    (
      SELECT * FROM ucladb.PATRON_BARCODE pb2 
      where 
        pb2.patron_id = p.patron_id 
        and pb2.patron_barcode_id <> pb.patron_barcode_id
        and pb2.barcode_status = 1
    )
    ;
  END;
END;

/

  GRANT EXECUTE ON "VGER_SUPPORT"."LWS_PATRON" TO "VGER_REPORT";

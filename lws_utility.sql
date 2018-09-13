--------------------------------------------------------
--  File created - Tuesday-December-12-2017   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body LWS_UTILITY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "VGER_SUPPORT"."LWS_UTILITY" AS
	/*  The FIRST function takes an input string and an optional delimeter, parses
	  and returns the part of the string before the delimeter.

	  Last revised: 2006-08-24 chunt
	*/
	FUNCTION FIRST(p_input VARCHAR2,   p_delimiter VARCHAR2 DEFAULT ', ') RETURN VARCHAR2 AS p_output VARCHAR2(4000);
	BEGIN
	-- If the delimiter isn't in the string return the whole string.
	IF instr(p_input,   p_delimiter) = 0 THEN
	  p_output := p_input;
	-- Otherwise get what's before the delimiter.
	ELSE
	  p_output := RTRIM(SUBSTR(p_input,   0,   instr(p_input,   p_delimiter) -1));
	END IF;

	RETURN p_output;
	END;

	/*  The REST function takes an input string and an optional delimeter, parses
	  and returns the part of the string after the delimeter.

	  Last revised: 2006-08-24 chunt
	*/
	FUNCTION REST(p_input VARCHAR2,   p_delimiter VARCHAR2 DEFAULT ',') RETURN VARCHAR2 AS p_output VARCHAR(4000);
	BEGIN
	-- If the delimiter isn't in the string return null.
	IF instr(p_input,   p_delimiter) = 0 THEN
	  p_output := NULL;
	-- Otherwise get what's after the delimiter.
	ELSE
	  p_output := LTRIM(SUBSTR(p_input,   instr(p_input,   p_delimiter) + 1));
	END IF;

	RETURN p_output;
	END;

	/*	The COUNT_ONLY_ONE function takes two numerical parameters
		Returns 1 if either parameter is non-zero, otherwise zero
		Last revised: unknown chunt
	*/
	FUNCTION COUNT_ONLY_ONE(p_1 number, p_2 number) RETURN NUMBER AS v_output NUMBER(38,0);
	BEGIN
	IF p_1 <> 0 OR p_2 <> 0 THEN
	  v_output := 1;
	ELSE
	  v_output := 0;
	END IF;

	RETURN v_output;
	END;

	/*	split_list takes a string containing a delimited list, and an optional parameter with the delimiter (default is comma).
		Returns a pipelined table of strings from the list.  
		Sample usage:	SELECT * FROM TABLE(split_list('a, b, c'));
		or dynamic IN:	SELECT * FROM foo WHERE bar IN (SELECT column_value FROM TABLE(split_list('a, b, c')));
		Last revised: 2007-06-14 akohler
	*/
	FUNCTION split_list
	(	p_list		VARCHAR2
	,	p_delimiter	VARCHAR2 := ','
	) RETURN split_table pipelined
	IS
		v_idx	PLS_INTEGER;
		v_list	VARCHAR2(32767) := p_list;
		v_value	VARCHAR2(32767);
	BEGIN
		LOOP
			v_idx := InStr(v_list, p_delimiter);
			IF v_idx > 0 THEN
				pipe ROW(Trim(SubStr(v_list, 1, v_idx - 1)));
				v_list := SubStr(v_list, v_idx + Length(p_delimiter));
			ELSE
				pipe ROW(Trim(v_list));
				EXIT;
			END IF;
		END LOOP;
		RETURN;
	END split_list;

	/*	The PREV_FISCAL_YR_START function takes a date as input and 
                returns the start date of the previous whole fiscal year.
		Last revised: 20090924 akohler - now calls fiscal_year_start
	*/
/*	FUNCTION PREV_FISCAL_YR_START
        (
          p_input DATE
        ) RETURN DATE AS v_output DATE;
	BEGIN
          IF add_months(TRUNC(p_input, 'YEAR'), 6) <= p_input THEN
            v_output := add_months(TRUNC(p_input, 'YEAR'), -6);
          ELSE
            v_output := add_months(TRUNC(p_input, 'YEAR'), -18);
          END IF;
          RETURN v_output;
	END;
*/
  function prev_fiscal_yr_start (p_input date) return date as
  begin
    return add_months(fiscal_year_start(p_input), -12);
  end;
  
  /*  fiscal_year_start takes a date as input and returns the start date
        of the fiscal year that date is in.
      Last revised: 20090924 akohler
  */
  function fiscal_year_start (p_input date) return date as
    v_output date;
    v_month integer;
  begin
    -- UCLA fiscal year starts July 1st
    v_month := extract(month from p_input);
    v_output := trunc(p_input, 'MONTH');
    if (v_month >= 7) then
      v_output := add_months(v_output, (7 - v_month));
    else
      v_output := add_months(v_output, (7 - 12 - v_month));
    end if;
    return v_output;
  end;
  
	/*  The CURRENT_TERM function returns the current campus term
            according to whether student is semester or quarter track.

	  Last revised: 2012-02-02 drickard
	*/
  function CURRENT_TERM ( p_uid vger_report.cmp_registrar.university_id%TYPE )
  RETURN VARCHAR2 AS
    v_quarter VARCHAR2(3) := '17F';
    v_semester VARCHAR2(3) := '17F';
    v_career vger_report.cmp_registrar.career%TYPE := '';
    v_term VARCHAR2(3) := '';
  BEGIN
    SELECT career INTO v_career 
    FROM vger_report.cmp_registrar 
    WHERE university_id = p_uid;
    
    IF (v_career = 'L' OR v_career = 'M') THEN
      v_term := v_semester;
    ELSE
      v_term := v_quarter;
    END IF;
    
    RETURN v_term;
  END;
        --FUNCTION CURRENT_TERM
        --RETURN varchar2 AS 
	--BEGIN
        --	RETURN '12W';
	--END;

  /*  get_blanks returns a varchar2 containing p_count spaces (ascii 32)
      Last revised: 20090506 akohler
  */
  function get_blanks (p_count integer) return varchar2 as
    blanks varchar2(32767);
  begin
    return rpad(' ', p_count, ' ');
  end;

  /*  is_numeric tries to convert p_str to number.
      Returns the number if successful; null otherwise (not boolean since Oracle SQL queries
      can't handle boolean).
      Snagged from http://forums.oracle.com/forums/thread.jspa?threadID=356888
      Last revised: 20100503 akohler
  */
  function is_numeric (p_str in varchar2) return number as
    num number;
  begin
    num := to_number(p_str);
    return num;
  exception
    when others then
    return null;
  end;

  /*  pac_number_format returns a varchar2 containing p_number formatted for PAC usage.
      * Make number positive
      * Left-pad the number by prepending zero until there are p_left digits to the left of the decimal point
      * Right-pad the number by appending zero until there are p_right digits to the right of the decimal point
      * Remove the decimal point
      Last revised: 20090506 akohler
  */
  function pac_number_format(p_number number, p_left integer, p_right integer) return varchar2 as
    v_number number;
    pac_result varchar2(50);
    num_format varchar2(50);
  begin
    v_number := abs(p_number);
    num_format := 'FM' || rpad('0', p_left, '0') || 'D' || rpad('0', p_right, '0');
    pac_result := to_char(v_number, num_format);
    pac_result := replace(pac_result, '.');
    return pac_result;
  end;
END;

/

  GRANT EXECUTE ON "VGER_SUPPORT"."LWS_UTILITY" TO "UCLA_PREADDB";
  GRANT EXECUTE ON "VGER_SUPPORT"."LWS_UTILITY" TO PUBLIC;
  GRANT EXECUTE ON "VGER_SUPPORT"."LWS_UTILITY" TO "VGER_REPORT";

--------------------------------------------------------
--  File created - Tuesday-December-12-2017   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body LWS_VBBI
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "VGER_SUPPORT"."LWS_VBBI" as
  function build_z20 (p_voy_record voyager_record) return z20_record as
    z20 z20_record;
  begin
    z20.vendor_number := p_voy_record.vck;
    z20.invoice_number := p_voy_record.invoice_number;
    z20.invoice_date := to_char(p_voy_record.invoice_date, 'YYMMDD');
    -- not doing encumbrance release for now, so don't set po_reference
    --z20.po_reference := p_voy_record.po_reference;
    z20.po_reference := lws_utility.get_blanks(10);
    z20.invoice_total_amount := 0; --set by update_pac_record_totals
    z20.sales_tax_amount := 0; --set by update_pac_record_totals
    z20.discount_amount := 0; --set by update_pac_record_totals
    z20.voy_invoice_total := p_voy_record.voy_invoice_total;
    z20.invoice_due_date := to_char(p_voy_record.invoice_date + 25, 'YYMMDD');
    z20.line_1 := format_z20_line_1(z20);
    z20.line_2 := format_z20_line_2(z20);
    z20.line_3 := format_z20_line_3(z20);
    return z20;
  end build_z20;

  -- z20 delete record is special form of z20 record which instructs PAC to delete entire invoice
  function build_z20_delete_record (p_invoice_id integer) return z20_record as
    invoice_number char(23);
    vendor_number char(10);
    z20 z20_record;
  begin
    -- build regular z20, then modify as needed
    select i.invoice_number, v.institution_id
      into invoice_number, vendor_number
      from ucladb.invoice i
      inner join ucladb.vendor v on i.vendor_id = v.vendor_id
      where i.invoice_id = p_invoice_id;
    z20.invoice_number := invoice_number;
    z20.vendor_number := vendor_number;
    z20.line_1 := format_z20_line_1_for_delete(z20);
    return z20;
  end build_z20_delete_record;

  function build_z21 (p_voy_record voyager_record, p_line_number integer, p_line_code varchar2 := NULL) return z21_record as
    z21 z21_record;
  begin
    z21.vendor_number := p_voy_record.vck;
    z21.invoice_number := p_voy_record.invoice_number;
    z21.line_number := lws_utility.pac_number_format(p_line_number, 4, 0);
    z21.line_amount := abs(p_voy_record.amount);
    z21.description := p_voy_record.description;
    z21.fau_location := p_voy_record.fau_location;
    z21.fau_account := p_voy_record.fau_account;
    z21.fau_cost_center := p_voy_record.fau_cost_center;
    z21.fau_fund := p_voy_record.fau_fund;
    z21.fau_project := p_voy_record.fau_project;
    z21.fau_sub := p_voy_record.fau_sub;
    z21.fau_object := p_voy_record.fau_object;
    z21.fau_source := p_voy_record.fau_source;
    -- not doing encumbrance release for now, so don't set po_reference
    --z21.po_reference := p_voy_record.po_reference;
    z21.po_reference := lws_utility.get_blanks(10);
    z21.encumbrance_release := ' '; -- PLACEHOLDER one blank, until we start setting F/P for real releases

    -- Line codes: freight, handling, or credit/debit
    -- If negative, it's a CR (credit); otherwise, set it based on other info
    -- Credit or debit; 0 not allowed, filtered out by vbbi_voy_invoice_data view
    -- Limitation: negative amounts must be credits, which are incompatible with Shipping/Handling which must be ESH/TSH; see Footprints #24358
    if p_voy_record.amount < 0 then
      z21.line_code := 'CR';
    else
      case
        when p_voy_record.description in ('shipping charge', 'EX Freight')
          then z21.line_code := 'FT'; -- not taxable
        when p_voy_record.description like '%Shipping _ Handling' -- VR and regular
          -- Use passed value if present
          then z21.line_code := p_line_code;
        when p_voy_record.description in ('processing charge', 'VR processing charge')
          then z21.line_code := 'MAT'; -- taxable
        when p_voy_record.description = 'EX processing charge'
          then z21.line_code := 'SVS'; -- not taxable
        else
          z21.line_code := 'DR'; -- might be taxable
      end case;
    end if;

    -- Sales tax values; order of evaluation matters!
    case
      when p_voy_record.lib_tax_code = 'EX' or z21.line_code = 'FT' then -- no tax
        z21.sales_tax_code := 'E';
        z21.tax_rate_group_code := ' ';
      when p_voy_record.description like '%Shipping _ Handling' then -- Shipping and Handling gets split 80/20
        if z21.line_code = 'ESH' then -- Shipping portion (80%)
          z21.line_amount := z21.line_amount * 0.80;
          if p_voy_record.description like 'VR%' then -- tax to the vendor
            z21.sales_tax_code := 'T';
            z21.tax_rate_group_code := 'M';
          else -- no tax to the state - exempt
            z21.sales_tax_code := 'E';
            z21.tax_rate_group_code := ' ';
          end if;
        else -- Handling portion (20%)
          z21.line_amount := z21.line_amount * 0.20;
          if p_voy_record.description like 'VR%' then -- tax to the vendor
            z21.sales_tax_code := 'T';
            z21.tax_rate_group_code := 'M';
          else -- tax to the state
            z21.sales_tax_code := 'S';
            z21.tax_rate_group_code := 'M';
          end if;
        end if;
      when p_voy_record.lib_tax_code = 'VR' then -- tax to the vendor
        z21.sales_tax_code := 'T';
        z21.tax_rate_group_code := 'M';
      when upper(p_voy_record.description) like 'T% SPECIAL SALES TAX CODE' then -- special credit of tax to the state
        z21.line_code := 'CR';
        z21.sales_tax_code := 'E';
        z21.tax_rate_group_code := ' ';
        z21.fau_location := '4';
        z21.fau_account := get_special_tax_fund(p_voy_record.description);
        z21.fau_cost_center := lws_utility.get_blanks(2);
        z21.fau_fund := '18888';
        z21.fau_project := lws_utility.get_blanks(6);
        z21.fau_sub := lws_utility.get_blanks(2);
        z21.fau_object := lws_utility.get_blanks(4);
        --z21.fau_source := lws_utility.get_blanks(6);
        z21.fau_source := p_voy_record.fau_source;
      else -- tax to the state
        z21.sales_tax_code := 'S';
        z21.tax_rate_group_code := 'M';
    end case;

    z21.line_1 := format_z21_line_1(z21);
    z21.line_2 := format_z21_line_2(z21);
    z21.line_3 := format_z21_line_3(z21);
    return z21;
  end build_z21;

  function build_z25 (p_voy_record voyager_record) return z25_record as
    z25 z25_record;
  begin
    z25.vendor_number := p_voy_record.vck;
    z25.invoice_number := p_voy_record.invoice_number;
    z25.line_1 := format_z25(z25);
    return z25;
  end build_z25;

  function build_z41 (p_voy_record voyager_record, p_line_number integer) return z41_record as
    z41 z41_record;
  begin
    z41.vendor_number := p_voy_record.vck;
    z41.invoice_number := p_voy_record.invoice_number;
    z41.line_number := lws_utility.pac_number_format(p_line_number, 4, 0);
    z41.invoiced_amount := p_voy_record.amount;
    z41.fau_location := p_voy_record.fau_location;
    z41.fau_account := p_voy_record.fau_account;
    z41.fau_cost_center := p_voy_record.fau_cost_center;
    z41.fau_fund := p_voy_record.fau_fund;
    z41.fau_project := p_voy_record.fau_project;
    z41.fau_sub := p_voy_record.fau_sub;
    z41.fau_object := p_voy_record.fau_object;
    z41.fau_source := p_voy_record.fau_source;
    z41.line_1 := format_z41_line_1(z41);
    z41.line_2 := format_z41_line_2(z41);
    z41.line_3 := format_z41_line_3(z41);
    return z41;
  end build_z41;

  function format_z20_line_1(p_z20 z20_record) return varchar2 as
    card_number char(2) := '01';
  begin
    return  upper(
            p_z20.transaction_number
        ||  p_z20.screen_number
        ||  card_number
        ||  lws_utility.get_blanks(1)
        ||  p_z20.action_code
        ||  p_z20.vendor_number
        ||  p_z20.invoice_number
        ||  p_z20.invoice_date
        ||  p_z20.batch_sequence
        ||  p_z20.batch_number
        ||  p_z20.po_reference
        ||  p_z20.encumbrance_release
        ||  lws_utility.get_blanks(13)
    );
  end format_z20_line_1;

  function format_z20_line_1_for_delete(p_z20 z20_record) return varchar2 as
    card_number char(2) := '01';
    action_code char(1) := 'D';
  begin
    return  upper(
            p_z20.transaction_number
        ||  p_z20.screen_number
        ||  card_number
        ||  lws_utility.get_blanks(1)
        ||  action_code
        ||  p_z20.vendor_number
        ||  p_z20.invoice_number
        ||  lws_utility.get_blanks(38)
    );
  end format_z20_line_1_for_delete;

  function format_z20_line_2(p_z20 z20_record) return varchar2 as
    card_number char(2) := '02';
  begin
    return  upper(
            p_z20.transaction_number
        ||  p_z20.screen_number
        ||  card_number
        ||  lws_utility.get_blanks(1)
        ||  lws_utility.pac_number_format(p_z20.invoice_total_amount, 13, 2)
        ||  p_z20.invoice_type
        ||  lws_utility.pac_number_format(p_z20.sales_tax_amount, 13, 2)
        ||  p_z20.terms_code
        ||  lws_utility.pac_number_format(p_z20.discount_amount, 13, 2)
        ||  p_z20.invoice_due_date
        ||  p_z20.retention_amount
        ||  lws_utility.get_blanks(3)
    );
  end format_z20_line_2;

  function format_z20_line_3(p_z20 z20_record) return varchar2 as
    card_number char(2) := '03';
  begin
    return  upper(
            p_z20.transaction_number
        ||  p_z20.screen_number
        ||  card_number
        ||  lws_utility.get_blanks(1)
        ||  p_z20.adjustment_code
        ||  p_z20.income_reporting
        ||  p_z20.income_reporting_code
        ||  p_z20.hold_cycle
        ||  p_z20.reason
        ||  p_z20.release_code
        ||  p_z20.check_dist_code
        ||  p_z20.pck_segment
        ||  p_z20.po_control_key
        ||  p_z20.tax_state_code
        ||  lws_utility.get_blanks(45)
    );
  end format_z20_line_3;

  function format_z21_line_1(p_z21 z21_record) return varchar2 as
    card_number char(2) := '01';
  begin
    return  upper(
            p_z21.transaction_number
        ||  p_z21.screen_number
        ||  card_number
        ||  lws_utility.get_blanks(1)
        ||  p_z21.action_code
        ||  p_z21.vendor_number
        ||  p_z21.invoice_number
        ||  p_z21.line_number
        ||  p_z21.line_code
        ||  p_z21.quantity
        ||  p_z21.unit_price
        ||  lws_utility.get_blanks(1)
    );
  end format_z21_line_1;

  function format_z21_line_2(p_z21 z21_record) return varchar2 as
    card_number char(2) := '02';
  begin
    return  upper(
            p_z21.transaction_number
        ||  p_z21.screen_number
        ||  card_number
        ||  lws_utility.get_blanks(1)
        ||  lws_utility.pac_number_format(p_z21.line_amount, 13, 2)
        ||  p_z21.description
        ||  p_z21.sales_tax_code
        ||  p_z21.tax_rate_group_code
    );
  end format_z21_line_2;

  function format_z21_line_3(p_z21 z21_record) return varchar2 as
    card_number char(2) := '03';
  begin
    return  upper(
            p_z21.transaction_number
        ||  p_z21.screen_number
        ||  card_number
        ||  lws_utility.get_blanks(1)
        ||  p_z21.fau_location
        ||  p_z21.fau_account
        ||  p_z21.fau_cost_center
        ||  p_z21.fau_fund
        ||  p_z21.fau_project
        ||  p_z21.fau_sub
        ||  p_z21.fau_object
        --||  p_z21.fau_source
        ||  case when p_z21.fau_source = lws_utility.get_blanks(6) then p_z21.fau_source
              else lws_utility.pac_number_format(p_z21.fau_source, 6, 0)
            end
        ||  p_z21.po_reference
        ||  p_z21.uc_property_number
        ||  p_z21.fst_status_code
        ||  p_z21.po_line_number
        ||  p_z21.line_code
        ||  p_z21.encumbrance_release
        ||  lws_utility.get_blanks(5)
    );
  end format_z21_line_3;

  function format_z25 (p_z25 z25_record) return varchar2 as
  begin
    return  upper(
            p_z25.transaction_number
        ||  p_z25.screen_number
        ||  p_z25.card_number
        ||  lws_utility.get_blanks(1)
        ||  p_z25.action_code
        ||  p_z25.vendor_number
        ||  p_z25.invoice_number
        ||  p_z25.transaction_date
        ||  p_z25.insufficient_funds
        ||  lws_utility.get_blanks(31)
    );
  end format_z25;

  function format_z41_line_1 (p_z41 z41_record) return varchar2 as
    card_number char(2) := '01';
  begin
    return  upper(
            p_z41.transaction_number
        ||  p_z41.screen_number
        ||  card_number
        ||  lws_utility.get_blanks(1)
        ||  p_z41.action_code
        ||  p_z41.vendor_number
        ||  p_z41.invoice_number
        ||  lws_utility.get_blanks(30)
        ||  p_z41.line_number
        ||  lws_utility.get_blanks(4)
    );
  end format_z41_line_1;

  function format_z41_line_2 (p_z41 z41_record) return varchar2 as
    card_number char(2) := '02';
  begin
    return  upper(
            p_z41.transaction_number
        ||  p_z41.screen_number
        ||  card_number
        ||  lws_utility.get_blanks(1)
        ||  p_z41.invoiced_percent
        ||  p_z41.invoiced_quantity
        ||  lws_utility.pac_number_format(p_z41.invoiced_amount, 13, 2)
        ||  lws_utility.get_blanks(34)
    );
  end format_z41_line_2;

  function format_z41_line_3 (p_z41 z41_record) return varchar2 as
    card_number char(2) := '03';
  begin
    return  upper(
            p_z41.transaction_number
        ||  p_z41.screen_number
        ||  card_number
        ||  lws_utility.get_blanks(1)
        ||  p_z41.fau_location
        ||  p_z41.fau_account
        ||  p_z41.fau_cost_center
        ||  p_z41.fau_fund
        ||  p_z41.fau_project
        ||  p_z41.fau_sub
        ||  p_z41.fau_object
        --||  p_z41.fau_source
        ||  lws_utility.pac_number_format(p_z41.fau_source, 6, 0)
        ||  p_z41.po_reference
        ||  lws_utility.get_blanks(12)
        ||  p_z41.acct_eff_date
        ||  lws_utility.get_blanks(12)
    );
  end format_z41_line_3;

  function needs_line_item(p_voy_record voyager_record) return boolean as
    v_result boolean := false;
    v_description varchar2(100) := upper(p_voy_record.description);
  begin
    if p_voy_record.is_line_item = 'Y' then
      v_result := true;
    else
      if v_description like '%SHIPPING%'
        or v_description like '%FREIGHT%'
        or v_description like 'T% SPECIAL SALES TAX CODE'
        or v_description like '%DISCOUNT%'
        or v_description like '%PROCESSING CHARGE'
        or v_description like 'HANDLING ONLY'
      then
        v_result := true;
      end if;
    end if;
    return v_result;
  end needs_line_item;

  function is_taxable(p_z21 z21_record) return boolean as
    v_result boolean := false;
  begin
    if p_z21.sales_tax_code = 'T' then
      v_result := true;
    end if;
    return v_result;
  end is_taxable;

  function get_special_tax_fund(p_description varchar2) return char as
    v_fund_code char(6);
  begin
    case substr(p_description, 1, 2)
      when 'TA' then v_fund_code := '115523'; --0.25%
      when 'TB' then v_fund_code := '115522'; --0.50%
      when 'TC' then v_fund_code := '115524'; --0.75%
      when 'TD' then v_fund_code := '115521'; --1.00%
      when 'TE' then v_fund_code := '115529'; --1.25%
      when 'TF' then v_fund_code := '115528'; --1.50% in Voyager, but not explicitly supported by A/P so use default fund
      when 'TG' then v_fund_code := '115518'; --1.75%
      when 'TH' then v_fund_code := '115519'; --2.00%
      when 'TI' then v_fund_code := '115525'; --2.25%
      else v_fund_code := '115528';
    end case;
    return v_fund_code;
  end;

  function get_tax_rate(p_invoice_date varchar2) return number as
    rate number;
  begin
    --YYMMDD from Z20; not Y2K compliant, campus A/P doesn't care, assumes century is '20'
    case
      when p_invoice_date >= '171001' then rate := .0950;
      when p_invoice_date between '170701' and '170930' then rate := .0925;
      when p_invoice_date between '170101' and '170630' then rate := .0875;
      when p_invoice_date between '130101' and '161231' then rate := .0900;
      when p_invoice_date between '110701' and '121231' then rate := .0875;
      when p_invoice_date between '090701' and '110630' then rate := .0975;
      when p_invoice_date between '090401' and '090630' then rate := .0925;
      else rate := .0825;
    end case;
    return rate;
  end get_tax_rate;

  procedure update_pac_record_totals(p_invoice_id integer, p_voy_vendor_tax_amount number, p_pac_invoice in out pac_record, p_prod_mode boolean := TRUE) as
    line_amount number := 0;
    state_taxable_total number := 0;
    vendor_taxable_total number := 0;
    nontaxable_total number := 0;
    state_tax_credit number := 0;
    state_tax_amount number := 0;
    vendor_tax_amount number := 0;
    discount_total number := 0;
    vendor_invoice_total number := 0;
    payment_total number := 0;
    z20 z20_record;
    z21 z21_record;
  begin
    z20 := p_pac_invoice.z20;
    for z21_count in 1..p_pac_invoice.z21.count loop
      z21 := p_pac_invoice.z21(z21_count);
      if z21.line_code = 'CR' then
        line_amount := 0 - z21.line_amount;
        if z21.fau_fund = '18888' then
          state_tax_credit := state_tax_credit + abs(line_amount);
        end if;
      else
        line_amount := z21.line_amount;
      end if;
      case z21.sales_tax_code
        when 'S' then
          state_taxable_total := state_taxable_total + line_amount;
        -- We have no exceptions for vendor-taxable amounts
        when 'T' then vendor_taxable_total := vendor_taxable_total + line_amount;
        else nontaxable_total := nontaxable_total + line_amount;
      end case;
    end loop;
    state_tax_amount := state_taxable_total * get_tax_rate(z20.invoice_date);
    vendor_tax_amount := p_voy_vendor_tax_amount;
    vendor_invoice_total := state_taxable_total + vendor_taxable_total + nontaxable_total + vendor_tax_amount;
    payment_total := vendor_invoice_total + state_tax_amount + state_tax_credit;
    -- (D)ebit (we pay them) or (C)redit (they pay us) invoice
    if vendor_invoice_total >= 0 then
      z20.invoice_type := 'D';
    else
      z20.invoice_type := 'C';
    end if;
    z20.invoice_total_amount := vendor_invoice_total;
    z20.sales_tax_amount := vendor_tax_amount;
    z20.discount_amount := discount_total;
    z20.pac_invoice_total := round(payment_total, 2); -- not used for further calculations, not formatted for z20_line output later
    z20.line_2 := format_z20_line_2(z20);
    p_pac_invoice.z20 := z20;

-- for debugging
    if p_prod_mode = FALSE then
      dbms_output.put_line(p_invoice_id || ' *** discount *** ' || round(discount_total, 2));
      dbms_output.put_line(p_invoice_id || ' *** nontaxable *** ' || round(nontaxable_total, 2));
      dbms_output.put_line(p_invoice_id || ' *** taxable(state) *** ' || round(state_taxable_total, 2));
      dbms_output.put_line(p_invoice_id || ' *** taxable(vendor) *** ' || round(vendor_taxable_total, 2));
      dbms_output.put_line(p_invoice_id || ' *** tax credit *** ' || round(state_tax_credit, 2));
      dbms_output.put_line(p_invoice_id || ' *** tax(state) *** ' || round(state_tax_amount, 2));
      dbms_output.put_line(p_invoice_id || ' *** tax(vendor) *** ' || round(vendor_tax_amount, 2));
      dbms_output.put_line(p_invoice_id || ' *** total(vendor) *** ' || round(vendor_invoice_total, 2));
      dbms_output.put_line(p_invoice_id || ' *** total paid *** ' || round(payment_total, 2));
      dbms_output.put_line(p_invoice_id || ' *** voy total paid *** ' || round(z20.voy_invoice_total, 2));
    end if;
  end update_pac_record_totals;

  procedure store_log_record(p_invoice_id integer, p_message varchar2, p_amount number) as
  begin
    insert into vger_support.vbbi_log_data values (p_invoice_id, p_message, p_amount);
  end store_log_record;

  procedure store_pac_record(p_invoice_id integer, p_pac_invoice pac_record) as
    z21 z21_record;
    seq integer := 1;
  begin
    insert into vger_support.vbbi_pac_invoice_data (invoice_id, seq, line) values (p_invoice_id, seq, p_pac_invoice.z20.line_1);
    seq := seq + 1;
    insert into vger_support.vbbi_pac_invoice_data (invoice_id, seq, line) values (p_invoice_id, seq, p_pac_invoice.z20.line_2);
    seq := seq + 1;
    insert into vger_support.vbbi_pac_invoice_data (invoice_id, seq, line) values (p_invoice_id, seq, p_pac_invoice.z20.line_3);
    seq := seq + 1;
    for z21_count in 1..p_pac_invoice.z21.count loop
      z21 := p_pac_invoice.z21(z21_count);
      insert into vger_support.vbbi_pac_invoice_data (invoice_id, seq, line) values (p_invoice_id, seq, z21.line_1);
      seq := seq + 1;
      insert into vger_support.vbbi_pac_invoice_data (invoice_id, seq, line) values (p_invoice_id, seq, z21.line_2);
      seq := seq + 1;
      insert into vger_support.vbbi_pac_invoice_data (invoice_id, seq, line) values (p_invoice_id, seq, z21.line_3);
      seq := seq + 1;
      for z41_count in 1..z21.z41.count loop
        insert into vger_support.vbbi_pac_invoice_data (invoice_id, seq, line) values (p_invoice_id, seq, z21.z41(z41_count).line_1);
        seq := seq + 1;
        insert into vger_support.vbbi_pac_invoice_data (invoice_id, seq, line) values (p_invoice_id, seq, z21.z41(z41_count).line_2);
        seq := seq + 1;
        insert into vger_support.vbbi_pac_invoice_data (invoice_id, seq, line) values (p_invoice_id, seq, z21.z41(z41_count).line_3);
        seq := seq + 1;
      end loop;
    end loop;
    insert into vger_support.vbbi_pac_invoice_data (invoice_id, seq, line) values (p_invoice_id, seq, p_pac_invoice.z25.line_1);
  end store_pac_record;

  procedure store_z20_delete_record(p_invoice_id integer, p_z20_record z20_record) as
    seq integer := 0;
  begin
    insert into vger_support.vbbi_pac_invoice_data (invoice_id, seq, line) values (p_invoice_id, seq, p_z20_record.line_1);
  end store_z20_delete_record;

  procedure update_z21(p_z21 in out z21_record, p_line_amount number) as
  begin
    p_z21.line_amount := abs(p_line_amount);
    p_z21.fau_location := '';
    p_z21.fau_account := '';
    p_z21.fau_cost_center := '';
    p_z21.fau_fund := '';
    p_z21.fau_project := '';
    p_z21.fau_sub := '';
    p_z21.fau_object := '';
    p_z21.fau_source := '';
    p_z21.line_1 := format_z21_line_1(p_z21);
    p_z21.line_2 := format_z21_line_2(p_z21);
    p_z21.line_3 := format_z21_line_3(p_z21);
  end update_z21;

  procedure build_delete_invoices as
    cursor c_del_invoices is
      select invoice_id
      from vger_support.vbbi_delete_invoices
      where delivered = 'N'
      order by invoice_id
    ;
    invoice_id integer;
  begin
    open c_del_invoices;
    loop
      fetch c_del_invoices into invoice_id;
      exit when c_del_invoices%notfound;
      store_z20_delete_record(invoice_id, build_z20_delete_record(invoice_id));
    end loop;
    close c_del_invoices;
  end build_delete_invoices;

  procedure build_vbbi_file as
    cursor c_invoices is
      select distinct invoice_id
      from vger_support.vbbi_voy_invoice_data vvid
      where not exists (select * from vger_support.vbbi_pac_invoice_data where invoice_id = vvid.invoice_id)
      and not exists (select * from vger_support.vbbi_log_data where invoice_id = vvid.invoice_id)
      order by invoice_id
    ;
    invoice_id integer;
  begin
    open c_invoices;
    loop
      fetch c_invoices into invoice_id;
      exit when c_invoices%notfound;
      --dbms_output.put_line(invoice_id);
      build_invoice_data(invoice_id);
    end loop;
    close c_invoices;
  end build_vbbi_file;

  procedure build_invoice_data(p_invoice_id integer, p_prod_mode boolean := TRUE) as
    cursor c_voyager is
      select *
      from vger_support.vbbi_voy_invoice_data
      where invoice_id = p_invoice_id
      order by invoice_id, inv_line_item_id
    ;
    voy_record voyager_record;
    pac_invoice pac_record;
    voy_vendor_tax_amount number := 0;
    vendor_tax_difference number := 0;
    pac_invoice_total number := 0;
    voy_invoice_total number := 0;
    total_difference number := 0;
    line_amount_total number := 0;
    line_percent_total integer := 0;
    line_number integer := 1;
    z41_number integer := 1;
  begin
    open c_voyager;
    loop
      fetch c_voyager into voy_record;
      exit when c_voyager%notfound;

      if needs_line_item(voy_record) then
        if pac_invoice.z21.exists(line_number) = false then
          if voy_record.description like '%Shipping _ Handling' then -- VR or regular
            pac_invoice.z21(line_number) := build_z21(voy_record, line_number, 'ESH');
            line_number := line_number + 1;
            pac_invoice.z21(line_number) := build_z21(voy_record, line_number, 'TSH');
          else
            pac_invoice.z21(line_number) := build_z21(voy_record, line_number);
          end if;
        end if;

        if voy_record.percentage >= 100 then
          line_number := line_number + 1;
        else
          pac_invoice.z21(line_number).z41(z41_number) := build_z41(voy_record, line_number);
          z41_number := z41_number + 1;
          line_amount_total := line_amount_total + voy_record.amount;
          line_percent_total := line_percent_total + voy_record.percentage;
          if line_percent_total = 100 then
            update_z21(pac_invoice.z21(line_number), line_amount_total);
            line_amount_total := 0;
            line_percent_total := 0;
            z41_number := 1;
            line_number := line_number + 1;
          end if;
        end if;
      end if;
      -- Capture vendor-related tax amounts, regardless of whether line item is created
      if voy_record.description = 'VR vendor sales tax code' or voy_record.description like '%special sales tax code' then
        voy_vendor_tax_amount := voy_vendor_tax_amount + voy_record.amount;
      end if;

    end loop;
    pac_invoice.z20 := build_z20(voy_record);
    pac_invoice.z25 := build_z25(voy_record);
    close c_voyager;
    update_pac_record_totals(p_invoice_id, voy_vendor_tax_amount, pac_invoice, p_prod_mode);
    vendor_tax_difference := round(abs(pac_invoice.z20.sales_tax_amount - voy_vendor_tax_amount), 2);
    if vendor_tax_difference != 0 then
      if p_prod_mode = TRUE then
        store_log_record(p_invoice_id, 'Vendor tax difference', vendor_tax_difference);
      else
        dbms_output.put_line(p_invoice_id || ' *** Vendor tax difference *** ' || vendor_tax_difference);
      end if;
    end if;
    pac_invoice_total := pac_invoice.z20.pac_invoice_total;
    voy_invoice_total := pac_invoice.z20.voy_invoice_total;
    if pac_invoice_total = voy_invoice_total then
      if p_prod_mode = TRUE then
        store_pac_record(p_invoice_id, pac_invoice);
      else
        dbms_output.put_line(p_invoice_id || ' *** PAC record would be stored ***');
      end if;
    else
      total_difference := abs(pac_invoice_total - voy_invoice_total);
      if total_difference <= 0.10 then
        if p_prod_mode = TRUE then
          store_log_record(p_invoice_id, 'Rounding difference within threshold', total_difference);
          store_pac_record(p_invoice_id, pac_invoice);
        else
          dbms_output.put_line(p_invoice_id || ' *** Rounding difference within threshold *** ' || total_difference);
        end if;
      else
        if p_prod_mode = TRUE then
          store_log_record(p_invoice_id, 'ERROR (amount mismatch) - rejected', total_difference);
        else
          dbms_output.put_line(p_invoice_id || ' *** ERROR (amount mismatch) - rejected *** ' || total_difference);
          dbms_output.put_line(p_invoice_id || ' *** PAC RECORD STORED FOR REVIEW IN VBBI_PAC_INVOICE_DATA - REVIEW AND DELETE ***');
          store_pac_record(p_invoice_id, pac_invoice);
        end if;
      end if;
    end if;
  end build_invoice_data;

  procedure reset_invoice(p_invoice_id integer) as
    invoice_num vger_support.vbbi_voy_invoice_data.invoice_number%type;
    z20d_required vger_support.vbbi_batch_errors.z20d_required%type;
    cnt integer := 0;
  begin
    -- will throw NO_DATA_FOUND if invoice_id doesn't exist, which is good to know
    select distinct invoice_number into invoice_num from vger_support.vbbi_voy_invoice_data where invoice_id = p_invoice_id;
    -- may throw NO_DATA_FOUND if no vbbi batch errors, which is possible and valid, so test count first
    select count(*) into cnt from vger_support.vbbi_batch_errors where invoice_number = invoice_num;
    if (cnt > 0) then
      -- z20d_required is Y or N; some invoices can have multiple errors, some requiring deletion
      -- max(z20d_required) returns Y if any Y exist, otherwise N
      select max(z20d_required) into z20d_required from vger_support.vbbi_batch_errors where invoice_number = invoice_num;
      if (z20d_required = 'Y') then
        insert into vger_support.vbbi_delete_invoices (invoice_id, invoice_number)
          values (p_invoice_id, invoice_num);
      end if;
    end if;
    delete from vger_support.vbbi_batch_errors where invoice_number = invoice_num;
    delete from vger_support.vbbi_log_data where invoice_id = p_invoice_id;
    delete from vger_support.vbbi_pac_invoice_data where invoice_id = p_invoice_id;
    commit;
    exception
      -- rethrow so we know about it; occurs before any insert/delete can occur
      when NO_DATA_FOUND or TOO_MANY_ROWS then
        raise;
      when others then
        rollback;
        raise;
    -- end of exception block
  end reset_invoice;

end lws_vbbi;

/

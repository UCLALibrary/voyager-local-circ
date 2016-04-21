SELECT DISTINCT
  e.employee_id
, e.emp_first_name
, e.emp_middle_name
, e.emp_last_name
, e.email_addr
, e.work_addr_line1
, e.work_addr_line2
, e.campus_mail_code
, e.campus_phone
, e.work_addr_city
, e.work_addr_state
, e.work_addr_zip
, e.home_dept_code
, case 
  when
  (
    select count(*) from tbl_emp_appt ea 
      where e.employee_id = ea.employee_id and ea.appt_type = '5'
  ) > 0 and
  (
    (
      select count(*) from tbl_emp_appt ea inner join employee_title et
        on ea.title_code = et.title_code and e.employee_id = ea.employee_id and 
        (
          et.ttl_job_title like '%PROFESSOR%' or 
          et.ttl_job_title like '%LECTURER%' or 
          et.ttl_job_title like '%EMERITUS%' or 
          et.ttl_job_title like '%POSTGRADUATE%' or 
          et.ttl_job_title like '%POSTDOCTORAL%'
        )
    ) > 0 or
    (
      select max(ttl_acad_rank_code) from tbl_emp_appt ea inner join employee_title et
        on ea.title_code = et.title_code and e.employee_id = ea.employee_id) > 0
    )
    then 4
    when
    (
      select count(*) from tbl_emp_appt ea inner join employee_title et 
        on ea.title_code = et.title_code and e.employee_id = ea.employee_id
        where e.employee_id = ea.employee_id and ea.appt_type = '5' and
        et.ttl_job_title not like '%NON-GSHIP%'
    ) > 0
    then 3
    else 1
    end type
, case
  when
  (
    select count(*) from tbl_emp_appt ea where e.employee_id = ea.employee_id and 
      (
        ea.appt_dept_code = '0250' or 
        ea.appt_dept_code = '5445' or 
        ea.appt_dept_code = '5446'
      )
  ) > 0
  then 1
  else 0
  end law
FROM tbl_emp e
WHERE 
e.emp_status <> 'I'
AND e.emp_status <> 'S'
--A Active
--I Inactive
--N leave without pay
--P leave with pay
--S Separated
ORDER BY e.employee_id
GO

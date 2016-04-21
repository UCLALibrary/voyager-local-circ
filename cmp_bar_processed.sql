var today varchar2(10);
exec :today := to_char(sysdate, 'YYYY.MM.DD');
update vger_report.CMP_BAR set processed = to_date(:today, 'YYYY.MM.DD') where processed is null;


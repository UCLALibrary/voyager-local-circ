select 
  pn.patron_note_id
from 
  ucladb.patron_notes pn
where 
  note like 'Automated suspension: % in BAR'
;

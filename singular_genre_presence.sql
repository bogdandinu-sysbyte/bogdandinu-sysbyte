 
 
 -------------function to concatenate genre with a single presence  
 create or replace function f_test (p_string in varchar2)
   return varchar
   is
     l_output_string varchar2(4000) :='';
   begin
   FOR X IN (
     with data_rows  as
     (
     select
       trim( substr (txt,
             instr (txt, ',', 1, level  ) + 1,
             instr (txt, ',', 1, level+1)
                - instr (txt, ',', 1, level) -1 ) )
         as token
       from (select ','||p_string||',' txt
               from dual)
     connect by level <=
        length(p_string)-length(replace(p_string,',',''))+1
     )
    SELECT distinct * FROM data_rows)
   LOOP
     l_output_string :=l_output_string||', '||x.token;
   END LOOP;
   return substr(l_output_string,3);
  END;
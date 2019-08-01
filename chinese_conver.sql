BEGIN
DECLARE str1 VARCHAR(4);
DECLARE return_str VARCHAR(255) character set gbk DEFAULT '' ; 
	DECLARE done int DEFAULT false;
    DECLARE tmp_fee varchar(40);
    DECLARE total varchar(40);
    DECLARE nnn int default 1;
    
    DECLARE curs CURSOR for SELECT fee FROM bill;
    DECLARE CONTINUE HANDLER for not found set done = true;
    
    open curs;
    FETCH curs into tmp_fee;

    WHILE not done DO
    set nnn=1;
    SET return_str='';
        WHILE nnn < LENGTH(tmp_fee) + 1  DO 
    	set str1 =  SUBSTRING(tmp_fee,  nnn, 1  );
        CASE str1
    WHEN '1' THEN SET str1 ="一"; 
    WHEN '2' THEN SET str1 ="二"; 
    WHEN '3' THEN SET str1 ="三"; 
    WHEN '4' THEN SET str1 ="四"; 
    WHEN '5' THEN SET str1 ="五"; 
    WHEN '6' THEN SET str1 ="六"; 
    WHEN '7' THEN SET str1 ="七"; 
    WHEN '8' THEN SET str1 ="八"; 
    WHEN '9' THEN SET str1 ="九"; 
	WHEN '0' THEN SET str1 ="零";
    END CASE;
        SET nnn = nnn + 1 ;
        SET return_str = CONCAT(return_str,str1); 
        UPDATE bill set `中文` = return_str where `fee`=tmp_fee;
        
        end while;
        
     /*   SELECT return_str;*/
        FETCH curs into tmp_fee;
     /*   UPDATE bill set `中文` = return_str where 1; */
        
        end while;
        
        close curs;
        
    end
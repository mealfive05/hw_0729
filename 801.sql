trigger通常用來紀錄log
有建trigger一定要寫文件


CREATE TRIGGER `tr_log_userinfo_update` AFTER UPDATE ON `userinfo` FOR EACH ROW begin set @body = concat('將[', old.uid, ', ', old.cname, '修改成',new.uid, ', ', new.cname, ']' ); insert into log (body) values (@body); END


create TRIGGER tr_userinfo_update before UPDATE
on userinfo for EACH ROW

begin 
	set @count=if(@count is NULL,1,(@count+1));
    if @count>1 THEN
    SIGNAL SQLSTATE '123456' set MESSAGE_TEXT='stop!!!';
    end IF
    END;


-------預存程序
DELIMITER $$

CREATE PROCEDURE live_where(location varchar(20))
BEGIN
	SELECT * FROM vw_user where address like concat(location,'%');
end $$

---------變數宣告
set @n =(SELECT COUNT(*) FROM bill);
SELECT @n
---------上下兩句同等
SELECT @n := COUNT(*) FROM userinfo;
SELECT @n



----- ROLLBACK OR COMMIT
DELIMITER $$ CREATE PROCEDURE pro_name()
begin 
--  declare exit handler for sqlexception (select 'ERROR'; 錯誤時還能做事情)    例外處理
    declare _rollback bool default false;
    declare continue handler for sqlexception set _rollback = true;

    start transaction;
        
        insert into userinfo(uid) values ('A01');
        UPDATE userinfo set cname = '豬小妹' where uid ='A04';
        if _rollback THEN 
            select 'rollback!' 
            rollback;
        else
        select 'commit!'
        commit;
        end if;
END $$




DELIMITER $$

CREATE PROCEDURE pro_test()
BEGIN
	DECLARE done int DEFAULT false;
    DECLARE tmp_fee int;
    DECLARE total int DEFAULT 0;
    DECLARE curs CURSOR for SELECT fee FROM bill;
    DECLARE CONTINUE HANDLER for not found set done = true;
    
    open curs;
    FETCH curs into tmp_fee;
    
    WHILE not done DO
    	set total = total+tmp_fee;
        FETCH curs into tmp_fee;
        end while;
        
        close curs;
        SELECT total;
    end $$


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
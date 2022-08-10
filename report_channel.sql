 

 
  exec  report_channel_package.Insert_report(1, 3, 'type','text');
  exec  report_channel_package.Update_report(21,1);
  exec  report_channel_package.Delete_report(2);
  exec  report_channel_package.Get_All_Reports();
  exec  report_channel_package.Get_All_channel_Reports(3);
  exec  report_channel_package.Filter_By_Type('type');
  exec  report_channel_package.Count_Channel_Report(3);
  exec  report_channel_package.Get_Channel_report_info(21);
 
 select * from REPORT_CHANNEL;


CREATE or REPLACE PACKAGE report_channel_package IS

    PROCEDURE Insert_report(p_user_id int, p_channel_id int, p_report_type varchar2,
    p_report_text varchar2);
    PROCEDURE Update_report(p_rid int, p_is_accept int);
    PROCEDURE Delete_report(p_rid int);
    PROCEDURE Get_All_Reports(p_limit int := 0, p_count int := 100);
    PROCEDURE Get_All_channel_Reports(p_channel_id int);
    PROCEDURE Filter_By_Type(p_type varchar2);
    PROCEDURE Count_Channel_Report(p_channel_id int);
    PROCEDURE Get_Channel_report_info(p_rid int);
 
    

END report_channel_package;



--body of the package
CREATE or REPLACE PACKAGE body  report_channel_package IS

 PROCEDURE Insert_report(p_user_id int, p_channel_id int, p_report_type varchar2,
    p_report_text varchar2) is 
    BEGIN
        insert into report_channel values (DEFAULT,p_user_id, p_channel_id,
         p_report_type, p_report_text, default);
          commit;
    END;
   
     PROCEDURE Update_report(p_rid int, p_is_accept int) is
    BEGIN
        update report_channel set is_accept = p_is_accept where id = p_rid;
        commit;
    END;

    PROCEDURE Delete_report(p_rid int) is
    BEGIN
        delete from report_channel where id = p_rid;
        commit;
    END;

    PROCEDURE Get_All_Reports(p_limit int :=0, p_count int := 100) is
       c_all sys_refcursor;
    BEGIN
       open c_all for
        SELECT
        ch.username,count(*)
        FROM
        channel ch 
        INNER JOIN REPORT_CHANNEL r on ch.id=r.channel_id
        group by ch.username
        OFFSET p_limit ROWS FETCH NEXT p_count ROWS ONLY;
        DBMS_SQL.RETURN_RESULT(c_all);
    END;

    PROCEDURE Get_All_channel_Reports(p_channel_id int) is
    c_all sys_refcursor;
    BEGIN
        open c_all for
        select r.id,ch.username,r.type,r.is_accept  
        from report_channel r
        INNER JOIN channel ch on r.channel_id = ch.id
        where r.channel_id = p_channel_id 
        order by r.id desc;
        DBMS_SQL.RETURN_RESULT(c_all);
    END;

    PROCEDURE Filter_By_Type(p_type varchar2) is
      c_all sys_refcursor;
    BEGIN
        open c_all for
        select r.id,ch.username,r.type,r.is_accept  
        from report_channel r 
        INNER JOIN channel ch on r.channel_id = ch.id
        where r.type = p_type
        order by r.id desc;
        DBMS_SQL.RETURN_RESULT(c_all);
    END;

    PROCEDURE Count_Channel_Report(p_channel_id int) is
    c_all sys_refcursor;
    BEGIN
        open c_all for
        select count(*) from report_channel where channel_id = p_channel_id And IS_ACCEPT=1;
        DBMS_SQL.RETURN_RESULT(c_all);
    END;


    PROCEDURE Get_Channel_report_info(p_rid int) is
    c_all sys_refcursor;
    BEGIN
        open c_all for
        select r.*,ch.username,ch.owner_id,ch.image_path,u.first_name,u.last_name,u.image_path,u.login_id
        from REPORT_CHANNEL r
        inner join users u on r.user_id = u.id
        inner join channel ch on r.channel_id = ch.id
        where r.id = p_rid; 
        DBMS_SQL.RETURN_RESULT(c_all);
    
    END;
    
    
END report_channel_package;



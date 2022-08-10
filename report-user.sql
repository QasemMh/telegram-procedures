 
  exec  report_user_package.Insert_report(24, 22, 'type','text');
  exec  report_user_package.Update_report(5,1);
  exec  report_user_package.Delete_report(7);
  exec  report_user_package.Get_All_Reports();
  exec  report_user_package.Get_All_user_Reports(22);
  exec  report_user_package.Filter_By_Type('type');
  exec  report_user_package.Count_user_Report(24);
  exec  report_user_package.Get_user_report_info(5);
  
 select * from report_user;
 
 



CREATE or REPLACE PACKAGE report_user_package IS

    PROCEDURE Insert_report(p_user_from int, p_user_to int, p_report_type varchar2,
    p_report_text varchar2);
    PROCEDURE Update_report(p_rid int, p_is_accept int);
    PROCEDURE Delete_report(p_rid int);
    PROCEDURE Get_All_Reports(p_limit int := 0, p_count int := 100);
    PROCEDURE Get_All_user_Reports(p_user_to int);
    PROCEDURE Filter_By_Type(p_type varchar2);
    PROCEDURE Count_user_Report(p_user_to int);
    PROCEDURE Get_user_report_info(p_rid int);
 
    

END report_user_package;




--body of the package
CREATE or REPLACE PACKAGE body  report_user_package IS

    PROCEDURE Insert_report(p_user_from int, p_user_to int, p_report_type varchar2,
    p_report_text varchar2) is 
    BEGIN
        insert into report_user values (DEFAULT,p_user_from, p_user_to,
         p_report_type, p_report_text, default);
          commit;
    END;
   
    PROCEDURE Update_report(p_rid int, p_is_accept int) is
    BEGIN
        update report_user set is_accept = p_is_accept where id = p_rid;
        commit;
    END;

    PROCEDURE Delete_report(p_rid int) is
    BEGIN
        delete from report_user where id = p_rid;
        commit;
    END;

    PROCEDURE Get_All_Reports(p_limit int :=0, p_count int := 100) is
       c_all sys_refcursor;
    BEGIN
        open c_all for
        select l.username,count(*)
        from REPORT_USER r
        inner join users u on u.id=r.user_to
        inner join login l on l.id=u.login_id
        group by l.username 
        OFFSET p_limit ROWS FETCH NEXT p_count ROWS ONLY;
        DBMS_SQL.RETURN_RESULT(c_all);
    END;

 
    PROCEDURE Get_All_user_Reports(p_user_to int) is
    c_all sys_refcursor;
    BEGIN
        open c_all for
        select r.id,l.username,u.first_name,u.last_name,r.type,r.is_accept
        from REPORT_USER r
        inner join users u on u.id=r.user_to
        inner join login l on l.id=u.login_id
        where r.user_to = p_user_to
        order by r.id desc;
        DBMS_SQL.RETURN_RESULT(c_all);
    END;

    PROCEDURE Filter_By_Type(p_type varchar2) is
      c_all sys_refcursor;
    BEGIN
        open c_all for
        select r.id,l.username,u.first_name,u.last_name,r.type,r.is_accept
        from REPORT_USER r
        inner join users u on u.id=r.user_to
        inner join login l on l.id=u.login_id
        where r.type = p_type
        order by r.id desc;
        DBMS_SQL.RETURN_RESULT(c_all);
    END;

    PROCEDURE Count_user_Report(p_user_to int) is
    c_all sys_refcursor;
    BEGIN
        open c_all for
        select count(*) from report_user where user_to = p_user_to And IS_ACCEPT=1;
        DBMS_SQL.RETURN_RESULT(c_all);
    END;


    PROCEDURE Get_user_report_info(p_rid int) is
    c_all sys_refcursor;
    BEGIN
        open c_all for
        select r.id,l.username as "userNameFrom",(u.first_name || ' ' || u.last_name) as "FullNameFrom",
        u.login_id as "loginIdFrom", ll.username as "userNameTo",
        (uu.first_name || ' ' ||uu.last_name) as "FullNameTo",uu.login_id as "LoginIdTo"
        ,r.type,r.description,r.is_accept
        from REPORT_USER r
        inner join users u on u.id=r.user_from
        inner join users uu on uu.id=r.user_to
        inner join login l on l.id=u.login_id
        inner join login ll on ll.id=uu.login_id
        where r.id = p_rid; 
        DBMS_SQL.RETURN_RESULT(c_all);
    END;
    
    
END report_user_package;



  

 

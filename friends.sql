 
 select * from friends;

 exec Friends_Package.InsertFriendRequest(22,24);
 exec Friends_Package.DeleteFriendship(22,24);
 exec Friends_Package.DeleteFriendRequest(22,24);
 exec Friends_Package.AcceptFriendRequest(22,24);
 exec Friends_Package.GetUserFriends(24);
 exec Friends_Package.GetFriendship(22,24);
 exec Friends_Package.HasFriendship(22,24);
 exec Friends_Package.HeSent(22,24);
 

CREATE OR REPLACE PACKAGE Friends_Package AS

--0: pending, 1: accepted, 2: rejected
PROCEDURE InsertFriendRequest(userFrom int, userTo int);
PROCEDURE DeleteFriendship(userFrom int, userTo int);
PROCEDURE DeleteFriendRequest(userFrom int, userTo int);
PROCEDURE AcceptFriendRequest(userFrom int, userTo int);
PROCEDURE GetUserFriends(userFrom int);
PROCEDURE GetFriendship(userFrom int, userTo int);
PROCEDURE HasFriendship(userFrom int, userTo int);
PROCEDURE HeSent(userFrom int, userTo int);

END Friends_Package;
 

-- BODY

CREATE OR REPLACE PACKAGE body Friends_Package AS

PROCEDURE DeleteFriendship(userFrom int, userTo int) is
BEGIN
    DELETE FROM Friends 
    WHERE  (user_from = userFrom AND user_to=userTo) OR (user_from = userTo AND user_to=userFrom);
    commit;
END;

PROCEDURE DeleteFriendRequest(userFrom int, userTo int) is
BEGIN
    update friends 
    set status = 2
    where (user_from = userFrom AND user_to=userTo) OR (user_from = userTo AND user_to=userFrom);
      commit;
END;

PROCEDURE AcceptFriendRequest(userFrom int, userTo int) is
BEGIN
    update friends 
    set status = 1
    where (user_from = userFrom AND user_to=userTo) OR (user_from = userTo AND user_to=userFrom);
    commit;
END;

PROCEDURE GetUserFriends(userFrom int) is
c_all sys_refcursor;
BEGIN
    open c_all for
    select u.id,u.first_name,u.middle_name,u.last_name,u.image_path,u.login_id,
            f.created_at 
            from friends f
            inner join users u on (u.id=f.user_to OR u.id = f.user_from)
            where (userFrom=f.user_to OR userFrom = f.user_from) and f.status=1
            order by f.created_at desc;
                 DBMS_SQL.RETURN_RESULT(c_all);
END;

PROCEDURE InsertFriendRequest(userFrom int, userTo int) is
BEGIN
    insert into friends (user_from,user_to,status) values (userFrom,userTo,0);
commit;
END;

PROCEDURE GetFriendship(userFrom int, userTo int) is
c_all sys_refcursor;
BEGIN
    open c_all for
    select status,created_at from friends
     where (user_from = userFrom AND user_to=userTo) 
     OR (user_from = userTo AND user_to=userFrom);
     DBMS_SQL.RETURN_RESULT(c_all);
END;

PROCEDURE HasFriendship(userFrom int, userTo int) IS
c_all sys_refcursor;
BEGIN
    open c_all for
    select count(*) from friends
     where (user_from = userFrom AND user_to=userTo) 
     OR (user_from = userTo AND user_to=userFrom);
     DBMS_SQL.RETURN_RESULT(c_all);
END;
 
PROCEDURE HeSent(userFrom int, userTo int) IS
c_all sys_refcursor;
BEGIN
    open c_all For
    select count(*) from friends 
    where user_from = userFrom and user_to=userTo and status = 0;
    DBMS_SQL.RETURN_RESULT(c_all);
END;

END Friends_Package;

 






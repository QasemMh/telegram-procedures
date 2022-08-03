
CREATE OR REPLACE PACKAGE Friends_Package AS

--0: pending, 1: accepted, 2: rejected
PROCEDURE DeleteFriendship(userFrom int, userTo int);
PROCEDURE DeleteFriendRequest(userFrom int, userTo int);
PROCEDURE AcceptFriendRequest(userFrom int, userTo int);
PROCEDURE GetUserFriends(userFrom int);
PROCEDURE InsertFriendRequest(userFrom int, userTo int);


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
            where (userFrom=f.user_to OR userFrom = f.user_from) and f.status=1;
END;

PROCEDURE InsertFriendRequest(userFrom int, userTo int) is
BEGIN
update friends set status=1;
END;


END Friends_Package;










/*
PROCEDURE CountReportChannelReject;
PROCEDURE ReportChannelReject;
PROCEDURE CountReportChannelReject;
PROCEDURE ReportChannelReject;
PROCEDURE CountReportChannelAccept;
PROCEDURE ReportChannelAccept;
PROCEDURE FilterChannelReportByType(T_R_CH in varchar);
PROCEDURE CountReportPost;
PROCEDURE ReportPostAndInfo(P_id in int);
*/



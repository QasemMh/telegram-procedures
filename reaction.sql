
/*
*the reaction table has been edited*


*/

exec Reaction_Package.InsertReaction(1,1,1);
exec Reaction_Package.DeleteReaction(1,1);
exec Reaction_Package.GetPostReactions(1);
exec Reaction_Package.UpdateReaction(1,1,1);

select * from reaction;

create or replace PACKAGE Reaction_Package AS

procedure InsertReaction (ruserId int, rpostId int, isReact number);
procedure UpdateReaction (ruserId int, rpostId int, isReact number);
procedure DeleteReaction(ruserId int, rpostId int);
procedure GetPostReactions(postId int);
 
 -- add PROCEDURE to get user reaction (all reaction)

END Reaction_Package;

 
 


--Create a new Package Body

CREATE or REPLACE PACKAGE BODY Reaction_Package IS
 procedure InsertReaction (ruserId int, rpostId int,  isReact number)   IS
    BEGIN
    INSERT INTO reaction values(default, ruserId, rpostId, isReact);
    COMMIT;
    END;
 
procedure DeleteReaction(ruserId int, rpostId int)  IS
    BEGIN
     DELETE FROM reaction where user_id = ruserId AND post_id=rpostId;
     commit;
    END;
 
procedure UpdateReaction (ruserId int, rpostId int, isReact number) IS
BEGIN
    UPDATE reaction SET is_react = isReact where user_id = ruserId AND post_id=rpostId;
    commit;
END;


procedure GetPostReactions(postId int)  IS
    c_all sys_refcursor;
    BEGIN
       open c_all for
       SELECT r.user_id,u.first_name,u.middle_name,u.last_name,u.image_path,u.login_id,
       r.post_id, r.is_react
       from users u
       inner join reaction r
       on r.user_id=u.id
       where r.post_id = postId AND r.is_react = 1;
       DBMS_SQL.RETURN_RESULT(c_all);
    END;
 

END Reaction_Package;

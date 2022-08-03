
exec Comments_Package.GetComment(3);
exec Comments_Package.InsertComment(1,1,'comment 22');
exec Comments_Package.UpdateComment(1,'comment 222');
exec Comments_Package.DeleteComment(1);
exec Comments_Package.GetPostComments(1);

-- add PROCEDURE to get user comments (all comments)

create or replace package Comments_Package 
as

procedure GetComment(cid int);
procedure InsertComment (cuserId int, cpostId int, ccontent varchar2);
procedure UpdateComment(cid int, ccontent varchar2);
procedure DeleteComment(cid int);
procedure GetPostComments(postId int);


end Comments_Package;


create or replace package body Comments_Package as

procedure GetComment(cid int) as
c_all sys_refcursor;
begin
open c_all for
select c.user_id ,u.first_name,u.middle_name,u.last_name,u.image_path,u.login_id,
       c.post_id,c.content,c.created_at
       from users u
       inner join comments c
       on c.user_id=u.id
       where c.id = cid;
DBMS_SQL.RETURN_RESULT(c_all);
end;

procedure InsertComment (cuserId int, cpostId int, ccontent varchar2) as
begin
insert into comments values(default, cuserId, cpostId, ccontent, default); 
commit;
end;
procedure UpdateComment(cid int, ccontent varchar2) as
begin
update comments 
set content = ccontent, created_at = CURRENT_TIMESTAMP
where id=cid;
commit;
end;
procedure DeleteComment(cid int) as
begin
delete from comments where id=cid;
commit;
end;
procedure GetPostComments(postId int) as
c_all sys_refcursor;
begin
open c_all for
select c.user_id,u.first_name,u.middle_name,u.last_name,u.image_path,u.login_id,
       c.post_id,c.content,c.created_at
       from users u
       inner join comments c
       on c.user_id=u.id
       where c.post_id = postId;
DBMS_SQL.RETURN_RESULT(c_all);
end;


 

end Comments_Package;



 


 












 
 


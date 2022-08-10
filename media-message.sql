 

create or REPLACE PACKAGE Package_media_message as
PROCEDURE media_message_insert( p_file_path VARCHAR2, p_caption VARCHAR2,p_message_id int);
procedure MEDIA_MESSAGE_DELETE(p_id int); 
procedure Get_All_message_media(p_message_id int);
end Package_media_message;


create or REPLACE PACKAGE BODY Package_media_message as
PROCEDURE media_message_insert( p_file_path VARCHAR2, p_caption VARCHAR2,p_message_id int) IS

BEGIN
INSERT INTO media_message VALUES (DEFAULT,p_file_path, p_caption, p_message_id);
COMMIT;
END;

procedure MEDIA_MESSAGE_DELETE(p_id int) IS
BEGIN
DELETE FROM media_message WHERE id = p_id;
commit;
END;

procedure Get_All_message_media(p_message_id int) IS
c_all sys_refcursor;
BEGIN
open c_all for
SELECT * FROM media_message WHERE message_id = p_message_id;
DBMS_SQL.RETURN_RESULT(c_all);
END;

end Package_media_message;


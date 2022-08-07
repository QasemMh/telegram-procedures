 

create or REPLACE PACKAGE Package_media_message as
PROCEDURE media_message_insert( p_file_path VARCHAR2, p_caption VARCHAR2,p_message_id int);
procedure MEDIA_MESSAGE_DELETE(p_id int);
end Package_media_message;


create or REPLACE PACKAGE BODY Package_media_message as
PROCEDURE media_message_insert( p_file_path VARCHAR2, p_caption VARCHAR2,p_message_id int) IS

BEGIN
INSERT INTO media_message VALUES (DEFAULT,p_file_path, p_caption, p_message_id);
END;

procedure MEDIA_MESSAGE_DELETE(p_id int) IS
BEGIN
DELETE FROM media_message WHERE id = p_id;
END;

end Package_media_message;


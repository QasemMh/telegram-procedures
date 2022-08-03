--role
create table telegram_role(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
name varchar2(24) not null
);

--login
create table telegram_login(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
username varchar2(32) not null unique,
password varchar2(160) not null,
phone varchar2(14) unique,
email varchar2(50) not null unique,
role_id int not null references telegram_role(id) on delete set null
);


 --users 
create table telegram_user(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
first_name varchar2(23) not null,
middle_name varchar2(23),
last_name varchar2(23) not null,
bio varchar2(200),
gender varchar2(1) not null check(gender in('M','F')),
image_path varchar2(255),
login_id int not null unique references telegram_login(id) on delete cascade,
created_at timestamp default current_timestamp
);

--user block list
create table telegram_user_block_list(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_from int not null references telegram_user(id) on delete cascade,
user_to int not null references telegram_user(id),
UNIQUE(user_from, user_to)
); 
 
 -- select user_to from user_block_list where user_from = 1; --1,2,3,4,56,6 --1,2,3
 -- select * from users where id in(1,2,3,4,56,6) 4,56,6
 
 
 
--report user 
create table telegram_report_user(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_from int not null references telegram_user(id),
user_to int not null references telegram_user(id) on delete cascade,
type varchar2(30) not null,
description varchar2(200),
is_accept number(1) default 0 check(is_accept in(0,1))
);

--friends
--(user_from = id ||user_to = id)
create table telegram_friends(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_from int not null references telegram_user(id) on delete cascade,
user_to int not null references telegram_user(id),
status number(1) default 0 CHECK( status IN (0,1,2) ),
created_at timestamp default current_timestamp,
UNIQUE(user_from, user_to)
);

--chat message
create table telegram_chat_message(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_from int not null references telegram_user(id) on delete cascade,
user_to int not null references telegram_user(id) on delete cascade,
content varchar2(500),
is_read number(1) default 0 CHECK( is_read IN (0,1) ),
created_at timestamp default current_timestamp
);

create table telegram_media_message(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
file_path varchar(255) not null,
caption varchar2(200),
message_id not null references telegram_chat_message(id) on delete cascade
);

--group
create table telegram_group(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
name varchar2(60) not null,
owner_id int not null references telegram_user(id) on delete cascade, 
bio varchar2(200),
image_path varchar2(255)
);

create table telegram_group_link(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
link varchar2(255) not null,
period_time timestamp,
group_id not null references telegram_group(id) on delete cascade, 
created_at timestamp default current_timestamp
);
create table telegram_group_member(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references telegram_user(id) on delete cascade, 
group_id not null references telegram_group(id) on delete cascade, 
UNIQUE(user_id, group_id)
);
create table telegram_group_admin(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references telegram_user(id) on delete cascade, 
group_id not null references telegram_group(id) on delete cascade,
UNIQUE(user_id, group_id)
);
create table telegram_group_message(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
from_id int not null references telegram_user(id) on delete cascade, 
group_id not null references telegram_group(id) on delete cascade,
content varchar2(500),
created_at timestamp default current_timestamp
);

create table telegram_media_group(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
file_path varchar(255) not null,
caption varchar2(200),
group_message_id not null references telegram_group_message(id) on delete cascade
);

--channel
create table telegram_channel(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
username varchar2(32) not null unique,
owner_id int not null references telegram_user(id) on delete cascade, 
bio varchar2(200),
is_private number(1) default 0 CHECK( is_private IN (0,1) )
);
create table telegram_channel_member(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references telegram_user(id) on delete cascade, 
channel_id not null references telegram_channel(id) on delete cascade, 
UNIQUE(user_id, channel_id)
);
create table telegram_channel_admin(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references telegram_user(id) on delete cascade, 
channel_id not null references telegram_channel(id) on delete cascade,
UNIQUE(user_id, channel_id)
);

--post
create table telegram_post(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
admin_id int references telegram_user(id) on delete set null, 
channel_id not null references telegram_channel(id) on delete cascade,
content varchar2(500),
post_id int not null,
created_at timestamp default current_timestamp
);

create table telegram_media_post(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
file_path varchar(255) not null,
post_id not null references telegram_post(id) on delete cascade
);

create table telegram_comment(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references telegram_user(id) on delete cascade, 
post_id not null references telegram_channel(id) on delete cascade,
content varchar2(500) not null,
 created_at timestamp default current_timestamp
);

create table telegram_reaction(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references telegram_user(id) on delete cascade, 
post_id not null references telegram_channel(id) on delete cascade,
is_react number(1) CHECK( is_react = 1) 
);

--channel report 
create table telegram_report_channel(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references telegram_user(id),
channel_id int not null references telegram_channel(id) on delete cascade,
type varchar2(30) not null,
description varchar2(200),
is_accept number(1) default 0 check(is_accept in(0,1))

 );

 --story
 create table telegram_story(
 id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
 content varchar2(500),
 file_path varchar2(255),
 user_id int not null references telegram_user(id) on delete cascade,
 created_at timestamp default current_timestamp
 );
 
 --post
create table telegram_report_post(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_from int not null references telegram_user(id),
post_id int not null references telegram_post(id) on delete cascade,
type varchar2(30) not null,
description varchar2(200),
is_accept number(1) default 0 check(is_accept in(0,1))
);
 
ALTER TABLE group_message
ADD created_at timestamp default current_timestamp;

ALTER TABLE comments
ADD created_at timestamp default current_timestamp;

ALTER TABLE post
ADD created_at timestamp default current_timestamp;
 
 /*
 group 1:channel, channel-admin, channel-member, post ,post-media, post-report
 group 2:user, login, role, story, chat-message, block list
 group 3:group, group-member, group-link, group-message, group-admin, media-group
 group 4:comment, reaction, friends, media-message, report-user, report-channel
 */
 
 /*
 
 */
 
 
 /* 
--------------------------------------------------------
 after edit
--------------------------------------------------------
 */
 --role
create table  role(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
name varchar2(24) not null
);

--login
create table  login(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
username varchar2(32) not null unique,
password varchar2(160) not null,
phone varchar2(14) unique,
email varchar2(50) not null unique,
role_id int not null references  role(id) on delete set null
);


 --users 
create table  users(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
first_name varchar2(23) not null,
middle_name varchar2(23),
last_name varchar2(23) not null,
bio varchar2(200),
gender varchar2(1) not null check(gender in('M','F')),
image_path varchar2(255),
login_id int not null unique references  login(id) on delete cascade,
created_at timestamp default current_timestamp
);

--user block list
create table  user_block_list(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_from int not null references  users(id) on delete cascade,
user_to int not null references  users(id),
UNIQUE(user_from, user_to)
); 
 
 -- select user_to from user_block_list where user_from = 1; --1,2,3,4,56,6 --1,2,3
 -- select * from users where id in(1,2,3,4,56,6) 4,56,6
 
 
 
--report user 
create table  report_user(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_from int not null references  users(id),
user_to int not null references  users(id) on delete cascade,
type varchar2(30) not null,
description varchar2(200),
is_accept number(1) default 0 check(is_accept in(0,1))
);

--friends
--(user_from = id ||user_to = id)
create table  friends(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_from int not null references  users(id) on delete cascade,
user_to int not null references  users(id),
status number(1) default 0 CHECK( status IN (0,1,2) ), --0: pending, 1: accepted, 2: rejected
created_at timestamp default current_timestamp,
UNIQUE(user_from, user_to)
);

--chat message
create table  chat_message(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_from int not null references  users(id) on delete cascade,
user_to int not null references  users(id) on delete cascade,
content varchar2(500),
is_read number(1) default 0 CHECK( is_read IN (0,1) ),
created_at timestamp default current_timestamp
);

create table  media_message(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
file_path varchar(255) not null,
caption varchar2(200),
message_id not null references  chat_message(id) on delete cascade
);

--group
create table  groups(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
name varchar2(60) not null,
owner_id int not null references  users(id) on delete cascade, 
bio varchar2(200),
image_path varchar2(255)
);

create table  group_link(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
link varchar2(255) not null,
period_time timestamp,
group_id not null references  groups(id) on delete cascade, 
created_at timestamp default current_timestamp
);
create table  group_member(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references  users(id) on delete cascade, 
group_id not null references  groups(id) on delete cascade, 
UNIQUE(user_id, group_id)
);
create table  group_admin(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references  users(id) on delete cascade, 
group_id not null references  groups(id) on delete cascade,
UNIQUE(user_id, group_id)
);
create table  group_message(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
from_id int not null references  users(id) on delete cascade, 
group_id not null references  groups(id) on delete cascade,
content varchar2(500)
);

create table  media_group(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
file_path varchar(255) not null,
caption varchar2(200),
group_message_id not null references  group_message(id) on delete cascade
);

--channel
create table  channel(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
username varchar2(32) not null unique,
owner_id int not null references  users(id) on delete cascade, 
bio varchar2(200),
is_private number(1) default 0 CHECK( is_private IN (0,1) )
);
create table  channel_member(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references  users(id) on delete cascade, 
channel_id not null references  channel(id) on delete cascade, 
UNIQUE(user_id, channel_id)
);
create table  channel_admin(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references  users(id) on delete cascade, 
channel_id not null references  channel(id) on delete cascade,
UNIQUE(user_id, channel_id)
);

--post
create table  post(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
admin_id int references  users(id) on delete set null, 
channel_id not null references  channel(id) on delete cascade,
content varchar2(500),
post_id int not null --sequance
);

create table  media_post(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
file_path varchar(255) not null,
post_id not null references  post(id) on delete cascade
);

create table  comments(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references  users(id) on delete cascade, 
post_id not null references  post(id) on delete cascade,
content varchar2(500) not null 
);
 
create table  reaction(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references  users(id) on delete cascade, 
post_id not null references  post(id) on delete cascade,
unique(user_id,post_id)
);

 --channel report 
create table  report_channel(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_id int not null references  users(id),
channel_id int not null references  channel(id) on delete cascade,
type varchar2(30) not null,
description varchar2(200),
is_accept number(1) default 0 check(is_accept in(0,1))
);

 --story
 create table  story(
 id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
 content varchar2(500),
 file_path varchar2(255),
 user_id int not null references  users(id) on delete cascade,
 created_at timestamp default current_timestamp
 );
 
 create table  report_post(
id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
user_from int not null references  users(id),
post_id int not null references  post(id) on delete cascade,
type varchar2(30) not null,
description varchar2(200),
is_accept number(1) default 0 check(is_accept in(0,1))
);



ALTER TABLE group_message
ADD created_at timestamp default current_timestamp;

ALTER TABLE comments
ADD created_at timestamp default current_timestamp;

ALTER TABLE post
ADD created_at timestamp default current_timestamp;


-- run this
ALTER TABLE channel
ADD image_path varchar2(255) null;









 
 
 
 
 
 
 









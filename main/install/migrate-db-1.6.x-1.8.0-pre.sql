-- This script updates the databases structure before migrating the data from
-- version 1.6.x to version 1.8.0
-- it is intended as a standalone script, however, because of the multiple
-- databases related difficulties, it should be parsed by a PHP script in
-- order to connect to and update the right databases.
-- There is one line per query, allowing the PHP function file() to read
-- all lines separately into an array. The xxMAINxx-type markers are there
-- to tell the PHP script which database we're talking about.
-- By always using the keyword "TABLE" in the queries, we should be able
-- to retrieve and modify the table name from the PHP script if needed, which
-- will allow us to deal with the unique-database-type installations
--
-- This first part is for the main database
-- xxMAINxx
ALTER TABLE admin 		CHANGE user_id 	user_id 	int unsigned NOT NULL default 0;

ALTER TABLE class_user 	CHANGE class_id class_id 	mediumint unsigned NOT NULL default 0;
ALTER TABLE class_user 	CHANGE user_id 	user_id 	int unsigned NOT NULL default 0;

ALTER TABLE course 		ADD registration_code		varchar(255) NOT NULL default '';

ALTER TABLE course_rel_user CHANGE user_id user_id int unsigned NOT NULL default 0;
ALTER TABLE course_rel_user CHANGE sort sort int default NULL;

ALTER TABLE user CHANGE auth_source auth_source varchar(50) default 'platform';
ALTER TABLE user ADD language varchar(40) default NULL;
ALTER TABLE user ADD registration_date datetime NOT NULL default '0000-00-00 00:00:00';
ALTER TABLE user ADD expiration_date datetime NOT NULL default '0000-00-00 00:00:00';
ALTER TABLE user ADD active enum('0','1') NOT NULL default '1';

-- Rename table session into php_session
RENAME TABLE session TO php_session;
ALTER TABLE php_session DROP PRIMARY KEY;
ALTER TABLE php_session CHANGE sess_id session_id varchar(32) NOT NULL default '';
ALTER TABLE php_session CHANGE sess_name session_name varchar(10) NOT NULL default '';
ALTER TABLE php_session CHANGE sess_time session_time int NOT NULL default '0';
ALTER TABLE php_session CHANGE sess_start session_start int NOT NULL default '0';
ALTER TABLE php_session CHANGE sess_value session_value text NOT NULL;
ALTER TABLE php_session ADD PRIMARY KEY (session_id);

-- We might want to review the following table structure --
CREATE TABLE session (id smallint unsigned NOT NULL auto_increment, id_coach int unsigned NOT NULL default '0', name char(50) NOT NULL default '', nbr_courses smallint unsigned NOT NULL default '0', nbr_users mediumint unsigned NOT NULL default '0', nbr_classes mediumint unsigned NOT NULL default '0', date_start date NOT NULL default '0000-00-00', date_end date NOT NULL default '0000-00-00', PRIMARY KEY  (id),  UNIQUE KEY name (name));

-- We might want to review the following table structure --
CREATE TABLE session_rel_course(id_session smallint unsigned NOT NULL default '0', course_code char(40) NOT NULL default '', id_coach int unsigned NOT NULL default '0', nbr_users smallint(5) unsigned NOT NULL default '0', PRIMARY KEY  (id_session,course_code), KEY course_code (course_code));

-- We might want to review the following table structure --
CREATE TABLE session_rel_course_rel_user(id_session smallint unsigned NOT NULL default '0', course_code char(40) NOT NULL default '', id_user int unsigned NOT NULL default '0', PRIMARY KEY  (id_session,course_code,id_user), KEY id_user (id_user), KEY course_code (course_code));

-- We might want to review the following table structure --
CREATE TABLE session_rel_user(id_session mediumint unsigned NOT NULL default '0', id_user mediumint unsigned NOT NULL default '0', PRIMARY KEY  (id_session,id_user));

-- We might want to review the following table structure --
CREATE TABLE course_rel_survey (id int NOT NULL auto_increment, course_code varchar(200) default NULL, db_name varchar(200) default NULL,  survey_id varchar(200) default NULL,  PRIMARY KEY  (id));

-- We might want to review the following table structure --
CREATE TABLE survey_reminder(sid int NOT NULL default '0', db_name varchar(100) NOT NULL default '', email varchar(100) NOT NULL default '', access int NOT NULL default '0', subject text NOT NULL, content text NOT NULL, reminder_choice int NOT NULL default '0', reminder_time text NOT NULL, avail_till date NOT NULL default '0000-00-00');

-- We might want to review the following table structure --
CREATE TABLE survey_user_info(id int NOT NULL auto_increment, user_id int NOT NULL default '0', survey_id int NOT NULL default '0', db_name varchar(200) default NULL, firstname varchar(200) default NULL, lastname varchar(200) default NULL, email varchar(200) default NULL, organization  text, age int default NULL, registered char(1) default NULL, attempted varchar(10) NOT NULL default '', PRIMARY KEY (id));

ALTER TABLE sys_announcement CHANGE visible_teacher visible_teacher_temp enum('true','false') NOT NULL DEFAULT 'false';
ALTER TABLE sys_announcement CHANGE visible_student visible_student_temp enum('true','false') NOT NULL DEFAULT 'false';
ALTER TABLE sys_announcement CHANGE visible_guest visible_guest_temp enum('true','false') NOT NULL DEFAULT 'false';
ALTER TABLE sys_announcement ADD COLUMN visible_teacher tinyint NOT NULL DEFAULT 0;
ALTER TABLE sys_announcement ADD COLUMN visible_student tinyint NOT NULL DEFAULT 0;
ALTER TABLE sys_announcement ADD COLUMN visible_guest tinyint NOT NULL DEFAULT 0;
ALTER TABLE sys_announcement ADD lang varchar(70) NULL;

-- update contents of the main db tables
UPDATE TABLE settings_current SET selected_value = 'activity' WHERE variable='homepage_view';
UPDATE TABLE settings_current SET subkey = 'world', type = 'checkbox', subkeytext = 'ShowOnlineWorld' WHERE variable='showonline';
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('showonline','users','checkbox','Platform','true','ShowOnlineTitle','ShowOnlineComment',NULL,'ShowOnlineUsers');
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('showonline','course','checkbox','Platform','true','ShowOnlineTitle','ShowOnlineComment',NULL,'ShowOnlineCourse');
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('profile','language','checkbox','User','true','ProfileChangesTitle','ProfileChangesComment',NULL,'Language');
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('registration','language','checkbox','User','true','RegistrationRequiredFormsTitle','RegistrationRequiredFormsComment',NULL,'Language');
-- UPDATE TABLE settings_current SET selected_value = 'true' WHERE variable='course_create_active_tools' AND subkey='announcements';
-- UPDATE TABLE settings_current SET selected_value = 'true' WHERE variable='course_create_active_tools' AND subkey='forums';
-- UPDATE TABLE settings_current SET selected_value = 'true' WHERE variable='course_create_active_tools' AND subkey='dropbox';
-- UPDATE TABLE settings_current SET selected_value = 'true' WHERE variable='course_create_active_tools' AND subkey='quiz';
-- UPDATE TABLE settings_current SET selected_value = 'true' WHERE variable='course_create_active_tools' AND subkey='users';
-- UPDATE TABLE settings_current SET selected_value = 'true' WHERE variable='course_create_active_tools' AND subkey='groups';
-- UPDATE TABLE settings_current SET selected_value = 'true' WHERE variable='course_create_active_tools' AND subkey='chat';
-- UPDATE TABLE settings_current SET selected_value = 'true' WHERE variable='course_create_active_tools' AND subkey='online_conference';
-- UPDATE TABLE settings_current SET selected_value = 'true' WHERE variable='course_create_active_tools' AND subkey='student_publications';
-- UPDATE TABLE settings_current SET selected_value = 'true' WHERE variable='use_document_title';
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('student_view_enabled',NULL,'radio','Platform','true','StudentViewEnabledTitle','StudentViewEnabledComment',NULL,NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('show_navigation_menu',NULL,'radio','Course','false','ShowNavigationMenuTitle','ShowNavigationMenuComment',NULL,NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('enable_tool_introduction',NULL,'radio','course','false','EnableToolIntroductionTitle','EnableToolIntroductionComment',NULL,NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('page_after_login', NULL, 'radio','Platform','user_portal.php', 'PageAfterLoginTitle','PageAfterLoginComment', NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('time_limit_whosonline', NULL, 'textfield','Platform','30', 'TimeLimitWhosonlineTitle','TimeLimitWhosonlineComment', NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('breadcrumbs_course_homepage', NULL, 'radio','Course','course_title', 'BreadCrumbsCourseHomepageTitle','BreadCrumbsCourseHomepageComment', NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('example_material_course_creation', NULL, 'radio','Platform','true', 'ExampleMaterialCourseCreationTitle','ExampleMaterialCourseCreationComment', NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('account_valid_duration',NULL, 'textfield','Platform','3660', 'AccountValidDurationTitle','AccountValidDurationComment', NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('use_session_mode', NULL, 'radio','Platform','false', 'UseSessionModeTitle','UseSessionModeComment', NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('allow_email_editor', NULL, 'radio', 'Tools', 'false', 'AllowEmailEditorTitle', 'AllowEmailEditorComment', NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('registered', NULL, 'textfield', NULL, 'false', NULL, NULL, NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('donotlistcampus', NULL, 'textfield', NULL, 'false', NULL, NULL, NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('show_email_addresses', NULL,'radio','Platform','false','ShowEmailAddresses','ShowEmailAddressesComment',NULL,NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('profile','phone','checkbox','User','true','ProfileChangesTitle','ProfileChangesComment',NULL,'phone');
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('Ajax_course_tracking_refresh', NULL, 'textfield','Course','0', 'Ajax_course_tracking_refresh','Ajax_course_tracking_refresh_comment', NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('service_visio', 'active', 'radio',NULL,'false', 'visio_actived','', NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('service_visio', 'url', 'textfield',NULL,'', 'visio_url','', NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('service_ppt2lp', 'active', 'radio',NULL,'false', 'ppt2lp_actived','', NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('service_ppt2lp', 'host', NULL, NULL, NULL, 'Host', NULL, NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('service_ppt2lp', 'user', NULL, NULL, NULL, 'UserOnHost', NULL, NULL, NULL);
INSERT INTO settings_current(variable,subkey,type,category,selected_value,title,comment,scope,subkeytext) VALUES ('service_ppt2lp', 'ftp_password', NULL, NULL, NULL, 'FtpPassword', NULL, NULL, NULL);

UPDATE settings_options SET value = 'activity', display_text='HomepageViewActivity' WHERE variable = 'homepage_view' AND value = 'default';
UPDATE settings_options SET value = '2column', display_text='HomepageView2column' WHERE variable = 'homepage_view' AND value = 'basic_tools_fixed';
INSERT INTO settings_options(variable,value,display_text) VALUES ('homepage_view','3column','HomepageView3column');
INSERT INTO settings_options(variable,value,display_text) VALUES ('allow_registration','approval','AfterApproval');
INSERT INTO settings_options(variable,value,display_text) VALUES ('student_view_enabled','true','Yes');
INSERT INTO settings_options(variable,value,display_text) VALUES ('student_view_enabled','false','No');
INSERT INTO settings_options(variable,value,display_text) VALUES ('show_navigation_menu','false','No');
INSERT INTO settings_options(variable,value,display_text) VALUES ('show_navigation_menu','icons','IconsOnly');
INSERT INTO settings_options(variable,value,display_text) VALUES ('show_navigation_menu','text','TextOnly');
INSERT INTO settings_options(variable,value,display_text) VALUES ('show_navigation_menu','iconstext','IconsText');
INSERT INTO settings_options(variable,value,display_text) VALUES ('enable_tool_introduction','true','Yes');
INSERT INTO settings_options(variable,value,display_text) VALUES ('enable_tool_introduction','false','No');
INSERT INTO settings_options(variable,value,display_text) VALUES ('page_after_login', 'index.php', 'CampusHomepage');
INSERT INTO settings_options(variable,value,display_text) VALUES ('page_after_login', 'user_portal.php', 'MyCourses');
INSERT INTO settings_options(variable,value,display_text) VALUES ('breadcrumbs_course_homepage', 'get_lang', 'CourseHomepage');
INSERT INTO settings_options(variable,value,display_text) VALUES ('breadcrumbs_course_homepage', 'course_code', 'CourseCode');
INSERT INTO settings_options(variable,value,display_text) VALUES ('breadcrumbs_course_homepage', 'course_title', 'CourseTitle');
INSERT INTO settings_options(variable,value,display_text) VALUES ('example_material_course_creation', 'true', 'Yes');
INSERT INTO settings_options(variable,value,display_text) VALUES ('example_material_course_creation', 'false', 'No');
INSERT INTO settings_options(variable,value,display_text) VALUES ('use_session_mode', 'true', 'Yes');
INSERT INTO settings_options(variable,value,display_text) VALUES ('use_session_mode', 'false', 'No');
INSERT INTO settings_options(variable,value,display_text) VALUES ('allow_email_editor', 'true' ,'Yes');
INSERT INTO settings_options(variable,value,display_text) VALUES ('allow_email_editor', 'false', 'No');
INSERT INTO settings_options(variable,value,display_text) VALUES ('show_email_addresses','true','Yes');
INSERT INTO settings_options(variable,value,display_text) VALUES ('show_email_addresses','false','No');

UPDATE course_module SET image = 'links.gif' WHERE image='liens.gif';
UPDATE course_module SET image = 'members.gif' WHERE image = 'membres.gif';
UPDATE course_module SET link = 'forum/index.php' WHERE link = 'phpbb/index.php';
UPDATE course_module SET image = 'statistics.gif' WHERE image = 'statistiques.gif';
UPDATE course_module SET image = 'reference.gif', column = '1' WHERE image = 'referencement.gif';
DELETE FROM course_module WHERE link = 'coursecopy/backup.php';
DELETE FROM course_module WHERE link = 'coursecopy/copy_course.php';
DELETE FROM course_module WHERE link = 'coursecopy/recycle_course.php';
UPDATE course_module SET link = 'newscorm/lp_controller.php' WHERE link = 'scorm/scormdocument.php';
INSERT INTO course_module(name,link,image,row,column,position) VALUES ('blog','blog/blog.php','blog.gif',1,2,'basic'); 
INSERT INTO course_module(name,link,image,row,column,position) VALUES ('blog_management','blog/blog_admin.php','blog_admin.gif',1,2,'courseadmin'); 
INSERT INTO course_module(name,link,image,row,column,position) VALUES ('course_maintenance','course_info/maintenance.php','backup.gif',2,3,'courseadmin'); 
INSERT INTO course_module(name,link,image,row,column,position) VALUES ('survey','survey/survey_list.php','survey.gif',2,1,'courseadmin');

-- xxSTATSxx
CREATE TABLE track_e_attempt(exe_id int default NULL, user_id int NOT NULL default 0, question_id int NOT NULL default 0, answer text NOT NULL, teacher_comment text NOT NULL, marks int NOT NULL default 0, course_code varchar(40) NOT NULL default '', position int default 0);
CREATE TABLE track_e_course_access(course_access_id int NOT NULL auto_increment, course_code varchar(40) NOT NULL, user_id int NOT NULL, login_course_date datetime NOT NULL default '0000-00-00 00:00:00', logout_course_date datetime default NULL, counter int NOT NULL, PRIMARY KEY (course_access_id));
ALTER TABLE track_e_access CHANGE access_cours_code access_cours_code varchar(40) NOT NULL default '';
ALTER TABLE track_e_lastaccess CHANGE access_id access_id bigint NOT NULL auto_increment;
ALTER TABLE track_e_lastaccess CHANGE acces_cours_code access_cours_code varchar(40) NOT NULL default '';
ALTER TABLE track_e_lastaccess ADD access_session_id int unsigned default NULL;
ALTER TABLE track_e_downloads CHANGE down_cours_id down_cours_id varchar(20) NOT NULL default '';
ALTER TABLE track_e_downloads CHANGE down_doc_path down_doc_path varchar(255) NOT NULL default '';
ALTER TABLE track_e_links CHANGE links_cours_id links_cours_id varchar(40) NOT NULL default '';
ALTER TABLE track_e_login ADD logout_date datetime NULL default NULL;
ALTER TABLE track_e_online ADD course varchar(40) default NULL;

-- xxUSERxx
ALTER TABLE user_course_category ADD sort int;

-- xxCOURSExx
ALTER TABLE announcement CHANGE content content mediumtext;
ALTER TABLE announcement ADD email_sent tinyint;
CREATE TABLE blog(blog_id smallint NOT NULL AUTO_INCREMENT , blog_name varchar(250) NOT NULL default '', blog_subtitle varchar( 250 ) default NULL , date_creation datetime NOT NULL default '0000-00-00 00:00:00', visibility tinyint unsigned NOT NULL default 0, PRIMARY KEY (blog_id));
CREATE TABLE blog_comment(comment_id int NOT NULL AUTO_INCREMENT , title varchar(250) NOT NULL default '', comment longtext NOT NULL , author_id int NOT NULL default 0, date_creation datetime NOT NULL default '0000-00-00 00:00:00', blog_id mediumint NOT NULL default 0, post_id int NOT NULL default 0, task_id int default NULL , parent_comment_id int NOT NULL default 0, PRIMARY KEY (comment_id));
CREATE TABLE blog_post(post_id int NOT NULL AUTO_INCREMENT, title varchar(250) NOT NULL default '', full_text longtext NOT NULL, date_creation datetime NOT NULL default '0000-00-00 00:00:00', blog_id mediumint NOT NULL default 0, author_id int NOT NULL default 0, PRIMARY KEY (post_id));
CREATE TABLE blog_rating(rating_id int NOT NULL AUTO_INCREMENT, blog_id int NOT NULL default 0, rating_type enum( 'post', 'comment' ) NOT NULL default 'post', item_id int NOT NULL default 0, user_id int NOT NULL default 0, rating mediumint NOT NULL default 0, PRIMARY KEY (rating_id));
CREATE TABLE blog_rel_user(blog_id int NOT NULL default 0, user_id int NOT NULL default 0, PRIMARY KEY (blog_id,user_id));
CREATE TABLE blog_task(task_id mediumint NOT NULL AUTO_INCREMENT,blog_id mediumint NOT NULL default 0,title varchar( 250 ) NOT NULL default '',description text NOT NULL ,color varchar( 10 ) NOT NULL default '', system_task tinyint unsigned NOT NULL default 0,PRIMARY KEY (task_id));
CREATE TABLE blog_task_rel_user(blog_id mediumint NOT NULL default 0,user_id int NOT NULL default 0,task_id mediumint NOT NULL default 0,target_date date NOT NULL default '0000-00-00',PRIMARY KEY (blog_id,user_id,task_id));

CREATE TABLE course_setting(id int unsigned NOT NULL auto_increment, variable varchar(255) NOT NULL default '', subkey varchar(255) default NULL, type varchar(255) default NULL,category varchar(255) default NULL,value varchar(255) NOT NULL default '', title varchar(255) NOT NULL default '',comment varchar(255) default NULL, subkeytext varchar(255) default NULL, PRIMARY KEY (id));

CREATE TABLE dropbox_category(cat_id int NOT NULL auto_increment, cat_name text NOT NULL, received tinyint unsigned NOT NULL default 0, sent tinyint unsigned NOT NULL default 0, user_id int NOT NULL default 0, PRIMARY KEY  (cat_id));
CREATE TABLE dropbox_feedback(feedback_id int NOT NULL auto_increment, file_id int NOT NULL default 0, author_user_id int NOT NULL default 0, feedback text NOT NULL, feedback_date datetime NOT NULL default '0000-00-00 00:00:00', PRIMARY KEY  (feedback_id), KEY file_id (file_id), KEY author_user_id (author_user_id));

CREATE TABLE forum_category(cat_id int NOT NULL auto_increment, cat_title varchar(255) NOT NULL default '', cat_comment text, cat_order int NOT NULL default 0, locked int NOT NULL default 0, PRIMARY KEY (cat_id));
CREATE TABLE forum_forum(forum_id int NOT NULL auto_increment, forum_title varchar(255) NOT NULL default '', forum_comment text, forum_threads int default 0, forum_posts int default 0, forum_last_post int default 0, forum_category int default NULL, allow_anonymous int default NULL, allow_edit int default NULL, approval_direct_post varchar(20) default NULL, allow_attachments int default NULL, allow_new_threads int default NULL, default_view varchar(20) default NULL, forum_of_group varchar(20) default NULL, forum_group_public_private varchar(20) default 'public', forum_order int default NULL,  locked int NOT NULL default 0, PRIMARY KEY (forum_id));
CREATE TABLE forum_thread(thread_id int NOT NULL auto_increment,thread_title varchar(255) default NULL, forum_id int default NULL, thread_replies int default 0, thread_poster_id int default NULL, thread_poster_name varchar(100) default '', thread_views int default 0, thread_last_post int default NULL, thread_date datetime default '0000-00-00 00:00:00', thread_sticky tinyint unsigned default 0, locked int NOT NULL default 0, PRIMARY KEY (thread_id), KEY thread_id (thread_id));
CREATE TABLE forum_post(post_id int NOT NULL auto_increment, post_title varchar(250) default NULL, post_text text, thread_id int default 0, forum_id int default 0, poster_id int default 0, poster_name varchar(100) default '', post_date datetime default '0000-00-00 00:00:00', post_notification tinyint default 0, post_parent_id int default 0, visible tinyint default 1, PRIMARY KEY (post_id), KEY poster_id (poster_id), KEY forum_id (forum_id));
CREATE TABLE forum_mailcue(thread_id int default NULL, user_id int default NULL, post_id int default NULL);

ALTER TABLE group_category ADD COLUMN calendar_state tinyint unsigned NOT NULL default 1;
ALTER TABLE group_category ADD COLUMN work_state tinyint unsigned NOT NULL default 1;
ALTER TABLE group_category ADD COLUMN announcements_state tinyint unsigned NOT NULL default 1;
ALTER TABLE group_category CHANGE self_reg_allowed self_reg_allowed_temp enum('0','1') NOT NULL default '0';
ALTER TABLE group_category CHANGE self_unreg_allowed self_unreg_allowed_temp enum('0','1') NOT NULL default '0';
ALTER TABLE group_category ADD COLUMN self_reg_allowed tinyint unsigned NOT NULL default 0;
ALTER TABLE group_category ADD COLUMN self_unreg_allowed tinyint unsigned NOT NULL default 0;

ALTER TABLE group_info MODIFY secret_directory varchar(255) default NULL;
ALTER TABLE group_info ADD COLUMN calendar_state tinyint unsigned NOT NULL default 0;
ALTER TABLE group_info ADD COLUMN work_state tinyint unsigned NOT NULL default 0;
ALTER TABLE group_info ADD COLUMN announcements_state tinyint unsigned NOT NULL default 0;
ALTER TABLE group_info CHANGE self_registration_allowed self_registration_allowed_temp enum('0','1') NOT NULL default '0';
ALTER TABLE group_info CHANGE self_unregistration_allowed self_unregistration_allowed_temp enum('0','1') NOT NULL default '0';
ALTER TABLE group_info ADD COLUMN self_registration_allowed tinyint unsigned NOT NULL default 0;
ALTER TABLE group_info ADD COLUMN self_unregistration_allowed tinyint unsigned NOT NULL default 0;
ALTER TABLE group_info CHANGE doc_state doc_state_temp enum('0','1','2') NOT NULL default '1';
ALTER TABLE group_info ADD COLUMN doc_state tinyint unsigned NOT NULL default 1;

CREATE TABLE group_rel_tutor(id int NOT NULL auto_increment, user_id int NOT NULL, group_id int NOT NULL default 0, PRIMARY KEY (id));

CREATE TABLE lp(id int	unsigned primary key auto_increment, lp_type	smallint unsigned not null, name tinytext not null, ref tinytext null, description text null, path text	not null, force_commit  tinyint	unsigned not null default 0, default_view_mod char(32) not null default 'embedded', default_encoding char(32)	not null default 'ISO-8859-1', display_order int		unsigned	not null default 0, content_maker tinytext  not null default '', content_local 	varchar(32)  not null default 'local', content_license	text not null default '', prevent_reinit tinyint unsigned not null default 1, js_lib tinytext    not null default '', debug tinyint unsigned not null default 0);
CREATE TABLE lp_view(id	int	unsigned primary key auto_increment, lp_id int	unsigned not null, user_id int unsigned not null, view_count smallint unsigned not null default 0, last_item int	unsigned not null default 0, progress int	unsigned default 0);
CREATE TABLE lp_item(id	int	unsigned primary key auto_increment, lp_id int unsigned	not null, item_type	char(32) not null default 'dokeos_document', ref tinytext not null default '', title tinytext not null, description	tinytext not null default '', path text	 not null, min_score float unsigned	not null default 0, max_score float unsigned not null default 100, mastery_score float unsigned null, parent_item_id		int unsigned	not null default 0, previous_item_id	int unsigned	not null default 0, next_item_id		int unsigned	not null default 0, display_order		int unsigned	not null default 0, prerequisite  char(64)  null, parameters  text  null, launch_data text not null default '');
CREATE TABLE lp_item_view(id bigint	unsigned primary key auto_increment, lp_item_id		int unsigned	not null, lp_view_id		int unsigned 	not null, view_count		int unsigned	not null default 0, start_time		int unsigned	not null, total_time		int unsigned not null default 0, score			float unsigned not null default 0, status			char(32) not null default 'Not attempted', suspend_data	text null default '', lesson_location text null default '');
CREATE TABLE lp_iv_interaction(id bigint unsigned primary key auto_increment, order_id smallint unsigned not null default 0, lp_iv_id		bigint	unsigned not null, interaction_id	varchar(255) not null default '', interaction_type	varchar(255) not null default '', weighting			double not null default 0, completion_time	varchar(16) not null default '', correct_responses	text not null default '', student_response	text not null default '', result			varchar(255) not null default '', latency		varchar(16)	not null default '');

CREATE TABLE permission_group(id int NOT NULL AUTO_INCREMENT, group_id int NOT NULL default 0, tool varchar( 250 ) NOT NULL default '', action varchar( 250 ) NOT NULL default '', PRIMARY KEY ( id ));
CREATE TABLE permission_user(id int NOT NULL AUTO_INCREMENT, user_id int NOT NULL default 0, tool varchar( 250 ) NOT NULL default '', action varchar( 250 ) NOT NULL default '', PRIMARY KEY ( id ));
CREATE TABLE permission_task(id int NOT NULL AUTO_INCREMENT, task_id int NOT NULL default 0, tool varchar( 250 ) NOT NULL default '', action varchar( 250 ) NOT NULL default '', PRIMARY KEY ( id ));

ALTER TABLE quiz_answer ADD COLUMN hotspot_coordinates tinytext;
ALTER TABLE quiz_answer ADD COLUMN hotspot_type enum('square','circle','poly') default NULL;


CREATE TABLE role(role_id int NOT NULL AUTO_INCREMENT , role_name varchar( 250 ) NOT NULL default '', role_comment text, default_role tinyint default 0,	PRIMARY KEY ( role_id ));
CREATE TABLE role_group(role_id int NOT NULL default 0, scope varchar( 20 ) NOT NULL default 'course', group_id int NOT NULL default 0);
CREATE TABLE role_permissions(role_id int NOT NULL default 0, tool varchar( 250 ) NOT NULL default '', action varchar( 50 ) NOT NULL default '', default_perm tinyint NOT NULL default 0);
CREATE TABLE role_user(role_id int NOT NULL default 0, scope varchar( 20 ) NOT NULL default 'course', user_id int NOT NULL default 0);

ALTER TABLE student_publication ADD COLUMN post_group_id int DEFAULT 0 NOT NULL;

CREATE TABLE survey(survey_id int unsigned NOT NULL auto_increment, code varchar(20) default NULL, title varchar(80) default NULL, subtitle varchar(80) default NULL, author varchar(20) default NULL, lang varchar(20) default NULL, avail_from date default NULL, avail_till date default NULL, is_shared char(1) default 1, template varchar(20) default NULL, intro text, surveythanks text, creation_date datetime NOT NULL default '0000-00-00 00:00:00', PRIMARY KEY (survey_id), UNIQUE KEY id (survey_id));
CREATE TABLE survey_group(group_id int NOT NULL auto_increment, survey_id int NOT NULL default 0, groupname varchar(100) NOT NULL default '', introduction text NOT NULL, imported_group int NOT NULL default 0, db_name varchar(100) NULL default '', sortby int NOT NULL default 1, PRIMARY KEY (group_id));
CREATE TABLE survey_report(id int NOT NULL auto_increment, qid int NOT NULL default 0, answer text NOT NULL, survey_id int NOT NULL default 0, user_id int NOT NULL default 0, PRIMARY KEY (id));
CREATE TABLE questions(qid int unsigned NOT NULL auto_increment,gid int NOT NULL default 0,	survey_id int NOT NULL default 0,qtype varchar(50) NOT NULL default '',	caption text NOT NULL,alignment varchar(100) NOT NULL default '',sortby int NOT NULL default 1,a1 text NOT NULL,a2 text NOT NULL,a3 text NOT NULL,a4 text NOT NULL,a5 text NOT NULL,a6 text NOT NULL,a7 text NOT NULL,a8 text NOT NULL,a9 text NOT NULL,a10 text NOT NULL,at varchar(200) NOT NULL default '',ad varchar(200) NOT NULL default '',alt_text text NOT NULL,	r1 int NOT NULL default 0,r2 int NOT NULL default 0,r3 int NOT NULL default 0,r4 int NOT NULL default 0,r5 int NOT NULL default 0,r6 int NOT NULL default 0,r7 int NOT NULL default 0,r8 int NOT NULL default 0,r9 int NOT NULL default 0,r10 int NOT NULL default 0,	imported_question int NOT NULL default 0,db_name varchar(100) NULL default '',PRIMARY KEY (qid));

ALTER TABLE tool ADD COLUMN category enum('authoring','interaction','admin') NOT NULL default 'authoring';

UPDATE tool SET image = 'links.gif' WHERE image = 'liens.gif';
UPDATE tool SET image = 'members.gif' WHERE image = 'membres.gif';
UPDATE tool SET link = 'forum/index.php' WHERE link = 'phpbb/index.php';
UPDATE tool SET image = 'statistics.gif' WHERE image = 'statistiques.gif';
UPDATE tool SET image = 'reference.gif' WHERE image = 'referencement.gif';
-- UPDATE tool SET column = '1' WHERE image = 'reference.gif';
DELETE FROM tool WHERE link = 'coursecopy/backup.php';
DELETE FROM tool WHERE link = 'coursecopy/copy_course.php';
DELETE FROM tool WHERE link = 'coursecopy/recycle_course.php';
UPDATE tool SET link = 'newscorm/lp_controller.php' WHERE link = 'scorm/scormdocument.php';
INSERT INTO tool() VALUES (); 
 
CREATE DATABASE task_sys;
use task_sys;
CREATE TABLE users(
    id int primary key auto_increment,
    firstname varchar(20) not null,
    lastname varchar(20),
    email varchar(255) not null unique,
    dob date,
    password varchar(256) not null,
    activate_link varchar(1000),
    password_exp timestamp not null,
    link_exp timestamp not null,
    isactive boolean default 1,
    isverifed boolean default 0,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);

CREATE TRIGGER user_trigger BEFORE INSERT ON users 
FOR EACH ROW SET
    NEW.password_exp = TIMESTAMPADD(DAY, 10, current_timestamp),
    NEW.link_exp = TIMESTAMPADD(HOUR, 2, current_timestamp);
    
CREATE TABLE login_logs(
    id int primary key auto_increment,
    user_id int references users(id) on delete cascade on update cascade, 
    attempt_count int not null default 1,
    attempt_sys_ip varchar(16),
    created_at timestamp default current_timestamp
);
CREATE TABLE password_change_logs(
    user_id int references users(id) on delete cascade on update cascade,
    password varchar(256) not null,
    created_at timestamp default current_timestamp
);
CREATE TABLE email_change_logs(
    user_id int references users(id) on delete cascade on update cascade,
    email varchar(255) not null,
    created_at timestamp default current_timestamp
);
#Role Module

CREATE  TABLE roles(
    id int primary key auto_increment,
    name varchar(20) not null unique,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE  TABLE permissions(
    id int primary key auto_increment,
    name varchar(20) not null unique,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE  TABLE role_has_permissions(
    role_id int references roles(id) on delete cascade on update cascade,
    permission_id int references permissions(id) on delete cascade on update cascade,
    constraint role_permission_pk primary key (role_id,permission_id)
);

CREATE TABLE categories(
    id int primary key auto_increment,
    name varchar(20),
    description varchar(50),
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE TABLE priorities(
    id int primary key auto_increment,
    label varchar(20),
    color_code varchar(20)
);
CREATE TABLE tasks(
    id int primary key auto_increment,
    name varchar(20),
    description varchar(250),
    due_date date,
    priority_id int references priorities(id) on delete cascade on update cascade,
    creator_id int references users(id) on delete cascade on update cascade,
    project_id int references tool_integration(project_token) on delete cascade on update cascade,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);

CREATE TABLE task_collabration(
    id int primary key auto_increment,
    collebrator_id int references users(id) on delete cascade on update cascade,
    role_id int references roles(id) on delete cascade on update cascade
);
CREATE TABLE task_assignees(
    id int primary key auto_increment,
    task_collebrator_id int references task_collabration(id) on delete cascade on update cascade,
    task_id int references tasks(id) on delete cascade on update cascade,
    stage varchar(20) check(stage in ('to-do','in-progress','completed')),
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE TABLE completed_tasks(
    id int primary key auto_increment,
    task_assignee_id int references task_assignees(id) on delete cascade on update cascade,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);

CREATE TABLE task_comments(
    id int primary key auto_increment,
    task_id int references tasks(id) on delete cascade on update cascade,
    commentor_id int references task_assignees(id) on delete cascade on update cascade,
    comments varchar(30)
);

CREATE TABLE task_attachments(
    id int primary key auto_increment,
    task_assignee_id int references task_assignees(id) on delete cascade on update cascade,
    attachment_url varchar(255)
);
CREATE TABLE tool_integration(
    id int primary key auto_increment,
    user_id int references users(id) on delete cascade on update cascade,
    project_token varchar(50),
    email_client_token varchar(50),
    google_calender_token varchar(50),
    trello_token varchar(50),
    asana_token varchar(50)
);
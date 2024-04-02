create database mcq_exam_sys;
use mcq_exam_sys;
CREATE TABLE roles(
    id int primary key auto_increment,
    name varchar(20) not null unique check(name in ('administrators', 'instructors','students')),
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE TABLE permissions(
    id int primary key auto_increment,
    name varchar(20) not null unique,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE TABLE role_has_permissions(
    role_id int references roles(id) on delete cascade on update cascade,
    permission_id int references permissions(id) on delete cascade on update cascade,
    constraint role_permission_pk primary key (role_id,permission_id)
);
#Auth Module

CREATE TABLE users(
    id int primary key auto_increment,
    role_id int references roles(id),
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

CREATE TABLE exams(
    id int primary key auto_increment,
    title varchar(30) not null,
    duration int not null,
    criteria int not null,
    instructions varchar(255),
    instructor_id int references users(id) on delete cascade on update cascade,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);

CREATE TABLE questions(
    id int primary key auto_increment,
    question varchar(250) not null,
    topic varchar(50),
    level enum('easy','moderat','hard'),
    type varchar(20) check(type in ('single-answer','multi-answer')),
    exam_id int references exams(id)  on delete cascade on update cascade,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);

CREATE TABLE options(
    id int primary key auto_increment,
    value varchar(50),
    question_id int references questions(id) on delete cascade on update cascade,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE TABLE answers(
    id int primary key auto_increment,
    option_id int  references options(id)  on delete cascade on update cascade,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE TABLE results(
    id int primary key auto_increment,
    student_id int references users(id) on delete cascade on update cascade,
    option_id int references options(id)  on delete cascade on update cascade
);
CREATE TABLE feedbacks(
    id int primary key auto_increment,
    student_id int references users(id) on delete cascade on update cascade,
    instructor_id int references users(id) on delete cascade on update cascade,
    feedback varchar(100) not null
);
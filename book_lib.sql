create database book_lib;
use book_lib;
#Role Module
CREATE TABLE roles(
    id int primary key auto_increment,
    name varchar(20) not null unique,
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

#book module
CREATE TABLE books(
    id int primary key auto_increment,
    title varchar(50) not null,
    sub_title varchar(200),
    auther varchar(25) not null,
    publisher_id int references users(id),
    publish_year year not null,
    ISBN varchar(30) not null,
    thumbnail varchar(255),
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE TABLE category(
    id int primary key auto_increment,
    name varchar(20),
    description varchar(50),
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE TABLE book_category(
    id int primary key auto_increment,
    book_id int references books(id) on delete cascade on update cascade,
    category_id int references category(id) on delete cascade on update cascade,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);

CREATE TABLE book_reader(
    id int primary key auto_increment,
    reader_id int references users(id) on delete cascade on update cascade,
    book_id int references books(id) on delete cascade on update cascade,
    status varchar(20) check(status in ('read','currently reading','to read')),
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);

CREATE TABLE review(
    id int primary key auto_increment,
    reader_id int references users(id) on delete cascade on update cascade,
    comment varchar(20),
    rating decimal(2,1),
    isfavorite boolean
);
CREATE TABLE preference(
    id int primary key auto_increment,
    user_id int references users(id) on delete cascade on update cascade,
    language varchar(20) not null,
    location varchar(25) not null
);

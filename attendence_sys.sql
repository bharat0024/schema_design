create database attendence_sys;
use attendence_sys;
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
CREATE TABLE employee(
    id int primary key auto_increment,
    role_id int references roles(id),
    firstname varchar(20) not null,
    lastname varchar(20),
    email varchar(255) not null unique,
    dob date,
    password varchar(256) not null,
    city varchar(20),
    mobile varchar(10),
    gender varchar(6),
    avatar varchar(255),
    isactive boolean default 1,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE TABLE activity_type(
    id int primary key auto_increment,
    type varchar(20)
);
CREATE TABLE attendence(
    id int primary key auto_increment,
    employee_id int references employee(id) on update cascade on delete cascade,
    activity int references activity_type(id) on update cascade on delete cascade,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
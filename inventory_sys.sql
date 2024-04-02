create database inventory_sys;
use inventory_sys;
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
#Auth Module

CREATE  TABLE users(
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
CREATE TABLE inventories(
    id int primary key auto_increment,
    location varchar(20),
    status varchar(20)
);
CREATE TABLE item_master(
    id int primary key auto_increment,
    name varchar(20),
    description varchar(20),
    quntity int,
    SKU varchar(20),
    unit_cost varchar(20),
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
)
CREATE TABLE items(
    id int primary key auto_increment,
    description varchar(20),
    RFID varchar(20) unique,
    item_id int references item_master(id) on delete cascade on update cascade,
    inventory_id int references inventories(id) on delete cascade on update cascade,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
CREATE TABLE inventory_movements(
    id int primary key auto_increment,
    RFID varchar(20) references items(id) on delete cascade on update cascade,
    type varchar(20) check( type in ('receiving', 'transferring','disposing')),
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);

CREATE TABLE products_in_order(
    id int primary key auto_increment,
    order_id int references order_master(id) on delete cascade on update cascade,
    product_id int references products(id) on delete cascade on update cascade,
    quantity int not null
);
CREATE TABLE order_master(
    id int primary key auto_increment,
    user_id int references users(id) on update cascade on delete cascade,
    type varchar(20) check(type in ('seles','purchase','return')),
    status varchar(20),
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);

CREATE TABLE shhipings(
    id int primary key auto_increment,
    order_id int references order_master(id) on delete cascade on update cascade,
    tracking_link varchar(255),
    status varchar(20) not null,
    shhiping_address varchar(200) not null,
    charge decimal(5,2) not null,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);

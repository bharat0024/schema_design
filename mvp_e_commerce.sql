CREATE DATABASE mvp_e_commerce;
use mvp_e_commerce
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

#product module
CREATE TABLE products(
    id int primary key auto_increment,
    name varchar(20) not null,
    price decimal(5,2) not null,
    description varchar(250),
    image varchar(256),
    available_stock int,
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
CREATE TABLE product_categories(
    id int primary key auto_increment,
    product_id int references products(id) on delete cascade on update cascade,
    category_id int references category(id) on delete cascade on update cascade,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);

CREATE TABLE products_in_cart(
    id int primary key auto_increment,
    cart_id int references cart_master(id) on delete cascade on update cascade,
    product_id int references products(id) on delete cascade on update cascade,
    quantity int not null
);

CREATE TABLE cart_master(
    id int primary key auto_increment,
    user_id int references users(id) on delete cascade on update cascade,
    status varchar(20) not null,
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
    user_id int references users(id) on delete cascade on update cascade,
    gst_percentage decimal(4,2),
    discount_percentage decimal(4,2),
    status varchar(20) not null,
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

CREATE TABLE payments(
    id int primary key auto_increment,
    status varchar(20) not null,
    order_id int references order_master(id) on delete cascade on update cascade,
    mode varchar(20),
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
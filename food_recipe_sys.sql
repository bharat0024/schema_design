create database food_recipe_sys;
use food_recipe_sys;
CREATE TABLE meal_types(
    id int primary key auto_increment,
    type varchar(20),
    description varchar(50)
);
CREATE TABLE cooking_methods(
    id int primary key auto_increment,
    name varchar(20),
    description varchar(50)
);

CREATE TABLE defficulty_level(
    id int primary key auto_increment,
    level varchar(20)
);
CREATE TABLE recipe(
    id int primary key auto_increment,
    name varchar(20),
    description varchar(50),
    ingredients varchar(100),
    cuisines varchar(20),
    dietary varchar(20),
    nutritional varchar(50),
    size varchar(20),
    popularity decimal(4,2),
    duration time,
    meal_id int references meal_types(id) on delete cascade on update cascade,
    cooking_method_id int references cooking_methods(id) on delete cascade on update cascade,
    defficulty_level_id int references defficulty_level(id) on delete cascade on update cascade
);
CREATE TABLE ingredients(
    id int primary key auto_increment,
    name varchar(20),
    description varchar(50)
);
CREATE TABLE recipe_ingredients(
    id int primary key auto_increment,
    recipe_id int references recipe(id) on delete cascade on update cascade,
    ingredient_id int references ingredients(id) on delete cascade on update cascade,
    quantity decimal(5,2)
);
CREATE TABLE recipe_resources(
    id int primary key auto_increment,
    recipe_id int references recipe(id) on delete cascade on update cascade,
    type varchar(20) check(type in ('image','video','artical')),
    url varchar(50)
);
#auth module
CREATE TABLE users(
    id int primary key auto_increment,
    name varchar(20) not null,
    email varchar(255) not null unique,
    password varchar(256) not null,
    activate_link varchar(1000),
    password_exp timestamp not null,
    link_exp timestamp not null,
    isactive boolean default 1,
    isverifed boolean default 0,
    dietary_preferences  varchar(20),
    skill_level_id int references defficulty_level(id) on delete cascade on update cascade,
    created_at timestamp default current_timestamp,
    updated_at timestamp on update current_timestamp
);
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

#user activity
CREATE TABLE user_favorites(
    id int primary key auto_increment,
    user_id int references users(id) on delete cascade on update cascade,
    recipe_id int references recipe(id) on delete cascade on update cascade
);
CREATE TABLE user_recipes(
    id int primary key auto_increment,
    user_id int references users(id) on delete cascade on update cascade,
    recipe_id int references recipe(id) on delete cascade on update cascade
);
CREATE TABLE user_comments(
    id int primary key auto_increment,
    recipe_id int references recipe(id) on delete cascade on update cascade,
    commentor_id int references users(id) on delete cascade on update cascade,
    comments varchar(30)
);
CREATE TABLE recipe_ratings(
    id int primary key auto_increment,
    recipe_id int references recipe(id) on delete cascade on update cascade,
    user_id int references users(id) on delete cascade on update cascade,
    ratings decimal(2,1)
);
CREATE TABLE user_tips_and_tricks(
    id int primary key auto_increment,
    recipe_id int references recipe(id) on delete cascade on update cascade,
    user_id int references users(id) on delete cascade on update cascade,
    tips varchar(30)
);
#shopping list module
CREATE TABLE other_shopping_ingredients(
    id int primary key auto_increment,
    name varchar(20),
    description varchar(50),
    quantity decimal(5,2)
);
CREATE TABLE shopping_lists(
    id int primary key auto_increment,
    recipe_id int references recipe(id) on delete cascade on update cascade,
    other_ingredient int references other_shopping_ingredients(id) on delete cascade on update cascade
);
CREATE TABLE meal_based_lists(
    id int primary key auto_increment,
    ingredient_id int references ingredients(id) on delete cascade on update cascade,
    quantity decimal(5,2),
    meal_id int references meal_types(id) on delete cascade on update cascade
);
CREATE TABLE user_recipe_based_shopping_lists(
    id int primary key auto_increment,
    user_id int references users(id) on delete cascade on update cascade,
    list_id int references shopping_lists(id) on delete cascade on update cascade
);
CREATE TABLE user_meal_based_shopping_lists(
    id int primary key auto_increment,
    user_id int references users(id) on delete cascade on update cascade,
    list_id int references meal_based_lists(id) on delete cascade on update cascade
);

#user social module
CREATE TABLE user_social_accounts(
    id int primary key auto_increment,
    user_id int references users(id) on delete cascade on update cascade,
    whatsapp_token varchar(50),
    instagram_token varchar(50),
    facebook_token varchar(50),
    tweeter_token varchar(50),
    sharechat_token varchar(50)
);
CREATE TABLE recipe_experice_shareings(
    id int primary key auto_increment,
    user_id int references users(id) on delete cascade on update cascade,
    post_link varchar(255)
);

#collabrations
CREATE TABLE collabrations(
    id int primary key auto_increment,
    name varchar(20),
    detail varchar(250),
    type varchar(20) check(type in('brand','cheaf','influencer')), #with brand,cheaf,influencer
    stating_at timestamp,
    ending_at timestamp,
    collabration_stamp_url varchar(250)
);


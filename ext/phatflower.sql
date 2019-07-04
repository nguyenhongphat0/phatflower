drop table if exists analytics;
drop table if exists product_contents;
drop table if exists products;
drop table if exists categories;
create table products (
    id int not null auto_increment,
    name varchar(500),
    link varchar(500),
    image varchar(500),
    price int not null,
    is_hot boolean default true,
    primary key (id)
);
create table product_contents (
    id int not null,
    content text,
    primary key (id),
    foreign key (id) references products(id)
);
create table categories (
    id int not null auto_increment,
    name varchar(100),
    count int,
    enable boolean default false,
    onmenu boolean default false,
    primary key (id)
);
create table analytics (
    id int not null auto_increment,
    product int,
    user_agent varchar(500),
    page_url varchar(500),
    moment datetime default now(),
    primary key (id),
    foreign key (product) references products(id)
);
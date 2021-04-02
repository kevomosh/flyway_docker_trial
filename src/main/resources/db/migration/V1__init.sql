create sequence hibernate_sequence start 1 increment 1;

create table if not exists person(
    id int8 not null,
    age int4 not null,
    name varchar(255),
    primary key (id)
);


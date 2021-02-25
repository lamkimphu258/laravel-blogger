use laravel;

drop table if exists posts;

create table posts (
    id integer auto_increment not null primary key,
    slug varchar(50),
    title varchar(255)
)

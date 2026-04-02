create database online_bookstore;
use online_bookstore;

create table books(
bookid int primary key auto_increment,
bookname varchar(10) not null,
price decimal(10,2),
storename varchar(10)
); 

create table orders(
orderid int primary key,
bookid int ,
quantiy int,
orderdate date,
foreign key(bookid) references books(bookid)
);
alter table books
add column ISBN varchar(30);
alter table books
modify ISBN varchar(30) unique;

delete from books
where bookid=2;
truncate table orders;


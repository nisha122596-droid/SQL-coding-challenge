create database onlineusers;
use onlineusers;
create table user(
user_id int primary key,
username varchar(10),
email varchar(20)
);

create table posts(
post_id int primary key auto_increment,
user_id int,
caption text,
posted_at DATETIME DEFAULT CURRENT_TIMESTAMP ,
foreign key(user_id) references user(user_id)
);

create table followers(
follower_id int,
following_id INT,
follow_date DATETIME default current_timestamp,
foreign key(follower_id) references user(user_id),
foreign key(following_id) references user(user_id)

);

-- insert

insert into user(user_id,username,email)
values(1, 'arun', 'arun@gmail.com'),
(2, 'meena', 'meena@hotmail.com'),
(3, 'rahul', 'rahul@yahoo.com'),
(4, 'divya', 'divya@gmail.com'),
(5, 'karthik', 'karthikho@mail.com');

select * from user;

insert into posts(post_id,user_id,caption,posted_at)
values(1,1, 'My first post','2024-01-01'),
(2,2, 'Hello world','2024-01-08'),
(3,3, 'Learning SQL','2024-06-11'),
(4,4, 'Database practice','2024-12-31'),
(5,5, 'Good morning!','2024-04-21');

select * from posts;

INSERT INTO followers(follower_id, following_id) VALUES
(1, 2),
(1, 3),
(2, 3),
(3, 4),
(5, 1);

select* from followers;

-- Retrieve all users whose username starts with “a”.
select username from user
where username like 'a%';

-- Get posts posted BETWEEN '2024-01-01' AND '2024-12-31'.

select * from posts
where posted_at BETWEEN '2024-01-01' AND '2024-12-31';

-- Find posts that have NULL captions.

select * from posts
where caption is null;

-- Find users whose email domain is in:

select * from user
where email in ('arun@gmail.com', 'meena@hotmail.com',' rahul@yahoo.com');

-- Sort users by number of posts (DESC) and LIMIT 5.

select * from posts
order by post_id desc
limit 3;

-- Group posts by DATE(posted_at) and return:
select date(posted_at) as post_date,count(*) as total_post from posts
group by post_date
having count(*)>10;


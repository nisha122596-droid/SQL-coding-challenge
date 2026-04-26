# SQL-coding-challenge

#sql assignment session 33
DELIMITER $$

CREATE FUNCTION GetUserEngagement(p_user_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_likes INT;
    DECLARE total_comments INT;

    SELECT COUNT(*) INTO total_likes
    FROM likes
    WHERE user_id = p_user_id;

    SELECT COUNT(*) INTO total_comments
    FROM comments
    WHERE user_id = p_user_id;

    RETURN total_likes + total_comments;
END$$

DELIMITER ;

SELECT user_id, COUNT(follower_id) AS follower_count
FROM followers
GROUP BY user_id
HAVING COUNT(follower_id) > (
    SELECT AVG(follower_count)
    FROM (
        SELECT COUNT(follower_id) AS follower_count
        FROM followers
        GROUP BY user_id
    ) AS avg_table
);

DELIMITER $$

CREATE PROCEDURE GetPostsByUsername(IN p_username VARCHAR(100))
BEGIN
    SELECT p.*
    FROM posts p
    JOIN users u ON u.user_id = p.user_id
    WHERE u.username = p_username;
END$$

DELIMITER ;

CALL GetPostsByUsername('richared');

#sql assignment session 36
SELECT 
    u.user_id,
    u.username,
    COALESCE(l.total_likes, 0) + COALESCE(c.total_comments, 0) AS engagement
FROM users u
LEFT JOIN (
    SELECT user_id, COUNT(*) AS total_likes
    FROM likes
    GROUP BY user_id
) l ON u.user_id = l.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS total_comments
    FROM comments
    GROUP BY user_id
) c ON u.user_id = c.user_id
ORDER BY engagement DESC
LIMIT 10;

SELECT 
    p.post_id,
    p.caption,
    COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id) AS engagement
FROM posts p
LEFT JOIN likes l ON p.post_id = l.post_id
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY p.post_id
HAVING engagement > (
    SELECT AVG(total_engagement)
    FROM (
        SELECT 
            p2.post_id,
            COUNT(DISTINCT l2.like_id) + COUNT(DISTINCT c2.comment_id) AS total_engagement
        FROM posts p2
        LEFT JOIN likes l2 ON p2.post_id = l2.post_id
        LEFT JOIN comments c2 ON p2.post_id = c2.post_id
        GROUP BY p2.post_id
    ) t
);

SELECT 
    DATE(created_at) AS post_date,
    COUNT(*) AS total_posts
FROM posts
GROUP BY DATE(created_at)
ORDER BY post_date;

SELECT 
    YEARWEEK(created_at) AS week,
    COUNT(*) AS total_posts
FROM posts
GROUP BY YEARWEEK(created_at)
ORDER BY week;
SELECT 
    user_id,
    COUNT(*) AS new_followers
FROM followers
WHERE followed_at >= NOW() - INTERVAL 7 DAY
GROUP BY user_id
ORDER BY new_followers DESC
LIMIT 10;

SELECT 
    h.hashtag,
    COUNT(*) AS usage_count
FROM hashtags h
WHERE h.created_at >= NOW() - INTERVAL 30 DAY
GROUP BY h.hashtag
ORDER BY usage_count DESC
LIMIT 10;

SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(p.caption, '#', -1), ' ', 1) AS hashtag,
    COUNT(*) AS count
FROM posts p
WHERE p.created_at >= NOW() - INTERVAL 30 DAY
AND p.caption LIKE '%#%'
GROUP BY hashtag
ORDER BY count DESC;

#sql coding challenge 3.11.26
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

#sql coding challenge session 31 and 30
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

#sql codingchallenge 3.9.26

use hospitaldb;
create table patients(
PatientID int primary key,
PatientName varchar(20),
age int,
Gender varchar(20),
AdmissionDate date 

);

#sql codingchallenge SESSION 32
use onlineusers;
select* from posts;

create table comments(
comment_id int primary key,
post_id int,
user_id int,
comment text,
commented_at date,
foreign key(post_id) references posts(post_id),
foreign key(user_id) references user(user_id)
);

create table likes(
like_id int primary key,
post_id int,
user_id int,
liked_at date,
foreign key(post_id) references posts(post_id),
foreign key(user_id) references user(user_id)
);

INSERT INTO comments (comment_id, post_id, user_id, comment, commented_at) VALUES
(10, 1, 2, 'Nice post!', '2024-01-10'),
(21, 1, 3, 'Very helpful', '2024-01-11'),
(33, 2, 1, 'Great content', '2024-02-05'),
(44, 3, 4, 'Thanks for sharing', '2024-03-12'),
(55, 4, 5, 'Interesting read', '2024-04-20');

INSERT INTO likes (like_id, post_id, user_id, liked_at) VALUES
(10, 1, 2, '2024-01-01'),
(20, 1, 3, '2024-01-02'),
(30, 2, 1, '2024-01-03'),
(40, 3, 4, '2024-01-04'),
(50, 5, 2, '2024-01-05');

-- JOIN Report
-- post_id, username, caption, total likes, total comments.
select * from likes;
select * from comments;
select * from post;
SELECT 
    p.post_id,
    u.username,
    p.caption,
    COUNT(DISTINCT l.user_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM posts p
JOIN user u ON p.user_id = u.user_id
LEFT JOIN likes l ON p.post_id = l.post_id
LEFT JOIN comments c ON p.post_id = c.post_id
GROUP BY p.post_id, u.username, p.caption;
-- Built-in Functions
-- Show usernames in UPPER case.
-- Extract month name from posted_at.
-- Return the length of each caption.

SELECT 
    UPPER(u.username) AS username_upper,
    MONTHNAME(p.posted_at) AS post_month,
    LENGTH(p.caption) AS caption_length
FROM posts p
JOIN user u ON u.user_id = p.user_id;

-- UNION
-- Combine list of users who commented OR liked.


SELECT user_id FROM likes
UNION
SELECT user_id FROM comments;

 

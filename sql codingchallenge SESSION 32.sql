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

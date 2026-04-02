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
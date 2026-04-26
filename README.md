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

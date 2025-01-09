-- Graf 1 --
SELECT 
    du.age_groups AS age_group, 
    COUNT(fr.fact_rating_id) AS rating_count
FROM fact_ratings fr
JOIN dim_users du ON fr.user_id = du.user_id
GROUP BY du.age_groups
ORDER BY rating_count DESC;

-- Graf 2 --
SELECT 
    dm.genres AS genre, 
    AVG(fr.rating) AS average_rating
FROM fact_ratings fr
JOIN dim_movies dm ON fr.movie_id = dm.movie_id
GROUP BY dm.genres
ORDER BY average_rating DESC
LIMIT 10;

-- Graf 3 --
SELECT 
    dt.am_pm AS time_period, 
    COUNT(fr.fact_rating_id) AS rating_count
FROM fact_ratings fr
JOIN dim_time dt ON fr.time_id = dt.time_id
GROUP BY dt.am_pm
ORDER BY rating_count DESC;

-- Graf 4 --
SELECT 
    dm.title AS movie_title, 
    COUNT(fr.fact_rating_id) AS total_ratings
FROM fact_ratings fr
JOIN dim_movies dm ON fr.movie_id = dm.movie_id
GROUP BY dm.title
ORDER BY total_ratings DESC
LIMIT 5;

-- Graf 5 --
SELECT 
    dd.month_string AS month, 
    COUNT(fr.fact_rating_id) AS total_ratings
FROM fact_ratings fr
JOIN dim_date dd ON fr.date_id = dd.date_id
GROUP BY dd.month_string, dd.month
ORDER BY dd.month ASC;

CREATE DATABASE MONGOOSE_ETL_DB;
CREATE SCHEMA etl_schema;
CREATE OR REPLACE STAGE my_stage;

USE DATABASE MONGOOSE_ETL_DB;
USE SCHEMA MONGOOSE_ETL_DB.etl_schema;


CREATE OR REPLACE TABLE age_group_staging (
    id INT,
    name STRING
);

CREATE OR REPLACE TABLE movie_genres_staging (
    id INT,
    name STRING
);

CREATE OR REPLACE TABLE movie_genre_relationship_staging (
    id INT,
    movie_id INT,
    genre_id INT
);

CREATE OR REPLACE TABLE movies_staging (
    id INT,
    title STRING,
    release_year INT
);

CREATE OR REPLACE TABLE occupations_staging (
    id INT,
    name STRING
);

CREATE OR REPLACE TABLE ratings_staging (
    id INT,
    user_id INT,
    movie_id INT,
    rating INT,
    rated_at TIMESTAMP
);

CREATE OR REPLACE TABLE tags_staging (
    id INT,
    user_id INT,
    movie_id INT,
    tags STRING,
    created_at TIMESTAMP
);

CREATE OR REPLACE TABLE users_staging (
    id INT,
    age INT,
    gender STRING,
    occupation_id INT,
    zip_code STRING
);



COPY INTO age_group_staging
FROM @my_stage/age_group.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

COPY INTO movie_genres_staging
FROM @my_stage/genres.csv
FILE_FORMAT = (TYPE = 'CSV', FIELD_OPTIONALLY_ENCLOSED_BY = '"', SKIP_HEADER = 1);

COPY INTO movie_genre_relationship_staging
FROM @my_stage/genres_movies.csv
FILE_FORMAT = (TYPE = 'CSV', FIELD_OPTIONALLY_ENCLOSED_BY = '"', SKIP_HEADER = 1);

COPY INTO movies_staging
FROM @my_stage/movies.csv
FILE_FORMAT = (TYPE = 'CSV', FIELD_OPTIONALLY_ENCLOSED_BY = '"', SKIP_HEADER = 1);

COPY INTO occupations_staging
FROM @my_stage/occupations.csv
FILE_FORMAT = (TYPE = 'CSV', FIELD_OPTIONALLY_ENCLOSED_BY = '"', SKIP_HEADER = 1);

COPY INTO ratings_staging
FROM @my_stage/ratings.csv
FILE_FORMAT = (TYPE = 'CSV', FIELD_OPTIONALLY_ENCLOSED_BY = '"', SKIP_HEADER = 1);

COPY INTO tags_staging
FROM @my_stage/tags.csv
FILE_FORMAT = (TYPE = 'CSV', FIELD_OPTIONALLY_ENCLOSED_BY = '"', SKIP_HEADER = 1);

COPY INTO users_staging
FROM @my_stage/users.csv
FILE_FORMAT = (TYPE = 'CSV', FIELD_OPTIONALLY_ENCLOSED_BY = '"', SKIP_HEADER = 1);



CREATE TABLE dim_users AS
SELECT DISTINCT
    u.id AS user_id,
    u.age AS age,
    ag.name AS age_groups,
    u.gender AS gender,
    u.zip_code AS zip_code,
    o.name AS occupation
FROM users_staging u
LEFT JOIN age_group_staging ag ON u.age = ag.id
LEFT JOIN occupations_staging o ON u.occupation_id = o.id;



CREATE TABLE dim_movies AS
SELECT DISTINCT
    m.id AS movie_id,
    m.title AS title,
    m.release_year AS release_year,
    LISTAGG(g.name, ', ') WITHIN GROUP (ORDER BY g.name) AS genres
FROM movies_staging m
LEFT JOIN movie_genre_relationship_staging mgr ON m.id = mgr.movie_id
LEFT JOIN movie_genres_staging g ON mgr.genre_id = g.id
GROUP BY m.id, m.title, m.release_year;



CREATE TABLE dim_date AS
SELECT DISTINCT
    CAST(DATE(r.rated_at) AS STRING) AS date_id,
    EXTRACT(DAY FROM r.rated_at) AS day,
    TO_CHAR(r.rated_at, 'Day') AS day_string,
    EXTRACT(MONTH FROM r.rated_at) AS month,
    TO_CHAR(r.rated_at, 'Month') AS month_string,
    EXTRACT(YEAR FROM r.rated_at) AS year,
    CEIL(EXTRACT(MONTH FROM r.rated_at) / 3.0) AS quarter
FROM ratings_staging r;



CREATE TABLE dim_time AS
SELECT DISTINCT
    TO_CHAR(r.rated_at, 'HH24:MI:SS') AS time_id,
    EXTRACT(HOUR FROM r.rated_at) AS hour,
    EXTRACT(MINUTE FROM r.rated_at) AS minute,
    EXTRACT(SECOND FROM r.rated_at) AS second,
    CASE 
        WHEN EXTRACT(HOUR FROM r.rated_at) < 12 THEN 'AM' 
        ELSE 'PM' 
    END AS am_pm
FROM ratings_staging r;


CREATE TABLE dim_tags AS
SELECT DISTINCT
    t.id AS tags_id,
    t.tags AS tags,
    t.created_at AS created_at
FROM tags_staging t;


CREATE TABLE fact_ratings AS
SELECT DISTINCT
    r.id AS fact_rating_id,
    r.user_id AS user_id,
    r.movie_id AS movie_id,
    TO_CHAR(r.rated_at, 'YYYY-MM-DD') AS date_id,
    TO_CHAR(r.rated_at, 'HH24:MI:SS') AS time_id,
    t.id AS tags_id,
    r.rating AS rating
FROM ratings_staging r
LEFT JOIN tags_staging t 
    ON r.user_id = t.user_id AND r.movie_id = t.movie_id;

DROP TABLE IF EXISTS age_group_staging;
DROP TABLE IF EXISTS movie_genres_staging;
DROP TABLE IF EXISTS movie_genre_relationship_staging;
DROP TABLE IF EXISTS movies_staging;
DROP TABLE IF EXISTS occupations_staging;
DROP TABLE IF EXISTS ratings_staging;
DROP TABLE IF EXISTS tags_staging;
DROP TABLE IF EXISTS users_staging;
    



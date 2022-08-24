USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    COUNT(*) Total_Rows_movie
FROM
    movie;
-- Total_Rows_movie = 7997
SELECT 
    COUNT(*) Total_Rows_genre
FROM
    genre;
-- Total_Rows_movie = 14662
SELECT 
    COUNT(*) Total_Rows_director_mapping
FROM
    director_mapping;
-- Total_Rows_director_mapping = 3867
SELECT 
    COUNT(*) Total_Rows_role_mapping
FROM
    role_mapping;
-- Total_Rows_role_mapping = 15615
SELECT 
    COUNT(*) Total_Rows_names
FROM
    names;
-- Total_Rows_names = 25735
SELECT 
    COUNT(*) Total_Rows_ratings
FROM
    ratings;
-- Total_Rows_ratings = 7997


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            id IS NULL) AS id_NULL_COUNT,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            title IS NULL) AS title_NULL_COUNT,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            year IS NULL) AS year_NULL_COUNT,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            date_published IS NULL) AS date_published_NULL_COUNT,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            duration IS NULL) AS duration_NULL_COUNT,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            country IS NULL) AS country_NULL_COUNT,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            worlwide_gross_income IS NULL) AS worlwide_gross_income_NULL_COUNT,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            languages IS NULL) AS languages_NULL_COUNT,
    (SELECT 
            COUNT(*)
        FROM
            movie
        WHERE
            production_company IS NULL) AS production_company_NULL_COUNT
;

-- Columns (id, title, year, date_published, duration) have no null values. 
-- country has 20 null value counts.
-- worlwide_gross_income has 3724 null value counts.
-- language has 194 null value counts.
-- production_company has 528 null value counts.



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Count of movie released in an year. 
SELECT 
    year, COUNT(id) number_of_movies
FROM
    movie
GROUP BY year;

-- Count of movie released in a month.
SELECT 
    MONTH(date_published) month_num, COUNT(id) number_of_movies
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    year, COUNT(id) number_of_movies
FROM
    movie
WHERE
    UPPER(country) REGEXP 'INDIA|USA'
        AND year = 2019;

-- The total number of movies produced in the USA or India in the year 2019 = 1059


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT 
    genre
FROM
    genre
GROUP BY genre;

-- The output shows that there are 13 genres in total. 


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    genre, COUNT(genre) number_of_movies
FROM
    genre
GROUP BY genre
ORDER BY COUNT(genre) DESC
LIMIT 1;

-- Highest number of movies are produced in "Drama" genre i.e. 4285.



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH one_genre_count AS
(SELECT COUNT(*) genre_count
FROM genre
GROUP BY (movie_id)
HAVING COUNT(DISTINCT movie_id) = 1)
SELECT COUNT(*) number_of_movies 
FROM one_genre_count
WHERE genre_count = 1;

-- Total number of movies belonging to only one genre = 3289


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    g.genre, ROUND(AVG(m.duration), 2) avg_duration
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY AVG(m.duration) DESC;

-- This will give aerage duration time (rounded by 2 decimal places) grouped by genre and odered by average duaration time.


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH gen_rank AS
(SELECT genre, 
COUNT(genre) movie_count, 
RANK() OVER (ORDER BY COUNT(genre) DESC) genre_rank
FROM genre
GROUP BY genre
ORDER BY genre_rank)
SELECT *
FROM gen_rank
WHERE genre = 'thriller';

-- The ouput will give out 'thriller' genre count as 1484 and rank as 3.



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
    MIN(avg_rating) min_avg_rating,
    MAX(avg_rating) max_avg_rating,
    MIN(total_votes) min_total_votes,
    MAX(total_votes) max_total_votes,
    MIN(median_rating) min_median_rating,
    MAX(median_rating) min_median_rating
FROM
    ratings;	

    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT m.title,
r.avg_rating,
RANK() OVER (ORDER BY r.avg_rating DESC) movie_rank
FROM ratings r
INNER JOIN movie m
ON m.id=r.movie_id
GROUP BY m.title
ORDER BY movie_rank
LIMIT 10;

-- This gives the output over the rank function.

SELECT m.title,
r.avg_rating,
DENSE_RANK() OVER (ORDER BY r.avg_rating DESC) movie_rank
FROM ratings r
INNER JOIN movie m
ON m.id=r.movie_id
GROUP BY m.title
ORDER BY movie_rank
LIMIT 10;

-- This gives the output over the dense_rank function.


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    median_rating, COUNT(median_rating) movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
COUNT(id) movie_count,
DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) prod_company_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE avg_rating >8 
AND production_company IS NOT NULL
GROUP BY production_company
ORDER BY prod_company_rank;

-- OR, We can limit the output to 1 if we want only one outcome as the code shown below. 
SELECT production_company,
COUNT(id) movie_count,
DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) prod_company_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE avg_rating >8 
AND production_company IS NOT NULL
GROUP BY production_company
ORDER BY prod_company_rank
LIMIT 1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    g.genre, COUNT(g.genre) movie_count
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    MONTH(date_published) = 3
        AND year = 2017
        AND UPPER(country) REGEXP 'USA'
        AND total_votes > 1000
GROUP BY g.genre
ORDER BY COUNT(g.genre) DESC;


-- As per the output, movies from 'Drama' genre comes out to be top with 24 counts in total.


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
    m.title, r.avg_rating, g.genre
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    avg_rating > 8 AND title REGEXP '^The'
ORDER BY avg_rating DESC;


-- As per the output, there are a total of 15 movies which starts with "The" and has an average rating more than 8.


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT 
    r.median_rating, COUNT(r.movie_id) movie_count
FROM
    movie m
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND median_rating = 8;

-- There are a total of 361 movies which has the median_rating "8" and released between 1 April 2018 and 1 April 2019.


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT m.languages,
       Sum(r.total_votes) votes_sum
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  UPPER(m.languages) REGEXP 'ITALIAN'
UNION
SELECT m.languages,
       Sum(r.total_votes) votes_sum
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  UPPER(m.languages) REGEXP 'GERMAN'
ORDER  BY votes_sum DESC;

SELECT m.languages,
       Sum(r.total_votes) votes_sum
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  UPPER(m.languages) REGEXP 'GERMAN'
ORDER  BY votes_sum DESC;

-- This code will give the sum of total votes for ITALIAN and GERMAN language individually.

WITH Votes_summary AS
(SELECT m.languages,
       Sum(r.total_votes) votes_sum
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  UPPER(m.languages) REGEXP 'ITALIAN'
UNION
SELECT m.languages,
       Sum(r.total_votes) votes_sum
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  UPPER(m.languages) REGEXP 'GERMAN'
ORDER  BY votes_sum DESC),
Language_votes AS
(SELECT languages
FROM Votes_summary
ORDER BY votes_sum DESC
LIMIT 1)
SELECT 
CASE WHEN languages = 'German' THEN 'Yes'
ELSE 'No'
END AS Answer
FROM Language_votes;


-- The code will give output as YES or NO for the statement "if German movies get more votes than Italian movies.?".

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT
(SELECT COUNT(*) FROM names WHERE id IS NULL) AS id_nulls,
(SELECT COUNT(*) FROM names WHERE name IS NULL) AS name_nulls,
(SELECT COUNT(*) FROM names WHERE height IS NULL) AS height_nulls,
(SELECT COUNT(*) FROM names WHERE date_of_birth IS NULL) AS date_of_birth_nulls,
(SELECT COUNT(*) FROM names WHERE known_for_movies IS NULL) AS known_for_movies_nulls; 



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH genre_summary AS
(SELECT g.genre, 
COUNT(g.genre) genre_count
FROM genre g
INNER JOIN movie m
ON g.movie_id = m.id
INNER JOIN ratings r
ON r.movie_id = m.id
WHERE avg_rating > 8
GROUP BY g.genre
ORDER BY genre_count DESC
LIMIT 3)
SELECT n.name director_name,
COUNT(dm.movie_id) movie_count
FROM names n
INNER JOIN director_mapping dm
ON n.id = dm.name_id
INNER JOIN genre g
USING (movie_id)
INNER JOIN genre_summary gs
USING (genre)
INNER JOIN ratings r
USING (movie_id)
WHERE avg_rating >8
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remember his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT n.name actor_name,
COUNT(movie_id) movie_count
FROM names n
INNER JOIN role_mapping rm
ON n.id = rm.name_id
INNER JOIN ratings r
USING (movie_id)
WHERE r.median_rating >= 8 AND CATEGORY = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

-- Top 2 actors are Mammootty and Mohanlal having 8 and 5 as respective movie_counts with median_rating >= 8.


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
SUM(total_votes) vote_count,
RANK() OVER(ORDER BY SUM(total_votes) DESC) prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
GROUP BY production_company
ORDER BY prod_comp_rank
LIMIT 3;



/*Yes Marvel Studios rules the movie world.
So, Marvel Studios, followed by Twentieth Century Fox and Warner Bros. are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH movie_rating AS
(SELECT r.movie_id,
m.country,
r.total_votes,
avg_rating
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id)
SELECT n.name actor_name,
mr.total_votes,
COUNT(rm.movie_id) movie_count,
ROUND(SUM(mr.avg_rating*mr.total_votes)/SUM(mr.total_votes),2) actor_avg_rating,
RANK() OVER(ORDER BY ROUND(SUM(mr.avg_rating*mr.total_votes)/SUM(mr.total_votes),2) DESC, mr.total_votes DESC) actor_rank
FROM names n
INNER JOIN role_mapping rm
ON n.id = rm.name_id
INNER JOIN movie_rating mr
USING (movie_id)
WHERE category = 'actor'
AND UPPER(country) REGEXP 'INDIA'
GROUP BY actor_name
HAVING movie_count >= 5
ORDER BY actor_rank;

-- Top actors are 'Vijay Sethupathi' followed by 'Fahadh Faasil' and 'Yogi Babu'.

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH movie_rating AS
(SELECT r.movie_id,
m.country,
m.languages,
r.total_votes,
avg_rating
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id)
SELECT n.name actress_name,
mr.total_votes,
COUNT(rm.movie_id) movie_count,
ROUND(SUM(mr.avg_rating*mr.total_votes)/SUM(mr.total_votes),2) actress_avg_rating,
RANK() OVER(ORDER BY ROUND(SUM(mr.avg_rating*mr.total_votes)/SUM(mr.total_votes),2) DESC, mr.total_votes DESC) actress_rank
FROM names n
INNER JOIN role_mapping rm
ON n.id = rm.name_id
INNER JOIN movie_rating mr
USING (movie_id)
WHERE category = 'actress'
AND UPPER(country) REGEXP 'INDIA'
AND UPPER(languages) REGEXP 'HINDI'
GROUP BY actress_name
HAVING movie_count >= 3
ORDER BY actress_rank
LIMIT 5;

-- Top actresses are "Taapsee Pannu" followed by 'Kriti Sanon' and 'Divya Dutta'.


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT m.title,
r.avg_rating,
CASE
WHEN avg_rating > 8 THEN 'Superhit movies'
WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
ELSE 'Flop movies'
END AS rating_category
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
INNER JOIN genre g
USING (movie_id)
WHERE UPPER(g.genre) REGEXP 'THRILLER'
GROUP BY title;

-- OR (2ND APPROACH USING DISTINCT title)
SELECT DISTINCT m.title,
r.avg_rating,
CASE
WHEN avg_rating > 8 THEN 'Superhit movies'
WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
ELSE 'Flop movies'
END AS rating_category
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
INNER JOIN genre g
USING (movie_id)
WHERE UPPER(g.genre) REGEXP 'THRILLER';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH duration_summary AS
(SELECT genre,
ROUND(AVG(duration),2) avg_duration
FROM genre g
INNER JOIN movie m
ON m.id = g.movie_id
GROUP BY genre)
SELECT *,
SUM(avg_duration) OVER w1 AS running_total_duration,
AVG(avg_duration) OVER w2 AS moving_avg_duration
FROM duration_summary
WINDOW w1 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING),
w2 AS (ORDER BY genre ROWS 10 PRECEDING)
ORDER BY genre;





-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH genre_summary AS
(SELECT g.genre,
COUNT(m.id) movie_count 
FROM genre g
INNER JOIN movie m
ON m.id = g.movie_id
INNER JOIN ratings r
USING (movie_id)
WHERE r.avg_rating > 8
GROUP BY genre
ORDER BY COUNT(m.id) DESC
LIMIT 3),
grossing_summary AS
(SELECT genre,
m.year,
m.title movie_name,
CASE 
WHEN m.worlwide_gross_income regexp 'INR' 
THEN ROUND(CAST(replace(m.worlwide_gross_income, 'INR', '') AS decimal(12)) / 79.70,2)
WHEN m.worlwide_gross_income regexp '$' 
THEN ROUND(CAST(replace(m.worlwide_gross_income, '$', '') AS decimal(12)),2)
ELSE CAST(m.worlwide_gross_income AS decimal(12))
END AS worldwide_gross_income
FROM genre g
INNER JOIN movie m
ON m.id = g.movie_id
WHERE genre IN (SELECT genre FROM genre_summary)
GROUP BY movie_name),
movie_ranking AS 
(SELECT *, 
dense_rank() OVER w    AS movie_rank 
FROM grossing_summary 
WINDOW w AS (PARTITION BY year ORDER BY worldwide_gross_income DESC)
)
SELECT * 
FROM movie_ranking 
WHERE movie_rank <=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
COUNT(m.id) movie_count,
RANK() OVER(ORDER BY COUNT(m.id) DESC) prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE r.median_rating >= 8
AND LOCATE(',', m.languages)>0
AND production_company IS NOT NULL
GROUP BY production_company
ORDER BY prod_comp_rank
LIMIT 2;

-- Production company Star Cinema comes at the 1st rank with followed by Twentieth Century Fox with 7 and 4 hit movies respectively.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH movie_summary AS
(SELECT r.movie_id,
genre,
total_votes,
avg_rating
FROM ratings r
INNER JOIN genre g
USING (movie_id)
WHERE genre = 'Drama'
AND avg_rating > 8)
SELECT name actress_name,
SUM(total_votes),
COUNT(ms.movie_id) movie_count,
ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) actress_avg_rating,
RANK() OVER(ORDER BY COUNT(ms.movie_id) DESC) actress_rank
FROM names n
INNER JOIN role_mapping rm
ON id = name_id
INNER JOIN movie_summary ms
USING (movie_id)
WHERE category = 'actress'
GROUP BY actress_name
ORDER BY actress_rank
LIMIT 3;

-- Top 3 actresses based on the number of super hit movies are Parvathy Thiruvothu followed by Susan Brown and Amanda Lawrence.
-- Same way we can find the top 3 actors in "Drama" genre.
WITH movie_summary AS
(SELECT r.movie_id,
genre,
total_votes,
avg_rating
FROM ratings r
INNER JOIN genre g
USING (movie_id)
WHERE genre = 'Drama'
AND avg_rating > 8)
SELECT name actress_name,
SUM(total_votes),
COUNT(ms.movie_id) movie_count,
ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) actress_avg_rating,
RANK() OVER(ORDER BY COUNT(ms.movie_id) DESC) actress_rank
FROM names n
INNER JOIN role_mapping rm
ON id = name_id
INNER JOIN movie_summary ms
USING (movie_id)
WHERE category = 'actor'
GROUP BY actress_name
ORDER BY actress_rank
LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH lead_summary AS
(SELECT name_id,
name,
r.movie_id,
duration,
avg_rating,
total_votes,
date_published,
LEAD(date_published,1) OVER(PARTITION BY dm.name_id ORDER BY date_published,movie_id ) AS lead_date
FROM director_mapping dm
INNER JOIN names n
ON n.id = dm.name_id
INNER JOIN movie m
ON m.id = dm.movie_id
INNER JOIN ratings r
ON r.movie_id = m.id ), 
director_summary AS
(SELECT *,
DATEDIFF(lead_date, date_published) date_difference
FROM lead_summary)
SELECT name_id director_id,
NAME director_name,
COUNT(movie_id) number_of_movies,
ROUND(Avg(date_difference),2) avg_inter_movie_days,
ROUND(Avg(avg_rating),2) avg_rating,
SUM(total_votes) total_votes,
MIN(avg_rating) min_rating,
MAX(avg_rating) max_rating,
SUM(duration) total_duration
FROM director_summary
GROUP BY director_id
ORDER BY COUNT(movie_id) DESC 
LIMIT 9;


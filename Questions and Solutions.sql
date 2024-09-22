/* Q1: Who is the senior most employee based on job title? */
SELECT
	TITLE,
	LAST_NAME,
	FIRST_NAME
FROM
	EMPLOYEE
ORDER BY
	LEVELS DESC
LIMIT
	1
	
/* Q2: Which countries have the most Invoices? */
SELECT
	COUNT(*) AS C,
	BILLING_COUNTRY
FROM
	INVOICE
GROUP BY
	BILLING_COUNTRY
ORDER BY
	C DESC
	
/* Q3: What are top 3 values of total invoice? */
SELECT
	TOTAL
FROM
	INVOICE
ORDER BY
	TOTAL DESC
LIMIT
	3
	
/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */
SELECT
	BILLING_CITY,
	SUM(TOTAL) AS INVOICETOTAL
FROM
	INVOICE
GROUP BY
	BILLING_CITY
ORDER BY
	INVOICETOTAL DESC
LIMIT
	1;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
SELECT
	CUSTOMER.CUSTOMER_ID,
	FIRST_NAME,
	LAST_NAME,
	SUM(TOTAL) AS TOTAL_SPENDING
FROM
	CUSTOMER
	JOIN INVOICE ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
GROUP BY
	CUSTOMER.CUSTOMER_ID
ORDER BY
	TOTAL_SPENDING DESC
LIMIT
	1;

/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
SELECT DISTINCT
	EMAIL AS EMAIL,
	FIRST_NAME AS FIRSTNAME,
	LAST_NAME AS LASTNAME,
	GENRE.NAME AS GENRE
FROM
	CUSTOMER
	JOIN INVOICE ON INVOICE.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID
	JOIN INVOICE_LINE ON INVOICE_LINE.INVOICE_ID = INVOICE.INVOICE_ID
	JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID
	JOIN GENRE ON GENRE.GENRE_ID = TRACK.GENRE_ID
WHERE
	GENRE.NAME LIKE 'Rock'
ORDER BY
	EMAIL;

/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
SELECT
	ARTIST.ARTIST_ID,
	ARTIST.NAME,
	COUNT(ARTIST.ARTIST_ID) AS NUMBER_OF_SONGS
FROM
	TRACK
	JOIN ALBUM ON ALBUM.ALBUM_ID = TRACK.ALBUM_ID
	JOIN ARTIST ON ARTIST.ARTIST_ID = ALBUM.ARTIST_ID
	JOIN GENRE ON GENRE.GENRE_ID = TRACK.GENRE_ID
WHERE
	GENRE.NAME LIKE 'Rock'
GROUP BY
	ARTIST.ARTIST_ID
ORDER BY
	NUMBER_OF_SONGS DESC
LIMIT
	10;

/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
SELECT
	NAME,
	MILLISECONDS
FROM
	TRACK
WHERE
	MILLISECONDS > (
		SELECT
			AVG(MILLISECONDS) AS AVG_TRACK_LENGTH
		FROM
			TRACK
	)
ORDER BY
	MILLISECONDS DESC;

/* Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */
WITH
	BEST_SELLING_ARTIST AS (
		SELECT
			ARTIST.ARTIST_ID AS ARTIST_ID,
			ARTIST.NAME AS ARTIST_NAME,
			SUM(INVOICE_LINE.UNIT_PRICE * INVOICE_LINE.QUANTITY) AS TOTAL_SALES
		FROM
			INVOICE_LINE
			JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID
			JOIN ALBUM ON ALBUM.ALBUM_ID = TRACK.ALBUM_ID
			JOIN ARTIST ON ARTIST.ARTIST_ID = ALBUM.ARTIST_ID
		GROUP BY
			1
		ORDER BY
			3 DESC
		LIMIT
			1
	)
SELECT
	C.CUSTOMER_ID,
	C.FIRST_NAME,
	C.LAST_NAME,
	BSA.ARTIST_NAME,
	SUM(IL.UNIT_PRICE * IL.QUANTITY) AS AMOUNT_SPENT
FROM
	INVOICE I
	JOIN CUSTOMER C ON C.CUSTOMER_ID = I.CUSTOMER_ID
	JOIN INVOICE_LINE IL ON IL.INVOICE_ID = I.INVOICE_ID
	JOIN TRACK T ON T.TRACK_ID = IL.TRACK_ID
	JOIN ALBUM ALB ON ALB.ALBUM_ID = T.ALBUM_ID
	JOIN BEST_SELLING_ARTIST BSA ON BSA.ARTIST_ID = ALB.ARTIST_ID
GROUP BY
	1,
	2,
	3,
	4
ORDER BY
	5 DESC;

/* Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */
WITH
	POPULAR_GENRE AS (
		SELECT
			COUNT(INVOICE_LINE.QUANTITY) AS PURCHASES,
			CUSTOMER.COUNTRY,
			GENRE.NAME,
			GENRE.GENRE_ID,
			ROW_NUMBER() OVER (
				PARTITION BY
					CUSTOMER.COUNTRY
				ORDER BY
					COUNT(INVOICE_LINE.QUANTITY) DESC
			) AS ROWNO
		FROM
			INVOICE_LINE
			JOIN INVOICE ON INVOICE.INVOICE_ID = INVOICE_LINE.INVOICE_ID
			JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
			JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID
			JOIN GENRE ON GENRE.GENRE_ID = TRACK.GENRE_ID
		GROUP BY
			2,
			3,
			4
		ORDER BY
			2 ASC,
			1 DESC
	)
SELECT
	*
FROM
	POPULAR_GENRE
WHERE
	ROWNO <= 1
/* Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */
WITH RECURSIVE
	CUSTOMTER_WITH_COUNTRY AS (
		SELECT
			CUSTOMER.CUSTOMER_ID,
			FIRST_NAME,
			LAST_NAME,
			BILLING_COUNTRY,
			SUM(TOTAL) AS TOTAL_SPENDING
		FROM
			INVOICE
			JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
		GROUP BY
			1,
			2,
			3,
			4
		ORDER BY
			2,
			3 DESC
	),
	COUNTRY_MAX_SPENDING AS (
		SELECT
			BILLING_COUNTRY,
			MAX(TOTAL_SPENDING) AS MAX_SPENDING
		FROM
			CUSTOMTER_WITH_COUNTRY
		GROUP BY
			BILLING_COUNTRY
	)
SELECT
	CC.BILLING_COUNTRY,
	CC.TOTAL_SPENDING,
	CC.FIRST_NAME,
	CC.LAST_NAME,
	CC.CUSTOMER_ID
FROM
	CUSTOMTER_WITH_COUNTRY CC
	JOIN COUNTRY_MAX_SPENDING MS ON CC.BILLING_COUNTRY = MS.BILLING_COUNTRY
WHERE
	CC.TOTAL_SPENDING = MS.MAX_SPENDING
ORDER BY
	1;
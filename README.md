# Music Store Data Analysis

## Project Overview
This project focuses on analyzing a music store's data using **SQL**. Various queries were run on the store's database to extract meaningful insights related to sales, customer activity, and artist performances. The analysis covered topics such as identifying the top customers, best-performing cities, and most popular music genres across different regions.

## Tools and Technologies
- **Data Analysis**: SQL
- **Database**: Customer, Invoice, Track, Genre datasets and more

## Dataset
The dataset includes tables for employees, invoices, customers, tracks, artists, and music genres. The data was analyzed using a series of SQL queries.

### Key Queries & Analysis

1. **Top Employees**: Identified the senior-most employee based on job title.
    ```sql
    SELECT TITLE, LAST_NAME, FIRST_NAME 
    FROM EMPLOYEE 
    ORDER BY LEVELS DESC LIMIT 1;
    ```

2. **Most Invoices by Country**: Counted invoices by billing country.
    ```sql
    SELECT COUNT(*) AS C, BILLING_COUNTRY 
    FROM INVOICE 
    GROUP BY BILLING_COUNTRY 
    ORDER BY C DESC;
    ```

3. **Top Invoice Values**: Extracted the top 3 highest invoice totals.
    ```sql
    SELECT TOTAL FROM INVOICE 
    ORDER BY TOTAL DESC LIMIT 3;
    ```

4. **Best City for a Music Festival**: Identified the city with the highest sum of invoice totals to plan a music festival.
    ```sql
    SELECT BILLING_CITY, SUM(TOTAL) AS INVOICETOTAL 
    FROM INVOICE 
    GROUP BY BILLING_CITY 
    ORDER BY INVOICETOTAL DESC LIMIT 1;
    ```

5. **Best Customer**: Identified the customer who spent the most.
    ```sql
    SELECT CUSTOMER.CUSTOMER_ID, FIRST_NAME, LAST_NAME, SUM(TOTAL) AS TOTAL_SPENDING 
    FROM CUSTOMER 
    JOIN INVOICE ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID 
    GROUP BY CUSTOMER.CUSTOMER_ID 
    ORDER BY TOTAL_SPENDING DESC LIMIT 1;
    ```

6. **Rock Music Listeners**: Listed customers who listen to Rock music, ordered by email.
    ```sql
    SELECT DISTINCT EMAIL, FIRST_NAME, LAST_NAME, GENRE.NAME 
    FROM CUSTOMER 
    JOIN INVOICE ON INVOICE.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID 
    JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID 
    JOIN GENRE ON GENRE.GENRE_ID = TRACK.GENRE_ID 
    WHERE GENRE.NAME = 'Rock' 
    ORDER BY EMAIL;
    ```

7. **Top 10 Rock Artists**: Identified the top 10 rock artists based on track count.
    ```sql
    SELECT ARTIST.NAME, COUNT(TRACK.TRACK_ID) AS TRACK_COUNT 
    FROM ARTIST 
    JOIN ALBUM ON ARTIST.ARTIST_ID = ALBUM.ARTIST_ID 
    JOIN TRACK ON TRACK.ALBUM_ID = ALBUM.ALBUM_ID 
    WHERE GENRE.NAME = 'Rock' 
    GROUP BY ARTIST.NAME 
    ORDER BY TRACK_COUNT DESC LIMIT 10;
    ```

8. **Longest Songs**: Listed tracks that are longer than the average song length.
    ```sql
    SELECT NAME, MILLISECONDS 
    FROM TRACK 
    WHERE MILLISECONDS > (SELECT AVG(MILLISECONDS) FROM TRACK) 
    ORDER BY MILLISECONDS DESC;
    ```

9. **Customer Spending on Artists**: Returned customer name, artist name, and total spending on music tracks.
    ```sql
    WITH BEST_SELLING_ARTIST AS (SELECT ARTIST_ID, NAME, SUM(UNIT_PRICE * QUANTITY) AS TOTAL_SALES 
    FROM INVOICE_LINE 
    GROUP BY ARTIST_ID) 
    SELECT CUSTOMER.FIRST_NAME, CUSTOMER.LAST_NAME, ARTIST.NAME, SUM(INVOICE_LINE.UNIT_PRICE * INVOICE_LINE.QUANTITY) AS AMOUNT_SPENT 
    FROM CUSTOMER 
    JOIN INVOICE ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID 
    JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID 
    JOIN ALBUM ON ALBUM.ALBUM_ID = TRACK.ALBUM_ID 
    JOIN ARTIST ON ARTIST.ARTIST_ID = ALBUM.ARTIST_ID 
    GROUP BY CUSTOMER.CUSTOMER_ID, ARTIST.NAME;
    ```

10. **Popular Genre by Country**: Found the most popular genre in each country.
    ```sql
    SELECT CUSTOMER.COUNTRY, GENRE.NAME, COUNT(*) AS PURCHASES 
    FROM INVOICE 
    JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID 
    JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID 
    JOIN GENRE ON GENRE.GENRE_ID = TRACK.GENRE_ID 
    GROUP BY CUSTOMER.COUNTRY, GENRE.NAME 
    ORDER BY CUSTOMER.COUNTRY, PURCHASES DESC;
    ```

11. **Top Customer per Country**: Identified the top-spending customer in each country.
    ```sql
    SELECT CUSTOMER.COUNTRY, FIRST_NAME, LAST_NAME, SUM(TOTAL) AS SPENDING 
    FROM CUSTOMER 
    JOIN INVOICE ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID 
    GROUP BY CUSTOMER.COUNTRY, CUSTOMER.CUSTOMER_ID;
    ```

## Learning & Outcomes
- Strengthened SQL querying skills, including **JOINs**, **GROUP BY**, **subqueries**, and **window functions**.
- Gained insights into customer behavior and sales trends by analyzing music store data.
- Applied advanced techniques for data aggregation and report generation.

---

### Contact
For questions or further discussion, reach out:
- **Email**: [mohammad.rabius.sanii@gmail.com](mailto:mohammad.rabius.sanii@gmail.com)
- **LinkedIn**: [LinkedIn Profile](https://www.linkedin.com/in/mohammad-rabius-sani/)

#Write SELECT statements to perform the following queries on the bookstore database.

#Exercise 1: # Fetch ISBN of all book editions published by the publisher "Random House". 
#You should have 3 results.
SELECT e.isbn 
FROM editions AS e, publishers AS p 
WHERE p.id = e.publisher_id AND p.name = 'Random House'

#Exercise 2: Instead of just their ISBN number, fetch their Book Title as well.
SELECT e.isbn, b.title
FROM editions AS e, publishers AS p, books AS b
WHERE p.id = e.publisher_id AND b.id = e.book_id AND p.name = 'Random House';

#I practiced using intricate joins here
SELECT e.isbn, b.title
FROM ((editions AS e INNER JOIN publishers AS p ON (p.id = e.publisher_id)) 
INNER JOIN books AS b ON (b.id = e.book_id))
WHERE p.name = 'Random House';

#Exercise 3: Also include their stock information (available stock and retail price for each book edition).
SELECT b.title, s.stock, s.retail, s.isbn
FROM (((editions AS e INNER JOIN publishers AS p ON (p.id = e.publisher_id)) 
INNER JOIN books AS b ON (b.id = e.book_id))
INNER JOIN stock AS s ON (s.isbn = e.isbn))
WHERE p.name = 'Random House';

#Exercise 4: Note how one of the of books has 0 stock. Modify the query to only return books that are in stock.
SELECT b.title, s.stock, s.retail, s.isbn
FROM (((editions AS e INNER JOIN publishers AS p ON (p.id = e.publisher_id)) 
INNER JOIN books AS b ON (b.id = e.book_id))
INNER JOIN stock AS s ON (s.isbn = e.isbn))
WHERE p.name = 'Random House'AND s.stock > 0;

#Exercise 5: Editions has a column called "type". 
#Include the print type but instead of just displaying "h" or "p" 
#(the values in the column) output the human readable types ("hardcover" and "paperback" accordingly)
SELECT b.title, s.stock, s.retail, s.isbn,
CASE WHEN e.type = 'h' THEN 'hardcover'
     ELSE 'paperback'
     END AS type
FROM (((editions AS e INNER JOIN publishers AS p ON (p.id = e.publisher_id)) 
INNER JOIN books AS b ON (b.id = e.book_id))
INNER JOIN stock AS s ON (s.isbn = e.isbn))
WHERE p.name = 'Random House'AND s.stock > 0;

#Exercise 6: List all book titles along with their publication dates (column on the editions dates) 
#That's 2 columns: "title" and "publication"
SELECT b.title, e.publication
FROM editions AS e FULL OUTER JOIN books AS b ON (b.id = e.book_id);


#Practiced performing aggregate functions

#Exercise 7: What's the total inventory of books in this library (i.e. how many total copies are in stock)?
SELECT sum(stock)
FROM stock;

#Exercise 8: What is the overall average cost and retail price for all books for sale? 
#Return three columns "Average cost", "Average Retail" and "Average Profit"
SELECT avg(cost) AS "Average Cost",
       avg(retail) AS "Average Retail",
       avg(retail - cost) AS "Average Profit"
FROM stock;


#Exercise 9: 
#Which book ID has the most pieces in stock?
SELECT e.book_id 
FROM editions AS e INNER JOIN stock AS s
ON e.isbn = s.isbn
ORDER BY s.stock DESC
LIMIT 1;


#Exercise 10: List author ID along with the full name and the number of books they have written. 
#Output 3 columns: "ID", "Full name" and "Number of Books"
SELECT a.id AS "ID",
      (a.first_name || ' '|| a.last_name) AS "Full Name", 
      COUNT (e.isbn) AS "Number of Books"
FROM books AS b INNER JOIN editions AS e ON (b.id = e.book_id)
INNER JOIN authors AS a ON (b.author_id = a.id)
GROUP BY a.id;

#Exercise 11: Order the result set above by number of books so that authors 
#with most number of books appear atop the list (descending order).
#I used book id here instead of isbn as it made more sense to me. 

SELECT a.id AS "ID",
      (a.first_name || ' '|| a.last_name) AS "Full Name", 
      COUNT (e.book_id) AS "Number of Books"
FROM books AS b INNER JOIN editions AS e ON (b.id = e.book_id)
INNER JOIN authors AS a ON (b.author_id = a.id)
GROUP BY a.id
ORDER BY (COUNT(e.book_id)) DESC;






Database Setup
We will be using Heroku's postgres service to create (provision) a database in the cloud.

Go ahead and log in to the dashboard with your heroku credentials now: https://postgres.heroku.com. Sign up for a Heroku account first if needed.

Create a free database (Dev Plan). This will create a brand spanking new PostgreSQL database instance for you. It will be empty of course, meaning it will have no tables or data.

Heroku Create Database Page

Installing Heroku Toolbelt
Before we can connect to the database, we need to download and install Heroku's command line client.

Download and install the Heroku Toolbelt for Debian/Ubuntu in your vagrant virtual machine using the wget command they give you here: https://toolbelt.heroku.com/debian. You can run it from anywhere within your vagrant box.

Connecting via command line
Copy the heroku:psql from the heroku database details page: Heroku Database Details page

From anywhere within your vagrant box, paste this command in the prompt.

Example run: Example PSQL Screenshot

This Heroku command is actually just a convenience for the real deal, the psql command. This command comes with the Postgres installation. Your vagrant box already has postgres installed on it. Just like irb and pry, psql is a REPL (Read-Eval-Print-Loop), aka interactive shell. However, instead interactive ruby, it's an interactive shell for executing SQL against a live database connection.

Some useful psql commands for you to try out at this point (in order) are: * \d - List all of the relations (tables, sequences, etc) in your database. Use arrow keys / spacebar to nav * \q - Quit psql

Go ahead and use the \q command to quit psql.

The database is still empty... Let's load it up with data.

Loading with data
We'll be creating a Bookstore database. Please download the following SQL file to your folder where your project files are (Run cd /vagrant in your vagrant machine):

https://gist.githubusercontent.com/kvirani/7742279/raw/bf24ac9bb25f2bfeb5200856a3c22f7733ef8e08/bookstore.sql

Pro Tip: Use the wget unix command utility to download (get) a file from the web onto your local machine:

wget https://gist.githubusercontent.com/kvirani/7742279/raw/bf24ac9bb25f2bfeb5200856a3c22f7733ef8e08/bookstore.sql
We can run the SQL instructions in this script file against our database using the heroku pg:psql command line tool. cd into the directory where the sql file is saved. Paste that heroku pg:psql command (that heroku gave you) but append the following to the command before running it:

< bookstore.sql
The full command will look something like this:

heroku pg:psql --app SOMECUSTOMDETAILS < bookstore.sql
Recall that The < in unix tells heroku pg:psql to take its input from that file instead of "standard input" (your keyboard).

Important Note: It's important that bookstore.sql is in the same folder (/vagrant) from which you are running the heroku pg:psql command. If you are not, then you have to specify the path to the sql file because the instructions above provide just a relative path to the file.

As soon as you run that, you should start seeing output on multiple lines, starting with CREATE TABLE.

Playing with psql
Cool... so let's check out our db. Connect to it using heroku pg:psql command just like we had initially (without the < bookstore.sql appended to the command since we've already run our SQL script against the database and we only need to do that once to load up the db).

Once you're in the psql shell, run the \d command and you will see a list of the tables: Screenshot

Note: You can press q when psql is listing out stuff and there is more to show. You can also use arrow keys to move up or down and the space key to page down.

Let's run some basic SQL to check out the data:

SELECT * from books;
Resulting output

Boom... you're browsing your bookstore data! Try it out with some of the other tables (customers, subjects, authors, etc). Recall that \d will list out tables in your db.

Some Useful Tips
All SQL statements must terminate/end with semincolon (;). If you accidentally forget it before hitting enter, that's okay. psql allows multi-line SQL so you can just add the ; on the next line and hit enter again. That will run your query.
SQL is case insensitive. This means that SELECT * FROM books; is the same as select * from BOOKS;.
That said, general convention is to upcase the SQL keywords (SELECT, FROM, WHERE, etc) and downcase names of tables, columns, etc.
Errors
Enter in some invalid queries to get acquainted and comfortable with error feedback from postgres.

psql error example

pgAdmin III
Many developers are happy with command line. Some others prefer a GUI. pgAdmin is (unfortunately) the most popular and feature rich app to use for postgres. Go ahead and download the latest version:

Mac OS X Download Link

Launch a new connection window, and input your host, db and username in the appropriate fields

Screenshot

Don't copy my credentials above, use yours from the heroku page

Screenshot

Once connected, you'll see a crap load of databases listed under your server. Thankfully it's sorted alphabetically. You'll have to scroll down until you visually locate your database (sorry!). I know what you're thinking at this point... "I'll just start typing in the name of the database instead"... Don't bother. They've made sure to waste your time here.

Once you've located your database in the list (congratulations!), expand it and drill down until you get to the list of tables

Screenshot

Notes:
pgAdmin is notorious for "beachballing". Be patient with it if it does. If you're not feeling patient, just kill and relaunch it. I do this all the time. I don't have time to stare at a beach ball. I've got things to see and people to do.
It also crashes from time to time. It's been like this for years, and with every update its instability remains constant.
If it prompts you for adding Server Instrumentation, please ignore the message and don't attempt to fix it.
You'll be using the SQL button located in the top toolbar ("Execute arbitrary SQL queries") to run your SQL just like you were in psql.

Try out some of the SELECTs you ran previously. It should look a bit better than working in psql.

Screenshot

Practice with SELECT queries
Follow along by typing in (don't copy/paste!) and executing the queries into your psql or pgAdmin client.

1. Using Aliases for table names
We alias books as b because, well developers are lazy:

SELECT b.id, b.author_id, b.title, id FROM books AS b;
2. Joining two tables
SELECT b.id, b.title, a.id, a.last_name FROM books AS b, authors AS a WHERE b.author_id = a.id;
3. Avoid ambiguous column names
Always prefix columns with table names/aliases. It's better to be explicit about what table you want your columns from, incase the same column exists in multiple tables that you are querying.

Try query #2 above again but swap out b.id with just id. You'll get the following error: ERROR: Column reference "id" is ambiguous.

4. Columns in the Result Set
Columns in the result set don't have to mimic a table's columns.

Note how in the query below the full-name column is being constructed by concatenating two columns, and other columns are aliased (much like table names were aliased earlier):

SELECT b.id as "Book ID", b.title AS "Book Title", a.id AS "Author ID", (a.last_name || ' ' || a.first_name) AS "Author Full Name" FROM books AS b, authors AS a WHERE b.author_id = a.id;
5. Referencing strings vs objects
Try running the query above again after changing the single quotes to double quotes. Note how it's looking for a column instead. In SQL, double quotes are used to qualify table/column (object) names. Single quotes are used for strings.

6. Unique results only
The optional DISTINCT keyword excludes duplicate rows from the result set. Only columns in the SELECT's target list will be evaluated.

For example, the books table has 15 rows, each with an author_id. Some authors may have several entries in the books table, causing there to be several rows with the same author_id. Supplying the DISTINCT clause ensures that the result set will not have two identical rows.

Run the two queries using DISTINCT from this example and read their explanation: http://www.commandprompt.com/ppbook/x5802.htm#USINGDISTINCT

7. WHERE clause to get subset
Read about and run the queries from here: http://www.commandprompt.com/ppbook/x5802.htm#ASIMPLEWHERECLAUSE

8. INNER vs OUTER joins
There are two major types of joins, Inner and Outer. We've already (implicitly) performed an INNER JOIN in query #2 above, but lets modify it slightly.

SELECT b.id, b.title, a.id, a.last_name FROM books AS b, authors AS a WHERE
b.author_id = a.id AND a.last_name = 'Geisel';
Note the join condition is really specified in the WHERE clause (b.author_id = a.id). This query can be rewritten as:

SELECT b.id, b.title, a.id, a.last_name FROM books AS b INNER JOIN authors AS a ON b.author_id = a.id WHERE a.last_name = 'Geisel';
You can add parentheses around the conditions in the query above to help with readability:

SELECT b.id, b.title, a.id, a.last_name FROM books AS b INNER JOIN authors AS a ON (b.author_id = a.id) WHERE (a.last_name = 'Geisel');
Okay so what about OUTER joins? Read about them here: http://www.commandprompt.com/ppbook/x5802.htm#AEN6531

This blog post is a good visual explanation of SQL joins.

Next, try out this example: http://www.commandprompt.com/ppbook/x5802.htm#INNERJOINSVERSUSOUTERJOINS

SELECT Exercises
Write SELECT statements to perform the following queries on the bookstore database.

Exercise 1
Fetch ISBN of all book editions published by the publisher "Random House". You should have 3 results.

Exercise 2
Instead of just their ISBN number, fetch their Book Title as well. You should still have the same 3 results but with more information. But instead of just one column, we should have 2 columns in the result set.

Exercise 3
Also include their stock information (available stock and retail price for each book edition). You should still have the same 3 results but with more information. But instead of just 2 columns, we should have 4 columns in the result set.

Exercise 4
Note how one of the of books has 0 stock. Modify the query to only return books that are in stock.

Exercise 5
Hardcover vs Paperback

Editions has a column called "type". Include the print type but instead of just displaying "h" or "p" (the values in the column) output the human readable types ("hardcover" and "paperback" accordingly)

Hint: Use a CASE statement to manipulate your result set, as in this example.

Exercise 6
List all book titles along with their publication dates (column on the editions dates) That's 2 columns: "title" and "publication"

Important Notes: * Certain books (such as "Learning Python") don't have any editions but we still want to see those books in the results. They just shouldn't have a publication date associated with them. * Certain other books (such as "Dune") have multiple editions and they will be repeated multiple times in the result set.

Aggregate Functions
You can read about how to perform aggregate functions here: http://www.commandprompt.com/ppbook/x8973#AGGREGATEFUNCTIONSTABLE

Exercise 7
What's the total inventory of books in this library (i.e. how many total copies are in stock)?

Exercise 8
What is the overall average cost and retail price for all books for sale? Return three columns "Average cost", "Average Retail" and "Average Profit"

Exercise 9
Which book ID has the most pieces in stock?

Hints: 1. Use an aggregate function combined with LIMIT and ORDER BY clauses. 2. No need to join with the books table since we just want the ID which is already in the editions table.

Grouping results
Read about grouping here: http://www.commandprompt.com/ppbook/x5802#USINGGROUPBY

Exercise 10
List author ID along with the full name and the number of books they have written. Output 3 columns: "ID", "Full name" and "Number of Books"

Exericse 11
Order the result set above by number of books so that authors with most number of books appear atop the list (descending order).

Advanced, Bonus Exercises
Exercise 12
List books that have both paperback and hardcover editions. That means at least one edition of the book in both formats.

The result contains four books:

The Shining
Dune
2001: A Space Odyssey
The Cat in the Hat
Exercise 13
For each publisher, list their average book sale price, number of editions published.

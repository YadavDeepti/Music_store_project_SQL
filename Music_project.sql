Q. find he senior most employee based on job title?

Select * from employee
Order by levels desc
Limit 1;


Q2. which country has the most invoices?

Select Count(*) As c, billing_country 
from invoice
Group By billing_country
Order By c desc;


Q3. What are top 3 values of total invoices?

Select total from invoice
Order by total desc
limit 3;


Q4. Which city has the highest customers.Return one city that has highest sum of invoice totals.
    Retuen both city name and sum of all invoice totals.


Select sum(total) As invoice_total, billing_city 
from invoice
Group By billing_city
Order By invoice_total desc;


Q5. Find the highest spending customer?


Select customer.customer_id, customer.first_name, customer.last_name, Sum(invoice.total) As total
From customer
Join invoice On customer.customer_id = invoice.customer_id
Group By customer.customer_id
Order By total desc
Limit 1;

Q6. find email, first name, last name, genre of all rock bands. 
Email should be in alphabetical order.

Select distinct email, first_name, last_name
from customer
Join invoice On customer.customer_id = invoice.customer_id
Join invoice_line On invoice.invoice_id = invoice_line.invoice_id
Where track_id In(
				Select track_id from track
				Join genre On track.genre_id = genre.genre_id
				Where genre.name = 'Rock'
)
Order By email;

Q7. find the artist name and total track count of the top 10 rock bands.


Select artist.artist_id, artist.name, count(artist.artist_id) As Number_of_songs
From track
Join album On album.album_id = track.album_id
Join artist On artist.artist_id = album.artist_id
Join genre On genre.genre_id = track.genre_id
Where genre.name Like 'Rock'
Group By artist.artist_id
Order By Number_of_songs Desc
Limit 10;
Q8. Return all the track names that have a song length longer than the average lenght.Return name and 
millisecond for track.

Select name, milliseconds
from track
where milliseconds > (
					Select avg(milliseconds) As avg_track_lenght
					From track
					)
ORDER bY milliseconds Desc;

Q9.find how much amount spend by each customer on artist? Write the query to return customer name, 
   artist name and total spent?

With best_selling_artist As(
			Select artist.artist_id as artist_id, artist.name as artist_name,
			Sum(invoice_line.unit_price * invoice_line.quantity) As total_sales
			From invoice_line
			Join track On track.track_id = invoice_line.track_id
			Join album On album.album_id = track.album_id
			Join artist On artist.artist_id = album.artist_id
	        Group By 1
	        Order By 3 Desc
	        Limit 1
  )
  
Select c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
Sum(il.unit_price * il.quantity) As amount_spent
From invoice i
Join customer c On c.customer_id = i.customer_id
Join invoice_line il On il.invoice_id = i.invoice_id
Join track t On t.track_id = il.track_id
Join album alb On alb.album_id = t.album_id
Join best_selling_artist bsa On bsa.artist_id = alb.artist_id
Group By 1,2,3,4
Order By 5 Desc

Q10. Find most popular genre(highest amont of purchases) for each country.

With popular_genre As(
	Select count(invoice_line.quantity) As purchases, customer.country, genre.name,genre.genre_id,
	Row_number() Over(Partition By customer.country Order By Count(invoice_line.quantity) Desc) As RowNumber
	From invoice_line
	Join invoice On invoice.invoice_id = invoice_line.invoice_id
	Join customer On customer.customer_id = invoice.customer_id
	Join track On track.track_id = invoice_line.track_id
	Join genre On genre.genre_id = track.genre_id
	Group By 2,3,4
	Order By 2 Asc, 1 Desc
)
Select * from popular_genre Where RowNumber <= 1;

Q11. Find the country with highest spending customers and how much they spend.
With Recursive 
  customer_with_country As(
	Select customer.customer_id, first_name, last_name, billing_country, Sum(total) As total_spending
	From invoice
	Join customer On customer.customer_id = invoice.customer_id
	Group By 1,2,3,4
	Order By 1,5 Desc ),
  country_max_spending As(
    Select billing_country, Max(total_spending) As max_spending
	From customer_with_country
	Group by billing_country )

Select cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
From customer_with_country cc
Join country_max_spending ms
On cc.billing_country = ms.billing_country
Where cc.total_spending = ms.max_spending
Order By 1;





















































































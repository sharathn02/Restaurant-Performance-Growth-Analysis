-- Rating demography
select city, sum(case when rating_category = 'Unrated' then 1 end) as total_unrated,
round(100.0 * count(case when rating_category = 'Unrated' then 1 end) / (select count(*) from zomato.zomato), 2) as unrated_percentage
from zomato.zomato
group by city
having sum(case when rating_category = 'Unrated' then 1 end) is not null
order by total_unrated desc;

-- Delivery comparison
select 
	has_online_delivery,
	round(avg(case when aggregate_rating > 0 then aggregate_rating end), 0) as average_rating, 
	round(avg(votes), 0) as average_votes, 
	round(avg(average_cost_for_two), 0) as average_cost, 
	round(avg(price_range), 0) as average_pricerange
from zomato.zomato
group by has_online_delivery;

-- Table booking comparison
select 
	has_table_booking,
	round(avg(case when aggregate_rating > 0 then aggregate_rating end), 0) as average_rating, 
	round(avg(votes), 0) as average_votes, 
	round(avg(average_cost_for_two), 0) as average_cost, 
	round(avg(price_range), 0) as average_pricerange
from zomato.zomato
group by has_table_booking;

-- Price range comparison
select price_range, 
	round(avg(case when aggregate_rating > 0 then aggregate_rating end), 0) as average_rating,
	round(avg(votes), 0) as average_votes,
	round(count(case when has_online_delivery = 'Yes' then 1 end), 0) as total_online_delivery,
	round(count(case when has_table_booking = 'Yes' then 1 end), 0) as total_table_booking
from zomato.zomato
group by price_range
order by avg(votes) desc;

-- Revenue potential analysis
select
price_range,
round(avg(votes), 0) as average_votes,
round(avg(average_cost_for_two), 0) as average_pricing,
round(avg(aggregate_rating), 1) as average_rating,
round(avg(votes) * avg(average_cost_for_two), 0) as commercial_potential
from zomato.zomato
where country_code = '1'
group by price_range
order by price_range;

-- City level analysis
select
city, count(restaurant_id) as total_counts,
round(avg(aggregate_rating), 1) as average_rating,
round(avg(votes), 0) as average_votes,
round(avg(price_range), 0) as average_price_range,
coalesce(sum(case when has_online_delivery = 'Yes' then 1 end), 0) as delivery,
coalesce(sum(case when rating_category = 'Unrated' then 1 end), 0) as unrated
from zomato.zomato
group by city
order by average_votes desc;

-- Top 10 city by counts
select city, count(restaurant_id) as total_counts 
from zomato.zomato
group by city
order by total_counts desc
limit 10;

-- Top 10 city by total votes
select city, sum(votes) as total_votes
from zomato.zomato
group by city
order by total_votes desc
limit 10;

-- Top 10 cities by average rating
select city, round(avg(aggregate_rating), 1) as average_rating
from zomato.zomato
where rating_category <> 'Unrated'
group by city
order by average_rating desc
limit 10;

-- Top 10 cities by unrated percentage
select city, 
round(100.0 * count(case when rating_category = 'Unrated' then 1 end) / (select count(restaurant_id) from zomato.zomato), 2) as unrated_pct
from zomato.zomato
group by city
order by unrated_pct desc
limit 10;

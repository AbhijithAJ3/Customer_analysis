
select *
from customer
limit 10;

-- gender wise revenue
select sum(purchased_amount),gender
from customer
group by gender;

-- customer who have discount and above the avg purchase amount
select count(customer_id)
from customer
where discount_applied='Yes' and purchased_amount>
		(select avg(purchased_amount)
		from customer);

-- top 5 product with highest avg review rating
select item_purchased,ROUND(avg(review_rating)::NUMERIC,2) as avg_rating
from customer
group by item_purchased
order by avg_rating desc
limit 5;

-- compare avg purchase amounts btw standard and express shipping
select shipping_type,round(avg(purchased_amount)::numeric,2) as avg_amount
from customer
where shipping_type in('Express','Standard')
group by shipping_type;



-- do subscribed customer spend more?compare avg spend and total revenue btw subscribers and non subscribers

select subscription_status,
	round(avg(purchased_amount)::numeric,2) as avg_spend,
	round(sum(purchased_amount)::numeric,2) as total_revenue
from customer
group by subscription_status
order by subscription_status desc;

-- which 5 products have highest percentage of purchase with discount applied

select item_purchased,
	round(100*SUM(
		CASE WHEN discount_applied='Yes' then 1 else 0 end)/count(*),2) as percentage_of_purchase
from customer
group by item_purchased
order by percentage_of_purchase desc
limit 5;



-- segment customer into new,returning,loyal based on their total number of prev purchases and shows the count of each segment

with customer_type as
(
select customer_id,previous_purchases,
case
	when previous_purchases=1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
	when previous_purchases >10 then 'loyal'
end as customer_category
from customer
)
select customer_category,count(customer_category) as number_of_customers
from customer_type
group by customer_category
order by 1 ;


-- what are the top 3  most purchased products within each category
 
with tablee as(
select category,item_purchased,
	count(customer_id) as total_orders,
row_number() over (partition by category order by count(customer_id) desc) as ranks
from customer
group by category,item_purchased
)
select category,item_purchased,total_orders
from tablee
where ranks<=3;



-- are customer who are repeat buyers(more than 5 prev purchase) also likely to subscribe?
select subscription_status,count(customer_id) as people
from customer
where previous_purchases>5
group by subscription_status;
;


-- revenue contribution of each age group

select age_group,sum(purchased_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;



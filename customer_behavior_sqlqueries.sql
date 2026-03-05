select*from customer limit 20;


SELECT gender, SUM(purchase_amount) AS revenue
FROM customer
GROUP BY gender;


SELECT customer_id, purchase_amount
FROM customer
WHERE discount_applied = 'Yes'
AND purchase_amount >= (
    SELECT AVG(purchase_amount)
    FROM customer
);

SELECT item_purchased,
       ROUND(AVG(review_rating)::numeric, 2) AS "Average Product Rating"
FROM customer
GROUP BY item_purchased
ORDER BY "Average Product Rating" DESC
LIMIT 5;


SELECT shipping_type,
       ROUND(AVG(purchase_amount)::numeric, 2) AS avg_purchase
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

Select subscription_status,
count(customer_id) as total_customers,
ROUND(avg(purchase_amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc


SELECT item_purchased,
       ROUND(
           100.0 * SUM(
               CASE 
                   WHEN discount_applied = 'Yes' THEN 1 
                   ELSE 0 
               END
           ) / COUNT(*)
       , 2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;



with customer_type as(
select customer_id,previous_purchases,
Case
    when previous_purchases = 1 then 'new'
	when previous_purchases between 2 and 10 then 'returning'
	else 'loyal'
	end as customer_segment
from customer
)
select customer_segment, count(*) as "number of customers"
from customer_type
group by customer_segment;






WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (
               PARTITION BY category
               ORDER BY COUNT(customer_id) DESC
           ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT item_rank,
       category,
       item_purchased,
       total_orders
FROM item_counts
WHERE item_rank <= 3;




select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases>5
group by subscription_status;



select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc





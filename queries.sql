-- queries

-- Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders;

-- calculate the total revenue generated from pizza sales.
-- revenue = quantity * sales 
select
round(sum(order_details.quantity * pizzas.price),2) as total_sales 
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.
-- order by desc or aesc.

select 
pizzas.price, pizza_types.name
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
order by pizzas.price desc limit 1;

-- Identify the most common pizza size ordered.
-- 
select 
pizzas.size, count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by order_count desc limit 1;

select 
pizzas.size , count(order_details.order_details_id) as order_c, pizza_types.name
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
join pizza_types
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizzas.size ,pizza_types.name
order by order_c desc;

-- List the top 5 most ordered pizza types along with their quantities.
-- quantity and name

select 
sum(order_details.quantity) as quantity , pizza_types.name
from pizzas join pizza_types
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by quantity desc limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select 
sum(order_details.quantity) as quantity , pizza_types.category
from pizzas join pizza_types
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity desc limit 5;

-- Determine the distribution of orders by hour of the day.
select 
hour(order_time) , count(order_id)
from orders
group by hour(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.

select 
pizza_types.category, count(pizzas.pizza_type_id) as count
from pizza_types 
join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select avg(quantity) from 
(select
orders.order_date , sum(order_details.quantity) as quantity
from orders	
join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
-- revenue quantity * price


select 
round(sum(pizzas.price*order_details.quantity),2) as revenue , pizza_types.name
from pizzas
join order_details
on pizzas.pizza_id = order_details.pizza_id
join pizza_types
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by revenue desc limit 5;

-- total revenue 
select 
round(sum(pizzas.price *order_details.quantity),2)
from pizzas
join order_details
on order_details.pizza_id = pizzas.pizza_id;

-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category ,
round(sum(pizzas.price * order_details.quantity) / 
(select 
round(sum(pizzas.price *order_details.quantity),1)
from pizzas
join order_details
on order_details.pizza_id = pizzas.pizza_id )*100,0) as revenue
from pizzas 
join order_details
on order_details.pizza_id = pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category
order by revenue desc;

-- Analyze the cumulative revenue generated over time.

select order_date,
sum(revenue) over(order by order_date) as cum_rev
from 
(select orders.order_date , round(sum(order_details.quantity * pizzas.price),2) as revenue
from orders 
join order_details
on order_details.order_id = orders.order_id
join pizzas
on pizzas.pizza_id = order_details.pizza_id
group by orders.order_date) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select pizza_types.category , sum(order_details.order_id) as orders
from pizza_types
join pizzas 
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name , revenue from
(select category , name, revenue,
rank() over(partition by category order by revenue desc) as ranking
from
(select pizza_types.category , pizza_types.name,
round(sum(order_details.quantity * pizzas.price),2) as revenue
from pizzas
join pizza_types 
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category , pizza_types.name) as a ) as b
where ranking <= 3; 

-- revenue per category

select pizza_types.category , 
sum(order_details.quantity * pizzas.price) as revenue
from pizzas
join order_details
on order_details.pizza_id = pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category
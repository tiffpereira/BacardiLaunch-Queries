# Bacardi - Iowa Liquor Sales Analysis

## Project Overview
This involved analyzing Iowa liquor sales data to uncover insights and opportunities for a new Bacardi product, to grow its market share and have a successful launch. The analysis was conducted using SQL, focusing on sales trends, category and product performance, and market share. The data from the SQL queries where visualized using Excel. 

### Data Source
The data was sourced from [source name/link], which contains detailed transactional data on liquor sales in Iowa.

## Key Objectives
- Identify the top-performing vendors based on total sales.
- Evaluate total profits and market share for vendors across all product categories.
- Analyze Bacardi's market share within various product categories.
- Assess the profitability of distinct product categories.
- Determine the most promising category for Bacardi to introduce a new product, based on its performance in the Iowa market.
- Highlight the key attributes (proof, shelf price, bottle size, etc.) that contribute to the success of products in the selected category.
- Identify top-performing counties and specific stores for Bacardi product rollout, emphasizing profit per capita and overall profits.

### Example SQL Queries
#### Profitability of Different Product Categories
```
SELECT category_name,			
    SUM((btl_price - state_btl_cost) * bottle_qty) AS total_profit			
FROM sales			
WHERE category_name IS NOT NULL 			
GROUP BY category_name			
ORDER BY total_profit DESC
```

#### Top 10 Performing Vendors Based on Total Sales
```
SELECT 			
	CASE 		
        WHEN vendor = 'Bacardi U.S.A., Inc.' THEN 'Bacardi U.S.A. Inc.'			
        ELSE vendor 			
    END AS corrected_vendor,			
	SUM(total :: money) AS total_sales		
FROM sales			
GROUP BY corrected_vendor			
ORDER BY total_sales DESC			
LIMIT 10
```

#### Bacardi's Market Share in Various Products and their Defining Elements
```
WITH CategoryProfits AS (			
    SELECT products.category_name,			
        SUM((sales.btl_price - sales.state_btl_cost) * sales.bottle_qty) AS category_total_profit			
    FROM sales INNER JOIN products 			
    ON sales.item = products.item_no			
    GROUP BY products.category_name			
)			
...
ORDER BY market_share DESC
```
For a detailed look into the SQL queries used in this project, please refer to the [SQL File](bacardi-queries.sql).


### Key Findings & Recommendations 
#### Product Strategy:

##### Category:
Prioritize the Spiced Rum category, where Bacardi's market share is just 0.7%, given it's the third-largest market in Iowa.

##### Specifications:
- Proof: Introduce a product with 70 proof, in line with top-performing products in this category.
- Bottle Size: Launch with a 1750 mL bottle, reflecting the preference of the dominant segment.
- Shelf Price: Position the product at a $27 price point, a successful benchmark among leading products in the 1750 mL category. For a 1000 mL bottle variant, a price of $17.63 is recommended based on top performers.

##### Market Entry Strategy:
Geographic Focus: Concentrate on counties with the highest Spiced Rum profit per capita, specifically Dickinson, Carroll, Kossuth, O’Brien, and Lyon.

Retail Partnerships: Initiate the rollout in high-performing stores for Spiced Rum, including:
- Hy-vee Food Store in Carroll
- Hy-vee Wine and Spirits in Harlan, Denison, and Spirit Lake
- Okoboji Avenue Liquor in Dickinson.

### Tools & Technologies
SQL
pgAdmin
[Database](https://analyticsga-euwest1.generalassemb.ly/login?next=%2F)
Excel
Powerpoint
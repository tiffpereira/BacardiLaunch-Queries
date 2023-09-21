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
			
			
			
SELECT DISTINCT vendor_no, vendor, SUM((btl_price - state_btl_cost) * bottle_qty) AS total_profit			
FROM sales			
GROUP BY vendor, vendor_no			
ORDER BY total_profit DESC			
			
-- This was to figure out why Bacardi was coming up twice, it was a data entry error once instance has a , after USA and one does not			
SELECT vendor_no, vendor, COUNT(*) AS count			
FROM sales			
WHERE vendor LIKE '%Bacardi%'			
GROUP BY vendor_no, vendor;			
			
			
-- Updated query to correct the Bacardi naming problem and have accurate information pulled			
SELECT vendor_no, 			
    CASE 			
        WHEN vendor = 'Bacardi U.S.A., Inc.' THEN 'Bacardi U.S.A. Inc.'			
        ELSE vendor 			
    END AS corrected_vendor, 			
    SUM((btl_price - state_btl_cost) * bottle_qty) AS total_profit			
FROM sales			
GROUP BY vendor_no, corrected_vendor			
ORDER BY total_profit DESC			
LIMIT 10			
			
-- total profits based on categories			
SELECT category_name,			
    SUM((btl_price - state_btl_cost) * bottle_qty) AS total_profit			
FROM sales			
WHERE category_name IS NOT NULL 			
GROUP BY category_name			
ORDER BY total_profit DESC			
			
-- total profits based on categories and corrected_vendor			
SELECT category_name,			
	CASE 		
        WHEN vendor = 'Bacardi U.S.A., Inc.' THEN 'Bacardi U.S.A. Inc.'			
        ELSE vendor 			
    END AS corrected_vendor, 			
    SUM((btl_price - state_btl_cost) * bottle_qty) AS total_profit			
FROM sales			
WHERE category_name IS NOT NULL 			
GROUP BY category_name, corrected_vendor 			
ORDER BY total_profit DESC			
LIMIT 50			
			
-- total profits based on categories and Bacardi as a vendor			
SELECT category_name,			
	CASE 		
        WHEN vendor = 'Bacardi U.S.A., Inc.' THEN 'Bacardi U.S.A. Inc.'			
        ELSE vendor 			
    END AS corrected_vendor, 			
    SUM((btl_price - state_btl_cost) * bottle_qty) AS total_profit			
FROM sales			
WHERE (vendor = 'Bacardi U.S.A., Inc.' OR vendor = 'Bacardi U.S.A. Inc.')			
GROUP BY category_name, corrected_vendor 			
ORDER BY total_profit DESC			
			
-- Average proof and shelf price of all categories based on their total profit DESC			
SELECT 			
    products.category_name, 			
    AVG(proof :: integer) AS average_proof, 			
    AVG(shelf_price) AS average_shelf_price, 			
    SUM((btl_price - state_btl_cost) * bottle_qty) AS total_profit			
FROM sales INNER JOIN products 			
ON sales.item = products.item_no			
WHERE products.category_name IS NOT NULL			
GROUP BY products.category_name			
ORDER BY total_profit DESC			
			
-- total profits based on categories and Bacardi as a vendor, and looking at specific product names			
SELECT products.category_name, products.item_description, proof, shelf_price, bottle_size,			
	CASE 		
        WHEN sales.vendor = 'Bacardi U.S.A., Inc.' THEN 'Bacardi U.S.A. Inc.'			
        ELSE sales.vendor 			
    END AS corrected_vendor, 			
    SUM((btl_price - state_btl_cost) * bottle_qty) AS total_profit			
FROM sales INNER JOIN products 			
ON sales.item = products.item_no			
WHERE (sales.vendor = 'Bacardi U.S.A., Inc.' OR sales.vendor = 'Bacardi U.S.A. Inc.')			
GROUP BY products.category_name, products.item_description, corrected_vendor, proof, shelf_price, bottle_size			
ORDER BY total_profit DESC			
			
-- Bacardi product lineup and relevant details as well as their market share			
WITH CategoryProfits AS (			
    SELECT products.category_name,			
        SUM((sales.btl_price - sales.state_btl_cost) * sales.bottle_qty) AS category_total_profit			
    FROM sales INNER JOIN products 			
    ON sales.item = products.item_no			
    GROUP BY products.category_name			
)			
SELECT 			
    products.category_name, 			
    products.item_description, 			
    proof, 			
    shelf_price, 			
    bottle_size,			
    CASE 			
        WHEN sales.vendor = 'Bacardi U.S.A., Inc.' THEN 'Bacardi U.S.A. Inc.'			
        ELSE sales.vendor 			
    END AS corrected_vendor, 			
    SUM((sales.btl_price - sales.state_btl_cost) * sales.bottle_qty) AS product_total_profit,			
    (SUM((sales.btl_price - sales.state_btl_cost) * sales.bottle_qty) / CategoryProfits.category_total_profit) * 100 AS market_share			
FROM sales INNER JOIN products 			
ON sales.item = products.item_no			
INNER JOIN CategoryProfits 			
ON products.category_name = CategoryProfits.category_name			
WHERE (sales.vendor = 'Bacardi U.S.A., Inc.' OR sales.vendor = 'Bacardi U.S.A. Inc.')			
GROUP BY products.category_name, products.item_description, corrected_vendor, proof, shelf_price, bottle_size, CategoryProfits.category_total_profit			
ORDER BY market_share DESC			
			
-- Bacardi category lineup and relevant details as well as their market share			
WITH CategoryProfits AS (			
    SELECT products.category_name,			
        SUM((sales.btl_price - sales.state_btl_cost) * sales.bottle_qty) AS category_total_profit			
    FROM sales INNER JOIN products 			
    ON sales.item = products.item_no			
    GROUP BY products.category_name			
)			
SELECT 			
    products.category_name, 			
    CASE 			
        WHEN sales.vendor = 'Bacardi U.S.A., Inc.' THEN 'Bacardi U.S.A. Inc.'			
        ELSE sales.vendor 			
    END AS corrected_vendor, 			
    SUM((sales.btl_price - sales.state_btl_cost) * sales.bottle_qty) AS product_total_profit,			
    (SUM((sales.btl_price - sales.state_btl_cost) * sales.bottle_qty) / CategoryProfits.category_total_profit) * 100 AS market_share			
FROM sales INNER JOIN products 			
ON sales.item = products.item_no			
INNER JOIN CategoryProfits 			
ON products.category_name = CategoryProfits.category_name			
WHERE (sales.vendor = 'Bacardi U.S.A., Inc.' OR sales.vendor = 'Bacardi U.S.A. Inc.')			
GROUP BY products.category_name, corrected_vendor, CategoryProfits.category_total_profit			
ORDER BY market_share DESC			
			
-- Products in spiced rum relevant info and total profits DESC			
SELECT products.category_name, products.item_description, proof, shelf_price, bottle_size, 			
	SUM((sales.btl_price - sales.state_btl_cost) * bottle_qty) AS total_profit		
FROM sales INNER JOIN products 			
ON sales.item = products.item_no			
WHERE products.category_name LIKE '%SPICED RUM%'			
GROUP BY products.category_name, products.item_description, proof, shelf_price, bottle_size			
ORDER BY total_profit DESC			
			
-- market share of each product in the spiced rum category			
WITH SpicedRumTotalProfit AS (			
    SELECT SUM((btl_price - state_btl_cost) * bottle_qty) AS total_profit_in_category			
    FROM sales INNER JOIN products 			
    ON sales.item = products.item_no			
    WHERE products.category_name LIKE '%SPICED RUM%'			
),			
SpicedRumProductDetails AS (			
    SELECT 			
        products.category_name, 			
        products.item_description, 			
        proof, 			
        shelf_price,			
		bottle_size,	
        SUM((sales.btl_price - sales.state_btl_cost) * sales.bottle_qty) AS product_total_profit			
    FROM sales INNER JOIN products 			
    ON sales.item = products.item_no			
    WHERE products.category_name LIKE '%SPICED RUM%'			
    GROUP BY 			
        products.category_name, products.item_description, proof, shelf_price, bottle_size			
)			
SELECT 			
    SpicedRumProductDetails.category_name, 			
    SpicedRumProductDetails.item_description, 			
    SpicedRumProductDetails.proof, 			
    SpicedRumProductDetails.shelf_price, 			
    SpicedRumProductDetails.product_total_profit,			
	SpicedRumProductDetails.bottle_size,		
    (SpicedRumProductDetails.product_total_profit / SpicedRumTotalProfit.total_profit_in_category) * 100 AS market_share			
FROM SpicedRumProductDetails, SpicedRumTotalProfit			
ORDER BY market_share DESC			
			
-- total profit per capita			
SELECT innerquery.county, innerquery.population, innerquery.total_profit,			
	(innerquery.total_profit/innerquery.population) AS profit_per_capita		
FROM 			
	(SELECT counties.county, population, 		
		SUM((sales.btl_price - sales.state_btl_cost) * sales.bottle_qty) AS total_profit	
	FROM sales INNER JOIN counties 		
		ON sales.county = counties.county	
	GROUP BY counties.county, population) AS innerquery		
ORDER BY profit_per_capita DESC			
			
-- total profit per capita in ONLY spiced rum category			
SELECT innerquery.county, innerquery.population, innerquery.total_profit,			
	(innerquery.total_profit/innerquery.population) AS profit_per_capita		
FROM 			
	(SELECT counties.county, population, 		
		SUM((sales.btl_price - sales.state_btl_cost) * sales.bottle_qty) AS total_profit	
	FROM sales INNER JOIN products 		
			ON sales.item = products.item_no
	 	INNER JOIN counties 	
			ON sales.county = counties.county
	 WHERE products.category_name LIKE '%SPICED RUM%'		
	GROUP BY counties.county, population) AS innerquery		
ORDER BY profit_per_capita DESC			
			
-- Top performing stores in county for spiced rum for Inital Rollout, focusing on profit per capita			
SELECT 			
    stores.store, 			
    stores.name, 			
    innerquery.county, 			
    innerquery.population, 			
    SUM(innerquery.total_profit) AS store_total_profit,			
    (SUM(innerquery.total_profit)/innerquery.population) AS profit_per_capita			
FROM 			
    (SELECT 			
        counties.county, 			
        population, 			
        products.category_name,			
        sales.store,			
        (sales.btl_price - sales.state_btl_cost) * sales.bottle_qty AS total_profit			
     FROM sales INNER JOIN products 			
     	ON sales.item = products.item_no		
     INNER JOIN counties 			
     	ON sales.county = counties.county		
     WHERE products.category_name LIKE '%SPICED RUM%'			
    ) AS innerquery			
INNER JOIN stores			
	ON innerquery.store = stores.store		
GROUP BY stores.store, stores.name, innerquery.county, innerquery.population			
ORDER BY profit_per_capita DESC			
LIMIT 50			
			
			
-- Top performing stores in county for spiced rum for Expansion, focusing on total profits in stores			
SELECT 			
    stores.store, 			
    stores.name, 			
    innerquery.county, 			
    innerquery.population, 			
    SUM(innerquery.total_profit) AS store_total_profit,			
    (SUM(innerquery.total_profit)/innerquery.population) AS profit_per_capita			
FROM 			
    (SELECT 			
        counties.county, 			
        population, 			
        products.category_name,			
        sales.store,			
        (sales.btl_price - sales.state_btl_cost) * sales.bottle_qty AS total_profit			
     FROM sales INNER JOIN products 			
     	ON sales.item = products.item_no		
     INNER JOIN counties 			
     	ON sales.county = counties.county		
     WHERE products.category_name LIKE '%SPICED RUM%'			
    ) AS innerquery			
INNER JOIN stores			
	ON innerquery.store = stores.store		
GROUP BY stores.store, stores.name, innerquery.county, innerquery.population			
ORDER BY store_total_profit DESC			
LIMIT 50			
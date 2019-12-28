CREATE OR REPLACE FUNCTION seller_purchases(sellerid text)
	RETURNS TABLE (
	pid integer,
	saleid integer,
	price DECIMAL(5,2),
	approve BOOLEAN,
	paid BOOLEAN,
	p_description VARCHAR,
	buyername VARCHAR,
	buyervenmo VARCHAR
)
AS $$
	SELECT pid, purchase.saleid as saleid, price, approve,paid, p_description, 
	buyer.name AS buyername,buyer.venmo as buyervenmo
	FROM PURCHASE
	LEFT JOIN REGISTEREDUSER as buyer
	on PURCHASE.bid = buyer.uid
	LEFT JOIN ACTIVESELLER
	on PURCHASE.saleid = ACTIVESELLER.saleid
	LEFT JOIN REGISTEREDUSER as seller
	on ACTIVESELLER.uid = seller.uid
	WHERE seller.uid = sellerid;
$$
LANGUAGE 'sql';

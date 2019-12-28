
DROP ROLE IF EXISTS web_anon;
DROP ROLE IF EXISTS authenticator;
DROP ROLE IF EXISTS todo_user;
DROP ROLE IF EXISTS authorizer;
CREATE  ROLE web_anon nologin;

create ROLE authenticator noinherit login password 'rFKC4RbY3S7j9VGz';
grant web_anon to authenticator;
create ROLE authorizer noinherit login password 'hY2zPbSM6vbEgxGn' createrole;

create role todo_user nologin;
grant todo_user to authenticator;

-- General Table Security
grant usage on schema public to todo_user;

GRANT SELECT,UPDATE ON REGISTEREDUSER TO todo_user;
GRANT INSERT ON REGISTEREDUSER TO todo_user;
GRANT SELECT,INSERT,UPDATE, DELETE ON ACTIVESELLER TO todo_user;

GRANT SELECT,DELETE ON PURCHASE TO todo_user;
GRANT INSERT (saleid, bid, price, p_description) ON PURCHASE  TO todo_user;
-- no funky stuff like inserting with pre-approved or pre-paid
GRANT UPDATE (approve, paid, p_description) on PURCHASE  TO todo_user;
-- Don't let a seller change the saleid or anything funky

GRANT SELECT ON ACTIVERESTAURANTS to todo_user;
grant usage, select on sequence ActiveSeller_saleid_seq to todo_user;
grant usage, select on sequence Purchase_pid_seq to todo_user;


-- Role level security:
  -- once we enable RLS for a table that table needs policies for every
  -- action in addition to the GRANT statements

-- RegisteredUser policies
ALTER TABLE REGISTEREDUSER ENABLE ROW LEVEL SECURITY;
CREATE POLICY user_insert ON REGISTEREDUSER FOR INSERT to todo_user 
	WITH CHECK (uid = current_user);
	-- any user can create themself, but only once because uid is key 

CREATE POLICY user_update ON REGISTEREDUSER FOR UPDATE to todo_user
	USING (uid = current_user);
	-- allow updates if the uid matches the current user

CREATE POLICY user_select on REGISTEREDUSER FOR SELECT to todo_user USING(true);
	-- any todo user can select (need it for getting names and venmos for other users)

-- ActiveSeller Policies
ALTER TABLE ACTIVESELLER ENABLE ROW LEVEL SECURITY;
CREATE POLICY seller_select on ACTIVESELLER FOR SELECT USING(true);
	-- any user can see all active sales
CREATE POLICY seller_update on ACTIVESELLER
	USING(uid = current_user) WITH CHECK (uid = current_user);
	-- users can only modiy their own sales

-- Purchase Policies
ALTER TABLE PURCHASE ENABLE ROW LEVEL SECURITY;
CREATE POLICY purchase_select on PURCHASE FOR SELECT
	USING(
	bid = current_user
	OR
	(SELECT ACTIVESELLER.uid FROM ACTIVESELLER where ACTIVESELLER.saleid = PURCHASE.saleid) = current_user
	); -- Can only look at purchases where user is buyer or seller

CREATE POLICY purchase_delete on PURCHASE FOR DELETE
        USING(
        PURCHASE.bid = current_user
        OR
        (SELECT uid FROM ACTIVESELLER where ACTIVESELLER.saleid = PURCHASE.saleid) = current_user
        ); -- Only buyer or seller can delete a purchase

CREATE POLICY purchase_insert on PURCHASE FOR INSERT WITH CHECK(bid = current_user);
-- can only insert rows into purchase if you are the buyer for that purchase

CREATE POLICY purchase_update on PURCHASE FOR UPDATE
	USING(
	(SELECT uid FROM ACTIVESELLER where ACTIVESELLER.saleid = PURCHASE.saleid) = current_user);
	-- only seller can update rows in purchase




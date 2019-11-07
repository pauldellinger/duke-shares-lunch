DROP SCHEMA lunches CASCADE;
CREATE SCHEMA lunches;
CREATE TABLE lunches.RegisteredUser
              (
                uid serial NOT NULL PRIMARY KEY,
                email VARCHAR(50) NOT NULL UNIQUE,
                name VARCHAR(50) NOT NULL,
                venmo VARCHAR(20) NOT NULL UNIQUE,
                major VARCHAR(20),
                dorm VARCHAR(20)
                );
CREATE TABLE lunches.ActiveSeller
                (saleid serial NOT NULL PRIMARY KEY,
                uid INTEGER NOT NULL REFERENCES lunches.RegisteredUser(uid),
                OrderTime TIMESTAMP,
                status BOOLEAN NOT NULL,
                percent DECIMAL(5,2) NOT NULL,
                location VARCHAR(20) NOT NULL);

CREATE TABLE lunches.SellPreferences
                (uid INTEGER NOT NULL REFERENCES lunches.RegisteredUser(uid),
                location VARCHAR(20) NOT NULL,
                percent DECIMAL(5,2),
                PRIMARY KEY(uid, location));

CREATE TABLE lunches.Purchase
                (pid INTEGER NOT NULL PRIMARY KEY,
                saleid INTEGER NOT NULL REFERENCES lunches.ActiveSeller(saleid),
                bid INTEGER NOT NULL REFERENCES lunches.RegisteredUser(uid),
                price DECIMAL(5,2) CHECK(price > 0) NOT NULL,
                approve BOOLEAN NOT NULL,
                paid BOOLEAN NOT NULL,
                p_description VARCHAR(200));


CREATE TABLE lunches.Meals
            (mid INTEGER NOT NULL PRIMARY KEY,
            price DECIMAL(5,2) CHECK(price > 0),
            location VARCHAR(20) NOT NULL,
            description VARCHAR(200));


INSERT INTO lunches.RegisteredUser VALUES(1, 'pd88@duke.edu', 'Paul Dellinger', 'paul_dellinger', 'Computer Science', 'Kilgo');
INSERT INTO lunches.RegisteredUser VALUES(2, 'jcr34@duke.edu', 'Josh Romine', 'joshielikescash');
INSERT INTO lunches.RegisteredUser VALUES(3, 'aje11@duke.edu', 'AJ Eckmann', 'AJs Venmo');
--Three example users

INSERT INTO lunches.ActiveSeller VALUES(2001, 1,'2019-10-25 02:36:00', TRUE, 0.60, 'Il Forno');
INSERT INTO lunches.ActiveSeller VALUES(2002, 1, '2019-10-25 02:36:00', TRUE, 0.60, 'Ginger and Soy');
--Paul has said he wants to sell food points at Ginger and Soy and Il Forno
--He has different price conversion for each because he is already getting Forno
--and would prefer that restaurant

INSERT INTO lunches.SellPreferences VALUES(1, 'Il Forno');
INSERT INTO lunches.SellPreferences VALUES(1, 'Ginger and Soy');
--Paul Likes to sell his food points at il forno and ginger and soy
--because he eats at those restaurants a lot

INSERT INTO lunches.Purchase VALUES(3001, 2001, 2, 8.95, FALSE, FALSE, 'Hey paul can you get me rigatoni with pomodoro, spinach and extra chiken');
--Paul is going to buy something for Josh at il forno
--Jjosh will venmo Paul based on the price

INSERT INTO lunches.Meals VALUES(4001, 8.85, 'Il Forno', 'Make your own pasta bowl');
INSERT INTO lunches.Meals VALUES(4002, 1.50, 'Il Forno', 'Extra Chicken');


CREATE ROLE web_anon nologin;
GRANT USAGE  on schema lunches to web_anon;
grant select on lunches.registereduser to web_anon;
grant select on lunches.purchase to web_anon;
grant select on lunches.activeseller to web_anon;
grant select on lunches.meals to web_anon;
grant select on lunches.sellpreferences to web_anon;


create role authenticator noinherit login password 'mysecretpassword';
grant web_anon to authenticator;

REVOKE usage on schema lunches from web_anon;

create role todo_user nologin;
grant todo_user to authenticator;

grant usage on schema lunches to todo_user;
grant all on lunches.registereduser to todo_user;
grant all on lunches.ActiveSeller to todo_user;
grant ALL on lunches.Purchase to todo_user;
grant usage, select on sequence lunches.RegisteredUser_uid_seq to todo_user;
grant all on lunches.meals to todo_user;
grant all on lunches.sellpreferences to todo_user;
grant usage, select on sequence lunches.ActiveSeller_saleid_seq to todo_user;

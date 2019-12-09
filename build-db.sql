
CREATE TABLE RegisteredUser
              (
                uid serial NOT NULL PRIMARY KEY,
                email VARCHAR(50) NOT NULL UNIQUE,
                name VARCHAR(50) NOT NULL,
                venmo VARCHAR(20) NOT NULL UNIQUE,
                major VARCHAR(20),
                dorm VARCHAR(20)
                );
CREATE TABLE ActiveSeller
                (saleid serial NOT NULL UNIQUE,
                uid INTEGER NOT NULL REFERENCES RegisteredUser(uid),
                OrderTime TIMESTAMP,
                status BOOLEAN NOT NULL,
                percent DECIMAL(5,2) NOT NULL,
                location VARCHAR(20) NOT NULL,
			PRIMARY KEY(uid, location));

CREATE TABLE SellPreferences
                (uid INTEGER NOT NULL REFERENCES RegisteredUser(uid),
                location VARCHAR(20) NOT NULL,
                percent DECIMAL(5,2),
                PRIMARY KEY(uid, location));

CREATE TABLE Purchase
                (pid serial NOT NULL PRIMARY KEY,
                saleid INTEGER NOT NULL REFERENCES ActiveSeller(saleid),
                bid INTEGER NOT NULL REFERENCES RegisteredUser(uid),
                price DECIMAL(5,2) CHECK(price > 0) NOT NULL,
                approve BOOLEAN NOT NULL,
                paid BOOLEAN NOT NULL,
                p_description VARCHAR(1000));


CREATE TABLE Meals
            (mid serial NOT NULL PRIMARY KEY,
            price DECIMAL(5,2) CHECK(price > 0),
            location VARCHAR(20) NOT NULL,
            description VARCHAR(200));




INSERT INTO RegisteredUser VALUES(1, 'pd88@duke.edu',  'Paul Dellinger', 'paul_dellinger', 'Computer Science', 'Kilgo');
INSERT INTO RegisteredUser VALUES(2, 'jcr34@duke.edu',  'Josh Romine', 'joshielikescash');
INSERT INTO RegisteredUser VALUES(3, 'aje11@duke.edu',  'AJ Eckmann', 'AJs Venmo');
--INSERT INTO basic_auth.users VALUES('pd88@duke.edu', 'Password1', 'todo_user');
--Three example users

INSERT INTO ActiveSeller VALUES(2001, 1,'2019-10-25 02:36:00', TRUE, 0.60, 'Il Forno');
INSERT INTO ActiveSeller VALUES(2002, 1, '2019-10-25 02:36:00', TRUE, 0.60, 'Ginger and Soy');
--Paul has said he wants to sell food points at Ginger and Soy and Il Forno
--He has different price conversion for each because he is already getting Forno
--and would prefer that restaurant

INSERT INTO SellPreferences VALUES(1, 'Il Forno');
INSERT INTO SellPreferences VALUES(1, 'Ginger and Soy');
--Paul Likes to sell his food points at il forno and ginger and soy
--because he eats at those restaurants a lot

--INSERT INTO Purchase VALUES(3001, 2001, 2, 8.95, FALSE, FALSE, 'Hey paul can you get me rigatoni with pomodoro, spinach and extra chiken');
--Paul is going to buy something for Josh at il forno
--Josh will venmo Paul based on the price

INSERT INTO Meals VALUES(4001, 8.85, 'Il Forno', 'Make your own pasta bowl');
INSERT INTO Meals VALUES(4002, 1.50, 'Il Forno', 'Extra Chicken');


CREATE VIEW ActiveRestaurants as (
SELECT location, count(*)
From Activeseller
GROUP BY location
ORDER BY count(*) DESC);

CREATE ROLE web_anon nologin;

create role authenticator noinherit login password 'mysecretpassword';
grant web_anon to authenticator;

create role todo_user nologin;
grant todo_user to authenticator;

grant usage on schema public to todo_user;
grant all on registereduser to todo_user;
grant all on ActiveSeller to todo_user;
grant ALL on Purchase to todo_user;
grant usage, select on sequence RegisteredUser_uid_seq to todo_user;
grant all on meals to todo_user;
grant all on sellpreferences to todo_user;
grant usage, select on sequence ActiveSeller_saleid_seq to todo_user;
grant usage, select on sequence meals_mid_seq to todo_user;
grant usage, select on sequence Purchase_pid_seq to todo_user;

grant select on ActiveRestaurants to todo_user;


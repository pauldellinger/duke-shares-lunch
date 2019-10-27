--CREATE TABLE User
--		(uid VARCHAR(20) NOT NULL PRIMARY KEY,
--		email VARCHAR(20) NOT NULL UNIQUE,
--		name VARCHAR(20) NOT NULL,
--		venmo VARCHAR(20) NOT NULL UNIQUE,
--		major VARCHAR(20) NOT NULL,
--		dorm VARCHAR(20) NOT NULL);

CREATE TABLE RegisteredUser
              (
		uid INTEGER NOT NULL PRIMARY KEY,
                email VARCHAR(50) NOT NULL UNIQUE,
                name VARCHAR(50) NOT NULL,
                venmo VARCHAR(20) NOT NULL UNIQUE,
                major VARCHAR(20),
	        dorm VARCHAR(20)
		);
CREATE TABLE ActiveSeller
		(saleid INTEGER NOT NULL PRIMARY KEY,
                uid INTEGER NOT NULL REFERENCES RegisteredUser(uid),
		OrderTime TIMESTAMP,
		status BOOLEAN NOT NULL,
		percent DECIMAL(5,2) NOT NULL,
		location VARCHAR(20) NOT NULL);

CREATE TABLE SellPreferences
		(uid INTEGER NOT NULL REFERENCES RegisteredUser(uid),
                location VARCHAR(20) NOT NULL,
		percent DECIMAL(5,2),
		PRIMARY KEY(uid, location));

CREATE TABLE Purchase
		(pid INTEGER NOT NULL PRIMARY KEY,
		saleid INTEGER NOT NULL REFERENCES ActiveSeller(saleid),
		bid INTEGER NOT NULL REFERENCES RegisteredUser(uid),
                price DECIMAL(5,2) CHECK(price > 0) NOT NULL,
		approve BOOLEAN NOT NULL,
		paid BOOLEAN NOT NULL,
                p_description VARCHAR(200));

CREATE TABLE Meals
		(mid INTEGER NOT NULL PRIMARY KEY,
               	price DECIMAL(5,2) CHECK(price > 0),
		location VARCHAR(20) NOT NULL,
		description VARCHAR(200));



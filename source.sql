CREATE TABLE User(uid VARCHAR(20) NOT NULL PRIMARY KEY,
		email VARCHAR(20) NOT NULL,
		name VARCHAR(20) NOT NULL,
		venmo VARCHAR(20) NOT NULL,
		major VARCHAR(20) NOT NULL,
		dorm VARCHAR(20) NOT NULL);

CREATE TABLE ActiveSeller(saleid VARCHAR(20) NOT NULL PRIMARY KEY,
                uid VARCHAR(20) NOT NULL,
		OrderTime VARCHAR(20) NOT NULL,
		status VARCHAR(20) NOT NULL,
		percent VARCHAR(20) NOT NULL,
		location VARCHAR(20) NOT NULL);

CREATE TABLE SellPreferences(uid VARCHAR(20) NOT NULL REFERENCES User(uid),
                location VARCHAR(20) NOT NULL,
		percent VARCHAR(20)),
		PRIMARY KEY(uid, location));

CREATE TABLE Purchase(pid VARCHAR(20) NOT NULL PRIMARY KEY,
		saleid VARCHAR(20) NOT NULL REFERENCES ActiveSeller(uid),
		bid VARCHAR(20) NOT NULL REFERENCES User(uid),
                price DECIMAL(5,2) CHECK(price > 0),
		approve BOOLEAN,
		paid BOOLEAN,
                p_description VARCHAR(200));

CREATE TABLE Meals(mid VARCHAR(20) NOT NULL PRIMARY KEY,
               	price DECIMAL(5,2) CHECK(price > 0)
		location VARCHAR(20) NOT NULL,
		description VARCHAR(20));


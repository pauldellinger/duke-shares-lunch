INSERT INTO RegisteredUser VALUES(1, 'pd88@duke.edu', 'Paul Dellinger', 'paul_dellinger', 'Computer Science', 'Kilgo');
INSERT INTO RegisteredUser VALUES(2, 'jcr34@duke.edu', 'Josh Romine', 'joshielikescash');
INSERT INTO RegisteredUser VALUES(3, 'aje11@duke.edu', 'AJ Eckmann', 'AJs Venmo');
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

INSERT INTO Purchase VALUES(3001, 2001, 2, 8.95, FALSE, FALSE, 'Hey paul can you get me rigatoni with pomodoro, spinach, and extra chicken');
--Paul is going to buy something for Josh at il forno
--Jjosh will venmo Paul based on the price

INSERT INTO Meals VALUES(4001, 8.85, 'Il Forno', 'Make your own pasta bowl');
INSERT INTO Meals VALUES(4002, 1.50, 'Il Forno', 'Extra Chicken');
--these will show up to Josh as something he can buy from Paul

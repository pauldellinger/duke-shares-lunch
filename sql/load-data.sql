UPDATE MENUS SET price = price* 1.075;
INSERT INTO RegisteredUser VALUES('mdUNjgUS6Vajor81BrExd3Dse7F2', 'pd88@duke.edu',  'Paul Dellinger', 'paul_dellinger', 'Computer Science', 'Kilgo');
INSERT INTO RegisteredUser VALUES('-2', 'jcr74@duke.edu',  'Josh Romine', 'jcromine');
INSERT INTO RegisteredUser VALUES('-3', 'aje11@duke.edu',  'AJ Eckmann', 'AJs Venmo');
--INSERT INTO basic_auth.users VALUES('pd88@duke.edu', 'Password1', 'todo_user');
--Three example users
--INSERT INTO LOCATIONS VALUES(1, 'Il Forno', 'WU');
--INSERT INTO LOCATIONS VALUES(2, 'Ginger and Soy', 'WU');

INSERT INTO ActiveSeller VALUES(2001, 'mdUNjgUS6Vajor81BrExd3Dse7F2','2019-10-25 02:36:00', TRUE, 0.60, 1);
INSERT INTO ActiveSeller VALUES(2002, 'mdUNjgUS6Vajor81BrExd3Dse7F2', '2019-10-25 02:36:00', TRUE, 0.60, 2);
--Paul has said he wants to sell food points at Ginger and Soy and Il Forno
--He has different price conversion for each because he is already getting Forno
--and would prefer that restaurant

INSERT INTO SellPreferences VALUES('mdUNjgUS6Vajor81BrExd3Dse7F2', 'Il Forno');
INSERT INTO SellPreferences VALUES('mdUNjgUS6Vajor81BrExd3Dse7F2', 'Ginger and Soy');
--Paul Likes to sell his food points at il forno and ginger and soy
--because he eats at those restaurants a lot

INSERT INTO Purchase VALUES(3001, 2001, '-2', 8.95, FALSE, FALSE, 'Hey paul can you get me rigatoni with pomodoro, spinach and extra chicken');
--Paul is going to buy something for Josh at il forno
--Josh will venmo Paul based on the price

--INSERT INTO Meals VALUES(4001, 8.85, 'Il Forno', 'Make your own pasta bowl');
--INSERT INTO Meals VALUES(4002, 1.50, 'Il Forno', 'Extra Chicken');




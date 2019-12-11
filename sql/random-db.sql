INSERT INTO registereduser(email,name,venmo)
SELECT CONCAT(g.id,'@duke.edu'), g.id, CONCAT(g.id,'venmo')
FROM generate_series(1, 10000) AS g (id) ;

INSERT INTO activeseller(uid,ordertime,status,percent,location) 
SELECT g.id, '2019-12-09T21:36:48', true, random(), 
(SELECT ARRAY['Il Forno', 'Ginger and Soy', 'Tandoor', 'Skillet', 'Farmstead', 'Sprout'])[floor(random() * 6 + 1)] 
FROM generate_series(1, 10000) AS g (id) ;

INSERT INTO purchase(saleid,bid,price,approve,paid,p_description)
SELECT floor(random()*(10000-1+1))+1, floor(random()*(10000-1+1))+1, floor(random()*(900-1+1))+1.02, false, false, 
'a sort of long description not too long but maybe average size'
FROM generate_series(1, 10000) AS g (id) ;

INSERT INTO activeseller(uid,ordertime,status,percent,location)
VALUES(-1, '2019-12-09T21:36:48', true, random(), 'Il Forno');

INSERT INTO purchase(saleid,bid,price,approve,paid,p_description)  
SELECT 10001, floor(random()*(900-100+1))+100, floor(random()*(1000-1+1))+.02, false, false, 'a sort of long descripti
on not too long but maybe average size'
FROM generate_series(4, 10000) AS g (id) ;

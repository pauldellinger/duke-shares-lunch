DROP ROLE notifier;
CREATE ROLE notifier login password 'verysecret';

DROP TABLE DeviceToken;
DROP TABLE NotificationQueue;
CREATE TABLE DeviceToken(
	uid text NOT NULL references REGISTEREDUSER(uid),
	token text NOT NULL,
	status boolean default TRUE,
	PRIMARY KEY (uid,token)
	);

CREATE TABLE NotificationQueue(
	recipient text,
	pid int,
	category text,
	stored timestamp,
	processed timestamp
	);

grant INSERT on NotificationQueue to todo_user;
grant INSERT,SELECT, DELETE on DeviceToken to todo_user;
GRANT ALL on NotificationQueue to notifier;
GRANT ALL ON NotificationQueue to notifier;

ALTER TABLE DeviceToken ENABLE ROW LEVEL SECURITY;

--only insert tokens for yourself
CREATE POLICY token_insert on DeviceToken FOR INSERT to todo_user
	WITH CHECK (uid = current_user);

-- let any user see the tokens (buyer sending notification to seller)
CREATE POLICY token_select on DeviceToken FOR SELECT to todo_user USING(true);

CREATE POLICY token_delete on DeviceToken FOR DELETE
	USING(uid = current_user);

--insert into devicetoken values ('mdUNjgUS6Vajor81BrExd3Dse7F2', 'aeba7e4439967cb7aba6b1e5bfae9fddb0e73fc54b6a383dc67e3ce3e3cc4b24', True);


CREATE OR REPLACE FUNCTION process_update_queue() RETURNS TRIGGER AS
	$update_queue$
	BEGIN
	IF (TG_OP = 'DELETE') THEN
            IF user = OLD.bid THEN -- buyer cancelled purchase
	    INSERT INTO NotificationQueue SELECT
		dt.token,
		OLD.pid,
		CONCAT((SELECT name from registereduser as RU where RU.uid = OLD.bid),' cancelled the purchase.'),
		now(),
		NULL
		FROM devicetoken as dt
			WHERE dt.uid = (SELECT uid FROM ActiveSeller WHERE ActiveSeller.saleid = OLD.saleid) AND dt.status;
	    ELSE -- seller cancelled purchase
	    	IF OLD.paid AND OLD.approve THEN -- purchase was paid so it's complete
			INSERT INTO NotificationQueue SELECT
                        dt.token,
                        OLD.pid,
                        CONCAT((select name from registereduser as RU where RU.uid
                                = (SELECT uid from ActiveSeller where ActiveSeller.saleid = OLD.saleid)),
                                ' marked your purchase as complete.'),
                        now(),
                        NULL
			FROM devicetoken as dt where dt.uid = OLD.bid AND dt.status;
		ELSE -- approve or paid not true, seller declined
			INSERT INTO NotificationQueue SELECT
			dt.token,
			OLD.pid,
			CONCAT((select name from registereduser as RU where RU.uid
				= (SELECT uid from ActiveSeller where ActiveSeller.saleid = OLD.saleid)),
				' declined the purchase.'),
			now(),
			NULL
			FROM devicetoken as dt where dt.uid = OLD.bid AND dt.status;
		END IF;
	    END IF;

            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN -- seller updating purchase
	    IF NEW.approve and NEW.paid  THEN-- seller marked paid
            	INSERT INTO NotificationQueue SELECT
			dt.token,
			NEW.pid,
			CONCAT((select name from registereduser as RU where RU.uid
                                = (SELECT uid from ActiveSeller where ActiveSeller.saleid = OLD.saleid)),
				' marked your purchase as Paid'),
			now(),
			NULL
			FROM devicetoken as dt WHERE dt.uid = NEW.bid AND dt.status;

	    ELSE -- seller approved
	    	INSERT INTO NotificationQueue SELECT
                        dt.token,
                        NEW.pid,
                        CONCAT((select name from registereduser as RU where RU.uid
                                = (SELECT uid from ActiveSeller where ActiveSeller.saleid = OLD.saleid)),
                                ' approved your purchase.'),
                        now(),
                        NULL
			FROM devicetoken as dt WHERE dt.uid = NEW.bid AND dt.status;
	    END IF;
            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN -- buyer inserting purchase
            INSERT INTO NotificationQueue SELECT
		dt.token,
		NEW.pid,
		CONCAT('You have a purchase for $', NEW.price, ' awaiting approval at ',
			(SELECT name from locations where lid = (SELECT activeseller.location from activeseller where activeseller.saleid = NEW.saleid))),
		now(),
		NULL
		FROM devicetoken as dt
                        WHERE dt.uid = (SELECT uid FROM ActiveSeller WHERE ActiveSeller.saleid = NEW.saleid) AND dt.status;
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;


$update_queue$ LANGUAGE plpgsql;

CREATE TRIGGER update_queue
AFTER INSERT OR UPDATE OR DELETE ON Purchase
    FOR EACH ROW EXECUTE PROCEDURE process_update_queue();


CREATE OR REPLACE FUNCTION send_to_python() RETURNS TRIGGER AS
$send$
BEGIN
	NOTIFY NotificationQueue, 'new row';
	RETURN NEW;
END
$send$ LANGUAGE plpgsql;

CREATE TRIGGER notify AFTER INSERT ON NotificationQueue
    FOR EACH ROW EXECUTE PROCEDURE send_to_python();

DROP TABLE DeviceToken;
DROP TABLE NotificationQueue;
CREATE TABLE DeviceToken(
	uid text references REGISTEREDUSER(uid),
	token text,
	status boolean,
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
grant all on DeviceToken to todo_user;
CREATE OR REPLACE FUNCTION process_update_queue() RETURNS TRIGGER AS
	$update_queue$
	BEGIN
	IF (TG_OP = 'DELETE') THEN
            IF user = OLD.bid THEN -- buyer cancelled purchase
	    INSERT INTO NotificationQueue VALUES(
		(SELECT uid from ActiveSeller where ActiveSeller.saleid = OLD.saleid),
		OLD.pid,
		'BUYER CANCEL',
		now(),
		NULL);
	    ELSE -- seller cancelled purchase
	    INSERT INTO NotificationQueue SELECT
		OLD.bid,
		OLD.pid,
		'SELLER CANCEL',
		now(),
		NULL;
	    END IF;

            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN -- seller updating purchase
            INSERT INTO NotificationQueue SELECT
		NEW.bid,
		NEW.pid,
		'SELLER UPDATE',
		now(),
		NULL;
            RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN -- buyer inserting purchase
            INSERT INTO NotificationQueue SELECT
		(SELECT uid from ActiveSeller where ActiveSeller.saleid = NEW.saleid),
		NEW.pid,
		'BUYER INSERT',
		now(),
		NULL;
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;


$update_queue$ LANGUAGE plpgsql;

CREATE TRIGGER update_queue
AFTER INSERT OR UPDATE OR DELETE ON Purchase
    FOR EACH ROW EXECUTE PROCEDURE process_update_queue();

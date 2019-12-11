CREATE OR REPLACE FUNCTION delete_from_purchase() RETURNS trigger as $$
	BEGIN
	IF OLD.saleid is NULL THEN
		RAISE EXCEPTION 'old saleid cannot be null';
	END IF;
	DELETE FROM PURCHASE WHERE PURCHASE.saleid = old.saleid;
	IF (TG_OP = 'UPDATE') THEN RETURN NEW;
	ELSIF (TG_OP = 'DELETE') THEN RETURN OLD;
	END IF;
	END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER no_rate_change BEFORE UPDATE OR DELETE
ON activeseller
	FOR EACH ROW EXECUTE PROCEDURE delete_from_purchase();




CREATE SCHEMA Assessment_100536383;

SET search_path to Assessment_100536383;

-- Creating table Event
 CREATE TABLE event (
       ecode CHAR(4) PRIMARY KEY,
	   edesc VARCHAR(20) NOT NULL,
	   elocation VARCHAR(20) NOT NULL,
	   edate DATE NOT NULL CHECK (edate BETWEEN '2026-07-01' AND '2026-07-31'),
	   etime TIME NOT NULL CHECK (etime >= '09:00:00'),
	   emax SMALLINT NOT NULL CHECK (1001 > emax AND emax > 0)
 );

SELECT * FROM event;


-- Creating table Spectator
 CREATE TABLE spectator (
        sno INTEGER PRIMARY KEY,
		sname VARCHAR(20) NOT NULL,
		semail VARCHAR(20) NOT NULL UNIQUE
 );

 SELECT * FROM spectator;


 --Creating table Ticket
 CREATE TABLE ticket (
        tno INTEGER PRIMARY KEY,
		ecode CHAR(4) NOT NULL REFERENCES event(ecode) ON DELETE CASCADE,
		sno INTEGER NOT NULL REFERENCES spectator(sno) ON DELETE CASCADE,
		CONSTRAINT only_one_ticket UNIQUE (ecode, sno)
 );

 SELECT * FROM ticket;

--Creating table Cancel
 CREATE TABLE cancel (
        tno INTEGER PRIMARY KEY, 
		ecode CHAR(4) NOT NULL,
		sno INTEGER NOT NULL,
		cdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		cuser VARCHAR(128) NOT NULL
 );

 SELECT * FROM cancel;

--Creating Function & Trigger: Event Capacity before issuing ticket
 CREATE OR REPLACE FUNCTION check_capacity()
 RETURNS TRIGGER AS $$
 BEGIN
      IF (SELECT COUNT(*) FROM ticket WHERE ecode = NEW.ecode) >=
	     (SELECT emax FROM event WHERE ecode = NEW.ecode) THEN 
		 RAISE EXCEPTION 'Event % is at full capacity (Max : % )', NEW.ecode, (SELECT emax FROM event WHERE ecode = NEW.ecode);
	  ELSE 
	   RETURN NEW;
	  END IF;
 END;
 $$ LANGUAGE plpgsql;

 CREATE TRIGGER target_capacity 
 BEFORE INSERT ON ticket 
 FOR EACH ROW 
 EXECUTE FUNCTION check_capacity();

--Creating Function & Trigger: Cancelled Tickets Logging in to Cancel Table
CREATE OR REPLACE FUNCTION ticket_cancel_alteration() 
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO cancel (tno, ecode, sno, cdate, cuser)
    VALUES (OLD.tno, OLD.ecode, OLD.sno, CURRENT_TIMESTAMP, CURRENT_USER)
    ON CONFLICT (tno) DO NOTHING; 
    RETURN OLD; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ticket_cancel_alter 
BEFORE DELETE ON ticket 
FOR EACH ROW 
EXECUTE FUNCTION ticket_cancel_alteration();

--Creating View: Event Schedule for each spectator
 CREATE VIEW spectator_event_schedule AS
             SELECT s.sno, s.sname, e.ecode, e.edesc, e.edate, e.etime, e.elocation
			 FROM spectator s
			 JOIN ticket t ON s.sno = t.sno
			 JOIN event e ON t.ecode = e.ecode;



SET search_path to Assessment_100536383;

DELETE FROM cancel;
DELETE FROM ticket;
DELETE FROM spectator;
DELETE FROM event;


-- Inserting data in to Event table

INSERT INTO event VALUES
('A100', '100 metres sprint', 'Stadium 1','2026-07-12','16:00',1000),
('AMTH', 'Marathon', 'Stadium 1', '2026-07-12', '18:00', 1000),
('A400', '400 metres sprint', 'Stadium 1', '2026-07-12', '10:00', 1000),
('ALJP', 'Long Jump', 'Stadium 1', '2026-07-12', '10:00', 1000),
('YCHT', 'Yacht Racing', 'Marina', '2026-07-12', '09:00', 200),
('WSRF', 'Wind Surfing', 'Marina', '2026-07-12', '12:00', 200),
('JUDO', 'Judo', 'Arena 2', '2026-07-12', '10:00', 3),
('SWIM', 'Swimming', 'Pool', '2026-07-12', '10:00', 100);

-- Inserting data in to spectator table
INSERT INTO spectator VALUES
(100, 'J Chin', 'j.chin@uea.ac.uk'),
(200, 'W Wang','whw@somewhere.net'),
(300, 'E Leist','e-leist@uea.ac.uk'),
(400, 'R Lapper', 'rl@uea.ac.uk'),
(500, 'R Hassen', 'rh@gmail.com');


-- Inserting data in to ticket table
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'A100', 100);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'A100', 200);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'A100', 300);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'A100', 500);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'ALJP', 100);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'ALJP', 200);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'AMTH', 200);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'AMTH', 300);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'AMTH', 500);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'A400', 200);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'A400', 300);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'YCHT', 200);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'YCHT', 300);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'YCHT', 500);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'WSRF', 200);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'WSRF', 300);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'JUDO', 100);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'JUDO', 300);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'JUDO', 200);
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'A100', 400);


------------------ Task 1 ----------------
INSERT INTO spectator(sno, sname, semail) VALUES
(100, 'K Misri', 'k.misri@uea.ac.uk');


SELECT * FROM spectator;


------------------ Task 2 ----------------
INSERT INTO event(ecode, edesc, elocation, edate, etime, emax) VALUES
('A200', '200 metres sprint', 'Stadium 1', '2026-08-10', '16:00', 1000);

SELECT * FROM event;

------------------ Task 3 ----------------
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'A100', 100);

SELECT * FROM ticket ORDER BY tno DESC;


------------------ Task 4 ----------------
SELECT e.edate, e.elocation, COUNT(DISTINCT t.sno) AS total_spectators
FROM event e
JOIN ticket t ON e.ecode = t.ecode
GROUP BY e.edate, e.elocation
ORDER BY e.edate, e.elocation;

------------------ Task 5 ----------------

SELECT e.edesc AS Desc, e.ecode, COUNT(t.tno) AS total_issued_tickets
FROM event e
LEFT JOIN ticket t ON e.ecode = t.ecode
GROUP BY e.edesc, e.ecode
ORDER BY e.edesc;


------------------ Task 6 ----------------
SELECT COUNT(*) AS total_tickets_A100
FROM ticket
WHERE ecode = 'A100';

SELECT tno, ecode, sno FROM ticket WHERE ecode='A100';


------------------ Task 7 ----------------
-- Using View
SELECT sname, edate, elocation, etime, edesc FROM spectator_event_schedule WHERE sno = 200 ORDER BY edate, etime;


------------------ Task 8 ----------------
SELECT t.tno, s.sname, e.ecode, 'Valid' AS status 
FROM ticket t 
JOIN spectator s ON t.sno = s.sno 
JOIN event e ON t.ecode = e.ecode 
WHERE t.tno = 20;

------------------ Task 9 ----------------
SELECT *
FROM cancel
WHERE ecode = 'A100';


------------------ Task 10 ----------------
-- Check initial state (should show 2 tickets) 
SELECT * FROM ticket WHERE ecode = 'A100'; 
-- Execute DELETE (This triggers trg_move_ticket for each row via CASCADE) 
DELETE FROM event WHERE ecode = 'A100';

SELECT * FROM event;
SELECT * FROM ticket;
SELECT * FROM cancel;


---------------------Task 11 -----------------
SELECT *
FROM cancel
WHERE ecode = 'A100';


---------------------Task 12 -----------------

DELETE FROM Spectator WHERE sno = 300;

SELECT * FROM Spectator;
SELECT * FROM ticket;
SELECT * FROM cancel;

---------------------Task 13 -----------------

DELETE FROM Spectator WHERE sno = 400;

SELECT * FROM Spectator;

---------------------Task 14 -----------------
SELECT t.tno, s.sname, e.ecode, 'Valid' AS status
FROM ticket t 
JOIN spectator s ON t.sno = s.sno 
JOIN event e ON t.ecode = e.ecode
WHERE t.tno = 19

UNION ALL

SELECT
c.tno, 
COALESCE(s.sname, 'Spectator Deleted (sno: '|| c.sno || ')') , 
c.ecode, 
'Cancelled' AS status
FROM cancel c
LEFT JOIN spectator s ON c.sno = s.sno  
WHERE c.tno = 19;

---------------------Task 15 -----------------
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'JUDO', 400);

SELECT * FROM ticket ORDER BY tno DESC;


---------------------Task 16 -----------------
INSERT INTO event VALUES
('A400', '400 metres sprint', 'Stadium 1','2026-07-12','10:00',1000);

---------------------Task 17 -----------------
INSERT INTO event VALUES
('A900', '900 metres sprint', 'Stadium 1','2023-07-12','10:00',1000);


---------------------Task 18 -----------------
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'AXXX', 100);

---------------------Task 19 -----------------
INSERT INTO ticket VALUES
((SELECT COALESCE(MAX(tno),0) FROM ticket) + 1, 'A400', 900);



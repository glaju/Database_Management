DROP TABLE DB1_TERMES cascade constraint purge;
DROP TABLE DB1_OSTERMELO cascade constraint purge;

CREATE TABLE "DB1_OSTERMELO"
  (
     "ID"           NUMBER(8, 0),
     "VEZETEKNEV"   VARCHAR2(30),
     "KERESZTNEV"   VARCHAR2(30),
     "IRANYITOSZAM" NUMBER(4, 0),
     "TELEPULES"    VARCHAR2(30),
     "UTCA"         VARCHAR2(30),
     "HAZSZAM"      VARCHAR2(5),
     "FOLDTERULET"  NUMBER(3, 0)
  );
CREATE TABLE "DB1_TERMES"
  (
     "ID"           NUMBER(8, 0),
     "OSTERMELO_ID" NUMBER(8, 0),
     "EV"           NUMBER(4, 0),
     "TERMEK"       VARCHAR2(30),
     "MENNYISEG"    NUMBER(4, 0)
  );

ALTER TABLE "DB1_OSTERMELO" ADD constraint "DB1_OSTERMELO_PK" primary key ("ID");
ALTER TABLE "DB1_OSTERMELO" MODIFY ("ID" NOT NULL enable);
ALTER TABLE "DB1_OSTERMELO" MODIFY ("VEZETEKNEV" NOT NULL enable);  
ALTER TABLE "DB1_TERMES" ADD constraint "DB1_TERMES_PK" primary key ("ID");
ALTER TABLE "DB1_TERMES" MODIFY ("ID" NOT NULL enable);
ALTER TABLE "DB1_TERMES" ADD constraint "DB1_TERMES_TERMELO" foreign key ("OSTERMELO_ID") references "DB1_OSTERMELO" ("ID") enable;  

INSERT INTO db1_ostermelo
            (id,vezeteknev,keresztnev,iranyitoszam,telepules,utca,hazszam,
             foldterulet)
VALUES      (1,'Minta','Anna',8642,'Aszófõ','Kossuth','44',4);

INSERT INTO db1_ostermelo
            (id,vezeteknev,keresztnev,iranyitoszam,telepules,utca,hazszam,
             foldterulet)
VALUES      (2,'Tóth','János',2478,'Pázmánd','Mátyás','33',7);

INSERT INTO db1_ostermelo
            (id,vezeteknev,keresztnev,iranyitoszam,telepules,utca,hazszam,
             foldterulet)
VALUES      (3,'Kiss','Zsombor',3477,'Rozsály','Domb','7',12);

INSERT INTO db1_ostermelo
            (id,vezeteknev,keresztnev,iranyitoszam,telepules,utca,hazszam,
             foldterulet)
VALUES      (4,'Kovács','István',4478,'Hosszúhetény','Kanyargós','47',9);

INSERT INTO db1_ostermelo
            (id,vezeteknev,keresztnev,iranyitoszam,telepules,utca,hazszam,
             foldterulet)
VALUES      (5,'Takács','Nándor',7847,'Székkutas','Kossuth','17',20);
INSERT INTO db1_termes
            (id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (1,1,2010,'burgonya',100);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (2,1,2010,'paradicsom',30);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (3,1,2011,'paradicsom',15);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (4,2,2010,'burgonya',500);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (5,2,2010,'rózsaburgonya',600);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (6,3,2011,'vöröshagyma',170);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (7,3,2011,'póréhagyma',20);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (8,3,2011,'görögdinnye',600);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (9,4,2010,'sárgarépa',120);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (10,4,2010,'zöldborsó',70);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (11,4,2011,'sárgarépa',150);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (12,4,2011,'csemegekukorica',600);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (13,4,2011,'zöldborsó',90);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (14,5,2011,'paradiccsom',70);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (15,5,2011,'zöldborsó',90);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (16,5,2011,'uborka',40);

COMMIT;
-- GYAKORLÓ FELADATOK


  
--1. Feladat. Hozzon létre egy új termelõt a saját nevével és címével (használhatsz kitalált címet (INSERT paranccsal))!
INSERT INTO db1_ostermelo 
            (id, 
             vezeteknev, 
             keresztnev, 
             iranyitoszam, 
             telepules, 
             utca, 
             hazszam, 
             foldterulet) 
VALUES      ( 6, 
              'Menta', 
              'Béla', 
              8642, 
              'Csömödér', 
              'Május 1.', 
              '5', 
              83 );  

--2. Feladat. A DB1_TERMES táblában, az ID=14-es sorban a termés nevében levõ helyesírási hibát javítsa ki egy UPDATE paranccsal! 
SELECT * 
FROM   db1_termes 
WHERE  id = 14; 

UPDATE db1_termes 
SET    termek = 'paradicsom' 
WHERE  id = 14;

--3. Feladat. Listázd ki az õstermelõk vezeték- és keresztnevét! 
SELECT vezeteknev, 
       keresztnev 
FROM   db1_ostermelo;
	   
--4. Feladat. Listázd ki a terméseket: az évet, a termék nevét és a mennyiséget! 
SELECT ev, 
       termek, 
       mennyiseg 
FROM   db1_termes; 

--5. Feladat. Listázd ki az õstermelõk irányítószámát, települését és földterületét! 
SELECT iranyitoszam, 
       telepules, 
       foldterulet 
FROM   db1_ostermelo; 

--6. Feladat. Listázd ki az õstermelõk irányítószámát, települését és földterületét (méret, ha)! 
--   Csak azokat vegyük figyelembe, akiknek a földterülete legalább 10 hektár. Az eredményt rendezze települések szerint.
SELECT iranyitoszam, 
       telepules, 
       foldterulet 
FROM   db1_ostermelo 
WHERE  foldterulet >= 10 
ORDER  BY telepules; 

--7. Feladat. Listázd ki az õstermelõk vezeték- és keresztnevét, települését, irányítószámát! 
--   Csak azokat vegyük figyelembe, akik vezetékneve “K” betûvel kezdõdik! Névsorban (vezetéknév, keresztnév) írjuk ki a nevüket!
SELECT vezeteknev, 
       keresztnev, 
       telepules, 
       iranyitoszam 
FROM   db1_ostermelo 
WHERE  vezeteknev LIKE 'K%' 
ORDER  BY vezeteknev, 
          keresztnev; 

--8. Feladat. Listázd ki a 2011-es terméseket (termék neve, mennyiség)! Csak a 100 kg feletti mennyiségeket vegye figyelembe.
--   A mennyiség szerint rendezze az eredményt. 
SELECT termek, 
       mennyiseg 
FROM   db1_termes 
WHERE  mennyiseg > 100 
ORDER  BY mennyiseg DESC; 

--9. Feladat. Listázd ki azokat a termelõket terméseikkel együtt (termelõ vezetékneve, települése, termék neve, mennyisége),
--   akiknek 2010-ben volt termésük. A mennyiség szerint rendezze az eredményt. 
SELECT vezeteknev, 
       t0.telepules, 
       t1.termek, 
       t1.mennyiseg 
FROM   db1_ostermelo t0 
       INNER JOIN db1_termes t1 
               ON t1.ostermelo_id = t0.id 
WHERE  t1.ev = 2010 
ORDER  BY t1.mennyiseg DESC; 

--10. Feladat. Listázd ki azokat a termelõket (vezetéknév, keresztnév, település), akiknek 2010-ben nem volt semmilyen termése! 
SELECT vezeteknev, 
       keresztnev, 
       telepules 
FROM   db1_ostermelo 
WHERE  id NOT IN (SELECT DISTINCT ostermelo_id 
                  FROM   db1_termes 
                  WHERE  ev = 2010); 
				  
--11. Feladat. Listázd ki azokat a termelõket terméseikkel együtt (termelõ vezetékneve, keresztneve, irányítószáma, év, termék neve, mennyisége),
---  akiknek bármelyik évben volt bármilyen hagymatermése (vigyázat, a “hagyma” sokféleképpen szerepelhet)!
SELECT t1.vezeteknev, 
       t1.keresztnev, 
       t1.iranyitoszam, 
       t0.termek, 
       t0.mennyiseg 
FROM   db1_termes t0 
       INNER JOIN db1_ostermelo t1 
               ON t1.id = t0.ostermelo_id 
WHERE  Lower(termek) LIKE '%hagyma%'; 

--12. Feladat. Listázd ki azokat a termelõket (vezetéknév, keresztnév, település), akiknek soha nem termett burgonyája
--   (a burgonyát sokféleképpen lehet írni...)! 
SELECT vezeteknev, 
       keresztnev, 
       telepules 
FROM   db1_ostermelo 
WHERE  id NOT IN (SELECT DISTINCT ostermelo_id 
                  FROM   db1_termes 
                  WHERE  Lower(termek) LIKE '%burgonya%'); 
				  
--13. Feladat. Listázd ki, hogy egy-egy terménnyel mennyi termelõ foglalkozik (foglalkozott)? 
SELECT termek, 
       Count(ostermelo_id) 
FROM   db1_termes 
GROUP  BY termek 
ORDER  BY termek;

-- Az egyes termek-ostermelo párok kétszer szerepelhetnek, 
-- mert különbözõ években is termelheti ugyanazt a terméket az ostermelo. Helyesebben: 
SELECT termek, 
       Count(ostermelo_id) 
FROM   (SELECT DISTINCT ostermelo_id, 
                        termek 
        FROM   db1_termes) 
GROUP  BY termek 
ORDER  BY termek;  

-- a.  Csak azokat a terményeket (id, név, termelõk száma) listázd ki, amelyeket legalább 2-n állítanak elõ. 
SELECT termek, 
       Count(ostermelo_id) 
FROM   (SELECT DISTINCT ostermelo_id, 
                        termek 
        FROM   db1_termes) 
GROUP  BY termek 
HAVING Count(ostermelo_id) > 1 
ORDER  BY termek; 

-- b.  Listázd ki, hogy 1-1 évben mennyi termés volt (mennyiség)? 
SELECT ev, 
       Sum(mennyiseg) 
FROM   db1_termes 
GROUP  BY ev; 

-- c.  Listázd ki, hogy egy-egy évben, egy-egy terménybõl mennyi termés volt! 
SELECT termek, 
       ev, 
       Sum(mennyiseg) 
FROM   db1_termes 
GROUP  BY termek, 
          ev 
ORDER  BY termek, 
          ev;  				  
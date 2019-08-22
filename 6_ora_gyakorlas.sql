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
VALUES      (1,'Minta','Anna',8642,'Asz�f�','Kossuth','44',4);

INSERT INTO db1_ostermelo
            (id,vezeteknev,keresztnev,iranyitoszam,telepules,utca,hazszam,
             foldterulet)
VALUES      (2,'T�th','J�nos',2478,'P�zm�nd','M�ty�s','33',7);

INSERT INTO db1_ostermelo
            (id,vezeteknev,keresztnev,iranyitoszam,telepules,utca,hazszam,
             foldterulet)
VALUES      (3,'Kiss','Zsombor',3477,'Rozs�ly','Domb','7',12);

INSERT INTO db1_ostermelo
            (id,vezeteknev,keresztnev,iranyitoszam,telepules,utca,hazszam,
             foldterulet)
VALUES      (4,'Kov�cs','Istv�n',4478,'Hossz�het�ny','Kanyarg�s','47',9);

INSERT INTO db1_ostermelo
            (id,vezeteknev,keresztnev,iranyitoszam,telepules,utca,hazszam,
             foldterulet)
VALUES      (5,'Tak�cs','N�ndor',7847,'Sz�kkutas','Kossuth','17',20);
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
VALUES      (5,2,2010,'r�zsaburgonya',600);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (6,3,2011,'v�r�shagyma',170);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (7,3,2011,'p�r�hagyma',20);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (8,3,2011,'g�r�gdinnye',600);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (9,4,2010,'s�rgar�pa',120);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (10,4,2010,'z�ldbors�',70);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (11,4,2011,'s�rgar�pa',150);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (12,4,2011,'csemegekukorica',600);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (13,4,2011,'z�ldbors�',90);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (14,5,2011,'paradiccsom',70);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (15,5,2011,'z�ldbors�',90);

INSERT INTO db1_termes
        	(id,ostermelo_id,ev,termek,mennyiseg)
VALUES      (16,5,2011,'uborka',40);

COMMIT;
-- GYAKORL� FELADATOK


  
--1. Feladat. Hozzon l�tre egy �j termel�t a saj�t nev�vel �s c�m�vel (haszn�lhatsz kital�lt c�met (INSERT paranccsal))!
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
              'B�la', 
              8642, 
              'Cs�m�d�r', 
              'M�jus 1.', 
              '5', 
              83 );  

--2. Feladat. A DB1_TERMES t�bl�ban, az ID=14-es sorban a term�s nev�ben lev� helyes�r�si hib�t jav�tsa ki egy UPDATE paranccsal! 
SELECT * 
FROM   db1_termes 
WHERE  id = 14; 

UPDATE db1_termes 
SET    termek = 'paradicsom' 
WHERE  id = 14;

--3. Feladat. List�zd ki az �stermel�k vezet�k- �s keresztnev�t! 
SELECT vezeteknev, 
       keresztnev 
FROM   db1_ostermelo;
	   
--4. Feladat. List�zd ki a term�seket: az �vet, a term�k nev�t �s a mennyis�get! 
SELECT ev, 
       termek, 
       mennyiseg 
FROM   db1_termes; 

--5. Feladat. List�zd ki az �stermel�k ir�ny�t�sz�m�t, telep�l�s�t �s f�ldter�let�t! 
SELECT iranyitoszam, 
       telepules, 
       foldterulet 
FROM   db1_ostermelo; 

--6. Feladat. List�zd ki az �stermel�k ir�ny�t�sz�m�t, telep�l�s�t �s f�ldter�let�t (m�ret, ha)! 
--   Csak azokat vegy�k figyelembe, akiknek a f�ldter�lete legal�bb 10 hekt�r. Az eredm�nyt rendezze telep�l�sek szerint.
SELECT iranyitoszam, 
       telepules, 
       foldterulet 
FROM   db1_ostermelo 
WHERE  foldterulet >= 10 
ORDER  BY telepules; 

--7. Feladat. List�zd ki az �stermel�k vezet�k- �s keresztnev�t, telep�l�s�t, ir�ny�t�sz�m�t! 
--   Csak azokat vegy�k figyelembe, akik vezet�kneve �K� bet�vel kezd�dik! N�vsorban (vezet�kn�v, keresztn�v) �rjuk ki a nev�ket!
SELECT vezeteknev, 
       keresztnev, 
       telepules, 
       iranyitoszam 
FROM   db1_ostermelo 
WHERE  vezeteknev LIKE 'K%' 
ORDER  BY vezeteknev, 
          keresztnev; 

--8. Feladat. List�zd ki a 2011-es term�seket (term�k neve, mennyis�g)! Csak a 100 kg feletti mennyis�geket vegye figyelembe.
--   A mennyis�g szerint rendezze az eredm�nyt. 
SELECT termek, 
       mennyiseg 
FROM   db1_termes 
WHERE  mennyiseg > 100 
ORDER  BY mennyiseg DESC; 

--9. Feladat. List�zd ki azokat a termel�ket term�seikkel egy�tt (termel� vezet�kneve, telep�l�se, term�k neve, mennyis�ge),
--   akiknek 2010-ben volt term�s�k. A mennyis�g szerint rendezze az eredm�nyt. 
SELECT vezeteknev, 
       t0.telepules, 
       t1.termek, 
       t1.mennyiseg 
FROM   db1_ostermelo t0 
       INNER JOIN db1_termes t1 
               ON t1.ostermelo_id = t0.id 
WHERE  t1.ev = 2010 
ORDER  BY t1.mennyiseg DESC; 

--10. Feladat. List�zd ki azokat a termel�ket (vezet�kn�v, keresztn�v, telep�l�s), akiknek 2010-ben nem volt semmilyen term�se! 
SELECT vezeteknev, 
       keresztnev, 
       telepules 
FROM   db1_ostermelo 
WHERE  id NOT IN (SELECT DISTINCT ostermelo_id 
                  FROM   db1_termes 
                  WHERE  ev = 2010); 
				  
--11. Feladat. List�zd ki azokat a termel�ket term�seikkel egy�tt (termel� vezet�kneve, keresztneve, ir�ny�t�sz�ma, �v, term�k neve, mennyis�ge),
---  akiknek b�rmelyik �vben volt b�rmilyen hagymaterm�se (vigy�zat, a �hagyma� sokf�lek�ppen szerepelhet)!
SELECT t1.vezeteknev, 
       t1.keresztnev, 
       t1.iranyitoszam, 
       t0.termek, 
       t0.mennyiseg 
FROM   db1_termes t0 
       INNER JOIN db1_ostermelo t1 
               ON t1.id = t0.ostermelo_id 
WHERE  Lower(termek) LIKE '%hagyma%'; 

--12. Feladat. List�zd ki azokat a termel�ket (vezet�kn�v, keresztn�v, telep�l�s), akiknek soha nem termett burgony�ja
--   (a burgony�t sokf�lek�ppen lehet �rni...)! 
SELECT vezeteknev, 
       keresztnev, 
       telepules 
FROM   db1_ostermelo 
WHERE  id NOT IN (SELECT DISTINCT ostermelo_id 
                  FROM   db1_termes 
                  WHERE  Lower(termek) LIKE '%burgonya%'); 
				  
--13. Feladat. List�zd ki, hogy egy-egy term�nnyel mennyi termel� foglalkozik (foglalkozott)? 
SELECT termek, 
       Count(ostermelo_id) 
FROM   db1_termes 
GROUP  BY termek 
ORDER  BY termek;

-- Az egyes termek-ostermelo p�rok k�tszer szerepelhetnek, 
-- mert k�l�nb�z� �vekben is termelheti ugyanazt a term�ket az ostermelo. Helyesebben: 
SELECT termek, 
       Count(ostermelo_id) 
FROM   (SELECT DISTINCT ostermelo_id, 
                        termek 
        FROM   db1_termes) 
GROUP  BY termek 
ORDER  BY termek;  

-- a.  Csak azokat a term�nyeket (id, n�v, termel�k sz�ma) list�zd ki, amelyeket legal�bb 2-n �ll�tanak el�. 
SELECT termek, 
       Count(ostermelo_id) 
FROM   (SELECT DISTINCT ostermelo_id, 
                        termek 
        FROM   db1_termes) 
GROUP  BY termek 
HAVING Count(ostermelo_id) > 1 
ORDER  BY termek; 

-- b.  List�zd ki, hogy 1-1 �vben mennyi term�s volt (mennyis�g)? 
SELECT ev, 
       Sum(mennyiseg) 
FROM   db1_termes 
GROUP  BY ev; 

-- c.  List�zd ki, hogy egy-egy �vben, egy-egy term�nyb�l mennyi term�s volt! 
SELECT termek, 
       ev, 
       Sum(mennyiseg) 
FROM   db1_termes 
GROUP  BY termek, 
          ev 
ORDER  BY termek, 
          ev;  				  
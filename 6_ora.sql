SELECT dcu_id FROM dcdb.dc_usage;
SELECT * FROM dcdb.components;
SELECT * FROM DCDB.ATC_CODES;
SELECT * FROM DCDB.jaccard_auc;

--1. Feladat. Az egyes gy�gyszerekhez (components), h�ny darab ATC k�d tartozik (atc_codes)? (Azokat a komponenseket is vedd figyelembe, amelyekhez nincsen ATC k�d annot�lva.)
SELECT t0.dcc_id,
  COUNT(t1.ATC_ID) nr_atc_codes
FROM dcdb.components t0
LEFT OUTER JOIN DCDB.DCC_TO_ATC t1
ON t1.dcc_id = t0.dcc_id
GROUP BY t0.dcc_id;

--2. Feladat. Az egyes gy�gyszereknek h�ny darab c�lpontjuk van? (targets)
SELECT t0.dcc_id,
  COUNT(t1.tar_id) nr_targets
FROM DCDB.components t0
LEFT OUTER JOIN DCDB.DCC_TO_TARGETS t1
ON t0.dcc_id = t1.dcc_id
GROUP BY t0.dcc_id;

--3. Feladat. Az egyes gy�gyszereknek h�ny darab c�lpontjuk �s h�ny darab ATC k�djuk van? (egym�s mellett ki�rva)
SELECT t0.dcc_id,
  t0.nr_atc_codes,
  COUNT(t1.tar_id) nr_targets
FROM
  (SELECT t0.dcc_id,
    COUNT(t1.ATC_ID) nr_atc_codes
  FROM dcdb.components t0
  LEFT OUTER JOIN DCDB.DCC_TO_ATC t1
  ON t1.dcc_id = t0.dcc_id
  GROUP BY t0.dcc_id
  ) t0
LEFT OUTER JOIN DCDB.DCC_TO_TARGETS t1
ON t0.dcc_id = t1.dcc_id
GROUP BY t0.dcc_id,
  t0.nr_atc_codes ;

  
---- Analitikus f�ggv�nyek
create table verseny(
tantargy varchar2(255),
pontszam number,
versenyzo varchar2(255));

insert into verseny values('matematika',100,'Kiss Anna');
insert into verseny values('matematika',98,'Kiss P�ter');
insert into verseny values('matematika',94,'Kov�cs B�la');
insert into verseny values('matematika',76,'Szab� Lilla');
insert into verseny values('matematika',65,'P�sztor J�lia');
insert into verseny values('matematika',88,'Nagy Anna');
insert into verseny values('matematika',45,'Juh�sz Antal');
insert into verseny values('matematika',63,'Fazekas Andr�s');
insert into verseny values('matematika',34,'Kiss �va');


insert into verseny values('irodalom',34,'Kiss �d�m');
insert into verseny values('irodalom',56,'Szab� �d�m');
insert into verseny values('irodalom',76,'Moln�r �goston');
insert into verseny values('irodalom',100,'Nagy M�t�');
insert into verseny values('irodalom',99,'Farkas Botond');
insert into verseny values('irodalom',99,'Lovas Lilla');
insert into verseny values('irodalom',98,'Juh�sz J�lia');
insert into verseny values('irodalom',45,'Nagy �va');

insert into verseny values('biol�gia',32,'Kiss M�rton');
insert into verseny values('biol�gia',89,'Kedves Anna');
insert into verseny values('biol�gia',100,'Vass Orsolya');
insert into verseny values('biol�gia',100,'Pint�r �kos');
insert into verseny values('biol�gia',23,'Horv�th D�niel');
insert into verseny values('biol�gia',55,'P�terfy Janka');
insert into verseny values('biol�gia',67,'Szab� �d�m');

SELECT * FROM verseny;

--4. Feladat. �rd ki tant�rgyank�nt az �tlagpontokat! 
--Majd �rd ki minden sorban egy �j oszlopba az adott tant�rgy �tlagpontsz�m�t!

select avg(pontszam) atlagpont,tantargy
from verseny
group by TANTARGY;

select tantargy, versenyzo, pontszam,
avg(pontszam) over(partition by tantargy) atlagpont
from verseny;

--5. Feladat. �rd ki, hogy ki h�ny ponttal t�rt el az �tlagpontt�l (tant�rgyank�nt)!

SELECT tantargy, versenyzo, pontszam,
floor(pontszam -(AVG(pontszam) OVER(PARTITION BY tantargy))) atlagponttol_elteres
FROM verseny;

SELECT tantargy, versenyzo, pontszam,
RANK() OVER(PARTITION BY tantargy ORDER BY pontszam DESC) rangsor,
DENSE_RANK() OVER(PARTITION BY tantargy ORDER BY pontszam DESC)suru_rangsor
FROM verseny;

--6. Feladat.�rd ki tant�rgyank�nt az els� 3 helyezettet!
SELECT * FROM(
SELECT tantargy, versenyzo, pontszam,
RANK() OVER(PARTITION BY tantargy ORDER BY pontszam DESC) rangsor,
DENSE_RANK() OVER(PARTITION BY tantargy ORDER BY pontszam DESC)suru_rangsor
FROM verseny)
WHERE rangsor<4;

--7. Feladat.�rd ki, hogy ki h�ny ponttal maradt le az eggyel jobb helyezett�l (t�rgyank�nt)!
SELECT tantargy, versenyzo, pontszam,
LAG(pontszam) OVER(PARTITION BY tantargy ORDER BY pontszam DESC) elozo_ember_pontja,
(LAG(pontszam) OVER(PARTITION BY tantargy ORDER BY pontszam DESC)-pontszam) lemaradas
FROM verseny;



SELECT * FROM DCDB.DCC_TO_ATC;
SELECT * FROM DCDB.JACCARD_AUC;
--8. feladat �rd az egyes gy�gyszerek mell�, hogy milyen ATC k�dok tartoznak hozz�juk! Az ATC k�dokat vessz�vel v�laszd el egym�st�l! A feladathoz haszn�ld a Listagg() f�ggv�nyt!
SELECT t0.DCC_ID, t0.generic_name,
LISTAGG(t2.codes, ', ') WITHIN GROUP (ORDER BY t2.CODES desc)
FROM dcdb.components t0
LEFT OUTER JOIN DCDB.DCC_TO_ATC t1 ON t1.dcc_id= t0.dcc_id
LEFT OUTER JOIN DCDB.ATC_CODES t2 ON t2.atc_id = t1.atc_id
GROUP BY t0.dcc_id, t0.generic_name;


--9. Feladat. K�s�rletenk�nt (exp_id) rangsorold a kombin�ci�kat a score-k alapj�n! (jaccard_auc t�bla)
SELECT exp_id,dc_id,jm,
rank() OVER (PARTITION BY exp_id ORDER BY jm DESC) sima_rang,
dense_rank() OVER (PARTITION BY exp_id ORDER BY jm DESC) suru_rank
FROM dcdb.jaccard_auc;




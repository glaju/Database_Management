SELECT dcu_id FROM dcdb.dc_usage;
SELECT * FROM dcdb.components;
SELECT * FROM DCDB.ATC_CODES;
SELECT * FROM DCDB.jaccard_auc;

--1. Feladat. Az egyes gyógyszerekhez (components), hány darab ATC kód tartozik (atc_codes)? (Azokat a komponenseket is vedd figyelembe, amelyekhez nincsen ATC kód annotálva.)
SELECT t0.dcc_id,
  COUNT(t1.ATC_ID) nr_atc_codes
FROM dcdb.components t0
LEFT OUTER JOIN DCDB.DCC_TO_ATC t1
ON t1.dcc_id = t0.dcc_id
GROUP BY t0.dcc_id;

--2. Feladat. Az egyes gyógyszereknek hány darab célpontjuk van? (targets)
SELECT t0.dcc_id,
  COUNT(t1.tar_id) nr_targets
FROM DCDB.components t0
LEFT OUTER JOIN DCDB.DCC_TO_TARGETS t1
ON t0.dcc_id = t1.dcc_id
GROUP BY t0.dcc_id;

--3. Feladat. Az egyes gyógyszereknek hány darab célpontjuk és hány darab ATC kódjuk van? (egymás mellett kiírva)
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

  
---- Analitikus függvények
create table verseny(
tantargy varchar2(255),
pontszam number,
versenyzo varchar2(255));

insert into verseny values('matematika',100,'Kiss Anna');
insert into verseny values('matematika',98,'Kiss Péter');
insert into verseny values('matematika',94,'Kovács Béla');
insert into verseny values('matematika',76,'Szabó Lilla');
insert into verseny values('matematika',65,'Pásztor Júlia');
insert into verseny values('matematika',88,'Nagy Anna');
insert into verseny values('matematika',45,'Juhász Antal');
insert into verseny values('matematika',63,'Fazekas András');
insert into verseny values('matematika',34,'Kiss Éva');


insert into verseny values('irodalom',34,'Kiss Ádám');
insert into verseny values('irodalom',56,'Szabó Ádám');
insert into verseny values('irodalom',76,'Molnár Ágoston');
insert into verseny values('irodalom',100,'Nagy Máté');
insert into verseny values('irodalom',99,'Farkas Botond');
insert into verseny values('irodalom',99,'Lovas Lilla');
insert into verseny values('irodalom',98,'Juhász Júlia');
insert into verseny values('irodalom',45,'Nagy Éva');

insert into verseny values('biológia',32,'Kiss Márton');
insert into verseny values('biológia',89,'Kedves Anna');
insert into verseny values('biológia',100,'Vass Orsolya');
insert into verseny values('biológia',100,'Pintér Ákos');
insert into verseny values('biológia',23,'Horváth Dániel');
insert into verseny values('biológia',55,'Péterfy Janka');
insert into verseny values('biológia',67,'Szabó Ádám');

SELECT * FROM verseny;

--4. Feladat. Írd ki tantárgyanként az átlagpontokat! 
--Majd írd ki minden sorban egy új oszlopba az adott tantárgy átlagpontszámát!

select avg(pontszam) atlagpont,tantargy
from verseny
group by TANTARGY;

select tantargy, versenyzo, pontszam,
avg(pontszam) over(partition by tantargy) atlagpont
from verseny;

--5. Feladat. Írd ki, hogy ki hány ponttal tért el az átlagponttól (tantárgyanként)!

SELECT tantargy, versenyzo, pontszam,
floor(pontszam -(AVG(pontszam) OVER(PARTITION BY tantargy))) atlagponttol_elteres
FROM verseny;

SELECT tantargy, versenyzo, pontszam,
RANK() OVER(PARTITION BY tantargy ORDER BY pontszam DESC) rangsor,
DENSE_RANK() OVER(PARTITION BY tantargy ORDER BY pontszam DESC)suru_rangsor
FROM verseny;

--6. Feladat.Írd ki tantárgyanként az elsõ 3 helyezettet!
SELECT * FROM(
SELECT tantargy, versenyzo, pontszam,
RANK() OVER(PARTITION BY tantargy ORDER BY pontszam DESC) rangsor,
DENSE_RANK() OVER(PARTITION BY tantargy ORDER BY pontszam DESC)suru_rangsor
FROM verseny)
WHERE rangsor<4;

--7. Feladat.Írd ki, hogy ki hány ponttal maradt le az eggyel jobb helyezettõl (tárgyanként)!
SELECT tantargy, versenyzo, pontszam,
LAG(pontszam) OVER(PARTITION BY tantargy ORDER BY pontszam DESC) elozo_ember_pontja,
(LAG(pontszam) OVER(PARTITION BY tantargy ORDER BY pontszam DESC)-pontszam) lemaradas
FROM verseny;



SELECT * FROM DCDB.DCC_TO_ATC;
SELECT * FROM DCDB.JACCARD_AUC;
--8. feladat Írd az egyes gyógyszerek mellé, hogy milyen ATC kódok tartoznak hozzájuk! Az ATC kódokat vesszõvel válaszd el egymástól! A feladathoz használd a Listagg() függvényt!
SELECT t0.DCC_ID, t0.generic_name,
LISTAGG(t2.codes, ', ') WITHIN GROUP (ORDER BY t2.CODES desc)
FROM dcdb.components t0
LEFT OUTER JOIN DCDB.DCC_TO_ATC t1 ON t1.dcc_id= t0.dcc_id
LEFT OUTER JOIN DCDB.ATC_CODES t2 ON t2.atc_id = t1.atc_id
GROUP BY t0.dcc_id, t0.generic_name;


--9. Feladat. Kísérletenként (exp_id) rangsorold a kombinációkat a score-k alapján! (jaccard_auc tábla)
SELECT exp_id,dc_id,jm,
rank() OVER (PARTITION BY exp_id ORDER BY jm DESC) sima_rang,
dense_rank() OVER (PARTITION BY exp_id ORDER BY jm DESC) suru_rank
FROM dcdb.jaccard_auc;




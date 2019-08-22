--1. Feladat. Ird ki azokat az orvosokat, akik legalabb 2 kezelest vegeztek el. 
SELECT t0.consultant, 
       t1.staff_name, 
       Count(treatment_id) 
FROM   treatment t0 
       inner JOIN staff t1 
               ON t1.staff_id = t0.consultant                
WHERE  t1.staff_name LIKE 'Dr%' 
GROUP  BY t0.consultant, 
          t1.staff_name 
HAVING Count(treatment_id) > 1; 

describe mb18___db.subject;

--2. Feladat. Az egyes beosztasokban (staff.post) mik az atlagos jovedelmek? 
SELECT post, 
       Avg(salary) 
FROM   staff 
GROUP  BY post;   


---- FAN TRAP, CHASM TRAP
--3.feladat Azok a tanarok, akiknek nem neurobiologia a kutatasi teruletuk (research_area='neurobiology'), mennyi az osszesen tanitott tantargyaiknak a szama?
SELECT *
FROM mb18___db.LECTURER l INNER JOIN mb18___db.SUBJECT s
ON l.ID = s.LECTURER;

SELECT *
FROM mb18___db.LECTURER l LEFT OUTER JOIN mb18___db.SUBJECT s
ON l.ID = s.LECTURER;

SELECT count(s.ID) num_of_subjects
FROM mb18___db.LECTURER l inner JOIN mb18___db.SUBJECT s
ON l.ID = s.LECTURER
WHERE lower(l.RESEARCH_AREA) NOT LIKE '%neurobiology%';

--4.feladat Hany targyat tanitanak ugyanezek a tanarok fejenkent?
SELECT l.ID, l.NAME, l.research_area , count(s.ID) num_of_subjects
FROM mb18___db.LECTURER l left outer JOIN mb18___db.SUBJECT s
ON l.ID = s.LECTURER
WHERE lower(l.RESEARCH_AREA) NOT LIKE '%neurobiology%'
GROUP BY l.ID, l.NAME, l.research_area
ORDER BY num_of_subjects DESC;

--Hany tanar van ezek kozott, akik 2-nel kevesebb targyat tanitanak?
SELECT count(*)
FROM
(SELECT l.ID, l.NAME, l.research_area , count(s.ID) num_of_subjects
FROM mb18___db.LECTURER l LEFT OUTER JOIN mb18___db.SUBJECT s
ON l.ID = s.LECTURER
WHERE lower(l.RESEARCH_AREA) NOT LIKE '%neurobiology%'
GROUP BY l.ID, l.NAME, l.research_area
HAVING count(s.ID) < 2
ORDER BY num_of_subjects DESC);

/*9. feladat Adjuk meg kampuszonkenti felbontasban a tanarok 
es a department-ek szamat, ugy, hogy a rendszerbiologiaval (research_area='Systems biology')
es filozofiaval (research_area='philosophy') foglalkozo tanarokat nem vesszuk figyelembe..*/

--kulon szemleltetve a ket szukseges JOIN
SELECT c.ID, c.NAME, count(d.id) as dep_num
FROM mb18___db.CAMPUS c LEFT OUTER JOIN mb18___db.DEPARTMENT d
ON c.ID = d.CAMPUS_ID
GROUP BY c.ID, c.NAME;

SELECT c.ID, c.NAME, count(l.id) as lecturer_num
FROM mb18___db.CAMPUS c LEFT OUTER JOIN mb18___db.LECTURER l
ON c.ID = l.CAMPUS_ID
GROUP BY c.ID, c.NAME;

--ket OUTER JOIN M:1,1:M kapcsolatokon keresztul (fan trap- sortobbszorozodes)
SELECT c.ID, c.NAME, count(d.ID) as dept_num, count(l.ID) as lecturer_num
              FROM (mb18___db.CAMPUS c left outer JOIN mb18___db.DEPARTMENT d
                    ON c.ID = d.CAMPUS_ID ) 
                left outer JOIN mb18___db.LECTURER l
                    ON l.CAMPUS_ID = c.ID
              GROUP BY c.ID, c.NAME;

--csak a department-tel a left outer join
SELECT *
FROM mb18___db.CAMPUS c LEFT OUTER JOIN mb18___db.DEPARTMENT d
ON c.ID = d.CAMPUS_ID
order by c.name;

SELECT *
FROM mb18___db.CAMPUS c LEFT OUTER JOIN mb18___db.LECTURER l
ON c.ID = l.CAMPUS_ID
order by c.name;

/*ha most megnezzuk a harom tablara a left outer join-ok eredmenyet,
akkor lathato, hogy az elozo eredmenytabla sorai duplikalodnak*/

SELECT *
FROM mb18___db.CAMPUS c LEFT OUTER JOIN mb18___db.DEPARTMENT d
ON c.ID = d.CAMPUS_ID
LEFT OUTER JOIN mb18___db.LECTURER l
ON l.CAMPUS_ID = c.ID
order by c.name;

-- megoldas a fan trap-re: subquery segitsegvel reszeredmenyt szamolunk:
SELECT s.c_ID, s.c_NAME, s.dep_num, count(l.ID) as leacturer_num
FROM (SELECT c.ID as c_ID, c.NAME as c_NAME, count(*) as dep_num
      FROM mb18___db.CAMPUS c LEFT OUTER JOIN mb18___db.DEPARTMENT d
      ON c.ID = d.CAMPUS_ID
      GROUP BY c.ID, c.NAME) s 
        LEFT OUTER JOIN mb18___db.LECTURER l
        ON s.c_ID = l.CAMPUS_ID
        WHERE lower(l.RESEARCH_AREA) NOT IN ('computational biology','philosophy')
        GROUP BY s.c_ID, s.c_NAME, s.dep_num;


-----OUTER JOIN
--7.feladat Nézzük meg, hogy van-e valamelyik oldalon olyan érték, aminek nincs meg a megfelelõje
--a másik táblában. Mit tapasztalsz?
SELECT *
FROM   dcdb.dcc_to_atc;

SELECT DISTINCT atc_id
FROM   dcdb.dcc_to_atc
MINUS
SELECT DISTINCT atc_id
FROM   dcdb.atc_codes;
/*
  Az ermeny ures, a dcdb.dcc_to_atc-ben szereplo osszes
  ertek szerepel az dcdb.atc_codes-ban is ---
  --- ahogy egyebkent egy kulso kulccsal el is varjuk
*/

SELECT DISTINCT atc_id
FROM   dcdb.atc_codes
MINUS
SELECT DISTINCT atc_id
FROM   dcdb.dcc_to_atc;
/*
  Az eredmenyben 7 sor szerepel. Tehat van olyan bejegyzes a dcdb.atc_codes-ban,
  amire a masik tablaban nem hivatkozunk.
  A masik tablaban levo kulso kulcs ettol meg persze ervenyes,
  nem kell mindenkire hivatkozni
*/

--8. Feladat. Mi tortenik, hogyha az INNER JOIN segitsegevel kapcsolod ossze a ket tablat?
select count(*) from(
SELECT t1.codes,
      t2.dcc_id
FROM   dcdb.atc_codes t1
      inner join dcdb.dcc_to_atc t2
        ON t1.atc_id = t2.atc_id);


--9. Feladat. Mi tortenik, ha LEFT OUTER JOIN, RIGHT OUTER JOIN vagy ha a FULL OUTER JOIN parancsokat hasznalod?
--(hany sort ad vissza a lekerdezes az egyes esetekben?)
 --LEFT OUTER JOIN
select count(*) from(
SELECT t1.codes,
      t2.dcc_id
FROM   dcdb.atc_codes t1
      left outer join dcdb.dcc_to_atc t2
        ON t1.atc_id = t2.atc_id);



 --RIGHT OUTER JOIN
select count(*) from(
SELECT t1.codes,
      t2.dcc_id
FROM   dcdb.atc_codes t1
      right outer join dcdb.dcc_to_atc t2
        ON t1.atc_id = t2.atc_id);

--FULL OUTER JOIN
select count(*) from(
SELECT t1.codes,
      t2.dcc_id
FROM   dcdb.atc_codes t1
      full outer join dcdb.dcc_to_atc t2
        ON  t1.atc_id = t2.atc_id); 
	
--LEFT + RIGHT OUTER JOIN
SELECT count(*)
FROM
(SELECT t1.codes,
      t2.dcc_id
FROM   dcdb.atc_codes t1
      left outer join dcdb.dcc_to_atc t2
        ON t1.atc_id = t2.atc_id
UNION
SELECT t1.codes,
      t2.dcc_id
FROM   dcdb.atc_codes t1
      right outer join dcdb.dcc_to_atc t2
        ON t1.atc_id = t2.atc_id);
	  
---- INLINE nezet
-- Eloszor megnezzuk a tablakat

SELECT * FROM dcdb.dc_usage;
SELECT * FROM dcdb.components;
SELECT * FROM DCDB.ATC_CODES;
SELECT * FROM DCDB.TARGETS;

DESCRIBE dcdb.dc_usage;
DESCRIBE dcdb.components;
DESCRIBE DCDB.ATC_CODES;
DESCRIBE DCDB.TARGETS;

--10. Feladat. Az egyes gyogyszerekhez (components), hany darab ATC kod tartozik (atc_codes)? (Azokat a komponenseket is vedd figyelembe, amelyekhez nincsen ATC kod annotalva.)
SELECT t0.dcc_id,
  COUNT(t1.ATC_ID) nr_atc_codes
FROM dcdb.components t0
LEFT OUTER JOIN DCDB.DCC_TO_ATC t1
ON t1.dcc_id = t0.dcc_id
GROUP BY t0.dcc_id;

--11. Feladat. Az egyes gyogyszereknek hany darab celpontjuk van? (targets)
SELECT t0.dcc_id,
  COUNT(t1.tar_id) nr_targets
FROM DCDB.components t0
LEFT OUTER JOIN DCDB.DCC_TO_TARGETS t1
ON t0.dcc_id = t1.dcc_id
GROUP BY t0.dcc_id;

--12. Feladat. Az egyes gyogyszereknek hany darab celpontjuk es hany darab ATC kodjuk van? (egymas mellett kiirva)
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
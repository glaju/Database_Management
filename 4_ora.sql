



--1. Feladat. Az egyes gy�gyszereket h�nyszor haszn�lt�k kezel�sre? 
SELECT drug, Count(*) 
FROM   treatment 

GROUP  BY drug; 

--2. Feladat. List�zd ki azokat a gy�gyszereket, amiket legal�bb 2x haszn�lt�k valamilyen kezel�sben!
SELECT drug, Count(*) 
FROM   treatment 
WHERE drug IS NOT null
GROUP  BY drug
HAVING count(*)>=2;

--3. Feladat. List�zd ki betegekk�nt a kezel�sek sz�m�t! (id, n�v, kezel�sek sz�ma)
SELECT patient.patient_name, patient.patient_id, count(treatment.treatment_id)
FROM patient
left outer JOIN treatment
ON patient.patient_id=treatment.patient_id
GROUP BY patient.patient_name,
		 patient.patient_id;

--4. Feladat. A 2. feladatot megold�s�t eg�sz�tsd egy ki egy �j oszloppal, ami a kezel�sek �sszk�lts�g�t tartalmazza!
SELECT drug, Count(*), sum(t_cost)
FROM   treatment 
WHERE drug IS NOT null
GROUP  BY drug
HAVING count(*)>=2;

--5. Feladat. Melyik orvos h�ny kezel�st v�gzett el? (Csak azokat list�zd, akik legal�bb 1 kezel�st v�geztek el)
SELECT t1.consultant, t2.staff_name, count(t1.treatment_id)
FROM treatment t1
INNER JOIN staff t2 ON t1.consultant=t2.staff_id
GROUP BY t1.consultant, t2.staff_name;


--6. Feladat. �rd ki azokat az orvosokat, akik legal�bb 2kezel�st v�geztek el. 
SELECT t0.consultant, t1.staff_name, Count(treatment_id) 
FROM   treatment t0 
INNER JOIN staff t1 ON t1.staff_id = t0.consultant 
GROUP  BY t0.consultant, t1.staff_name 
HAVING Count(treatment_id) > 1; 

--7. Feladat. Az egyes beoszt�sokban (staff.post) mik az �tlagos j�vedelmek? 
SELECT post, Avg(salary)
FROM   staff 
GROUP  BY post;   

--8. Feladat. Mi a f?n�k�k �tlagos j�vedelme?
SELECT avg(salary)
FROM staff
WHERE staff_id IN (SELECT manager_id FROM staff);

--9. Feladat. �tlagosan, aki f?n�k vagy orvos mennyivel keres t�bbet azokn�l, akik nem tartoznak ezekbe a csoportokba (se nem f?n�k, se nem orvos)? 	  
SELECT
 (SELECT avg(salary)
  FROM staff
  WHERE staff_id IN (SELECT manager_id
                   FROM staff)
  OR staff_name LIKE 'Dr%')
  -
  (SELECT avg(salary)
  FROM staff
  WHERE staff_id NOT IN (SELECT manager_id
                   FROM staff
				   WHERE manager_id IS NOT NULL)
  AND staff_name NOT LIKE 'Dr%') AS difference from dual;
  
SELECT * FROM dual;
 
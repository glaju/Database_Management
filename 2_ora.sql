drop table patient cascade constraints purge;
drop table staff cascade constraints purge;
drop table treatment cascade constraints purge;

CREATE TABLE patient(
patient_id VARCHAR(255) PRIMARY KEY,
patient_name VARCHAR(255) NOT NULL,
sex VARCHAR(6),
age NUMBER,
admission_date DATE,
alzheimer_diagnosis VARCHAR(255)
);

CREATE TABLE staff(
  staff_id VARCHAR2(255) PRIMARY KEY,
  staff_name VARCHAR2(255) NOT NULL,
  salary NUMBER,
  post VARCHAR2(255) NOT NULL,
  manager_id VARCHAR2(255) REFERENCES staff(staff_id) -- k�ls� kulcs
);

CREATE TABLE treatment(
    treatment_id VARCHAR(255) PRIMARY KEY,
    patient_id VARCHAR(255) REFERENCES patient (patient_id),
    drug VARCHAR(255),
    t_cost NUMBER,
    t_time DATE,
    consultant VARCHAR(255) REFERENCES staff(staff_id)
);

INSERT INTO patient
VALUES     ( 'P1500',
          'Irvin Brody',
          'male',
          46,
          to_date('24-10-2004', 'dd-mm-yyyy'),
          'mild');

INSERT INTO patient
VALUES     ( 'P9700',
          'Clifton Norman',
          'male',
          85,
          To_date('02-08-2010', 'dd-mm-yyyy'),
          'severe');

INSERT INTO patient
VALUES     ( 'P9500',
          'Arden Rodger',
          'female',
          72,
          To_date('04-09-2010', 'dd-mm-yyyy'),
          'moderate');

INSERT INTO patient
VALUES     ( 'P4000',
          'Harland Wilbur',
          'male',
          69,
          To_date('17-06-2008', 'dd-mm-yyyy'),
          'moderate');

INSERT INTO patient
VALUES     ( 'P8000',
          'Henry Kip',
          'male',
          73,
          To_date('28-07-2009', 'dd-mm-yyyy'),
          'severe');

INSERT INTO staff
VALUES('S0001', 'Dr Boss',20000, 'Manager', NULL);

INSERT INTO staff
VALUES('S0002', 'Dr Green', 18000, 'Surgeon', 'S0001');

INSERT INTO staff
VALUES('S0003', 'Dr Smith', 16000, 'Internist', 'S0001');

INSERT INTO staff
VALUES('S0004', 'Ms Jacques', 10000, 'Matron', 'S0001');

INSERT INTO staff
VALUES('S0005', 'Ms Ball', 8000, 'Sister', 'S0004');

INSERT INTO treatment
VALUES('T0001', 'P1500', 'Donepezil', 57, TO_DATE('24-10-2004 21:18:27', 'DD-MM-YYYY HH24:MI:SS'), 'S0003');

INSERT INTO treatment
VALUES('T0002', 'P8000', NULL , 150, TO_DATE('26-10-2004 21:18:27', 'DD-MM-YYYY HH24:MI:SS'), 'S0002');

INSERT INTO treatment
VALUES('T0003', 'P9700', 'Memantine', 128, TO_DATE('25-10-2004 21:18:27', 'DD-MM-YYYY HH24:MI:SS'), 'S0004');

INSERT INTO treatment
VALUES('T0004', 'P4000', NULL , 150, TO_DATE('27-10-2004 21:18:27', 'DD-MM-YYYY HH24:MI:SS'), 'S0002');
INSERT INTO treatment
VALUES('T0005', 'P4000', NULL , NULL, TO_DATE('21-10-2004 12:10:01', 'DD-MM-YYYY HH24:MI:SS'), 'S0002');

INSERT INTO treatment
VALUES('T0006', 'P9700', 'Memantine' , NULL, TO_DATE('02-11-2004 11:18:27', 'DD-MM-YYYY HH24:MI:SS'), 'S0002');
COMMIT;


--1. Feladat. List�zd ki a betegeket az aktu�lis �letkorukkal (�age� mez�: �letkor az els� felv�telkor)
SELECT patient_id,
       patient_name,
       age,
       admission_date,
       Round(( SYSDATE - admission_date ) / 365) + age
FROM   patient;

--2. Feladat. List�zd ki azokat a p�cienseket koruk szerint cs�kken�,  sorrendbe rendezve (azonos kor eset�n n�vsorban), akik 2005.01.01. ut�n ker�ltek felv�telre!
SELECT *
FROM   patient
WHERE  admission_date >= To_date('20050101', 'yyyymmdd')
ORDER  BY age DESC, 
          patient_name;

--3. Feladat. P9500 azonos�t�j� beteg diagn�zisa megv�ltozott moderate-r�l severe-re. Ennek megfelel�en friss�tsd az adatb�zist!
UPDATE patient
SET ALZHEIMER_DIAGNOSIS = 'severe'
WHERE patient_id        = 'P9500';

SELECT * FROM patient;
--4. Feladat. Opcion�lis: Friss�tsd az �letkort �gy, hogy az aktu�lis �letkort mutassa, ne pedig a felv�telkorit! (Aktu�lis d�tum: SYSDATE)
UPDATE patient
SET age = ROUND(( SYSDATE - admission_date ) / 365) + age;

--5. Feladat. T�r�ld az �sszes n�nem� beteget!
DELETE
FROM patient
WHERE sex ='female';

--6. Feladat. A Henry Kip nev� beteget �thelyezt�k, t�r�ld az adatb�zisb�l!
DELETE
FROM patient 
WHERE patient_name = 'Henry Kip';

--7. Feladat. T�r�ld az �ssze rekordot a t�bl�b�l! (Where kl�z elhagyhat�) 
DELETE
FROM patient;

--8. Feladat. Mik az 'ar' vagy 'Ar' karaktereket tartalmaz� betegek adatai?
SELECT *
FROM patient
WHERE patient_name LIKE '%Ar%'
OR patient_name LIKE '%ar%';

--9. Feladat. Mi az azonos�t�ja �s a kora a ' Henry' string-gel kezd�d� betegeknek?
SELECT patient_id, age
FROM patient
WHERE patient_name LIKE 'Henry%';		  

--10. Feladat. V�lassz�tok ki azokat a sorokat a treatment t�bl�b�l, amelyek cost attrib�tuma nem '�res'!
SELECT * 
FROM   treatment 
WHERE  t_cost IS NOT NULL; 

--11. Feladat. V�lassz�tok ki az �sszes rekordot, de �gy, hogy a Cost mez�ben hi�nyz� �rt�keket 0-val helyettes�titek! 
--(Haszn�ld az nvl() f�ggv�nyt)
SELECT treatment_id, patient_id,t_cost, NVL(t_cost, '0') 
FROM treatment;

--12. Feladat. Mit ad vissza a k�vetkez� lek�rdez�s?
SELECT *
FROM   treatment
WHERE  t_cost < 60
       OR t_cost >= 60;
	   
--13. Feladat.	�rd ki a gy�gyszerek nev�t kisbet�vel!
SELECT drug, LOWER(drug) 
FROM treatment;

--14. Feladat.	Mennyi az �tlag fizet�s?
SELECT avg(salary)
FROM STAFF;

--15. Feladat.	Egy h�napban a k�rh�z mennyi p�nzt k�lt a dolgoz�k fizet�s�re?
SELECT Sum(salary)
FROM STAFF;

--16. Feladat.	Mikor volt a legkor�bbi �s a legk�s�bbi kezel�s?
SELECT Min(t_time) as legkorabbi_kezeles, 
       Max(t_time) as legkesobbi_kezeles 
FROM   treatment;

--17. Feladat.	H�ny kezel�s volt �sszesen?
SELECT count(treatment_id)
FROM treatment;

--18. Feladat.	H�nyszor adtak gy�gyszert �sszesen?
SELECT Count(drug)
FROM treatment;

--19. Feladat.	Opcion�lis: mi a betegek vezet�k - �s keresztneve? Milyen f�ggv�nyek kellenek ehhez? (haszn�ld a google-t)
SELECT patient_name, 
       Substr(patient_name, 0, Instr(patient_name, ' '))  as keresztnev, 
       Substr(patient_name, Instr( patient_name, ' ') +1) as vezeteknev 
FROM   patient;  


--fruits
DROP TABLE FRUITS cascade constraints purge;

-- 1. feladat
CREATE TABLE FRUITS(
fruit_id VARCHAR(5),
f_name VARCHAR(255),
color VARCHAR(255),
best_before DATE,
amount_in_tons NUMBER
);

--2.feladat
ALTER TABLE FRUITS
ADD PRIMARY KEY (fruit_id);

--3.feladat
INSERT INTO FRUITS
            (fruit_id,
             f_name,
             color,
             best_before,
             amount_in_tons)
VALUES     ( 'F1500',
             'apple',
             'red',
             TO_DATE('24-10-2004', 'dd-mm-yyyy'),
             21);
             
INSERT INTO FRUITS
            (fruit_id,
             f_name,
             color,
             best_before,
             amount_in_tons)
VALUES     ( 'F9700',
             'peach',
             'peach',
             TO_DATE('02-08-2010', 'dd-mm-yyyy'),
             5);
             
INSERT INTO FRUITS
            (fruit_id,
             f_name,
             color,
             best_before,
             amount_in_tons)
VALUES     ( 'F9500',
             'apple',
             'green',
             TO_DATE('04-09-2010', 'dd-mm-yyyy'),
             32);
             
SELECT fruit_id, amount_in_tons as mennyiseg 
FROM FRUITS
WHERE amount_in_tons > 10;
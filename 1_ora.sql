













DROP TABLE patient;

DROP TABLE treatment;
--1. Feladat. Hozd l�tre az al�bbi t�bl�kat sql-ben! Melyik oszlopnak mi lesz a t�pusa?

CREATE TABLE patient
(    patient_id       VARCHAR(255) PRIMARY KEY,
    p_name           VARCHAR(255),
    sex              VARCHAR(6),
    admission_date   DATE,
 alzheimer_diagnosis VARCHAR(255)
 );
 
 SELECT * FROM patient;
 
 
 
 
 
 
 
















 CREATE TABLE treatment(
 	treatment_id VARCHAR(255) PRIMARY KEY,
 	patient_id VARCHAR(255),
 	drug VARCHAR(255),
 	cost NUMBER,
 	t_time DATE,
 	consultant VARCHAR(255),
 	FOREIGN KEY (patient_id) REFERENCES patient (patient_id)
);
 SELECT * from TREATMENT;
 
 
 
 
 
 
 
 
 -- 2. Feladat. A patient t�bl�hoz add hozz� az age attrib�tumot!
ALTER TABLE patient ADD age NUMBER;


SELECT * FROM patient;















-- 3. Feladat. M�dos�tsd �gy a patient t�bl�t, hogy a p_name attrib�tum megad�sa k�telez� legyen!
ALTER TABLE patient MODIFY p_name  NOT NULL;

SELECT * FROM patient;












-- 4. Feladat. A treatment nev� t�bl�b�l t�r�ld a consultant attrib�tumot!
ALTER TABLE treatment DROP COLUMN  consultant;


SELECT * FROM TREATMENT;
DROP TABLE treatment;
DROP TABLE patient;













-- 5. Feladat. T�r�lj�tek a treatment t�bl�t!
DROP TABLE treatment;

















-- 6. Feladat. T�lts�tek fel az al�bbi adatokkal a kor�bban defini�lt t�bl�t (ha t�r�lt�tek, akkor hozz�tok �jra l�tre)!
INSERT INTO patient (patient_id,p_name,sex,age,admission_date,alzheimer_diagnosis)
VALUES     ( 'P1500','Irvin Brody','male',46,To_date('24-10-2004', 'dd-mm-yyyy'),'mild');

INSERT INTO patient
            (patient_id,
             p_name,
             sex,
             age,
             admission_date,
             alzheimer_diagnosis)
VALUES     ( 'P9700',
             'Clifton Norman',
             'male',
             85,
             To_date('02-08-2010', 'dd-mm-yyyy'),
             'severe');

INSERT INTO patient
            (patient_id,
             p_name,
             sex,
             age,
             admission_date,
             alzheimer_diagnosis)
VALUES     ( 'P9500',
             'Arden Rodger',
             'female',
             72,
             To_date('04-09-2010', 'dd-mm-yyyy'),
             'moderate');

INSERT INTO patient
            (patient_id,
             p_name,
             sex,
             age,
             admission_date,
             alzheimer_diagnosis)
VALUES     ( 'P4000',
             'Harland Wilbur',
             'male',
             69,
             To_date('17-06-2008', 'dd-mm-yyyy'),
             'moderate');

INSERT INTO patient
            (patient_id,
             p_name,
             sex,
             age,
             admission_date,
             alzheimer_diagnosis)
VALUES     ( 'P8000',
             'Henry Kip',
             'male',
             73,
             To_date('28-07-2009', 'dd-mm-yyyy'),
             'severe'); 
SELECT * FROM patient;             
             
             

--7.	Feladat. Milyen rekordok vannak a patient t�bl�ban?
SELECT * FROM   patient;
















--8.	Feladat. V�laszd ki a patient_id, n�v �s alzheimer_diagnozis oszlopokat!
SELECT patient_id, p_name, alzheimer_diagnosis
FROM   patient;












--9.	Feladat. List�zd ki a 70 �vesn�l �regebb betegek adatait!
SELECT p_name, age
FROM   patient
WHERE  age>70;

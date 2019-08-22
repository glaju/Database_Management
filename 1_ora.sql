













DROP TABLE patient;

DROP TABLE treatment;
--1. Feladat. Hozd létre az alábbi táblákat sql-ben! Melyik oszlopnak mi lesz a típusa?

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
 
 
 
 
 
 
 
 
 -- 2. Feladat. A patient táblához add hozzá az age attribútumot!
ALTER TABLE patient ADD age NUMBER;


SELECT * FROM patient;















-- 3. Feladat. Módosítsd úgy a patient táblát, hogy a p_name attribútum megadása kötelezõ legyen!
ALTER TABLE patient MODIFY p_name  NOT NULL;

SELECT * FROM patient;












-- 4. Feladat. A treatment nevû táblából töröld a consultant attribútumot!
ALTER TABLE treatment DROP COLUMN  consultant;


SELECT * FROM TREATMENT;
DROP TABLE treatment;
DROP TABLE patient;













-- 5. Feladat. Töröljétek a treatment táblát!
DROP TABLE treatment;

















-- 6. Feladat. Töltsétek fel az alábbi adatokkal a korábban definiált táblát (ha töröltétek, akkor hozzátok újra létre)!
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
             
             

--7.	Feladat. Milyen rekordok vannak a patient táblában?
SELECT * FROM   patient;
















--8.	Feladat. Válaszd ki a patient_id, név és alzheimer_diagnozis oszlopokat!
SELECT patient_id, p_name, alzheimer_diagnosis
FROM   patient;












--9.	Feladat. Listázd ki a 70 évesnél öregebb betegek adatait!
SELECT p_name, age
FROM   patient
WHERE  age>70;

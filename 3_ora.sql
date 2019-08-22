DROP TABLE patient CASCADE CONSTRAINTS PURGE;

DROP TABLE staff CASCADE CONSTRAINTS PURGE;

DROP TABLE treatment CASCADE CONSTRAINTS PURGE;

CREATE TABLE patient (
    patient_id            VARCHAR(255) PRIMARY KEY,
    patient_name          VARCHAR(255) NOT NULL,
    sex                   VARCHAR(6),
    age                   NUMBER,
    admission_date        DATE,
    alzheimer_diagnosis   VARCHAR(255)
);

CREATE TABLE staff (
    staff_id     VARCHAR2(255) PRIMARY KEY,
    staff_name   VARCHAR2(255) NOT NULL,
    salary       NUMBER,
    post         VARCHAR2(255) NOT NULL,
    manager_id   VARCHAR2(255)
        REFERENCES staff ( staff_id ) -- külsõ kulcs
);

CREATE TABLE treatment (
    treatment_id   VARCHAR(255) PRIMARY KEY,
    patient_id     VARCHAR(255)
        REFERENCES patient ( patient_id ),
    drug           VARCHAR(255),
    t_cost         NUMBER,
    t_time         DATE,
    consultant     VARCHAR(255)
        REFERENCES staff ( staff_id )
);

INSERT INTO patient VALUES (
    'P1500',
    'Irvin Brody',
    'male',
    46,
    TO_DATE('24-10-2004','dd-mm-yyyy'),
    'mild'
);

INSERT INTO patient VALUES (
    'P9700',
    'Clifton Norman',
    'male',
    85,
    TO_DATE('02-08-2010','dd-mm-yyyy'),
    'severe'
);

INSERT INTO patient VALUES (
    'P9500',
    'Arden Rodger',
    'female',
    72,
    TO_DATE('04-09-2010','dd-mm-yyyy'),
    'moderate'
);

INSERT INTO patient VALUES (
    'P4000',
    'Harland Wilbur',
    'male',
    69,
    TO_DATE('17-06-2008','dd-mm-yyyy'),
    'moderate'
);

INSERT INTO patient VALUES (
    'P8000',
    'Henry Kip',
    'male',
    73,
    TO_DATE('28-07-2009','dd-mm-yyyy'),
    'severe'
);

INSERT INTO staff VALUES (
    'S0001',
    'Dr Boss',
    20000,
    'Manager',
    NULL
);

INSERT INTO staff VALUES (
    'S0002',
    'Dr Green',
    18000,
    'Surgeon',
    'S0001'
);

INSERT INTO staff VALUES (
    'S0003',
    'Dr Smith',
    16000,
    'Internist',
    'S0001'
);

INSERT INTO staff VALUES (
    'S0004',
    'Ms Jacques',
    10000,
    'Matron',
    'S0001'
);

INSERT INTO staff VALUES (
    'S0005',
    'Ms Ball',
    8000,
    'Sister',
    'S0004'
);

INSERT INTO treatment VALUES (
    'T0001',
    'P1500',
    'Donepezil',
    57,
    TO_DATE('24-10-2004 21:18:27','DD-MM-YYYY HH24:MI:SS'),
    'S0003'
);

INSERT INTO treatment VALUES (
    'T0002',
    'P8000',
    NULL,
    150,
    TO_DATE('26-10-2004 21:18:27','DD-MM-YYYY HH24:MI:SS'),
    'S0002'
);

INSERT INTO treatment VALUES (
    'T0003',
    'P9700',
    'Memantine',
    128,
    TO_DATE('25-10-2004 21:18:27','DD-MM-YYYY HH24:MI:SS'),
    'S0004'
);

INSERT INTO treatment VALUES (
    'T0004',
    'P4000',
    NULL,
    150,
    TO_DATE('27-10-2004 21:18:27','DD-MM-YYYY HH24:MI:SS'),
    'S0002'
);

INSERT INTO treatment VALUES (
    'T0005',
    'P4000',
    NULL,
    NULL,
    TO_DATE('21-10-2004 12:10:01','DD-MM-YYYY HH24:MI:SS'),
    'S0002'
);

INSERT INTO treatment VALUES (
    'T0006',
    'P9700',
    'Memantine',
    NULL,
    TO_DATE('02-11-2004 11:18:27','DD-MM-YYYY HH24:MI:SS'),
    'S0002'
);

COMMIT;

SELECT t_time
FROM treatment;

--1. Feladat. Melyik kezelést ki végezte és mennyibe került? Az eredményt rendezd kezelés ára alapján csökkenõ sorrendbe!
SELECT
    t0.treatment_id,
    t1.staff_name,
    t0.t_cost
FROM
    treatment t0
    INNER JOIN staff t1 ON t1.staff_id = t0.consultant;


--2. Feladat Módosítsd úgy az elõzõ lekérdezést, hogy azokat is kiírja, akik nem végeztek kezelést!
SELECT
    t0.treatment_id,
    t1.staff_name,
    t0.t_cost
FROM
    treatment t0
    RIGHT OUTER JOIN staff t1 ON t1.staff_id = t0.consultant;
               
               
--3. Feladat. Melyik beteget ki kezelte és mikor?
SELECT
    t0.patient_name,
    t2.staff_name,
    t1.t_time
FROM
    patient t0
    INNER JOIN treatment t1 ON t1.patient_id = t0.patient_id
    INNER JOIN staff t2 ON t2.staff_id = t1.consultant; 	  

--4. Feladat. Kinek ki a közvetlen fõnöke?
SELECT
    t0.staff_name AS beosztott,
    t1.staff_name AS fonok
FROM
    staff t0
    INNER JOIN staff t1 ON t1.staff_id = t0.manager_id; 



--5. Feladat. Az eddig kezelések során milyen gyógyszereket használtak?
SELECT DISTINCT
    drug
FROM
    treatment
WHERE
    drug IS NOT NULL;

--6. Feladat. Listázd ki a betegek és az orvosok ID-ját, duplikációk nélkül!
select patient_id,consultant
from treatment;

select distinct patient_id,consultant
from treatment;
	   
--7. Feladat.	Ki az, aki nem végzett egyetlen kezelést sem? (id-t elég kiírni)
SELECT
    staff_id
FROM
    staff
MINUS
SELECT
    consultant
FROM
    treatment; 

--8. Feladat.	Ki az, aki fõnöke valakinek, de nem õ az igazgató?
SELECT
    staff_id,
    staff_name
FROM
    staff
MINUS
SELECT
    staff_id,
    staff_name
FROM
    staff
WHERE
    manager_id IS NULL;

SELECT
    staff_name,
    staff_id
FROM
    staff
WHERE
    manager_id IS NULL;

--9. Feladat.	Listázd ki az összes kórházban lévõ ember nevét, és azt, hogy beteg-e, vagy alkalmazott!
SELECT
    staff_name AS name,
    'alkalmazott' AS status
FROM
    staff
UNION
SELECT
    patient_name,
    'beteg'
FROM
    patient; 

--10. Feladat.	Hozz létre egy view-t a következõ lekérdésekhez: melyik beteget ki kezelte és mikor?
CREATE OR REPLACE VIEW feladat_10 AS
    SELECT
        t0.patient_name,
        t2.staff_name,
        t1.t_time
    FROM
        patient t0
        INNER JOIN treatment t1 ON t1.patient_id = t0.patient_id
        INNER JOIN staff t2 ON t2.staff_id = t1.consultant;

COMMIT;
--11. Feladat.	A nézet használatának segítségével válaszold meg, hogy mely betegeket kezelte Dr. Green 2004 októberében.

SELECT
    *
FROM
    feladat_10
WHERE
    staff_name = 'Dr Green'
    AND   t_time > TO_DATE('20041001','yyyymmdd')
    AND   t_time < TO_DATE('20041101','yyyymmdd'); 


--12. Feladat.	Melyik dolgozónak mennyivel több vagy kevesebb a fizetése, mint az átlagos fizetés?
SELECT
    staff_id,
    staff_name,
    salary - (
        SELECT
            AVG(salary)
        FROM
            staff
    )
FROM
    staff;

--13. Feladat.	Melyek azok az orvosok, aki végeztek már legalább egy kezelést?(elég az id)
SELECT DISTINCT
    consultant
FROM
    treatment
INTERSECT
SELECT
    staff_id
FROM
    staff
WHERE
    staff_name LIKE 'Dr%';






SELECT DISTINCT
    t1.staff_name,
    t1.staff_id
FROM
    treatment t0
    INNER JOIN staff t1 ON t0.consultant = t1.staff_id
WHERE
    t1.staff_name LIKE 'Dr%'; 


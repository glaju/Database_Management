set serveroutput on;

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '.,';









--1. Készítsük egy hello world nev? programot, ami egy változó segítségével kiírja azt, hogy hello world! (dbms_output.put_line();)
begin
dbms_output.put_line('Hello World!');
end;
/

-- 1.b azt írja ki amit beadunk neki
begin
dbms_output.put_line('&beirt_dolog');
end;
/

--2. Hello World 10x
declare
i number:=0;
begin
loop
dbms_output.put_line('Hello World!');
i:=i+1;
exit when i=10;
end loop;
end;
/

begin
FOR x IN 1..10 LOOP
  dbms_output.put_line('Hello Világ!');
END LOOP;
end;
/

declare
i number:=0;
begin
WHILE i<10 
LOOP
dbms_output.put_line('Hello Világ!');
i:=i+1;
End Loop;
end;
/

--3. Írassuk ki a páros számok négyzetét 1 és 15 között
begin
FOR x IN 1..7 LOOP
  dbms_output.put_line(power(2*x,2));
END LOOP;
end;
/

--4. Iteráljunk végig a dcdb.components tábláján egy kurzor segítségével és írjuk ki az komponensek id-ját és nevét, csak azokat a komponenseket írjuk ki, ahol a chemical_formula nem 'Not Available'. 

DECLARE
  CURSOR interaction_cursor is select * from dcdb.components where chemical_formula!='Not Available';
BEGIN
  FOR sor in interaction_cursor LOOP
       dbms_output.put_line('ID: ' || sor.dcc_id || ' Név: ' || sor.generic_name);
  END LOOP;
END;
/

-- így is lehet (csak egy elemet ír ki)
DECLARE
  CURSOR interaction_cursor is select * from dcdb.components where chemical_formula!='Not Available';
  sor dcdb.components%rowtype;
BEGIN
  OPEN interaction_cursor;
    FETCH interaction_cursor INTO sor;
       dbms_output.put_line('ID: ' || sor.dcc_id || ' Név: ' || sor.generic_name);
  CLOSE interaction_cursor;
END;
/
--kell egy ciklus ide is
DECLARE
  CURSOR interaction_cursor is select * from dcdb.components where chemical_formula!='Not Available';
  sor dcdb.components%rowtype;
BEGIN
  OPEN interaction_cursor;
  LOOP
    FETCH interaction_cursor INTO sor;
    EXIT WHEN interaction_cursor%NOTFOUND;
       dbms_output.put_line('ID: ' || sor.dcc_id || ' Név: ' || sor.generic_name);
  END LOOP;
  CLOSE interaction_cursor;
END;
/

--5. Hozzunk létre egy függvényt, mely kiszámolja egy r sugarú kör kerületét!
create or replace function kerulet(r in number) -- in (megadja, hogy milyen módban használjuk) - kívülr?l kap értéket, out: a paraméter arra lesz használva, hogy visszaadjon vmit a fv-en kívül
return number
is 
pi CONSTANT REAL := 3.14159;
BEGIN
return 2*r*pi;
End;
/


--6. meghívjuk 
begin
dbms_output.put_line('Az 5 sugarú kör kerülete: ' || kerulet(5));
end;
/

--7. Készítsen egy eljárást, ami egy adott típusú (bemen? paraméter) komponensnek kiirja a kémiai formuláját
create or replace procedure kemiaiformula (tipus in varchar2) is
CURSOR interaction_cursor is 
    select chemical_formula, generic_name 
    from dcdb.components
    where lower(generic_name) like '%'||lower(tipus)||'%'
    and chemical_formula is not null and chemical_formula != 'Not Available';
begin
FOR sor IN interaction_cursor LOOP
    dbms_output.put_line('Név: ' || sor.generic_name ||' Kémiai formula: ' || sor.chemical_formula);
END LOOP;
END;
/
set serveroutput on;
begin
kemiaiformula('Pentazocine');
end;
/

-- így is lehet
create or replace procedure kemiaiformula_2 (tipus in varchar2) is
CURSOR interaction_cursor is 
    select chemical_formula, generic_name 
    from dcdb.components
    where lower(generic_name) like '%'||lower(tipus)||'%';
begin
FOR sor IN interaction_cursor LOOP
  if sor.chemical_formula is not null and sor.chemical_formula != 'Not Available' then
    dbms_output.put_line('Név: ' || sor.generic_name ||' Kémiai formula: ' || sor.chemical_formula);
  end if;
END LOOP;
END;
/

set serveroutput on;
begin
kemiaiformula_2('Pentazocine');
end;
/

---Ugyanez függvényként?
create or replace function kemiaiformula_fgv (tipus in varchar2) 
return varchar2 is
CURSOR interaction_cursor is 
    select chemical_formula, generic_name 
    from dcdb.components
    where lower(generic_name) like '%'||lower(tipus)||'%';
begin
FOR sor IN interaction_cursor LOOP
  if sor.chemical_formula is not null and sor.chemical_formula != 'Not Available' then
    return('Név: ' || sor.generic_name ||' Kémiai formula: ' || sor.chemical_formula);
  end if;
END LOOP;
END;
/

begin
dbms_output.put_line('A függvény eredménye: '||kemiaiformula_fgv('Pentazocine'));
end;
/

select generic_name, kemiaiformula_fgv(generic_name)
from dcdb.components;


--8 Írjunk egy anonim pl/sql szkriptet, amiben egy változóban megadott tábla egy másik változóban megadott paramétere különböz? értékeinek számát kérdezzük le.
SET serveroutput ON
DECLARE
  tablanev   VARCHAR2(30);
  oszlopnev  VARCHAR2(30);
  sqlparancs VARCHAR2(500);
  eredmeny   NUMBER;
BEGIN
  tablanev   := 'dcdb.components';
  oszlopnev  := 'molecular_weight';
  sqlparancs := 'select count(distinct ' || oszlopnev || ') from ' || tablanev;
  EXECUTE immediate sqlparancs INTO eredmeny;
  dbms_output.put_line(eredmeny);
END;
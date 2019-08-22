set serveroutput on;

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '.,';









--1. K�sz�ts�k egy hello world nev? programot, ami egy v�ltoz� seg�ts�g�vel ki�rja azt, hogy hello world! (dbms_output.put_line();)
begin
dbms_output.put_line('Hello World!');
end;
/

-- 1.b azt �rja ki amit beadunk neki
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
  dbms_output.put_line('Hello Vil�g!');
END LOOP;
end;
/

declare
i number:=0;
begin
WHILE i<10 
LOOP
dbms_output.put_line('Hello Vil�g!');
i:=i+1;
End Loop;
end;
/

--3. �rassuk ki a p�ros sz�mok n�gyzet�t 1 �s 15 k�z�tt
begin
FOR x IN 1..7 LOOP
  dbms_output.put_line(power(2*x,2));
END LOOP;
end;
/

--4. Iter�ljunk v�gig a dcdb.components t�bl�j�n egy kurzor seg�ts�g�vel �s �rjuk ki az komponensek id-j�t �s nev�t, csak azokat a komponenseket �rjuk ki, ahol a chemical_formula nem 'Not Available'. 

DECLARE
  CURSOR interaction_cursor is select * from dcdb.components where chemical_formula!='Not Available';
BEGIN
  FOR sor in interaction_cursor LOOP
       dbms_output.put_line('ID: ' || sor.dcc_id || ' N�v: ' || sor.generic_name);
  END LOOP;
END;
/

-- �gy is lehet (csak egy elemet �r ki)
DECLARE
  CURSOR interaction_cursor is select * from dcdb.components where chemical_formula!='Not Available';
  sor dcdb.components%rowtype;
BEGIN
  OPEN interaction_cursor;
    FETCH interaction_cursor INTO sor;
       dbms_output.put_line('ID: ' || sor.dcc_id || ' N�v: ' || sor.generic_name);
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
       dbms_output.put_line('ID: ' || sor.dcc_id || ' N�v: ' || sor.generic_name);
  END LOOP;
  CLOSE interaction_cursor;
END;
/

--5. Hozzunk l�tre egy f�ggv�nyt, mely kisz�molja egy r sugar� k�r ker�let�t!
create or replace function kerulet(r in number) -- in (megadja, hogy milyen m�dban haszn�ljuk) - k�v�lr?l kap �rt�ket, out: a param�ter arra lesz haszn�lva, hogy visszaadjon vmit a fv-en k�v�l
return number
is 
pi CONSTANT REAL := 3.14159;
BEGIN
return 2*r*pi;
End;
/


--6. megh�vjuk 
begin
dbms_output.put_line('Az 5 sugar� k�r ker�lete: ' || kerulet(5));
end;
/

--7. K�sz�tsen egy elj�r�st, ami egy adott t�pus� (bemen? param�ter) komponensnek kiirja a k�miai formul�j�t
create or replace procedure kemiaiformula (tipus in varchar2) is
CURSOR interaction_cursor is 
    select chemical_formula, generic_name 
    from dcdb.components
    where lower(generic_name) like '%'||lower(tipus)||'%'
    and chemical_formula is not null and chemical_formula != 'Not Available';
begin
FOR sor IN interaction_cursor LOOP
    dbms_output.put_line('N�v: ' || sor.generic_name ||' K�miai formula: ' || sor.chemical_formula);
END LOOP;
END;
/
set serveroutput on;
begin
kemiaiformula('Pentazocine');
end;
/

-- �gy is lehet
create or replace procedure kemiaiformula_2 (tipus in varchar2) is
CURSOR interaction_cursor is 
    select chemical_formula, generic_name 
    from dcdb.components
    where lower(generic_name) like '%'||lower(tipus)||'%';
begin
FOR sor IN interaction_cursor LOOP
  if sor.chemical_formula is not null and sor.chemical_formula != 'Not Available' then
    dbms_output.put_line('N�v: ' || sor.generic_name ||' K�miai formula: ' || sor.chemical_formula);
  end if;
END LOOP;
END;
/

set serveroutput on;
begin
kemiaiformula_2('Pentazocine');
end;
/

---Ugyanez f�ggv�nyk�nt?
create or replace function kemiaiformula_fgv (tipus in varchar2) 
return varchar2 is
CURSOR interaction_cursor is 
    select chemical_formula, generic_name 
    from dcdb.components
    where lower(generic_name) like '%'||lower(tipus)||'%';
begin
FOR sor IN interaction_cursor LOOP
  if sor.chemical_formula is not null and sor.chemical_formula != 'Not Available' then
    return('N�v: ' || sor.generic_name ||' K�miai formula: ' || sor.chemical_formula);
  end if;
END LOOP;
END;
/

begin
dbms_output.put_line('A f�ggv�ny eredm�nye: '||kemiaiformula_fgv('Pentazocine'));
end;
/

select generic_name, kemiaiformula_fgv(generic_name)
from dcdb.components;


--8 �rjunk egy anonim pl/sql szkriptet, amiben egy v�ltoz�ban megadott t�bla egy m�sik v�ltoz�ban megadott param�tere k�l�nb�z? �rt�keinek sz�m�t k�rdezz�k le.
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
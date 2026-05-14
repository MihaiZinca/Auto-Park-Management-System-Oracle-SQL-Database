SET SERVEROUTPUT ON
--B

--1.Sa se creeze o procedura care utilizeaza SQL Dinamic (EXECUTE IMMEDIATE) 
--pentru a genera o tabela de arhiva numita ARHIVA_MASINI_SCUMPE 
--care sa stocheze coloanele id_masina, pret_vechi si data_arhiva.

BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE ARHIVA_MASINI_SCUMPE (id_masina NUMBER, pret_vechi NUMBER, data_arhiva DATE)';
    DBMS_OUTPUT.PUT_LINE('Tabela ARHIVA_MASINI_SCUMPE a fost creata.');
EXCEPTION WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('Eroare: Tabela exista deja sau drepturi insuficiente.');
END;
/

--2.Sa se insereze in tabela de arhiva toate vehiculele care au pret_lista mai mare decat media tuturor masinilor
--utilizand o subcerere cu functia de grup AVG pentru a popula 
--coloanele id_masina, pret_vechi si data_arhiva.

BEGIN
    INSERT INTO ARHIVA_MASINI_SCUMPE (id_masina, pret_vechi, data_arhiva)
    SELECT id_masina, pret_lista, SYSDATE 
    FROM VEHICUL 
    WHERE pret_lista > (SELECT AVG(pret_lista) FROM VEHICUL);
    DBMS_OUTPUT.PUT_LINE('Au fost arhivate ' || SQL%ROWCOUNT || ' masini.');
END;
/

--3.Sa se adauge coloana status_itp in tabela Vehicul cu o valoare default de tip string
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE Vehicul ADD status_itp VARCHAR2(20) DEFAULT ''NECUNOSCT''';
    DBMS_OUTPUT.PUT_LINE('Coloana status_import a fost adaugata.');
END;
/

--4.Sa se actualizeze coloana stare_vehicul cu textul 'NECESITA ATENTIE' 
--pentru toate masinile din tabela Vehicul care apar in Inregistrare_Mentenanta 
--cu un cost_mentenanta mai mare de 100 EUR.

BEGIN
    UPDATE Vehicul 
    SET stare_vehicul = 'NECESITA ATENTIE'
    WHERE id_masina IN (SELECT id_masina FROM Inregistrare_Mentenanta WHERE cost_mentenanta > 100);
    DBMS_OUTPUT.PUT_LINE('Masini actualizate: ' || SQL%ROWCOUNT); 
END;
/

--5.Sa se elimine din tabela Proprietari toti clientii care nu au nicio 
--inregistrare asociata (nu au cumparat/vandut nicio masina)
--in tabela Istoric_Proprietari.

BEGIN
    DELETE 
    FROM Proprietari 
    WHERE id_proprietar NOT IN (SELECT id_proprietar FROM Istoric_Proprietari);
    DBMS_OUTPUT.PUT_LINE('Proprietari stersi: ' || SQL%ROWCOUNT);
END;
/

--6.Sa se utilizeze SQL dinamic pentru a modifica lungimea maxima a coloanei tara din tabela Proprietari 
--la 50 de caractere.

BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE Proprietari MODIFY tara VARCHAR2(50)';
    DBMS_OUTPUT.PUT_LINE('Lungime coloana tara a fost modificata.');
END;
/

--C
--1.Sa se parcurga masinile cu ID intre 1001 si 1005 si sa se afiseze o categorie bazata pe pret_lista 
--folosind IF-ELSIF (Premium > 30k, Standard 15-30k, Buget < 15k).

DECLARE
    V_P Vehicul.pret_lista%TYPE;
BEGIN
    FOR i IN 1001..1005 LOOP
        SELECT pret_lista INTO V_P 
        FROM Vehicul 
        WHERE id_masina = i;
        
        IF V_P > 30000 THEN 
            DBMS_OUTPUT.PUT_LINE(i || ': Masina Premium');
        ELSIF V_P > 15000 
            THEN DBMS_OUTPUT.PUT_LINE(i || ': Masina Standard');
        ELSE 
            DBMS_OUTPUT.PUT_LINE(i || ': Masina Buget');
        END IF;
    END LOOP;
END;
/


--2.Sa se afiseze un mesaj de confort bazat pe tipul de transmisie (Automata/Manuala) din tabela Modele_Vehicule 
--pentru masina cu ID 1001, utilizand structura CASE.

DECLARE
    V_TR Modele_Vehicule.transmisie%TYPE;
BEGIN
    SELECT m.transmisie INTO V_TR 
    FROM Modele_Vehicule m 
    JOIN Vehicul v ON v.id_model = m.id_model 
    WHERE v.id_masina = 1001;
    CASE V_TR
        WHEN 'Automata' THEN 
            DBMS_OUTPUT.PUT_LINE('Nivel de confort ridicat');
        WHEN 'Manuala' THEN 
            DBMS_OUTPUT.PUT_LINE('Control manual complet');
        ELSE DBMS_OUTPUT.PUT_LINE('Tip transmisie nespecificat');
    END CASE;
END;
/

--3.Sa se simuleze cresterea treptata a valorii pret_buy_back cu 1000 EUR 
--intr-o structura WHILE pana cand aceasta atinge pragul de 20.000 EUR.
DECLARE
    V_P NUMBER := 15000;
BEGIN
    WHILE V_P < 20000 LOOP
        V_P := V_P + 1000;
        DBMS_OUTPUT.PUT_LINE('Simulare crestere pret buy-back: ' || V_P);
    END LOOP;
END;
/

--4.Sa se listeze toate inregistrarile din coloana denumire_model 
--din tabela Modele_Vehicule folosind o structura repetitiva FOR cursor implicit.

BEGIN
    FOR r IN (SELECT denumire_model FROM Modele_Vehicule) LOOP
        DBMS_OUTPUT.PUT_LINE('Model disponibil: ' || r.denumire_model);
    END LOOP;
END;
/

--5.Sa se gaseasca prima masina cu combustibil setat pe 'Diesel' folosind un LOOP simplu 
--si comanda EXIT WHEN pentru a opri executia imediat dupa gasire.

DECLARE
    V_ID NUMBER;
    CURSOR c_v IS 
        SELECT id_masina 
        FROM Vehicul 
        WHERE combustibil = 'Diesel';
BEGIN
    OPEN c_v;
    LOOP
        FETCH c_v INTO V_ID;
        EXIT WHEN c_v%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Prima masina Diesel gasita are ID: ' || V_ID);
        EXIT; -- Oprim dupa prima gasire
    END LOOP;
    CLOSE c_v;
END;
/

--6.Sa se realizeze o numaratoare inversa de la 3 la 1 
--pentru un proces de mentenanta folosind structura FOR cu optiunea REVERSE.
BEGIN
    FOR i IN REVERSE 1..3 LOOP
        DBMS_OUTPUT.PUT_LINE('Pregatire sistem in pasul: ' || i);
    END LOOP;
END;
/

--D
--1.Sa se stocheze preturile din coloana pret_lista intr-o colectie de tip Index By Table 
--indexata dupa ID-ul masinii si sa se afiseze un pret stocat.
DECLARE
    TYPE T_P IS TABLE OF Vehicul.pret_lista%TYPE INDEX BY PLS_INTEGER;
    V_LISTA T_P;
BEGIN
    V_LISTA(1001) := 18000;
    DBMS_OUTPUT.PUT_LINE('Pret stocat in index-by: ' || V_LISTA(1001));
END;
/

--2.Sa se utilizeze un Nested Table 
--pentru a salva denumirile din coloana culoare si sa se afiseze numarul de elemente folosind metoda COUNT.
DECLARE
    TYPE T_C IS TABLE OF VARCHAR2(20);
    V_TAB T_C := T_C('Negru', 'Alb');
BEGIN
    V_TAB.EXTEND;
    V_TAB(3) := 'Gri';
    DBMS_OUTPUT.PUT_LINE('Numar culori in colectie: ' || V_TAB.COUNT);
END;
/


--3.Sa se salveze doua valori din coloana serie_sasiu intr-un Varray de dimensiune fixa 
--si sa se verifice capacitatea maxima
DECLARE
    TYPE T_V IS VARRAY(2) OF VARCHAR2(17);
    V_COLECTIE T_V := T_V('WBA1234567890ABC1', 'WBA9876543210DEF2');
BEGIN
    DBMS_OUTPUT.PUT_LINE('Limita maxima a Varray-ului este: ' || V_COLECTIE.LIMIT);
END;
/

--4.Sa se parcurga o colectie Index By Table (stocand nume de producatori) 
--folosind metoda NEXT pentru a trece de la un element la altul.
DECLARE
    TYPE T_L IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    V_L T_L;
    V_I PLS_INTEGER;
BEGIN
    V_L(10) := 'BMW'; 
    V_L(20) := 'AUDI';
    V_I := V_L.FIRST;
    WHILE V_I IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('Producator: ' || V_L(V_I));
        V_I := V_L.NEXT(V_I);
    END LOOP;
END;
/

--5.Sa se creeze un Nested Table cu preturi si sa se elimine elementul de la indexul 2 folosind metoda DELETE
DECLARE
    TYPE T_N IS TABLE OF NUMBER;
    V_N T_N := T_N(15000, 20000, 25000);
BEGIN
    V_N.DELETE(2);
    DBMS_OUTPUT.PUT_LINE('Elemente ramase dupa stergere: ' || V_N.COUNT);
END;
/

--6.Sa se preia toate masinile care au combustibil setat pe 'Benzina' 
--intr-o colectie de record-uri folosind comanda BULK COLLECT.
DECLARE
    TYPE T_B IS TABLE OF Vehicul%ROWTYPE;
    V_V T_B;
BEGIN
    SELECT * BULK COLLECT INTO V_V 
    FROM Vehicul 
    WHERE combustibil = 'Benzina';
    DBMS_OUTPUT.PUT_LINE('Inregistrari benzina incarcate: ' || V_V.COUNT);
END;
/


--E
--1.Sa se gestioneze exceptia NO_DATA_FOUND 
--cand se selecteaza nume_proprietar pentru un ID care nu exista in tabela Proprietari.
DECLARE
    V_N Proprietari.nume_proprietar%TYPE;
BEGIN
    SELECT nume_proprietar INTO V_N 
    FROM Proprietari 
    WHERE id_proprietar = 999;
    
EXCEPTION WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('Eroare: Proprietarul cautat nu exista.');
END;
/

--2.Sa se gestioneze exceptia TOO_MANY_ROWS cand se incearca 
--salvarea tuturor ID-urilor de modele intr-o singura variabila numerica.
DECLARE
    V_ID NUMBER;
BEGIN
    SELECT id_model INTO V_ID 
    FROM Modele_Vehicule;
    
EXCEPTION WHEN TOO_MANY_ROWS THEN 
    DBMS_OUTPUT.PUT_LINE('Eroare: Prea multe modele gasite.');
END;
/

--3.Sa se gestioneze exceptia ZERO_DIVIDE intr-un calcul de raport intre pret si kilometraj.
DECLARE
    V_R NUMBER;
BEGIN
    V_R := 100 / 0;
EXCEPTION WHEN ZERO_DIVIDE THEN 
    DBMS_OUTPUT.PUT_LINE('Eroare: Impartirea la zero nu este permisa.');
END;
/

--4.: Sa se defineasca si sa se ridice exceptia E_KM_INVALID 
--daca se incearca procesarea unei masini cu kilometraj (kilometri) negativ.
DECLARE
    E_KM_INVALID EXCEPTION;
    V_K NUMBER := -100;
BEGIN
    IF V_K < 0 THEN 
        RAISE E_KM_INVALID;
    END IF;
EXCEPTION WHEN E_KM_INVALID THEN 
    DBMS_OUTPUT.PUT_LINE('Eroare: Kilometrajul nu poate fi o valoare negativa.');
END;
/

--5.Sa se defineasca exceptia E_PRET_MIC daca pretul unei masini este setat sub 500 EUR intr-un bloc de control.
DECLARE
    E_PRET_MIC EXCEPTION;
    V_P NUMBER := 200;
BEGIN
    IF V_P < 500 THEN 
     RAISE E_PRET_MIC; 
    END IF;
EXCEPTION WHEN E_PRET_MIC THEN 
    DBMS_OUTPUT.PUT_LINE('Eroare: Pretul setat este sub pragul minim acceptat.');
END;
/

--6.Sa se utilizeze functia RAISE_APPLICATION_ERROR pentru 
--a opri executia cu un mesaj personalizat de eroare de sistem.
BEGIN
    IF (1=1) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Eroare personalizata: Actiunea a fost blocata de administrator.');
    END IF;
END;
/

--7.Sa se defineasca o exceptie non-predefinita care sa capteze eroarea specifica(-2292) 
--Sa se incerce stergerea unui producator care are modele asociate 
--si sa se afiseze un mesaj personalizat, in loc de eroarea standard de sistem.

DECLARE
    E_ARE_MODELE_ASOCIATE EXCEPTION;
    PRAGMA EXCEPTION_INIT(E_ARE_MODELE_ASOCIATE, -2292);
    V_NUME_PROD Producatori.nume_producator%TYPE;
BEGIN
    SELECT nume_producator INTO V_NUME_PROD 
    FROM Producatori 
    WHERE id_producator = 1;
    
    -- aici da err
    DELETE FROM Producatori WHERE id_producator = 1;
    
EXCEPTION 
    WHEN E_ARE_MODELE_ASOCIATE THEN
        DBMS_OUTPUT.PUT_LINE('Eroare: Nu puteti sterge producatorul ' || V_NUME_PROD ||' deoarece are modele inregistrate in stoc!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Alt tip de eroare: ' || SQLERRM);
END;
/

--8.Sa se defineasca o exceptie explicita E_MASINA_PERICULOASA. Sa se verifice daca o masina ce urmeaza a fi cumparata 
--prin Buy-Back are in Inregistrare_Mentenanta vreo interventie la sistemul de frane 
--(id_tip_mentenanta = 2) cu un cost mai mare de 1000 EUR. 
--Daca da, tranzactia se blocheaza.

DECLARE
    E_MASINA_PERICULOASA EXCEPTION;
    V_ID_M NUMBER := 1014; -- Exemplu masina
    V_PROBLEME NUMBER;
BEGIN
   
    SELECT COUNT(*) INTO V_PROBLEME
    FROM Inregistrare_Mentenanta
    WHERE id_masina = V_ID_M AND id_tip_mentenanta = 2  AND cost_mentenanta > 1000;

    IF V_PROBLEME > 0 THEN
        RAISE E_MASINA_PERICULOASA;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Masina cu ID ' || V_ID_M || ' a trecut verificarea tehnica.');
    END IF;

EXCEPTION 
    WHEN E_MASINA_PERICULOASA THEN
        RAISE_APPLICATION_ERROR(-20005, 'TRANZACTIE REFUZATA!');
END;
/

--9.Sa se proceseze o vanzare si sa se compare pretul din Vehicul cu pretul propus in Istoric_Proprietari. 
--Sa se ridice o exceptie daca pretul de vanzare este mai mic decat pret_buy_back (pretul de achizitie al parcului).
DECLARE
    E_PIERDERE_FINANCIARA EXCEPTION;
    V_ID_M Vehicul.id_masina%TYPE := 1002;
    V_PRET_V_PROPUS NUMBER := 35000; 
    V_PRET_ACHIZITIE Vehicul.pret_buy_back%TYPE;
BEGIN
    SELECT pret_buy_back INTO V_PRET_ACHIZITIE 
    FROM Vehicul 
    WHERE id_masina = V_ID_M;

    IF V_PRET_V_PROPUS < V_PRET_ACHIZITIE THEN
        RAISE E_PIERDERE_FINANCIARA;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Vanzarea poate fi procesata.Profit estimat: ' || (V_PRET_V_PROPUS - V_PRET_ACHIZITIE));

EXCEPTION 
    WHEN E_PIERDERE_FINANCIARA THEN
        DBMS_OUTPUT.PUT_LINE('ALERTA ECONOMICA:'||V_PRET_V_PROPUS);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Masina nu exista in inventar.');
END;
/

--F
--1.Sa se afiseze pentru un anumit producator (transmis ca parametru) toate modelele sale si numarul de vehicule 
--din stoc pentru fiecare model, folosind un cursor explicit.(parametrizat cu join)

DECLARE
    CURSOR c_stoc_producator(p_nume VARCHAR2) IS
        SELECT m.denumire_model, 
        COUNT(v.id_masina) as nr_masini
        FROM Producatori p
        JOIN Modele_Vehicule m ON p.id_producator = m.id_producator
        LEFT JOIN Vehicul v ON m.id_model = v.id_model
        WHERE p.nume_producator = p_nume
        GROUP BY m.denumire_model;
    
    V_MODEL VARCHAR2(100);
    V_NR NUMBER;
BEGIN
    OPEN c_stoc_producator('BMW');
    LOOP
        FETCH c_stoc_producator INTO V_MODEL, V_NR;
        EXIT WHEN c_stoc_producator%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Model:'||V_MODEL||'Unitati in stoc: '||V_NR);
    END LOOP;
    CLOSE c_stoc_producator;
END;
/

--2.Sa se parcurga toti producatorii si, pentru fiecare, sa se afiseze totalul cheltuielilor 
--de mentenanta realizate pentru masinile produse de acestia, folosind un cursor imbricat.
DECLARE
    CURSOR c_prod IS 
        SELECT id_producator, nume_producator 
        FROM Producatori;
    CURSOR c_mentenanta(p_id_p NUMBER) IS
        SELECT SUM(im.cost_mentenanta) as total_cost
        FROM Modele_Vehicule m
        JOIN Vehicul v ON m.id_model = v.id_model
        JOIN Inregistrare_Mentenanta im ON v.id_masina = im.id_masina
        WHERE m.id_producator = p_id_p;
    
    V_TOTAL NUMBER;
BEGIN
    FOR r_p IN c_prod LOOP
        OPEN c_mentenanta(r_p.id_producator);
        FETCH c_mentenanta INTO V_TOTAL;
        DBMS_OUTPUT.PUT_LINE('Producator:' || r_p.nume_producator ||'Cheltuieli service: '|| NVL(V_TOTAL, 0));
        CLOSE c_mentenanta;
    END LOOP;
END;
/

--3.Sa se parcurga masinile vandute (din Istoric_Proprietari) si sa se afiseze ID-ul masinii si profitul.
--La finalul executiei, sa se afiseze numarul total de randuri procesate folosind atributul %ROWCOUNT.
DECLARE
    CURSOR c_profit IS 
        SELECT id_masina, 
        (pret_vanzare - pret_cumparare) as profit 
        FROM Istoric_Proprietari 
        WHERE data_vanzarii IS NOT NULL;
    P c_profit%ROWTYPE;
BEGIN
    IF NOT c_profit%ISOPEN THEN
        OPEN c_profit;
    END IF;
    
    LOOP
        FETCH c_profit INTO P;
        EXIT WHEN c_profit%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Masina ID: ' || P.id_masina || ' | Profit: ' || P.profit);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Total tranzactii procesate:'|| c_profit%ROWCOUNT);
    CLOSE c_profit;
END;
/

--4.Sa se actualizeze pretul de lista cu o reducere de 5% pentru toate masinile care au kilometrajul peste 
--media kilometrajului din stoc.Sa se raporteze numarul de modificari.

BEGIN
    UPDATE Vehicul 
    SET pret_lista = pret_lista * 0.95 
    WHERE kilometri > (SELECT AVG(kilometri) FROM Vehicul);
    
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Au fost aplicate reduceri pentru ' || SQL%ROWCOUNT || ' vehicule uzate.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nicio masina nu indeplineste criteriul de kilometraj.');
    END IF;
END;
/

--5.Sa se parcurga masinile de o anumita culoare si sa se afiseze un status bazat pe anul fabricatiei:
--'GARANTIE' (daca an > 2019) sau 'POST-GARANTIE' folosind un cursor cu parametru.

DECLARE
    CURSOR c_status(p_culoare VARCHAR2) IS 
        SELECT id_masina, an_fabricatie 
        FROM Vehicul 
        WHERE culoare = p_culoare;
    V_STATUS VARCHAR2(20);
BEGIN
    FOR r IN c_status('Negru') LOOP
        V_STATUS := CASE 
            WHEN r.an_fabricatie > 2019 THEN 'GARANTIE'
            ELSE 'POST-GARANTIE'
        END;
        DBMS_OUTPUT.PUT_LINE('ID:'|| r.id_masina || 'Status: ' || V_STATUS);
    END LOOP;
END;
/

--6.Sa se parcurga inregistrarile de mentenanta care au costul 150 si 
--sa se actualizeze la un cost de 200 EUR.

DECLARE
    CURSOR c_fix_cost IS 
        SELECT cost_mentenanta 
        FROM Inregistrare_Mentenanta 
        WHERE cost_mentenanta = 150
        FOR UPDATE;
BEGIN
    FOR r IN c_fix_cost LOOP
        UPDATE Inregistrare_Mentenanta 
        SET cost_mentenanta = 200 
        WHERE CURRENT OF c_fix_cost;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Toate costurile de 150 au fost actualizate');
END;
/

--7.Sa se parcurga toate vehiculele ca sa se afiseze ID-ul si raportul dintre pret_lista si 
--an_fabricatie (ca indicator de devalorizare), doar pentru masinile care au acest raport mai mare de 10.
DECLARE
    TYPE T_REC IS RECORD (
        id_m Vehicul.id_masina%TYPE,
        raport NUMBER);
        
    CURSOR c_devalorizare IS 
        SELECT id_masina, 
        (pret_lista / (2026 - an_fabricatie + 1)) as raport
        FROM Vehicul;
    V_DATE T_REC;
BEGIN
    OPEN c_devalorizare;
    LOOP
        FETCH c_devalorizare INTO V_DATE;
        EXIT WHEN c_devalorizare%NOTFOUND;
        IF V_DATE.raport > 10 THEN
            DBMS_OUTPUT.PUT_LINE('Masina ID: '|| V_DATE.id_m || '  Indice valoare: ' || ROUND(V_DATE.raport, 2));
        END IF;
    END LOOP;
    CLOSE c_devalorizare;
END;
/

--G
--1.Sa se creeze o functie f_valoare_stoc_model care primeste ID-ul unui model 
--si returneaza valoarea totala a vehiculelor de acel tip aflate in stoc.
CREATE OR REPLACE FUNCTION f_valoare_stoc_model(p_id_model NUMBER) RETURN NUMBER IS
    v_total NUMBER := 0;
BEGIN
    SELECT SUM(pret_lista) INTO v_total 
    FROM Vehicul 
    WHERE id_model = p_id_model;
    RETURN NVL(v_total, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 0;
    WHEN OTHERS THEN RETURN -1;
END;
/

--2.Sa se creeze o functie f_status_uzura care primeste ID-ul unei masini si returneaza un text
--('NOU', 'UZURA MEDIE', 'UZURA MARE') in functie de kilometri.
CREATE OR REPLACE FUNCTION f_status_uzura(p_id_masina NUMBER) RETURN VARCHAR2 IS
    v_km NUMBER;
BEGIN
    SELECT kilometri INTO v_km 
    FROM Vehicul
    WHERE id_masina = p_id_masina;
    IF v_km < 10000 THEN 
        RETURN 'NOU';
    ELSIF v_km BETWEEN 10000 AND 100000 THEN 
        RETURN 'UZURA MEDIE';
    ELSE RETURN 'UZURA MARE';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 'INEXISTENT';
END;
/

--3.Sa se creeze o functie f_profit_estimat care calculeaza diferenta dintre pret_vanzare si 
--pret_cumparare din Istoric_Proprietari pentru o masina vanduta.

CREATE OR REPLACE FUNCTION f_profit_estimat(p_id_masina NUMBER) RETURN NUMBER IS
    v_profit NUMBER;
BEGIN
    SELECT (pret_vanzare - pret_cumparare) INTO v_profit 
    FROM Istoric_Proprietari 
    WHERE id_masina = p_id_masina AND data_vanzarii IS NOT NULL;
    RETURN NVL(v_profit, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 0;
END;
/

--4.Sa se creeze functia f_cheltuieli_service 
--care insumeaza toate costurile din Inregistrare_Mentenanta pentru un id_masina.

CREATE OR REPLACE FUNCTION f_cheltuieli_service(p_id_masina NUMBER) RETURN NUMBER IS
    v_suma NUMBER;
BEGIN
    SELECT SUM(cost_mentenanta) INTO v_suma 
    FROM Inregistrare_Mentenanta 
    WHERE id_masina = p_id_masina;
    RETURN NVL(v_suma, 0);
END;
/
--5.Sa se creeze functia f_taxa_vama care calculeaza 10% din pret_lista pentru o masina specifica.
CREATE OR REPLACE FUNCTION f_taxa_vama(p_id_masina NUMBER) RETURN NUMBER IS
    v_pret NUMBER;
BEGIN
    SELECT pret_lista INTO v_pret 
    FROM Vehicul 
    WHERE id_masina = p_id_masina;
    RETURN v_pret * 0.10;
END;
/
--6.Sa se creeze o procedura p_aplica_discount care reduce pret_lista cu un 
--anumit procent pentru toate masinile unui anumit producator.
CREATE OR REPLACE PROCEDURE p_aplica_discount(p_nume_prod VARCHAR2, p_procent NUMBER) IS
BEGIN
    UPDATE Vehicul 
    SET pret_lista = pret_lista * (1 - p_procent/100)
    WHERE id_model IN (
        SELECT m.id_model 
        FROM Modele_Vehicule m 
        JOIN Producatori p ON m.id_producator = p.id_producator 
        WHERE p.nume_producator = p_nume_prod
    );
    DBMS_OUTPUT.PUT_LINE('Discount aplicat pentru marca: ' || p_nume_prod);
END;
/

--7.Sa se creeze procedura p_actualizare_culoare 
--care modifica campul culoare in tabela Vehicul pentru un ID dat.

CREATE OR REPLACE PROCEDURE p_actualizare_culoare(p_id_m NUMBER, p_culoare_noua VARCHAR2) IS
BEGIN
    UPDATE Vehicul 
    SET culoare = p_culoare_noua 
    WHERE id_masina = p_id_m;
    DBMS_OUTPUT.PUT_LINE('Culoare actualizata pentru ID: ' || p_id_m);
END;
/

--8.Sa se creeze procedura p_majorare_pret_id care 
--creste pret_lista cu o valoare fixa (adaos) pentru o masina.

CREATE OR REPLACE PROCEDURE p_majorare_pret_id(p_id_m NUMBER, p_adaos NUMBER) IS
BEGIN
    UPDATE Vehicul 
    SET pret_lista = pret_lista + p_adaos 
    WHERE id_masina = p_id_m;
    DBMS_OUTPUT.PUT_LINE('Pret majorat cu succes.');
END;
/

CREATE OR REPLACE PACKAGE PK_GESTIUNE_AUTO IS

    FUNCTION f_valoare_stoc_model(p_id_model NUMBER) RETURN NUMBER;
    FUNCTION f_status_uzura(p_id_masina NUMBER) RETURN VARCHAR2;
    FUNCTION f_profit_estimat(p_id_masina NUMBER) RETURN NUMBER;
    FUNCTION f_cheltuieli_service(p_id_masina NUMBER) RETURN NUMBER;
    FUNCTION f_taxa_vama(p_id_masina NUMBER) RETURN NUMBER;
    
    
    PROCEDURE p_aplica_discount(p_nume_prod VARCHAR2, p_procent NUMBER);
    PROCEDURE p_actualizare_culoare(p_id_m NUMBER, p_culoare_noua VARCHAR2);
    PROCEDURE p_majorare_pret_id(p_id_m NUMBER, p_adaos NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY PK_GESTIUNE_AUTO IS

    FUNCTION f_valoare_stoc_model(p_id_model NUMBER) RETURN NUMBER IS
        v_total NUMBER := 0;
    BEGIN
        SELECT SUM(pret_lista) INTO v_total FROM Vehicul 
        WHERE id_model = p_id_model;
        RETURN NVL(v_total, 0);
    END;

    FUNCTION f_status_uzura(p_id_masina NUMBER) RETURN VARCHAR2 IS
        v_km NUMBER;
    BEGIN
        SELECT kilometri INTO v_km FROM Vehicul 
        WHERE id_masina = p_id_masina;
        IF v_km < 10000 THEN 
            RETURN 'NOU';
        ELSIF v_km BETWEEN 10000 AND 100000 THEN 
            RETURN 'UZURA MEDIE';
        ELSE RETURN 'UZURA MARE'; 
        END IF;
    END;

    FUNCTION f_profit_estimat(p_id_masina NUMBER) RETURN NUMBER IS
        v_profit NUMBER;
    BEGIN
        SELECT (pret_vanzare - pret_cumparare) INTO v_profit 
        FROM Istoric_Proprietari 
        WHERE id_masina = p_id_masina AND data_vanzarii IS NOT NULL;
        RETURN NVL(v_profit, 0);
    END;

    FUNCTION f_cheltuieli_service(p_id_masina NUMBER) RETURN NUMBER IS
        v_suma NUMBER;
    BEGIN
        SELECT SUM(cost_mentenanta) INTO v_suma 
        FROM Inregistrare_Mentenanta 
        WHERE id_masina = p_id_masina;
        RETURN NVL(v_suma, 0);
    END;

    FUNCTION f_taxa_vama(p_id_masina NUMBER) RETURN NUMBER IS
        v_pret NUMBER;
    BEGIN
        SELECT pret_lista INTO v_pret 
        FROM Vehicul 
        WHERE id_masina = p_id_masina;
        RETURN v_pret * 0.10;
    END;

    PROCEDURE p_aplica_discount(p_nume_prod VARCHAR2, p_procent NUMBER) IS
    BEGIN
        UPDATE Vehicul 
        SET pret_lista = pret_lista * (1 - p_procent/100)
        WHERE id_model IN (
            SELECT m.id_model 
            FROM Modele_Vehicule m 
            JOIN Producatori p ON m.id_producator = p.id_producator 
            WHERE p.nume_producator = p_nume_prod
        );
        DBMS_OUTPUT.PUT_LINE('Discount aplicat pentru marca: ' || p_nume_prod);
    END;

    PROCEDURE p_actualizare_culoare(p_id_m NUMBER, p_culoare_noua VARCHAR2) IS
    BEGIN
        UPDATE Vehicul 
        SET culoare = p_culoare_noua 
        WHERE id_masina = p_id_m;
        DBMS_OUTPUT.PUT_LINE('Culoare actualizata pentru ID: ' || p_id_m);
    END;

    PROCEDURE p_majorare_pret_id(p_id_m NUMBER, p_adaos NUMBER) IS
    BEGIN
        UPDATE Vehicul 
        SET pret_lista = pret_lista + p_adaos 
        WHERE id_masina = p_id_m;
        DBMS_OUTPUT.PUT_LINE('Pret majorat cu succes pentru ID: ' || p_id_m);
    END;

END;
/

BEGIN
    --Testare procedura din pachet
    PK_GESTIUNE_AUTO.p_actualizare_culoare(1001, 'Negru Perlat');
    
    -- Testare functii
    DBMS_OUTPUT.PUT_LINE('Status uzura: ' || PK_GESTIUNE_AUTO.f_status_uzura(1001));
    DBMS_OUTPUT.PUT_LINE('Profit estimat: ' || PK_GESTIUNE_AUTO.f_profit_estimat(1001));
    DBMS_OUTPUT.PUT_LINE('Taxa vama: ' || PK_GESTIUNE_AUTO.f_taxa_vama(1001));
    
    DBMS_OUTPUT.PUT_LINE('Rularea pachetului a fost realizata de:Zinca Mihai Cristian');
END;
/

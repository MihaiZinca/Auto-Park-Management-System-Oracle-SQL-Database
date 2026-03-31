
CREATE TABLE Producatori 
(
    id_producator NUMBER(5) CONSTRAINT pk_producatori PRIMARY KEY,
    nume_producator VARCHAR2(50) NOT NULL CONSTRAINT uq_nume_prod UNIQUE
);


CREATE TABLE Modele_Vehicule 
(
    id_model NUMBER(5) CONSTRAINT pk_modele PRIMARY KEY,
    id_producator NUMBER(5),
    denumire_model VARCHAR2(50) NOT NULL,
    capacitate_cilindrica NUMBER(4),
    transmisie VARCHAR2(20) CONSTRAINT ck_transmisie CHECK (transmisie IN ('Manuala', 'Automata')),
    CONSTRAINT fk_model_prod FOREIGN KEY (id_producator) REFERENCES Producatori(id_producator)
);


CREATE TABLE Vehicul 
(
    id_masina NUMBER(5) CONSTRAINT pk_vehicul PRIMARY KEY,
    id_model NUMBER(5),
    an_fabricatie NUMBER(4),
    kilometri NUMBER(10) DEFAULT 0 CONSTRAINT ck_km CHECK (kilometri >= 0),
    combustibil VARCHAR2(20) CONSTRAINT ck_combustibil CHECK(combustibil IN ('Diesel','Benzina','Hibrid','Electric')),
    serie_sasiu VARCHAR2(17) CONSTRAINT uq_sasiu UNIQUE,
    norma_poluare VARCHAR2(10),
    culoare VARCHAR2(20),
    pret_lista NUMBER(10, 2) CONSTRAINT ck_pret_lista CHECK (pret_lista > 0), 
    pret_buy_back NUMBER(10, 2),
    stare_vehicul VARCHAR2(20),
    CONSTRAINT fk_vehicul_model FOREIGN KEY (id_model) REFERENCES Modele_Vehicule(id_model)
);


CREATE TABLE Proprietari 
(
    id_proprietar NUMBER(5) CONSTRAINT pk_proprietari PRIMARY KEY,
    nume_proprietar VARCHAR2(50) NOT NULL,
    tara VARCHAR2(30)
);


CREATE TABLE Istoric_Proprietari 
(
    id_proprietar_masina NUMBER(5) CONSTRAINT pk_istoric PRIMARY KEY,
    id_masina NUMBER(5),
    id_proprietar NUMBER(5),
    numar_inmatriculare VARCHAR2(20),
    tara_inmatriculare VARCHAR2(30),
    data_cumpararii DATE,
    pret_cumparare NUMBER(10, 2),
    data_vanzarii DATE,
    pret_vanzare NUMBER(10, 2),
    CONSTRAINT fk_ist_masina FOREIGN KEY (id_masina) REFERENCES Vehicul(id_masina),
    CONSTRAINT fk_ist_prop FOREIGN KEY (id_proprietar) REFERENCES Proprietari(id_proprietar)
);


CREATE TABLE Mentenanta 
(
    id_tip_mentenanta NUMBER(5) CONSTRAINT pk_mentenanta PRIMARY KEY,
    denumire_mentenanta VARCHAR2(100) NOT NULL
);


CREATE TABLE Inregistrare_Mentenanta 
(
    id_mentenanta NUMBER(5) CONSTRAINT pk_inreg_ment PRIMARY KEY,
    id_masina NUMBER(5),
    id_tip_mentenanta NUMBER(5),
    data_mentenanta DATE DEFAULT SYSDATE,
    data_expirare_itp DATE,
    descriere_mentenanta VARCHAR2(200),
    cost_mentenanta NUMBER(10, 2) CONSTRAINT ck_cost_ment CHECK (cost_mentenanta >= 0), 
    CONSTRAINT fk_inreg_masina FOREIGN KEY (id_masina) REFERENCES Vehicul(id_masina),
    CONSTRAINT fk_inreg_tip FOREIGN KEY (id_tip_mentenanta) REFERENCES Mentenanta(id_tip_mentenanta)
);


CREATE TABLE Amortizare_Vehicul 
(
    id_amortizare NUMBER(5) CONSTRAINT pk_amortizare PRIMARY KEY,
    id_masina NUMBER(5),
    data_depreciere DATE,
    valoarea_initiala NUMBER(10, 2),
    valoarea_curenta NUMBER(10, 2) CONSTRAINT ck_val_cur CHECK (valoarea_curenta >= 0),
    km_la_calcul NUMBER(10),
    stare_vehicul VARCHAR2(20),
    observatii VARCHAR2(200),
    CONSTRAINT fk_amort_masina FOREIGN KEY (id_masina) REFERENCES Vehicul(id_masina)
);


CREATE TABLE Tranzactii_BuyBack 
(
    id_buyback NUMBER(5) CONSTRAINT pk_buyback PRIMARY KEY,
    id_vehicul_vandut NUMBER(5),
    id_vehicul_cumparat NUMBER(5),
    data_tranzactie DATE DEFAULT SYSDATE,
    diferenta_pret NUMBER(10, 2), 
    mentiuni VARCHAR2(200),
    CONSTRAINT fk_bb_vandut FOREIGN KEY (id_vehicul_vandut) REFERENCES Vehicul(id_masina),
    CONSTRAINT fk_bb_cumparat FOREIGN KEY (id_vehicul_cumparat) REFERENCES Vehicul(id_masina)
);


ALTER TABLE Proprietari 
ADD telefon VARCHAR2(15);


ALTER TABLE Proprietari 
ADD CONSTRAINT uq_telefon_proprietar UNIQUE (telefon);


ALTER TABLE Inregistrare_Mentenanta 
MODIFY descriere_mentenanta VARCHAR2(500);


INSERT INTO Producatori VALUES (1, 'BMW');
INSERT INTO Producatori VALUES (2, 'Audi');
INSERT INTO Producatori VALUES (3, 'Volkswagen');
INSERT INTO Producatori VALUES (4, 'Mercedes-Benz');
INSERT INTO Producatori VALUES (5, 'Dacia');
INSERT INTO Producatori VALUES (6, 'Renault');
INSERT INTO Producatori VALUES (7, 'Ford');
INSERT INTO Producatori VALUES (8, 'Toyota');
INSERT INTO Producatori VALUES (9, 'Hyundai');
INSERT INTO Producatori VALUES (10, 'Tesla');
INSERT INTO Producatori VALUES (11, 'Volvo');
INSERT INTO Producatori VALUES (12, 'Mazda');
INSERT INTO Producatori VALUES (13, 'Honda');
INSERT INTO Producatori VALUES (14, 'Kia');
INSERT INTO Producatori VALUES (15, 'Peugeot');


INSERT INTO Modele_Vehicule VALUES (101, 1, 'Seria 3', 2000, 'Automata');
INSERT INTO Modele_Vehicule VALUES (102, 1, 'X5', 3000, 'Automata');
INSERT INTO Modele_Vehicule VALUES (103, 2, 'A4', 2000, 'Automata');
INSERT INTO Modele_Vehicule VALUES (104, 3, 'Golf 7', 1600, 'Manuala');
INSERT INTO Modele_Vehicule VALUES (105, 3, 'Passat', 2000, 'Automata');
INSERT INTO Modele_Vehicule VALUES (106, 5, 'Logan', 1000, 'Manuala');
INSERT INTO Modele_Vehicule VALUES (107, 5, 'Duster', 1500, 'Manuala');
INSERT INTO Modele_Vehicule VALUES (108, 7, 'Focus', 1500, 'Manuala');
INSERT INTO Modele_Vehicule VALUES (109, 8, 'Corolla', 1800, 'Automata');
INSERT INTO Modele_Vehicule VALUES (110, 10, 'Model 3', 0, 'Automata');
INSERT INTO Modele_Vehicule VALUES (111, 11, 'XC60', 2000, 'Automata');
INSERT INTO Modele_Vehicule VALUES (112, 12, 'CX-5', 2200, 'Manuala');
INSERT INTO Modele_Vehicule VALUES (113, 13, 'Civic', 1500, 'Manuala');
INSERT INTO Modele_Vehicule VALUES (114, 14, 'Sportage', 1600, 'Automata');
INSERT INTO Modele_Vehicule VALUES (115, 15, '3008', 1600, 'Automata');



INSERT INTO Vehicul VALUES (1001, 101, 2018, 120000, 'Diesel', 'WBA1234567890ABC1', 'Euro 6', 'Negru', 18500, 16000, 'Foarte buna');
INSERT INTO Vehicul VALUES (1002, 102, 2019, 85000, 'Diesel', 'WBA9876543210DEF2', 'Euro 6', 'Alb', 45000, 40000, 'Excelenta');
INSERT INTO Vehicul VALUES (1003, 103, 2017, 150000, 'Diesel', 'WAU1234509876GHI3', 'Euro 6', 'Gri', 14500, 12000, 'Buna');
INSERT INTO Vehicul VALUES (1004, 104, 2016, 180000, 'Diesel', 'WVW1122334455JKL4', 'Euro 6', 'Albastru', 9500, 8000, 'Medie');
INSERT INTO Vehicul VALUES (1005, 105, 2020, 60000, 'Diesel', 'WVW5566778899MNO5', 'Euro 6', 'Negru', 22000, 19500, 'Excelenta');
INSERT INTO Vehicul VALUES (1006, 106, 2018, 90000, 'Benzina', 'UU12345678901PQR6', 'Euro 6', 'Alb', 6500, 5000, 'Buna');
INSERT INTO Vehicul VALUES (1007, 107, 2021, 40000, 'Diesel', 'UU19876543210STU7', 'Euro 6', 'Portocaliu', 15500, 13500, 'Excelenta');
INSERT INTO Vehicul VALUES (1008, 108, 2015, 210000, 'Diesel', 'WF01231231234VWX8', 'Euro 5', 'Rosu', 7500, 6000, 'Necesita revizie');
INSERT INTO Vehicul VALUES (1009, 109, 2022, 15000, 'Hibrid', 'JT11223344556YZ09', 'Euro 6', 'Gri', 21000, 19000, 'Noua');
INSERT INTO Vehicul VALUES (1010, 110, 2021, 25000, 'Electric', '5YJ1234567890TES0', 'Zero', 'Alb', 35000, 31000, 'Excelenta');
INSERT INTO Vehicul VALUES (1011, 111, 2019, 70000, 'Diesel', 'YV112233445566778', 'Euro 6', 'Argintiu', 28000, 25000, 'Excelenta');
INSERT INTO Vehicul VALUES (1012, 112, 2016, 130000, 'Benzina', 'JMZ12312312312345', 'Euro 6', 'Rosu', 12500, 10000, 'Buna');
INSERT INTO Vehicul VALUES (1013, 113, 2018, 95000, 'Benzina', 'SHH11223344556677', 'Euro 6', 'Alb', 14000, 12000, 'Buna');
INSERT INTO Vehicul VALUES (1014, 114, 2020, 50000, 'Diesel', 'U5Y11223344556677', 'Euro 6', 'Maron', 19500, 17000, 'Excelenta');
INSERT INTO Vehicul VALUES (1015, 115, 2021, 30000, 'Hibrid', 'VF311223344556677', 'Euro 6', 'Albastru', 24500, 22000, 'Excelenta');



INSERT INTO Proprietari VALUES (501, 'Popescu Ion', 'Romania', '0721111111');
INSERT INTO Proprietari VALUES (502, 'Radu Maria', 'Romania', '0722222222');
INSERT INTO Proprietari VALUES (503, 'Hans Mueller', 'Germania', '+491510001');
INSERT INTO Proprietari VALUES (504, 'Stoica Vasile', 'Romania', '0724444444');
INSERT INTO Proprietari VALUES (505, 'Jean Pierre', 'Franta', '+336000001');
INSERT INTO Proprietari VALUES (506, 'Stan Alexandru', 'Romania', '0726666666');
INSERT INTO Proprietari VALUES (507, 'Dumitru Elena', 'Romania', '0727777777');
INSERT INTO Proprietari VALUES (508, 'Auto Leasing GMBH', 'Germania', '+491510008');
INSERT INTO Proprietari VALUES (509, 'Marin Dan', 'Romania', '0729999999');
INSERT INTO Proprietari VALUES (510, 'John Smith', 'SUA', '+15550000');
INSERT INTO Proprietari VALUES (511, 'Gheorghe Ioana', 'Romania', '0730000000');
INSERT INTO Proprietari VALUES (512, 'Dobre Mihai', 'Romania', '0731111111');
INSERT INTO Proprietari VALUES (513, 'Nistor Gabriel', 'Romania', '0732222222');
INSERT INTO Proprietari VALUES (514, 'Paolo Rossi', 'Italia', '+393330000');
INSERT INTO Proprietari VALUES (515, 'SC Transport SRL', 'Romania', '0734444444');



INSERT INTO Istoric_Proprietari VALUES (1, 1001, 503, 'M-AB-123', 'Germania', TO_DATE('10-01-2018', 'DD-MM-YYYY'), 45000, TO_DATE('15-05-2023', 'DD-MM-YYYY'), 17000);
INSERT INTO Istoric_Proprietari VALUES (2, 1004, 501, 'B-101-POP', 'Romania', TO_DATE('20-06-2016', 'DD-MM-YYYY'), 20000, TO_DATE('01-08-2023', 'DD-MM-YYYY'), 8500);
INSERT INTO Istoric_Proprietari VALUES (3, 1002, 508, 'M-XY-999', 'Germania', TO_DATE('15-03-2019', 'DD-MM-YYYY'), 70000, TO_DATE('10-09-2023', 'DD-MM-YYYY'), 42000);
INSERT INTO Istoric_Proprietari VALUES (4, 1006, 504, 'CJ-20-VAS', 'Romania', TO_DATE('01-02-2018', 'DD-MM-YYYY'), 9000, TO_DATE('20-10-2023', 'DD-MM-YYYY'), 5500);
INSERT INTO Istoric_Proprietari VALUES (5, 1003, 505, 'FR-123-AA', 'Franta', TO_DATE('11-11-2017', 'DD-MM-YYYY'), 35000, TO_DATE('05-05-2023', 'DD-MM-YYYY'), 13000);
INSERT INTO Istoric_Proprietari VALUES (6, 1008, 502, 'DJ-55-ANA', 'Romania', TO_DATE('15-04-2015', 'DD-MM-YYYY'), 18000, TO_DATE('12-12-2022', 'DD-MM-YYYY'), 6500);
INSERT INTO Istoric_Proprietari VALUES (7, 1010, 510, 'CA-555-EV', 'SUA', TO_DATE('01-01-2021', 'DD-MM-YYYY'), 50000, TO_DATE('01-06-2023', 'DD-MM-YYYY'), 32000);
INSERT INTO Istoric_Proprietari VALUES (8, 1005, 508, 'B-99-LEA', 'Romania', TO_DATE('20-02-2020', 'DD-MM-YYYY'), 30000, TO_DATE('15-09-2023', 'DD-MM-YYYY'), 20000);
INSERT INTO Istoric_Proprietari VALUES (9, 1007, 506, 'IF-12-ALE', 'Romania', TO_DATE('10-05-2021', 'DD-MM-YYYY'), 19000, TO_DATE('20-08-2023', 'DD-MM-YYYY'), 14000);
INSERT INTO Istoric_Proprietari VALUES (10, 1011, 511, 'BV-08-IOA', 'Romania', TO_DATE('10-01-2019', 'DD-MM-YYYY'), 40000, TO_DATE('01-09-2023', 'DD-MM-YYYY'), 27000);
INSERT INTO Istoric_Proprietari VALUES (11, 1012, 512, 'IS-77-MIH', 'Romania', TO_DATE('05-05-2016', 'DD-MM-YYYY'), 20000, TO_DATE('10-10-2023', 'DD-MM-YYYY'), 11000);
INSERT INTO Istoric_Proprietari VALUES (12, 1013, 513, 'CT-33-GAB', 'Romania', TO_DATE('01-06-2018', 'DD-MM-YYYY'), 22000, TO_DATE('15-11-2023', 'DD-MM-YYYY'), 13000);
INSERT INTO Istoric_Proprietari VALUES (13, 1014, 514, 'RM-445-XX', 'Italia', TO_DATE('01-02-2020', 'DD-MM-YYYY'), 28000, TO_DATE('20-11-2023', 'DD-MM-YYYY'), 18000);
INSERT INTO Istoric_Proprietari VALUES (14, 1015, 515, 'B-400-SRL', 'Romania', TO_DATE('15-03-2021', 'DD-MM-YYYY'), 32000, TO_DATE('01-12-2023', 'DD-MM-YYYY'), 23000);
INSERT INTO Istoric_Proprietari VALUES (15, 1009, 509, 'AG-10-DAN', 'Romania', TO_DATE('01-01-2022', 'DD-MM-YYYY'), 25000, NULL, NULL);



INSERT INTO Mentenanta VALUES (1, 'Schimb Ulei si Filtre');
INSERT INTO Mentenanta VALUES (2, 'Inlocuire Placute Frana');
INSERT INTO Mentenanta VALUES (3, 'Schimb Kit Distributie');
INSERT INTO Mentenanta VALUES (4, 'Inspectie Tehnica Periodica (ITP)');
INSERT INTO Mentenanta VALUES (5, 'Igienizare AC');
INSERT INTO Mentenanta VALUES (6, 'Inlocuire Anvelope');
INSERT INTO Mentenanta VALUES (7, 'Vopsire Bara Fata');
INSERT INTO Mentenanta VALUES (8, 'Inlocuire Parbriz');
INSERT INTO Mentenanta VALUES (9, 'Diagnoza Generala');
INSERT INTO Mentenanta VALUES (10, 'Schimb Baterie');
INSERT INTO Mentenanta VALUES (11, 'Schimb Lichid Frana');
INSERT INTO Mentenanta VALUES (12, 'Reglaj Directie');
INSERT INTO Mentenanta VALUES (13, 'Polish Faruri');
INSERT INTO Mentenanta VALUES (14, 'Inlocuire Amortizoare');
INSERT INTO Mentenanta VALUES (15, 'Curatare Tapiterie');



INSERT INTO Inregistrare_Mentenanta VALUES (2001, 1001, 1, TO_DATE('02-12-2025', 'DD-MM-YYYY'), TO_DATE('02-12-2026', 'DD-MM-YYYY'), 'Revizie standard', 800);
INSERT INTO Inregistrare_Mentenanta VALUES (2002, 1004, 3, TO_DATE('10-10-2025', 'DD-MM-YYYY'), NULL, 'Distributie zgomotoasa', 2500);
INSERT INTO Inregistrare_Mentenanta VALUES (2003, 1008, 2, TO_DATE('20-11-2025', 'DD-MM-YYYY'), NULL, 'Placute uzate 90%', 600);
INSERT INTO Inregistrare_Mentenanta VALUES (2004, 1002, 9, TO_DATE('05-12-2025', 'DD-MM-YYYY'), NULL, 'Verificare inainte de vanzare', 250);
INSERT INTO Inregistrare_Mentenanta VALUES (2005, 1006, 4, TO_DATE('01-09-2025', 'DD-MM-YYYY'), TO_DATE('01-09-2027', 'DD-MM-YYYY'), 'ITP Valabil 2 ani', 150);
INSERT INTO Inregistrare_Mentenanta VALUES (2006, 1010, 10, TO_DATE('10-12-2025', 'DD-MM-YYYY'), NULL, 'Baterie 12V moarta', 400);
INSERT INTO Inregistrare_Mentenanta VALUES (2007, 1003, 7, TO_DATE('15-11-2025', 'DD-MM-YYYY'), NULL, 'Zgarieturi superficiale', 900);
INSERT INTO Inregistrare_Mentenanta VALUES (2008, 1005, 1, TO_DATE('25-11-2025', 'DD-MM-YYYY'), TO_DATE('25-11-2026', 'DD-MM-YYYY'), 'Ulei LongLife', 1100);
INSERT INTO Inregistrare_Mentenanta VALUES (2009, 1007, 6, TO_DATE('12-10-2025', 'DD-MM-YYYY'), NULL, 'Anvelope Iarna Noi', 1800);
INSERT INTO Inregistrare_Mentenanta VALUES (2010, 1001, 5, TO_DATE('02-12-2025', 'DD-MM-YYYY'), NULL, 'Miros neplacut AC', 200);
INSERT INTO Inregistrare_Mentenanta VALUES (2011, 1011, 1, TO_DATE('07-12-2025', 'DD-MM-YYYY'), TO_DATE('07-12-2026', 'DD-MM-YYYY'), 'Revizie Volvo', 1200);
INSERT INTO Inregistrare_Mentenanta VALUES (2012, 1012, 13, TO_DATE('22-11-2025', 'DD-MM-YYYY'), NULL, 'Faruri matuite', 150);
INSERT INTO Inregistrare_Mentenanta VALUES (2013, 1013, 12, TO_DATE('01-12-2025', 'DD-MM-YYYY'), NULL, 'Masina tragea dreapta', 300);
INSERT INTO Inregistrare_Mentenanta VALUES (2014, 1014, 2, TO_DATE('01-11-2025', 'DD-MM-YYYY'), NULL, 'Schimb placute spate', 500);
INSERT INTO Inregistrare_Mentenanta VALUES (2015, 1015, 15, TO_DATE('11-12-2025', 'DD-MM-YYYY'), NULL, 'Pregatire vanzare', 450);



INSERT INTO Amortizare_Vehicul VALUES (3001, 1001, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 45000, 18500, 120000, 'Buna', 'Depreciere normala');
INSERT INTO Amortizare_Vehicul VALUES (3002, 1004, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 20000, 9500, 180000, 'Medie', 'Kilometraj ridicat');
INSERT INTO Amortizare_Vehicul VALUES (3003, 1002, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 70000, 45000, 85000, 'Excelenta', 'Model cautat');
INSERT INTO Amortizare_Vehicul VALUES (3004, 1010, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 50000, 35000, 25000, 'Excelenta', 'Cerere mare EV');
INSERT INTO Amortizare_Vehicul VALUES (3005, 1008, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 18000, 7500, 210000, 'Slaba', 'Necesita investitii');
INSERT INTO Amortizare_Vehicul VALUES (3006, 1006, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 9000, 6500, 90000, 'Buna', 'Depreciere mica Dacia');
INSERT INTO Amortizare_Vehicul VALUES (3007, 1003, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 35000, 14500, 150000, 'Buna', 'Import Franta');
INSERT INTO Amortizare_Vehicul VALUES (3008, 1005, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 30000, 22000, 60000, 'Excelenta', 'Putini km');
INSERT INTO Amortizare_Vehicul VALUES (3009, 1007, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 19000, 15500, 40000, 'Excelenta', 'Aproape noua');
INSERT INTO Amortizare_Vehicul VALUES (3010, 1009, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 23000, 21000, 15000, 'Noua', 'Demonstrator');
INSERT INTO Amortizare_Vehicul VALUES (3011, 1011, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 55000, 28000, 70000, 'Excelenta', 'Volvo intretinut');
INSERT INTO Amortizare_Vehicul VALUES (3012, 1012, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 25000, 12500, 130000, 'Buna', 'Mazda fiabila');
INSERT INTO Amortizare_Vehicul VALUES (3013, 1013, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 24000, 14000, 95000, 'Buna', 'Honda Civic');
INSERT INTO Amortizare_Vehicul VALUES (3014, 1014, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 29000, 19500, 50000, 'Excelenta', 'SUV cautat');
INSERT INTO Amortizare_Vehicul VALUES (3015, 1015, TO_DATE('12-12-2025', 'DD-MM-YYYY'), 38000, 24500, 30000, 'Excelenta', 'Hibrid Peugeot');



INSERT INTO Tranzactii_BuyBack VALUES (4001, 1004, 1001, TO_DATE('20-11-2025', 'DD-MM-YYYY'), 9000, 'Clientul a dat Golful la schimb pt BMW');
INSERT INTO Tranzactii_BuyBack VALUES (4002, 1008, 1006, TO_DATE('25-11-2025', 'DD-MM-YYYY'), -1000, 'Schimb Ford vechi pe Logan mai nou');
INSERT INTO Tranzactii_BuyBack VALUES (4003, 1001, 1002, TO_DATE('05-12-2025', 'DD-MM-YYYY'), 26500, 'Upgrade de la Seria 3 vechi la X5');
INSERT INTO Tranzactii_BuyBack VALUES (4004, 1006, 1007, TO_DATE('10-12-2025', 'DD-MM-YYYY'), 9000, 'Upgrade Duster');
INSERT INTO Tranzactii_BuyBack VALUES (4005, 1003, 1010, TO_DATE('11-12-2025', 'DD-MM-YYYY'), 20500, 'Trecere la electric');
INSERT INTO Tranzactii_BuyBack VALUES (4006, 1005, 1002, TO_DATE('12-11-2025', 'DD-MM-YYYY'), 23000, 'Schimb Passat pe X5');
INSERT INTO Tranzactii_BuyBack VALUES (4007, 1009, 1010, TO_DATE('01-12-2025', 'DD-MM-YYYY'), 14000, 'Schimb Corolla pe Tesla');
INSERT INTO Tranzactii_BuyBack VALUES (4008, 1004, 1006, TO_DATE('01-11-2025', 'DD-MM-YYYY'), -3000, 'Downgrade pentru bani');
INSERT INTO Tranzactii_BuyBack VALUES (4009, 1002, 1010, TO_DATE('10-10-2025', 'DD-MM-YYYY'), -10000, 'Tesla buyback pt X5');
INSERT INTO Tranzactii_BuyBack VALUES (4010, 1008, 1005, TO_DATE('07-12-2025', 'DD-MM-YYYY'), 14500, 'Ford vechi avans pt Passat');
INSERT INTO Tranzactii_BuyBack VALUES (4011, 1012, 1011, TO_DATE('27-11-2025', 'DD-MM-YYYY'), 15500, 'Mazda la schimb pt Volvo');
INSERT INTO Tranzactii_BuyBack VALUES (4012, 1013, 1015, TO_DATE('02-12-2025', 'DD-MM-YYYY'), 10500, 'Honda pt Peugeot Hibrid');
INSERT INTO Tranzactii_BuyBack VALUES (4013, 1014, 1002, TO_DATE('04-12-2025', 'DD-MM-YYYY'), 25500, 'Kia la schimb pt X5');
INSERT INTO Tranzactii_BuyBack VALUES (4014, 1001, 1014, TO_DATE('09-12-2025', 'DD-MM-YYYY'), 1000, 'Schimb pe schimb');
INSERT INTO Tranzactii_BuyBack VALUES (4015, 1006, 1013, TO_DATE('10-12-2025', 'DD-MM-YYYY'), 7500, 'Logan pt Civic');

COMMIT;

--6
-- 1. DISCOUNT AUTOMAT: Ieftinim cu 9% masiniile Diesel cu peste 200.000 km
UPDATE Vehicul 
SET pret_lista = pret_lista * 0.90 
WHERE combustibil = 'Diesel' AND kilometri > 200000;

-- 2. MAJORARE COSTURI SERVICE (Subcerere Corelată):
-- Scumpim cu 15% manopera pentru Volkswagen (ID = 3),
UPDATE Inregistrare_Mentenanta 
SET cost_mentenanta = cost_mentenanta * 1.15 
WHERE id_masina IN (
    SELECT v.id_masina 
    FROM Vehicul v
    JOIN Modele_Vehicule m ON v.id_model = m.id_model
    WHERE m.id_producator = 3
);

-- 3. CONCATENARE TEXT: 
-- Daca diferenta e negativa, adaugam textul ' [PLATIT CATRE CLIENT]' la final
UPDATE Tranzactii_BuyBack
SET mentiuni = mentiuni || ' [PLATIT CATRE CLIENT]'
WHERE diferenta_pret < 0;

-- 4. UPDATE PE BAZA DE TIP: Modificam observatiile la Amortizare pt Electrice
UPDATE Amortizare_Vehicul
SET observatii = 'Depreciere influentata de starea bateriei'
WHERE id_masina IN (SELECT id_masina FROM Vehicul WHERE combustibil = 'Electric');


--7

-- 1. Cream o tabela copie de test (ca sa nu stergem tabelele reale si sa stricam legaturile)
CREATE TABLE Copie_Producatori AS SELECT * FROM Producatori;

-- Verificam ca s-a creat
SELECT * FROM Copie_Producatori;

-- 2. Stergem tabela 
DROP TABLE Copie_Producatori;

-- 3. Recuperam tabela din Recycle Bin
FLASHBACK TABLE Copie_Producatori TO BEFORE DROP;

-- 4. Verificam ca datele s-au intors
SELECT * FROM Copie_Producatori;

-- Stergem definitiv tabela de test la final, ca nu mai avem nevoie de ea
DROP TABLE Copie_Producatori PURGE;

--Prima Parte
-- 1. Cerinta: Sa se calculeze suma totala investita in mentenanta pentru fiecare producator auto, 
--ordonand rezultatele descrescator dupa costuri, pentru a identifica marcile care genereaza cele 
--mai mari cheltuieli de service. (JOIN pe 4 tabele + SUM)

SELECT p.nume_producator, 
       COUNT(v.id_masina) AS nr_masini_stoc,
       SUM(im.cost_mentenanta) AS total_investit_service
FROM Producatori p
JOIN Modele_Vehicule m ON p.id_producator = m.id_producator
JOIN Vehicul v ON m.id_model = v.id_model
JOIN Inregistrare_Mentenanta im ON v.id_masina = im.id_masina
GROUP BY p.nume_producator
ORDER BY total_investit_service DESC;

-- 2. Cerinta: Sa se genereze un raport de securitate care afiseaza numele complet al masinii,
-- seria de sasiu mascata (doar ultimele 4 caractere vizibile) si vechimea exacta in luni a vehiculului,
--calculata fata de data curenta. 

SELECT p.nume_producator || ' ' || m.denumire_model AS masina_completa,
       '***' || SUBSTR(v.serie_sasiu, -4) AS sasiu_securizat,
       v.an_fabricatie,
       ROUND(MONTHS_BETWEEN(SYSDATE, TO_DATE('01-01-'||v.an_fabricatie, 'DD-MM-YYYY')), 0) AS vechime_luni
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model
JOIN Producatori p ON m.id_producator = p.id_producator
WHERE v.stare_vehicul IN ('Excelenta', 'Buna');

-- 3. Cerinta: Sa se determine pretul mediu de vanzare pentru fiecare norma de poluare, 
--afisand doar acele categorii ecologice care sunt reprezentate de cel putin 2 autovehicule in stoc. 

SELECT norma_poluare, 
       COUNT(id_masina) AS numar_vehicule,
       ROUND(AVG(pret_lista), 2) AS pret_mediu_vanzare
FROM Vehicul
GROUP BY norma_poluare
HAVING COUNT(id_masina) >= 2
ORDER BY pret_mediu_vanzare DESC;

-- 4. Cerinta: Sa se realizeze o analiza a pietelor de provenienta, 
--afisand volumul de importuri si pretul mediu de achizitie (istoric) pentru fiecare tara din care au fost aduse masini.

SELECT pr.tara AS tara_provenienta,
       COUNT(ip.id_masina) AS volum_importuri,
       ROUND(AVG(ip.pret_cumparare), 2) AS medie_pret_achizitie
FROM Proprietari pr
JOIN Istoric_Proprietari ip ON pr.id_proprietar = ip.id_proprietar
WHERE pr.tara IS NOT NULL
GROUP BY pr.tara
ORDER BY medie_pret_achizitie DESC;

-- 5. Cerinta: Sa se calculeze valoarea totala de piata a stocului curent, grupata dupa tipul de
-- transmisie (afisat cu majuscule), pentru a estima incasarile potentiale pe aceste segmente tehnice.

SELECT UPPER(m.transmisie) AS tip_cutie,
       COUNT(v.id_masina) AS unitati,
       SUM(v.pret_lista) AS valoare_totala_piata
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model
GROUP BY m.transmisie;



--A Doua parte

-- 6. Cerinta: Sa se afiseze masinile (Marca, Model, Pret) care au un pret de lista mai mare 
--decat pretul mediu al tuturor masinilor din parcul auto. 
SELECT p.nume_producator, m.denumire_model, v.pret_lista
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model
JOIN Producatori p ON m.id_producator = p.id_producator
WHERE v.pret_lista > (SELECT AVG(pret_lista) FROM Vehicul)
ORDER BY v.pret_lista DESC;

--
UPDATE Istoric_Proprietari 
SET tara_inmatriculare = 'Spania' 
WHERE id_proprietar_masina = 1;

-- 7. Cerinta: Sa se afiseze lista tarilor din care au fost importate masini (Istoric), 
--dar in care NU locuieste niciun proprietar actual. 
SELECT tara_inmatriculare FROM Istoric_Proprietari
MINUS
SELECT tara FROM Proprietari;

-- 8. Cerinta: Sa se gaseasca marcile (Producatorii) care au in oferta parcului atat masini cu transmisie Automata
--, cat si masini cu transmisie Manuala. 
SELECT p.nume_producator
FROM Producatori p
JOIN Modele_Vehicule m ON p.id_producator = m.id_producator
WHERE m.transmisie = 'Automata'
INTERSECT
SELECT p.nume_producator
FROM Producatori p
JOIN Modele_Vehicule m ON p.id_producator = m.id_producator
WHERE m.transmisie = 'Manuala';

-- 9. Cerinta: Sa se genereze o lista comuna cu toate tarile implicate in activitatea parcului auto, 
--fie ca sunt tari de provenienta ale masinilor (Istoric) sau tari de resedinta ale proprietarilor, fara duplicate. 
SELECT tara_inmatriculare AS tari_partenere FROM Istoric_Proprietari
UNION
SELECT tara FROM Proprietari;

--
INSERT INTO Vehicul VALUES (1016, 101, 2020, 30000, 'Diesel', 'WBA_TEST_EXTRA', 'Euro 6', 'Albastru', 28000, 24000, 'Noua');
INSERT INTO Vehicul VALUES (1020, 101, 2005, 350000, 'Diesel', 'WBA_OLD_BMW_001', 'Euro 4', 'Gri', 4000, 3000, 'Uzata');
INSERT INTO Vehicul VALUES (1021, 104, 2019, 45000, 'Benzina', 'WVW_GTI_SPORT_X', 'Euro 6', 'Rosu', 22000, 19000, 'Excelenta');
INSERT INTO Vehicul VALUES (1022, 106, 2017, 200000, 'Benzina', 'UU1_TAXI_EX_009', 'Euro 6', 'Galben', 2500, 1500, 'Necesita vopsire');



-- 10. Cerinta: Sa se afiseze vehiculele care sunt mai scumpe decat media de pret A MODELULUI lor specific (nu a tot parcului). 
-- Aceasta interogare compara pretul unei masini cu media preturilor doar pentru masinile de acelasi tip.
SELECT p.nume_producator, m.denumire_model, v.an_fabricatie, v.pret_lista,
       (SELECT ROUND(AVG(v2.pret_lista), 2) 
        FROM Vehicul v2 
        WHERE v2.id_model = v.id_model) AS media_modelului
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model
JOIN Producatori p ON m.id_producator = p.id_producator
WHERE v.pret_lista > (
    SELECT AVG(v2.pret_lista) 
    FROM Vehicul v2 
    WHERE v2.id_model = v.id_model
);


--A treia parte 

-- 11. Cerinta: Sa se clasifice vehiculele in categorii comerciale in functie de pretul de lista, 
--folosind expresia CASE: 'Budget' (sub 10.000), 'Standard' (10.000-25.000) si 'Premium' (peste 25.000).

SELECT p.nume_producator, m.denumire_model, v.pret_lista,
       CASE 
           WHEN v.pret_lista < 10000 THEN 'Budget'
           WHEN v.pret_lista BETWEEN 10000 AND 25000 THEN 'Standard'
           ELSE 'Premium'
       END AS categorie_pret
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model
JOIN Producatori p ON m.id_producator = p.id_producator
ORDER BY v.pret_lista DESC;

-- 12. Cerinta: Sa se genereze un cod scurt de identificare pentru fiecare masina, unde tipul de combustibil este inlocuit cu o 
--litera (D=Diesel, B=Benzina, E=Electric, H=Hibrid) 

SELECT m.denumire_model, v.combustibil,
       DECODE(v.combustibil, 
              'Diesel', 'D', 
              'Benzina', 'B', 
              'Electric', 'E', 
              'Hibrid', 'H', 
              '?') || '-' || v.id_masina AS cod_intern_gestiune
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model;

-- 13. Cerinta: Sa se calculeze diferenta potentiala de profit dintre pretul de lista si
-- pretul de buy-back. Deoarece unele masini nu au setat pretul de buy-back (este NULL), 

SELECT p.nume_producator, m.denumire_model, v.pret_lista, v.pret_buy_back,
       (v.pret_lista - NVL(v.pret_buy_back, 0)) AS marja_bruta_teoretica
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model
JOIN Producatori p ON m.id_producator = p.id_producator
ORDER BY marja_bruta_teoretica DESC;

-- 14. Cerinta: Sa se creeze o vedere (View) numita 'V_OFERTA_PUBLICA' care afiseaza doar informatiile esentiale 
--pentru clienti (Marca, Model, An, Pret, Km), excluzand datele sensibile precum seria de sasiu. 

CREATE OR REPLACE VIEW V_Oferta_Publica AS
SELECT p.nume_producator, m.denumire_model, v.an_fabricatie, v.kilometri, v.pret_lista, v.combustibil
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model
JOIN Producatori p ON m.id_producator = p.id_producator
WHERE v.stare_vehicul != 'Vanduta';

SELECT * FROM V_Oferta_Publica;


-- 15. Cerinta: Sa se interogheze vederea creata anterior, filtrand doar masinile cu kilometraj redus (sub 50.000 km), 
--ordonate dupa anul fabricatiei.

SELECT * FROM V_Oferta_Publica
WHERE kilometri < 50000
ORDER BY an_fabricatie DESC;



--Ultim interogari

-- 16. Cerinta: Sa se afiseze toti producatorii din baza de date si modelele asociate acestora, 
--INCLUSIV producatorii pentru care nu am definit inca niciun model in tabela Modele_Vehicule 

SELECT p.nume_producator, m.denumire_model
FROM Producatori p
LEFT OUTER JOIN Modele_Vehicule m ON p.id_producator = m.id_producator
ORDER BY p.nume_producator;


-- 17. Cerinta: Sa se identifice vehiculele "impecabile", adica masinile care nu au nicio intrare in registrul de mentenanta 

SELECT v.id_masina, p.nume_producator, m.denumire_model, v.stare_vehicul
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model
JOIN Producatori p ON m.id_producator = p.id_producator
WHERE NOT EXISTS (SELECT 1 FROM Inregistrare_Mentenanta im WHERE im.id_masina = v.id_masina);


-- 18. Cerinta: Sa se calculeze "Zilele de Inventar" pentru fiecare masina aflata in stoc, 
--reprezentand numarul de zile scurse de la data achizitiei de catre parc pana in prezent 

SELECT m.denumire_model, 
       ip.data_cumpararii AS data_intrarii_in_parc,
       TRUNC(SYSDATE - ip.data_cumpararii) AS zile_de_cand_e_in_stoc
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model
JOIN Istoric_Proprietari ip ON v.id_masina = ip.id_masina
WHERE v.stare_vehicul != 'Vanduta' AND ip.data_vanzarii IS NULL 
ORDER BY zile_de_cand_e_in_stoc DESC;

-- 19. Cerinta: Sa se afiseze primele 3 cele mai scumpe masini din stoc (Top 3),  

SELECT * FROM (
    SELECT p.nume_producator, m.denumire_model, v.pret_lista
    FROM Vehicul v
    JOIN Modele_Vehicule m ON v.id_model = m.id_model
    JOIN Producatori p ON m.id_producator = p.id_producator
    ORDER BY v.pret_lista DESC
)
WHERE ROWNUM <= 3;

-- 20. Cerinta:Sa se afiseze pentru fiecare masina: Producatorul, Modelul, Pretul de lista si 
--ULTIMA operatiune de mentenanta efectuata (Data si Descrierea)

SELECT p.nume_producator, m.denumire_model, v.pret_lista,
       (SELECT MAX(data_mentenanta) FROM Inregistrare_Mentenanta im WHERE im.id_masina = v.id_masina) AS data_ultimei_revizii,
       (SELECT COUNT(*) FROM Inregistrare_Mentenanta im WHERE im.id_masina = v.id_masina) AS total_intrat_service
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model
JOIN Producatori p ON m.id_producator = p.id_producator;


-- Sa se creeze o vedere complexa numita 'V_Dashboard_Vanzari' pentru analiza profitabilitatii
-- stocului disponibil. Vederea va afisa modelul si anul fabricatiei, 
--va calcula dinamic profitul estimat (diferenta dintre pretul de lista si pretul de buy-back, 
--tratand valorile nule prin functia NVL) si va clasifica automat vehiculele folosind o expresie CASE:
-- cele cu un potential de profit peste 5000 vor fi etichetate 'PRIORITATE VANZARE'.
CREATE OR REPLACE VIEW V_Dashboard_Vanzari AS
SELECT m.denumire_model,
       v.an_fabricatie,
       v.pret_lista AS pret_vanzare,
       NVL(v.pret_buy_back, 0) AS cost_achizitie,
       (v.pret_lista - NVL(v.pret_buy_back, 0)) AS profit_estimat,
       CASE 
           WHEN (v.pret_lista - NVL(v.pret_buy_back, 0)) > 5000 THEN 'PRIORITATE VANZARE'
           ELSE 'Standard'
       END AS status_business
FROM Vehicul v
JOIN Modele_Vehicule m ON v.id_model = m.id_model
WHERE v.stare_vehicul != 'Vanduta';

SELECT * FROM V_Dashboard_Vanzari;


--INDEX
CREATE INDEX idx_nume_insensitive 
ON Proprietari(UPPER(nume_proprietar));

SELECT * FROM Proprietari 
WHERE UPPER(nume_proprietar) = 'POPESCU ION';



-- 3. SECVENTA Facturi Fiscale
CREATE SEQUENCE se_facturi_2025
START WITH 202501
INCREMENT BY 1
MAXVALUE 202599
NOCYCLE;

SELECT 'FACT-' || se_facturi_2025.NEXTVAL AS serie_factura_generata,
       SYSDATE AS data_emiterii,
       'Emisa pentru: Client_Test' AS detalii_log
FROM DUAL;


-- 4. SINONIM 
CREATE SYNONYM Oferta_Azi FOR V_Dashboard_Vanzari;

SELECT * FROM OFerta_azi;

COMMIT;
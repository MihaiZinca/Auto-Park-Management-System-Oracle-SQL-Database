# Sistem de Gestiune Parc Auto

**Proiectarea și implementarea SQL + PL/SQL**  

---

## Descrierea Bazei de Date

Scopul proiectului este proiectarea și implementarea unei baze de date pentru gestionarea activității unui Parc Auto Second-Hand (SH). Sistemul informatic are rolul de a evidenția:

- stocul curent de vehicule  
- istoricul proprietarilor anteriori  
- operațiunile de mentenanță efectuate înainte de vânzare  
- tranzacțiile complexe de tip "Buy-Back" (schimb de vehicule)

Această bază de date oferă suport decizional pentru stabilirea prețurilor de vânzare pe baza deprecierii și a costurilor de reparație.

---

## Descrierea Tabelelor și a Atributelor
<img width="452" height="271" alt="image" src="https://github.com/user-attachments/assets/36e64069-953b-4f4b-b07e-f69ff3909e82" />

Baza de date este compusă din 9 tabele interconectate:

1. **PRODUCĂTORI** – catalogul mărcilor auto  
   - `id_producator` (PK), `nume_producator`

2. **MODELE_VEHICULE** – tipurile de mașini asociate unui producător  
   - `id_model` (PK), `denumire_model`, `capacitate_cilindrica`, `transmisie`, `id_producator` (FK)

3. **VEHICUL** – tabela centrală care conține stocul parcului auto  
   - `id_masina` (PK), `an_fabricatie`, `kilometri`, `combustibil`, `serie_sasiu` (unic), `pret_lista`, `stare_vehicul`, `id_model` (FK)

4. **PROPRIETARI** – date despre foștii deținători ai vehiculelor  
   - `id_proprietar` (PK), `nume_proprietar`, `tara`

5. **ISTORIC_PROPRIETARI** – istoricul tranzacțiilor anterioare  
   - `id_proprietar_masina` (PK), `data_cumpararii`, `data_vanzarii`, `pret_vanzare`, `nr_inmatriculare`, `id_masina` (FK), `id_proprietar` (FK)

6. **MENTENANTA** – lista tipurilor de servicii service  
   - `id_tip_mentenanta` (PK), `denumire_mentenanta`

7. **INREGISTRARE_MENTENANTA** – jurnalul reparațiilor vehiculelor  
   - `id_mentenanta` (PK), `data_mentenanta`, `cost_mentenanta`, `descriere`, `id_masina` (FK), `id_tip_mentenanta` (FK)

8. **AMORTIZARE_VEHICUL** – calculul deprecierii vehiculelor  
   - `id_amortizare` (PK), `data_depreciere`, `valoarea_initiala`, `valoarea_curenta`, `id_masina` (FK)

9. **TRANZACTII_BUYBACK** – gestionarea schimburilor auto  
   - `id_buyback` (PK), `diferenta_pret`, `data_tranzactie`, `id_vehicul_vandut` (FK), `id_vehicul_cumparat` (FK)

---

## Normalizare și Integritate

Baza de date respectă Forma Normală 3 (FN3):

- Atributele sunt atomice (FN1)  
- Atributele non-cheie depind complet de cheia primară (FN2)  
- Nu există dependențe tranzitive între atributele non-cheie (FN3)  
- S-au impus restricții de integritate referențială (FK) pentru a evita vehicule fără model sau reparații fără vehicul asociat

---

## Cod SQL și Date Exemplu

- Codul sursă definește tabelele și relațiile conform schemei conceptuale.  
- Pentru testare, am inserat **15 înregistrări pentru fiecare tabel**.

### Exemple de scenarii implementate:

1. Reducerea stocurilor: -9% pentru vehicule diesel cu rulaj > 200.000 km  
2. Ajustarea costurilor de service: +15% pentru reparațiile mașinilor VW  
3. Marcarea tranzacțiilor Buy-Back cu diferență negativă  
4. Standardizarea descrierilor pentru amortizarea vehiculelor electrice

---

## Securitate și Recuperare Date

Oracle Database oferă mecanisme de protecție prin **Recycle Bin**:

1. Crearea unei copii de siguranță: tabelă temporară `COPIE_PRODUCATORI`  
2. Simularea ștergerii accidentale: `DROP TABLE`  
3. Verificarea indisponibilității  
4. Recuperarea datelor: `FLASHBACK TABLE ... TO BEFORE DROP`

---

## Interogări SQL Exemplu

- **Indicatori de performanță:** jonctiuni între tabele, funcții de agregare (SUM, AVG, COUNT) și scalare  
- **Probleme complexe de business:** compararea seturilor de date disjuncte, filtrare dinamică  
- **Analiză comercială:** CASE și DECODE pentru categorii de preț și coduri interne, NVL pentru valori nule  
- **Rapoarte:** top 3 cele mai scumpe vehicule, relații incomplete (`NOT EXISTS`)  

---

## Obiecte Avansate

1. **Vederi:** `V_Dashboard_Vanzari` – raport dinamic pentru management  
2. **Indexuri:** `idx_nume_insensitive` – căutări rapide, insensitive la majuscule/minuscule  
3. **Secvențe:** `se_facturi_2025` – generare automată a numerelor de facturi  
4. **Sinonime:** `Oferta_Azi` – simplifică interogările complexe

---

## 🚀 Extensie PL/SQL (Programare Avansata)

Aceasta sectiune adauga un strat de inteligenta si automatizare bazei de date, transformand-o intr-un sistem capabil sa gestioneze singur regulile de business.

### 🛠️ Functionalitati Cheie:

* **Automatizare si SQL Dinamic:**
  * Creare automata de tabele de arhiva si modificari structurale (`ALTER`) in timp real prin `EXECUTE IMMEDIATE`.
* **Logica Decizionala si Iterativa:**
  * Clasificarea automata a vehiculelor pe categorii de pret (`Premium/Standard/Buget`).
  * Simulari de calcul prin structuri repetitive (`WHILE`, `FOR REVERSE`).
* **Gestiune Performanta a Datelor:**
  * Utilizarea colectiilor (`Index-by Tables`, `Nested Tables`, `Varrays`) pentru procesarea rapida a datelor in memorie.
  * Optimizarea interogarilor masive prin `BULK COLLECT`.
* **Siguranta si Integritate (Tratarea Exceptiilor):**
  * Validarea stricta a datelor (ex: blocarea km negativi sau a vanzarilor in pierdere).
  * Capturarea erorilor de sistem si transformarea lor in mesaje personalizate.
* **Capsulare in Pachete (`PK_GESTIUNE_AUTO`):**
  * Gruparea functiilor si procedurilor intr-un singur obiect pentru performanta si securitate.
  * Functii pentru calculul profitului, uzurii si taxelor vamale.
* **Declansatori Inteligenti (Triggers):**
  * **Nivel Instructiune:** Restrictionarea accesului in afara orelor de program.
  * **Nivel Rand:** Corectia automata a datelor si protectia pretului de vanzare.

---

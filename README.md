# Sistem de Gestiune Parc Auto

**Proiectarea și implementarea SQL**

\---

## Descrierea Bazei de Date

Scopul proiectului este proiectarea și implementarea unei baze de date pentru gestionarea activității unui Parc Auto Second-Hand (SH). Sistemul informatic are rolul de a evidenția:

* stocul curent de vehicule
* istoricul proprietarilor anteriori
* operațiunile de mentenanță efectuate înainte de vânzare
* tranzacțiile complexe de tip "Buy-Back" (schimb de vehicule)

Această bază de date oferă suport decizional pentru stabilirea prețurilor de vânzare pe baza deprecierii și a costurilor de reparație.

\---

## Descrierea Tabelelor și a Atributelor

<img width="452" height="271" alt="image" src="https://github.com/user-attachments/assets/36e64069-953b-4f4b-b07e-f69ff3909e82" />

Baza de date este compusă din 9 tabele interconectate:

1. **PRODUCĂTORI** – catalogul mărcilor auto

   * `id\_producator` (PK), `nume\_producator`
2. **MODELE\_VEHICULE** – tipurile de mașini asociate unui producător

   * `id\_model` (PK), `denumire\_model`, `capacitate\_cilindrica`, `transmisie`, `id\_producator` (FK)
3. **VEHICUL** – tabela centrală care conține stocul parcului auto

   * `id\_masina` (PK), `an\_fabricatie`, `kilometri`, `combustibil`, `serie\_sasiu` (unic), `pret\_lista`, `stare\_vehicul`, `id\_model` (FK)
4. **PROPRIETARI** – date despre foștii deținători ai vehiculelor

   * `id\_proprietar` (PK), `nume\_proprietar`, `tara`
5. **ISTORIC\_PROPRIETARI** – istoricul tranzacțiilor anterioare

   * `id\_proprietar\_masina` (PK), `data\_cumpararii`, `data\_vanzarii`, `pret\_vanzare`, `nr\_inmatriculare`, `id\_masina` (FK), `id\_proprietar` (FK)
6. **MENTENANTA** – lista tipurilor de servicii service

   * `id\_tip\_mentenanta` (PK), `denumire\_mentenanta`
7. **INREGISTRARE\_MENTENANTA** – jurnalul reparațiilor vehiculelor

   * `id\_mentenanta` (PK), `data\_mentenanta`, `cost\_mentenanta`, `descriere`, `id\_masina` (FK), `id\_tip\_mentenanta` (FK)
8. **AMORTIZARE\_VEHICUL** – calculul deprecierii vehiculelor

   * `id\_amortizare` (PK), `data\_depreciere`, `valoarea\_initiala`, `valoarea\_curenta`, `id\_masina` (FK)
9. **TRANZACTII\_BUYBACK** – gestionarea schimburilor auto

   * `id\_buyback` (PK), `diferenta\_pret`, `data\_tranzactie`, `id\_vehicul\_vandut` (FK), `id\_vehicul\_cumparat` (FK)

\---

## Normalizare și Integritate

Baza de date respectă Forma Normală 3 (FN3):

* Atributele sunt atomice (FN1)
* Atributele non-cheie depind complet de cheia primară (FN2)
* Nu există dependențe tranzitive între atributele non-cheie (FN3)
* S-au impus restricții de integritate referențială (FK) pentru a evita vehicule fără model sau reparații fără vehicul asociat

\---

## Cod SQL și Date Exemplu

* Codul sursă definește tabelele și relațiile conform schemei conceptuale.
* Pentru testare, am inserat **15 înregistrări pentru fiecare tabel**.

### Exemple de scenarii implementate:

1. Reducerea stocurilor: -9% pentru vehicule diesel cu rulaj > 200.000 km
2. Ajustarea costurilor de service: +15% pentru reparațiile mașinilor VW
3. Marcarea tranzacțiilor Buy-Back cu diferență negativă
4. Standardizarea descrierilor pentru amortizarea vehiculelor electrice

\---

## Securitate și Recuperare Date

Oracle Database oferă mecanisme de protecție prin **Recycle Bin**:

1. Crearea unei copii de siguranță: tabelă temporară `COPIE\_PRODUCATORI`
2. Simularea ștergerii accidentale: `DROP TABLE`
3. Verificarea indisponibilității
4. Recuperarea datelor: `FLASHBACK TABLE ... TO BEFORE DROP`

\---

## Interogări SQL Exemplu

* **Indicatori de performanță:** jonctiuni între tabele, funcții de agregare (SUM, AVG, COUNT) și scalare
* **Probleme complexe de business:** compararea seturilor de date disjuncte, filtrare dinamică
* **Analiză comercială:** CASE și DECODE pentru categorii de preț și coduri interne, NVL pentru valori nule
* **Rapoarte:** top 3 cele mai scumpe vehicule, relații incomplete (`NOT EXISTS`)

\---

## Obiecte Avansate

1. **Vederi:** `V\_Dashboard\_Vanzari` – raport dinamic pentru management
2. **Indexuri:** `idx\_nume\_insensitive` – căutări rapide, insensitive la majuscule/minuscule
3. **Secvențe:** `se\_facturi\_2025` – generare automată a numerelor de facturi
4. **Sinonime:** `Oferta\_Azi` – simplifică interogările complexe



\---



\## 🚀 Extensie PL/SQL (Programare Avansata)



Aceasta sectiune adauga un strat de inteligenta si automatizare bazei de date, transformand-o intr-un sistem capabil sa gestioneze singur regulile de business.



\### 🛠️ Functionalitati Cheie:



\* \*\*Automatizare si SQL Dinamic:\*\*

&#x20; \* Creare automata de tabele de arhiva si modificari structurale (`ALTER`) in timp real prin `EXECUTE IMMEDIATE`.

\* \*\*Logica Decizionala si Iterativa:\*\*

&#x20; \* Clasificarea automata a vehiculelor pe categorii de pret (`Premium/Standard/Buget`).

&#x20; \* Simulari de calcul prin structuri repetitive (`WHILE`, `FOR REVERSE`).

\* \*\*Gestiune Performanta a Datelor:\*\*

&#x20; \* Utilizarea colectiilor (`Index-by Tables`, `Nested Tables`, `Varrays`) pentru procesarea rapida a datelor in memorie.

&#x20; \* Optimizarea interogarilor masive prin `BULK COLLECT`.

\* \*\*Siguranta si Integritate (Tratarea Exceptiilor):\*\*

&#x20; \* Validarea stricta a datelor (ex: blocarea km negativi sau a vanzarilor in pierdere).

&#x20; \* Capturarea erorilor de sistem si transformarea lor in mesaje personalizate.

\* \*\*Capsulare in Pachete (`PK\_GESTIUNE\_AUTO`):\*\*

&#x20; \* Gruparea functiilor si procedurilor intr-un singur obiect pentru performanta si securitate.

&#x20; \* Functii pentru calculul profitului, uzurii si taxelor vamale.

\* \*\*Declansatori Inteligenti (Triggers):\*\*

&#x20; \* \*\*Nivel Instructiune:\*\* Restrictionarea accesului in afara orelor de program.

&#x20; \* \*\*Nivel Rand:\*\* Corectia automata a datelor si protectia pretului de vanzare.



\---

\*\*Autor:\*\* Zinca Mihai Cristian  

\*\*Tehnologii:\*\* Oracle PL/SQL, Gestiune Tranzactionala, Auditare Automata.

\---


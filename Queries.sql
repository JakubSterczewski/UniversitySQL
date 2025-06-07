-- 1. 2 pytania z wielu tabel z warunkami where nie wliczając warunków złączeniowych
-- 1.1. Pracownicy z wynagrodzeniem większym niż 9000
SELECT o.imie, o.nazwisko, p.wynagrodzenie
FROM personel p, osoba o
WHERE p.osoba_s_numer = o.s_numer
  AND p.wynagrodzenie > 9000;

-- 1.2. Przedmioty, które mają więcej niż 3 ECTS
SELECT p.kod, p.nazwa, z.zaliczenie, p.ects
FROM przedmiot p, zaliczenie z
WHERE p.zaliczenie_kod = z.kod
  AND p.ects > 3
ORDER BY p.ects DESC;

-- 2. Grupujące na wielu tabelach z dodatkowymi (innymi niż złączeniowy) warunkami where
-- 2.1. Ostatni przelew dla każdego pracownika z parzystym s_numerem
SELECT o.imie, o.nazwisko, MIN(t.data) AS "Ostatnia transakcja"
FROM transakcja t, osoba o, personel p
WHERE t.osoba_s_numer = o.s_numer
  AND p.osoba_s_numer = o.s_numer
  AND MOD(o.s_numer, 2) = 0
GROUP BY o.s_numer, o.imie, o.nazwisko;

-- 2. Grupujące na wielu tabelach z warunkami having (w having nie zadajemy warunku na kolumny grupujące)
-- 2.2. Lista studentów z zaległościami
SELECT o.imie, o.nazwisko, SUM(t.kwota) AS suma_wplat, s.naleznosci
FROM transakcja t, osoba o, student s
WHERE t.osoba_s_numer = o.s_numer
  AND s.osoba_s_numer = o.s_numer
GROUP BY o.s_numer, o.imie, o.nazwisko, s.naleznosci
HAVING SUM(t.kwota) < s.naleznosci;

-- 2. Grupujące na wielu tabelach z warunkami where i having
-- 2.3. Grupy ćwiczeniowe z mniej niż 15 studentami
SELECT sg.grupa_kod AS "Grupa", COUNT(*) AS "Liczba studentów"
FROM student_grupa sg
WHERE sg.grupa_kod LIKE '%c'
GROUP BY sg.grupa_kod
HAVING COUNT(*) < 15;

-- 3. 2 pytania, każde z podzapytaniem zwykłym w warunku where
-- 3.1. Pracownicy z wynagrodzeniem mniejszym niż średnie
SELECT o.imie, o.nazwisko, p.wynagrodzenie
FROM personel p, osoba o
WHERE p.osoba_s_numer = o.s_numer
  AND p.wynagrodzenie < (
    SELECT AVG(wynagrodzenie)
    FROM personel
  );

-- 3.2. Przedmioty z zaliczeniem typu egzamin
SELECT *
FROM przedmiot
WHERE zaliczenie_kod IN (
  SELECT kod
  FROM zaliczenie
  WHERE zaliczenie LIKE 'Egzamin%'
);

-- 4. 1 pytanie  z  podzapytaniem zwykłym  w klauzuli from
-- 4.1. Wolne sale w budynku H, o pojemności co najmniej 16, w danym czasie
SELECT s.nr AS sala_nr, s.budynek AS sala_budynek, s.pojemnosc
FROM sala s
LEFT JOIN (
  SELECT p.sala_nr, p.sala_budynek
  FROM plan_jakub_sterczewski_s33164 p
  WHERE p.data = TO_TIMESTAMP('2025-03-24 12:15', 'YYYY-MM-DD HH24:MI')
) zajete ON s.nr = zajete.sala_nr AND s.budynek = zajete.sala_budynek
WHERE s.budynek = 'H'
  AND s.pojemnosc >= 16
  AND zajete.sala_nr IS NULL;

-- 5. 2 pytania, każde z podzapytaniem zwykłym w warunku having
-- 5.1. Pracownicy z większą liczbą zajęć niż wskazana osoba 'Witold Czajka'
SELECT o1.imie, o1.nazwisko, COUNT(*) AS "LICZBA ZAJĘĆ"
FROM plan_jakub_sterczewski_s33164 p1, personel per1, osoba o1
WHERE p1.personel_osoba_s_numer = per1.osoba_s_numer
  AND per1.osoba_s_numer = o1.s_numer
GROUP BY o1.s_numer, o1.imie, o1.nazwisko
HAVING COUNT(*) > (
  SELECT COUNT(*)
  FROM plan_jakub_sterczewski_s33164 p2
  WHERE p2.personel_osoba_s_numer = (
    SELECT p3.osoba_s_numer
    FROM personel p3, osoba o3
    WHERE p3.osoba_s_numer = o3.s_numer
      AND o3.imie || ' ' || o3.nazwisko = 'Witold Czajka'
  )
);

-- 5.2. Najmniejsze grupy ćwiczeniowe
SELECT grupa_kod, COUNT(*) AS "LICZBA STUDENTÓW"
FROM student_grupa sg
WHERE grupa_kod LIKE '%c'
GROUP BY grupa_kod
HAVING COUNT(*) <= ALL (
  SELECT COUNT(*)
  FROM student_grupa
  WHERE grupa_kod LIKE '%c'
  GROUP BY grupa_kod
);

-- 6. 2 pytania, każde z  podzapytaniem skorelowanym w klauzuli where 
-- 6.1. Plan zajęć dla wskazanego ucznia w danym dniu
SELECT p.*
FROM plan_jakub_sterczewski_s33164 p
WHERE TRUNC(p.data) = TO_DATE('2025-03-26', 'YYYY-MM-DD')
  AND EXISTS (
    SELECT 1
    FROM student_grupa sg, student s, osoba o
    WHERE sg.grupa_kod = p.grupa_kod
      AND s.osoba_s_numer = o.s_numer
      AND s.osoba_s_numer = sg.student_osoba_s_numer 
      AND o.imie || ' ' || o.nazwisko = 'Jakub Sterczewski'
  );

-- 6.2. Ostatnie zajęcia pracownika w danym dniu
SELECT o.imie, o.nazwisko, p.data
FROM plan_jakub_sterczewski_s33164 p, personel per, osoba o
WHERE p.personel_osoba_s_numer = per.osoba_s_numer
  AND per.osoba_s_numer = o.s_numer
  AND TRUNC(p.data) = TO_DATE('2025-03-28', 'YYYY-MM-DD')
  AND p.data = (
    SELECT MAX(p2.data)
    FROM plan_jakub_sterczewski_s33164 p2
    WHERE p2.personel_osoba_s_numer = p.personel_osoba_s_numer
      AND TRUNC(p2.data) = TO_DATE('2025-03-28', 'YYYY-MM-DD')
  );

-- 7. 1 pytanie z podzapytaniem  skorelowanym w warunku having
-- 7.1. Sale najbardziej oblegane w każdym budynku w danym dniu
SELECT p1.sala_budynek, p1.sala_nr, COUNT(*) AS "LICZBA ZAJĘĆ"
FROM plan_jakub_sterczewski_s33164 p1
WHERE TRUNC(p1.data) = TO_DATE('2025-03-26', 'YYYY-MM-DD')
GROUP BY p1.sala_budynek, p1.sala_nr
HAVING COUNT(*) = (
  SELECT MAX(COUNT(*))
  FROM plan_jakub_sterczewski_s33164 p2
  WHERE p1.sala_budynek = p2.sala_budynek
    AND TRUNC(p2.data) = TO_DATE('2025-03-26', 'YYYY-MM-DD')
  GROUP BY p2.sala_nr
);
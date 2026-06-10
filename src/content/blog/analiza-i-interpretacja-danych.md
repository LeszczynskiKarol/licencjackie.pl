---
title: "Analiza i interpretacja danych w pracy dyplomowej"
description: "Sposób zbierania, analizy i interpretacji danych w pracy naukowej krok po kroku: kodowanie danych, statystyki opisowe, opis tabel i dyskusja wyników, z przykładami."
publishDate: 2026-06-10
author: "Redakcja Licencjackie.pl"
category: "Metodologia"
tags: ["analiza danych", "interpretacja wyników", "badania", "praca dyplomowa", "statystyka", "metodologia"]
image: "/blog/analiza-i-interpretacja-danych.jpg"
imageAlt: "Analiza i interpretacja danych w pracy dyplomowej"
featured: false
draft: false
showSmartEduCTA: true
---

<p>Masz za sobą badania: 80 wypełnionych ankiet, kilka wywiadów albo plik z danymi z pomiarów. I właśnie w tym momencie utyka większość dyplomantów, bo nikt wcześniej nie pokazał im, co zrobić między „zebrałem dane" a „napisałem rozdział z wynikami". W tym artykule przechodzimy przez cały sposób zbierania, analizy i interpretacji danych w pracy naukowej (licencjackiej czy magisterskiej): od porządkowania surowego materiału, przez wybór metody analizy, po dyskusję wyników, której promotorzy i recenzenci przyglądają się najuważniej.</p>

<h2>Analiza to nie to samo co interpretacja</h2>

<p>Te dwa pojęcia bywają używane wymiennie, a w pracy dyplomowej pełnią różne funkcje i często lądują w osobnych podrozdziałach. Analiza odpowiada na pytanie „co wyszło w badaniu": polega na ilościowej lub jakościowej obróbce zebranych danych, czyli policzeniu, zestawieniu i uporządkowaniu wyników w tabele i wykresy. Interpretacja odpowiada na pytanie „co to znaczy": wyniki ocenia się w odniesieniu do postawionych hipotez, teorii przedstawionych w części teoretycznej i rezultatów innych badaczy.</p>

<p>Wytyczne uczelniane zwykle odzwierciedlają ten podział wprost. Rozdział z wynikami prezentuje zebrane dane wraz ze sposobem ich statystycznego opracowania, a dopiero dyskusja (nazywana też interpretacją wyników) konfrontuje je z hipotezami i literaturą. Jeśli Twoja uczelnia publikuje zasady dyplomowania, sprawdź je przed pisaniem: układ tych rozdziałów bywa narzucony co do podpunktu.</p>

<h2>Zbieranie i porządkowanie danych: zanim cokolwiek policzysz</h2>

<p>Pierwszy krok wykonuje się jeszcze przed otwarciem arkusza: trzeba sprawdzić kompletność zebranego materiału. Ankiety wypełnione częściowo, przerwane w połowie albo wypełnione ewidentnie mechanicznie (ta sama odpowiedź we wszystkich pytaniach) odrzuca się przed analizą, a liczbę odrzuconych kwestionariuszy odnotowuje w opisie próby. O tym, jak zaprojektować i przeprowadzić samo badanie kwestionariuszowe, piszemy w osobnym tekście o <a href="/blog/ankieta-w-pracy-magisterskiej">ankiecie w pracy magisterskiej</a>.</p>

<p>Punktem wyjścia do każdych obliczeń jest uporządkowany zbiór danych, a w praktyce studenckiej wystarczy do tego Excel. Dane wpisuje się w postaci macierzy: każdy wiersz to jeden respondent, każda kolumna to odpowiedź na jedno pytanie. Zanim zaczniesz wpisywać, opracuj klucz kodowy, czyli zamień odpowiedzi na liczby według jednolitego schematu, na przykład: płeć: 1 = mężczyzna, 2 = kobieta; częstość występowania objawów: 1 = często, 2 = czasami, 3 = nigdy.</p>

<p>Kodowanie wymaga też ujednolicenia odpowiedzi otwartych. Jeżeli respondenci wpisywali zawód ręcznie, „nauczycielka", „nauczyciel WF" i „pracuję w szkole" muszą trafić do jednej kategorii, którą sam zdefiniujesz. Ten etap wydaje się nudny, ale decyduje o wszystkim, co nastąpi później: błąd w macierzy danych przenosi się na każdą tabelę i każdy wniosek w pracy.</p>

<h2>Analiza ilościowa: co wystarczy w pracy licencjackiej</h2>

<p>Dobra wiadomość: wymagania rosną ze stopniem. W pracy licencjackiej badaną grupę charakteryzuje się zwykle przez procenty i statystykę opisową. Testy statystyczne, takie jak t-Studenta (porównywanie średnich dwóch grup) czy chi-kwadrat (zależności między cechami niemierzalnymi), są standardem dopiero w pracach magisterskich. Podstawowy zestaw miar, który warto znać i rozumieć:</p>

<ul>
<li><strong>średnia arytmetyczna</strong> pokazuje przeciętne położenie badanej cechy: sumę wszystkich wartości dzielimy przez liczebność grupy,</li>
<li><strong>odchylenie standardowe</strong> mówi, jak mocno wyniki rozrzucone są wokół średniej; im mniejsza wartość, tym bardziej wyniki skupiają się przy średniej,</li>
<li><strong>rozstęp</strong> to różnica między najwyższą a najniższą wartością w próbie; pokazuje, w jak szerokich granicach mieszczą się wyniki,</li>
<li><strong>odsetki</strong> określają, jaka część grupy należy do danej kategorii.</li>
</ul>

<p>Jeśli chcesz pójść krok dalej, w pracy licencjackiej dobrze sprawdza się korelacja Pearsona, która mierzy zależność statystyczną między dwiema zmiennymi. Współczynnik korelacji przyjmuje wartości od -1,0 (idealna korelacja ujemna) do +1,0 (idealna dodatnia). Znak mówi tylko o kierunku zależności; jej siłę odczytuje się z wartości bezwzględnej współczynnika, według przyjętych progów:</p>

<table>
<thead>
<tr>
<th>Wartość bezwzględna współczynnika |r|</th>
<th>Siła zależności</th>
</tr>
</thead>
<tbody>
<tr>
<td>0,0</td>
<td>brak korelacji</td>
</tr>
<tr>
<td>poniżej 0,3</td>
<td>korelacja słaba</td>
</tr>
<tr>
<td>0,3–0,7</td>
<td>korelacja umiarkowana</td>
</tr>
<tr>
<td>powyżej 0,7</td>
<td>korelacja silna</td>
</tr>
</tbody>
</table>

<p>Przy okazji jedna subtelność językowa, którą docenią recenzenci: gdy korelacja nie wychodzi, nie piszemy, że „zależność między cechami nie istnieje", tylko że „na podstawie dokonanych pomiarów nie stwierdzono zależności". Twoja próba mogła jej po prostu nie uchwycić. Podstawy samej statystyki rozwijamy w osobnym tekście o <a href="/blog/statystyka-praca-licencjacka">statystyce w pracy licencjackiej</a>.</p>

<h2>Analiza jakościowa: kodowanie zamiast liczenia</h2>

<p>Nie każde badanie da się ująć w liczbach. Wywiady, odpowiedzi otwarte czy dokumenty analizuje się jakościowo, a trzy najczęściej spotykane podejścia różnią się tym, czego szukasz w materiale. W analizie tematycznej identyfikujesz powtarzające się wątki i grupujesz je w kategorie. Analiza treści zmierza do policzenia, jak często w materiale pojawiają się określone elementy, więc stoi na granicy podejścia ilościowego. Analiza narracyjna skupia się z kolei na tym, jak badani opowiadają swoją historię: jaką nadają jej strukturę i jakie znaczenia przypisują wydarzeniom.</p>

<p>Niezależnie od podejścia obowiązuje ta sama zasada rzetelności: każda kategoria i każdy wniosek muszą mieć pokrycie w materiale. W praktyce oznacza to cytowanie wypowiedzi badanych jako materiału dowodowego, z oznaczeniem respondenta (np. „W12" dla dwunastego wywiadu), żeby czytelnik widział, skąd pochodzi przykład.</p>

<h2>Jak opisać wyniki, żeby nie powtarzać tabel słowami</h2>

<p>Tabele i wykresy podlegają prostym wymogom formalnym: każdy element graficzny musi mieć tytuł, kolejny numer i wskazane źródło (przy danych własnych będzie to formuła „Źródło: opracowanie własne"), a jeśli używasz kolorów, także legendę. Recenzenci sprawdzają te detale w pierwszej kolejności, bo zajmuje to chwilę.</p>

<p>Trudniejsza część to opis pod tabelą. Najczęściej powtarzany błąd polega na opisowym streszczaniu jej zawartości, czyli przepisywaniu zdaniami tego, co czytelnik widzi w komórkach. Opis powinien dawać interpretację i wskazywać to, co trudno dostrzec na pierwszy rzut oka: dominującą kategorię, nietypowe odchylenie, różnicę między podgrupami. Zobacz, jak wygląda poprawne, zwięzłe omówienie z realnej pracy o opiekunach osób chorych: „Średni wiek badanych opiekunów wynosił 48,4 lat. Najmłodszy opiekun miał 20 lat, natomiast najstarszy 85. Odchylenie standardowe równe było 14,5 roku, co oznacza, że badani reprezentowali głównie grupę wiekową między 34. a 62. rokiem życia". Trzy zdania, a czytelnik wie więcej, niż mówi sama tabela.</p>

<h2>Interpretacja, czyli dyskusja wyników</h2>

<p>Dyskusja jest tym fragmentem pracy, w którym przestajesz relacjonować, a zaczynasz myśleć na piśmie. Punkt wyjścia stanowią hipotezy: każdą trzeba rozstrzygnąć (potwierdzona, odrzucona, potwierdzona częściowo) i uzasadnić to konkretnymi wynikami. Następnie wyniki konfrontuje się z teorią i badaniami przywołanymi w części teoretycznej. Wytyczne uczelniane sprowadzają to do trzech pytań, które działają jak gotowy szkielet rozdziału:</p>

<ul>
<li>Na ile wyniki badań własnych są zbieżne z wynikami innych autorów?</li>
<li>Co nowego wnoszą badania własne?</li>
<li>W jaki sposób należałoby te badania zmodyfikować lub rozwinąć w przyszłości?</li>
</ul>

<p>Do dyskusji należy też uczciwe omówienie ograniczeń badania: małej próby, doboru celowego, narzędzia własnej konstrukcji. Wbrew obawom studentów taki akapit nie obniża oceny. Pokazuje, że rozumiesz, co właściwie zrobiłeś i jak daleko sięgają Twoje wnioski. Przemilczanie słabych punktów nie ma zresztą praktycznego sensu, ponieważ recenzent zwykle dostrzega je już przy pierwszej lekturze.</p>

<h2>Ile czasu na to zaplanować</h2>

<p>Analiza danych regularnie zajmuje więcej czasu, niż zakładają harmonogramy pisane na początku semestru. Realistyczne widełki z poradników planowania pracy dyplomowej: analiza zebranych danych wraz z przygotowaniem tabel i wykresów to 3–4 tygodnie, a sama interpretacja wyników dodatkowy tydzień. Efektem tego etapu jest rozdział empiryczny liczący zwykle 15–20 stron. Warto wpisać w plan konsultację z promotorem po wstępnych analizach, a przed napisaniem dyskusji: jeśli kierunek interpretacji wymaga korekty, na tym etapie poprawisz go szybko, natomiast po napisaniu całego rozdziału oznacza to pisanie dużej części od nowa. Jeśli dopiero projektujesz badanie, zajrzyj też do tekstu o <a href="/blog/badania-w-pracy-magisterskiej">prowadzeniu badań w pracy dyplomowej</a>.</p>

<h2>Najczęstsze błędy w analizie i interpretacji danych</h2>

<ul>
<li>przepisywanie zawartości tabel zdaniami zamiast ich interpretowania,</li>
<li>wnioski bez pokrycia w danych, zwłaszcza uogólnianie wyników małej próby na całą populację,</li>
<li>mylenie korelacji z przyczynowością: współwystępowanie dwóch zjawisk nie dowodzi, że jedno wywołuje drugie,</li>
<li>dyskusja bez odniesienia do hipotez postawionych w części metodologicznej,</li>
<li>pomijanie wyników niewygodnych dla założonej tezy,</li>
<li>tabele i wykresy bez numeracji, tytułów i źródła,</li>
<li>brak omówienia ograniczeń badania.</li>
</ul>

<p>Analiza i interpretacja danych to etap, na którym praca dyplomowa przestaje być referatem z literatury, a staje się badaniem. Dane uporządkuj w macierz z kluczem kodowym, dobierz miary do stopnia pracy, opisuj tabele tak, by dodawać wiedzę zamiast ją powtarzać, a dyskusję zbuduj wokół hipotez i trzech pytań o zbieżność, nowość i kierunki dalszych badań. Tak poprowadzony rozdział empiryczny broni się sam, na długo przed obroną.</p>

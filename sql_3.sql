create database tanfolyam default character set utf8mb4 collate utf8mb4_general_ci;

create table tanulok(
    id int primary key auto_increment,
    nev varchar(100) not null,
    telefonszam varchar(100) not null,
    szuletesiido date not null,
    email varchar(100) not null unique
)

create table tantargyak(
    id int primary key auto_increment,
    megnevezes varchar(100) not null unique, 
    tanar varchar(100) not null
)

create table ertekelesek(
    id int primary key auto_increment,
    tanuloid int not null,
    tantargyid int not null,
    jegy int not null,
    foreign key ertekelesek(tanuloid) references tanulok(id),
    foreign key ertekelesek(tantargyid) references tantargyak(id)
)

/*
    1. csináltunk egy database-t, aminek megadtuk a charset-jét a set character-vel és utána a collate-t is használuk
        create database tanfolyam set character utf8mb4 collate utf8mb4_general_ci;
    2. megcsináltuk a második create-eket, ahol a table-eket csináljuk a meglévő database-ben 
        fontos dolgok 
        - mindegyiknek legyen egy id-ja, ami egy int primary key auto_increment 
        - a harmadik table-ben csinálunk foreign key-eket, amivel majd össze tudjuk kötni az összes table, mindegyiket majd a tanulok 
        primary key-éhez fogjuk kötni 
        itt a harmadikban tehát lesz majd egy olyan mezőket, hogy tanuloid és tantargyid, ezelhez fogjuk majd kötni a tanulok id-ját 
            foreign key ertekelesek(tanuloid) references tanulok(id)
            foreign key ertekelesek(tantargyid) references tanulok(id)
        -> 
        amelyik table-ben vannak a foreign key-eink ott kell majd megadni, hogy mihez fogjuk majd kötni őket, mindig ez a színtaktika 
        -> 
        foreign key table neve, ahol vagyunk(mező, amit majd hozzá karunk kötni) references table neve, amit hozzá akarunk kötni(primary key)

        és akkor már meg van a table az is, hogy melyik a primary key és a foreign key, amihez majd kötjük őket 

        Most kell majd az INSERT INTO-val feltölteni a mezőket, minden egyes table-nek a VALUES-val 
        ********************************************************************************
*/

/*
    1.

    A tanfolyamon jelenleg 2 tantárgyat tanítanak. Hozza létre a két rekordot a tantárgyak táblában 

    Tehát a tantargyak table-t kell majd feltölteni és két mező van, amit itt meg kell majd adni, mert az id az alapból auto_increment 
    ->
    create table tantargyak(
    id int primary key auto_increment,
    megnevezes varchar(100) not null unique, 
    tanar varchar(100) not null
)
*/

INSERT INTO tantargyak(megnevezes, nev) 
VALUES('Angol nyelv', 'Nemes Angéla'), /*fontos, hogy itt vesssző legyen ha így viszunk fel több dolgot*/
('Informatika', 'Kis Ede');

/*
    2. 

    Az első napon 3 diák iratkozott be. Hozza létre a 3 rekordot a tanulok táblában 

    Ugyanyilyen INSERT INTO VALUES  metódus, csak most a másik táblát töltjük fel rekordokkal 
    ha valamelyiknek pl.itt nem adott meg telefonszámot, akkor a felvitelt külön kell majd megcsinálni és ott majd null lesz a 
    telefonszám értéke, tehét ha nem teljesen ugyanazokkal a mezőkkel akarunk felvinni egy rekordot egy adott táblába, akkor azt 
    külön insert into-val kell majd megcsinálni!!!!!  

    create table tanulok(
    id int primary key auto_increment,
    nev varchar(100) not null,
    telefonszam varchar(100) not null,
    szuletesiido date not null,
    email varchar(100) not null unique
)
*/

insert into tanulok(nev, szuletesiido, email) 
values('Kovács Elek', '1991-02-28', 'elek0228@email.com');
/*fontos, hogyha a mező értéke az date, akkor is ''-ba visszük fel majd az értéket*/

INSERT INTO tanulok(nev, telefonszam, szuletesiido, email)
VALUES('Nagy Béla', '+36-55-475319', '1987-06-16', 'nagy.bela@drotposta.com'),
VALUES('Tóth Emil', '+36-55-475319', '1987-06-16', 'emil@e-level.com');

/*
    3. 

    Kovács Elek kapott egy 3-ast anol nyelvből 
    Informatikából mindenki kapott egy 5-öst
    Kovács Elek kapott egy 5-öst angolból 

    create table ertekelesek(
    id int primary key auto_increment,
    tanuloid int not null,
    tantargyid int not null,
    jegy int not null,
    foreign key ertekelesek(tanuloid) references tanulok(id),
    foreign key ertekelesek(tantargyid) references tantargyak(id)
)

    Ez is egy insert lesz és majd az értékelések táblába kell majd felvinni
    2 lehetőség van, hogy vigyük majd fel az adatokat, mivel a másik táblából tudjuk, hogy az angol nyelv-nek a tantargyid-ja az 1 és 
    a tanulokban a Kovács Elek az tanuloid egy, ezért kézzel be tudjuk írni ezekezt az értékeket és a jegyet is(azt máshogy) nem is lehetne, 
    mert itt majd csak egy számot kell majd megadni
*/

INSERT INTO ertekelesek(tanuloid, tantargyid, jegy)
VALUES(1, 1, 3);

/*
    Második lehetőség, hogy ugyanúgy az értékelések-be ezeket mezőket kell majd megadni, de nem úgy, hogy tanuloid 1, tantargyid 1 
    hanem egy alleérdezéssel SELECT FROM, ott kiválasztjuk, hogy tanulok táblából ahhoz akarunk beírni, ahol a név Kovács Elek, tehét itt kell WHERE
    és mivel a foreign key ertekeleesk(tanuloid) össze van kötve a tanuluk(id)-val és a tanulok táblában az 1-es a Kovács Elek 
    ezért a kettőnek ugyanaz kell, hogy legyen az értéke, mert ezzel van összekötve a két tábla 
    -> foreign key ertekelesek(tanuloid) references tanulok(id)
        és a tantargyaknak ugyanez csak ott majd a select nem a tanulok lesz hanem a tantargyak és a WHERE-nél pedig a megnevezes kell, hogy 
        angol nyelv legyen!!!!! 
*/

INSERT INTO ertekelesek(tanuloid, tantargyid, jegy)
VALUES(
    (SELECT FROM tanulok WHERE nev = 'Kovács Elek'), 
    (SELECT FROM tantargyak WHERE megnevezes = 'Angol nyelv'),
    3
);
/*
    Nagyon fontos, hogy itt van 2 zárójel 
    1. kell a VALUES()-nak is 
    2. kell az allekérdezésnek is (select .... )
*/

/*informatika 5-ös mindenkinek*/
insert into ertekelesek(tanuloid, tantargyid, jegy) 
values(
    (select from tanulok where nev = 'Kovács Elek'),
    (select from tantargyak where megnevezes = 'informatika'),
    5
);

insert into ertekelesek(tanuloid, tantargyid, jegy)
values(
    (select from tanulok where nev = 'Nagy Béla'),
    (select from tantargyak where megnevezes = 'Informatika'),
    5 
);

INSERT INTO ertekelesek(tanuloid ,tantargyid, jegy)
VALUES(
    (SELECT FROM tanulok WHERE nev = 'Tóth Emil'),
    (SELECT FROM tantargyak WHERE megnevezes = 'Informatika'),
    5
);

/*Kovács Elek 5-ös angolból*/

INSERT INTO ertekelesek(tanuloid, tantargyid, jegy) 
VALUES(1, 1, 5);

/*
    Készítsen lekérdezést, amely tartalmazza Kovács Elek minden jegyét! 
    A lekérdezésben jelenjen meg a tantárgy neve és az érdemjegy 

1.
Mire vagyunk kiváncsiak tehát mit kell majd select-elni - és az melyik táblában található meg és melyik mező pontosan 
tantárgy neve -> tantargyak table megnevezes mező -> tantargyak.megnevezes 
érdemjegy -> ertekelesek table jegy mező -> ertekelesek.jegy 
Tehét ez a kettő kell, hogy legyen majd a select-ben tantargyak.megnevezes, ertekelesek.jegy 

és még az is fontos lesz, hogy majd a Kovács Eleknek kell majd megadni ezeket a dolgokat, ezért a tanulok table-t is hozzá kell majd kötni!!! 
moghozzá ott (WHERE) ahol a nev az Kovács Elek lesz 

2.
Melyik tablából akarjuk majd leszedni az adatokat -> itt mindig majd ertekelesek lesznek, mert ott van két foreign key, amivel össze vannak 
kapcsolva a táblák 
Tehát ez lesz a FROM, mert ha van SELECT, akkor biztos, hogy kell lennie FROM-nak is 

3. Kell egy INNER JOIN, illetve kettő, mert azt mondtuk, hogy az tantargyak-at meg a tanulokat is hozzá kell majd kötni
mert a tantargyakból mindenre kivácsiak vagyunk a tanulokból meg csak a Kovács Elekre 
És az összeKapcsolás az egy INNER JOIN lesz és majd ON-ba meg kell határozni, hogy hol van az összekapcsolás 

Tehát 
SELECT tantargyak.megnevezes, ertekelesek.jegy (ezek fognak majd megjelenni)
FROM ertekelesek (mert itt van összekötve az összes tábla)
INNER JOIN tantargyak 
ON tantargyak.id = ertekelesek.tantargyid
INNER JOIN tanulok
ON tanulok.id = ertekelesek.tanuloid
WHERE tanulok.nev = 'Kovács Elek' (mert rá vagyunk majd kiváncsiak, de ezt meg lehet csinálni egy allekérdezéssel is) 
tehát nekünk csak ő kell itt nem az összes adat, ha mondjuk csak az angol jegyei kellettek volna, akkor a tantargyaknal is kellett volna egy 
WHERE ahol tantargyak.megnevezes = 'Angol nyelv'
*/

SELECT tantargyak.megnevezes, ertekelesek.jegy
FROM ertekelesek
INNER JOIN tantargyak 
ON tantargyak.id = ertekelesek.tantargyid
INNER JOIN tanulok
ON tanulok.id = ertekelesek.tanuloid
WHERE tanulok.nev = 'Kovács Elek';

/*
    Gondolkodásmenet
    1. mit kell lekérdezni, melyik táblákból adatokat 
    2. le tudom-e kérdezni egy tablából 
        ha igen akkor csak egy sima SELECT FROM 
        ha nem akkor össze kell kötni a táblákat INNER JOIN-val (mindig abból indulunk ki ahol van a foreign key)
            annak kell lennie a FROM-nak
        melyik értékek alapján kapcsolom össze a táblákat ON itt mindig aminek meg van adva a foreign key, tehát ezek 
            foreign key ertekelesek(tanuloid) references tanulok(id),
            foreign key ertekelesek(tantargyid) references tantargyak(id)
    3. ott milyen adatokra van szükségem összes, akkor nem kell csinálni semmit ha pedig van kikötés, akkor azt vagy a WHERE-vel 
        vagy egy allekérdezéssel kell csinálni!!!! 
    De ami nagyon fontos itt hogyha allekérdezás van, akkor nem kell join-olni azt a táblát hanem csinálunk ott egy select-et!!!! 
*/

SELECT tantargyak.megnevezes, ertekelesek.jegy
FROM ertekelesek
INNER JOIN tantargyak 
ON tantargyak.id = ertekelesek.tantargyid
WHERE ertekelesek.tanuloid = 
(SELECT id FROM tanulok WHERE nev = 'Kovács Elek');

/*
    Tehét itt nem csatoltuk INNER JOIN-val a tanulok táblát, hanem WHERE-vel ertekelesek.tanuloid-t amihez már hozzáférünk össuekötöttük 
    egy másik lekerdezéssel ahol a FROM tanulok tablából a SELECT és ott tesszük meg a kikötést, hogy nev = 'Kovács Elek'
    és ne úgy, hogy hozzá van kötve a tábla és ott tanulok.nev = 'Kovács Elek'
*/

/*
    4. 

    Készítsen lekérdezést, ami megjeleníti a tantárgyakat és a tantárgyhoz tartazó jegyek átlagát 

    Mit kell itt megjeleníteni, melyik táblán vannak, hogy férünk hozzá, ahhoz a táblához 
    1. tantárgyak táblán vannak a megnevezések, tehát, hogy melyik tantárgyról van szó -> tantárgyak.megnevezés 
    2. értékelésen vannak a jegyek, de fontos, hogy itt egy átlag kell, ezért használjuk az AVG metódust -> AVG(ertekelsek.jegyek)
        Tehát kell nekünk a tantargyak és az ertekelesek tábla 
    Melyik tablán vannak összekötve a dolgok
        -> ertekelesek, tehát biztos, hogy ez lesz a select-nek a FROM-ja 
    Össze kell kötni a táblákat, tehát a értékelések táblából kell kiindulni, mert itt van egy foreign key-vel összekötve a tantargyak 
    -> INNER JOIN tantargyak 
    Mi alapján kell összekötni (ON), ami a foreign key-hez van megadva a primary key a tantargyaknál 
    tantargyak.id = ertekelesek.tantargyid 

    Nagyon fontos, hogy van itt egy GROUP BY, hogy mi alapján szeretnénk rendezni a megjelenő találatokat, ez pedig a tantargyak.id lesz 
    és akkor úgy fog megjelenni, hogy angol nyelv és egy átlag, informatika és annak az átlaga 
*/

SELECT tantargyak.megnevezes, AVG(ertekelesek.jegy)
FROM ertekelesek
INNER JOIN tantargyak 
ON ertekelsek.tantargyid = tantargyak.id
GROUP BY tantargyak.id;

/*
    Kérdezze le a tanulók nevét, akiknek még nincs egyetlen jegye sem angolból 

    Mit kell lekérdezni a nevet a tanulok tablából 
    Mi szerint nincsen egyetlen jegye sem angolból -> WHERE NOT EXISTS
    Itt kell tanuloid kell majd nekünk a ertelesekbők és ez egyenlő lesz majd a tanulok.id-val, hogy tudjuk, hogy melyik tanuloról van szó 
    a eretekelesek táblán 
    és ott kell majd a WHERE beállítani tartargyid = 1, tehát angolból 
*/

select nev from tanulok 
where not exists(select tanuloid from ertekelesek
where tanulok.id = ertekelesek.tanuloid and ertekelesek.tantargyid = 1);
/*
    Tehát meg fogjuk jeleníteni a nev-et a tanulok táblából, egy allekérdezéssel kell a tanuloid az értékeléseknél, hiszen tanuloid-val
    van összekötve a két tábla és a tanulok táblához és ertekelesek tantargyid-t pedig beállítjuk 1-re, mert angol nyelvből kérdezte
*/

SELECT nev, TIMESTAMPDIFF(YEAR, szuletesiido, now())
FROM tanulok;

/*
    Year, hogy évben adja meg és a szuletesiido-től egy now(), tehát mostanáig!!! 
    Itt egy táblán vannak a dolgok, tehát nem kell semmi összekötés, csak megjelenítjük ezeket a dolgokat!!! 
*/




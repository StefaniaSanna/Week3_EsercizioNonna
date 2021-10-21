create database RicetteNonna;

create table Libro(
IDLibro int not null,
Titolo nvarchar(40) not null,
Tipologia nvarchar(30) not null check (Tipologia = 'PrimiPiatti' or Tipologia = 'SecondiPiatti' or Tipologia = 'Dolci'),

constraint PK_Libro primary key (IDLibro)
);

create table Ingrediente(
IDIngrediente int not null,
Nome nvarchar(30) not null,
Descrizione nvarchar(50) not null,
UnitaDiMisura nvarchar(10) not null,

constraint PK_Ingrediente primary key (IDIngrediente)
);

create table Ricetta(
IDRicetta int not null,
Nome nvarchar(40) not null,
TempoDiPreparazione int not null,
NumeroPersone int not null,

constraint PK_Ricetta primary key (IDRicetta),
IDLibro int not null constraint FK_Libro_Ricetta foreign key references Libro(IDLibro)
);


create table Ricetta_Ingrediente(
IDIngrediente int not null,
IDRicetta int not null,
Quantità int not null,

constraint FK_Ingrediente foreign key (IDIngrediente) references Ingrediente(IDIngrediente),
constraint FK_Ricetta foreign key (IDRicetta) references Ricetta(IDRicetta),
constraint PK_Ingr_Ric primary key(IDIngrediente,IDRicetta)
);


--Proviamo l'inserimento Dati
Insert into Libro values (1, 'Le ricette di Stefania','Dolci'); 
Insert into Libro values (2, 'Le ricette di Stefania il ritorno', 'PrimiPiatti'); 
Insert into Libro values (3, 'Le delizie finali di Stefania', 'SecondiPiatti');

Insert into Ingrediente values (1,'Farina', 'Tipo 00', 'grammi');
Insert into Ingrediente values (2,'Uova', 'Di gallina', 'grammi');
Insert into Ingrediente values (3, 'Latte', 'Scremato', 'cl');

Insert into Ricetta values (1, 'Frittata', 3, 2,3);
Insert into Ricetta values (2,'Crepes', 5, 6,1);
Insert into Ricetta values (3,'Gnocchi di patate',30,4,2);

Insert into Ricetta_Ingrediente values (2,1, 200);
insert into Ricetta_Ingrediente values (3,2,150), (1,3,500);

--Select
select*
from Libro; --Me li fa vedere tutti

select * 
from Ricetta_Ingrediente
where  Quantità> 150; --Me ne fa vedere filtrati con un criterio

--Update

update Ricetta set Nome = 'Crepes dolci' where IDRicetta=2; --Sto modificando un campo

select * from Ricetta;

Insert into Ricetta values (4, 'Torta di mele', 120, 10,1);
insert into Ricetta values (5, 'Crema pasticcera', 20, 3,1);
insert into Ricetta_Ingrediente values (3,5,200)

insert into Ricetta_Ingrediente values (2,2,4)


--Cancelliamo quest'ultima ricetta

delete from Ricetta where IDRicetta=4;


--ESERCIZI
--1.Visualizzare tutta la lista degli ingredienti distinti.
select distinct i.Nome
from Ingrediente i

--2.Visualizzare tutta la lista degli ingredienti distinti utilizzati in almeno una ricetta.

select distinct i.Nome
from Ingrediente i join Ricetta_Ingrediente ri on i.IDIngrediente=ri.IDIngrediente


--3.Estrarre tutte le ricette che contengono l’ingrediente uova.

select r.*
from Ingrediente i join Ricetta_Ingrediente ri on i.IDIngrediente=ri.IDIngrediente
join Ricetta r on r.IDRicetta=ri.IDRicetta
where i.Nome ='uova'

--4.Mostrare il titolo delle ricette che contengono almeno 4 uova

select r.Nome
from Ingrediente i join Ricetta_Ingrediente ri on i.IDIngrediente=ri.IDIngrediente
join Ricetta r on r.IDRicetta=ri.IDRicetta
where i.Nome ='uova' and ri.Quantità >=4

--5.Estrarre tutte le ricette dei libri di Tipologia=Secondi per 4 persone contenenti l’ingrediente carne

insert Ingrediente values (4,'Carne','Bovina', 300)
insert Ricetta values (6,'Polpettone',140,4,3)
insert Ricetta_Ingrediente values (4,6,500)

select r.Nome
from Libro l join Ricetta r on r.IDLibro=l.IDLibro
join Ricetta_Ingrediente ri on ri.IDRicetta= r.IDRicetta
join Ingrediente i on i.IDIngrediente=ri.IDIngrediente
where l.Tipologia = 'SecondiPiatti' and r.NumeroPersone =4 and i.Nome ='carne'

--6.Mostrare tutte le ricette che hanno un tempo di preparazione inferiore a 10 minuti.
select*
from Ricetta r
where r.TempoDiPreparazione < 10

--7.Mostrare il titolo del libro che contiene più ricette

select count(r.IDRicetta)
from Libro l join Ricetta r on l.IDLibro=r.IDLibro
where l.Titolo ='Le ricette di Stefania'

select count(r.IDRicetta)
from Libro l join Ricetta r on l.IDLibro=r.IDLibro
where l.Titolo ='Le ricette di Stefania il ritorno'

select count(r.IDRicetta)
from Libro l join Ricetta r on l.IDLibro=r.IDLibro
where l.Titolo ='Le delizie finali di Stefania'







--8.Visualizzare i Titoli dei libri ordinati rispetto al numero di ricette che contengono 
--(il libro che con-tiene più ricette deve essere visualizzato per primo, quello con meno ricette per ultimo) e, 
--a parità di numero ricette in ordine alfabetico su Titolo del libro.

--7 fatta normale
select Tit
from (
select l.Titolo as Tit, count (r.IDRicetta) as 'NumeroRicette'
from Libro l join Ricetta r on r.IDLibro=l.IDLibro
group by l.Titolo)
 as Tabella_Libro_NumeroRicette

 where NumeroRicette = (select max(NumeroRicette) from (
select l.Titolo as Tit, count (r.IDRicetta) as 'NumeroRicette'
from Libro l join Ricetta r on r.IDLibro=l.IDLibro
group by l.Titolo) as Tabella_Libro_NumeroRicette)



-- nuova vista 
create view Tabella_Libro_NumeroRicette(Tit,NumeroRicette) --non è un vero errore
as (select l.Titolo as Tit, count (r.IDRicetta) as 'NumeroRicette'
from Libro l join Ricetta r on r.IDLibro=l.IDLibro
group by l.Titolo)


--7 con nuova vista
select Tit
from Tabella_Libro_NumeroRicette
where NumeroRicette = (select max(NumeroRicette) from Tabella_Libro_NumeroRicette)


--Esercizio 8

select*
from (
select l.Titolo as Tit, count (r.IDRicetta) as 'NumeroRicette'
from Libro l join Ricetta r on r.IDLibro=l.IDLibro
group by l.Titolo)
 as Tabella_Libro_NumeroRicette
 order by NumeroRicette desc, Tit














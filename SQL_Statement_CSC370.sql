/*Exercise 1*/

create table Classes(
    class varchar(20),
    atype char(2),
    country varchar(20),
    numGuns int,
    bore int,
    displacement int
);

create table Ships(
    name varchar(20),
    class varchar(20),
    launched int
);

create table Battles(
    name varchar(20),
    date_fought date
);

create table Outcomes(
    ship varchar(20),
    battle varchar(2),
    aresult varchar(20)
);

insert into classes values('Bismarck','bb','Germany',8,15,42000);
insert into classes values('Kongo','bc','Japan',8,15,32000);
insert into classes values('North Carolina','bb','USA',9,16,37000);
insert into classes values('Renown','bc','Gt.Britain',6,15,32000);
insert into classes values('Revenge','bb','Gt.Britain',8,15,29000);
insert into classes values('Tennessee','bb','USA',12,14,32000);
insert into classes values('Yamato','bb','Japan',9,18,65000);


insert into ships values('California','Tennessee',1921);
insert into ships values('Haruna','Kongo',1915);
insert into ships values('Hiei','Kongo',1914);
insert into ships values('Iowa','Iowa',1943);
insert into ships values('Kirishima','Kongo',1914);
insert into ships values('Kongo','Kongo',1913);
insert into ships values('Missouri','Iowa',1944);
insert into ships values('Musashi','Yamato',1942);
insert into ships values('New Jersey','Iowa',1943);
insert into ships values('North Carolina','North Carolina',1941);
insert into ships values('Ramilles','Revenge',1917);
insert into ships values('Renown','Renown',1916);
insert into ships values('Repulse','Renown',1916);
insert into ships values('Resolution','Revenge',1916);

insert into ships values('Revenge','Revenge',1916);
insert into ships values('Royal Oak','Revenge',1916);
insert into ships values('Royal Sovereign','Revenge',1916);
insert into ships values('Tennessee','Tennessee',1920);
insert into ships values('Washington','North Carolina',1941);
insert into ships values('Wisconsin','Iowa',1944);
insert into ships values('Yamato','Yamato',1941);


insert into battles values('North Atlantic','27-May-1941');
insert into battles values('Guadalcanal','15-Nov-1942');
insert into battles values('North Cape','26-Dec-1943');
insert into battles values('Surigao Strait','25-Oct-1944');

insert into outcomes values('Bismarck','North Atlantic', 'sunk');
insert into outcomes values('California','Surigao Strait', 'ok');
insert into outcomes values('Duke of York','North Cape', 'ok');
insert into outcomes values('Fuso','Surigao Strait', 'sunk');
insert into outcomes values('Hood','North Atlantic', 'sunk');
insert into outcomes values('King George V','North Atlantic', 'ok');
insert into outcomes values('Kirishima','Guadalcanal', 'sunk');
insert into outcomes values('Prince of Wales','North Atlantic', 'damaged');
insert into outcomes values('Rodney','North Atlantic', 'ok');
insert into outcomes values('Scharnhorst','North Cape', 'sunk');
insert into outcomes values('South Dakota','Guadalcanal', 'ok');
insert into outcomes values('West Virginia','Surigao Strait', 'ok');
insert into outcomes values('Yamashiro','Surigao Strait', 'sunk');

/*Exercise 2*/

/*EX 2.1*/
select name
from classes natural join ships
where displacement > 35000 and launched >=1921;



/*EX 2.2*/
select outcomes.ship, classes.displacement, classes.numGuns
from outcomes left join Ships ON Outcomes.ship=Ships.name
  left JOIN Classes ON Ships.class=Classes.class
where outcomes.battle = 'Guadalcanal';




/*EX 2.3*/
select name as shipname
from ships
union
select ship as shipname
from outcomes;


/*EX 2.4*/
select a.country
from classes a join classes b
where a.country = b.country and  a.atype = 'bb' and b.atype = 'bc'
group by a.country;



/*EX 2.5*/
create view OutcomesWithDate as
    select outcomes.ship, outcomes.battle, outcomes.aresult,battles.date_fought 
    from outcomes join battles on outcomes.battle = battles.name;
    
select a.ship
from OutcomesWithDate a join OutcomesWithDate b
where a.ship = b .ship and a.aresult = 'damaged' and a.date_fought < b.date_fought;

drop view OutcomesWithDate;


/*EX 2.6*/

select country
from classes, ships
where classes.numGuns = (
    select max(numGuns) 
    from classes
)
group by country;

/*EX 2.7*/
select name 
from classes join ships on classes.class = ships.class
where (bore,numGuns) in (
	select bore,max(numGuns)
	from classes 
group by bore);



/*2.8*/


/*Exercise 3*/


		  /*EX3.1*/
		  Insert into Classes values('Italia Vittoria Veneto','bb','Italia',NULL,15,41000);
				
		  Insert into Ships values('Italia','Italia Vittoria Veneto',1940);
		  Insert into Ships values('Vittorio Veneto','Italia Vittoria Veneto',1940);
		  Insert into Ships values('Roma','Italia Vittoria Veneto',1942);
		  
		  /*EX3.2*/
		  Delete from classes
		  where class in(
				Select classes.class
				From classes left natural join ships
				group by classes.class
				having count(classes.class)<3);
		
		  /*EX3.3*/
		  update classes
		  set bore = bore *2.5;
		  
		  update classes
		  set displacement = displacement/1.1;
		  
		  
		  
/*Exercise 4*/
	
		
		/*EX4.1*/
		create table Exceptions(
			row_id ROWID,
			owner VARCHAR2(30),
			table_name VARCHAR2(30),
			constraint VARCHAR2(30)
		);
		  ALTER TABLE Classes ADD CONSTRAINT classes_pk PRIMARY KEY(class);
		  ALTER TABLE Ships ADD CONSTRAINT ship_to_classes_fk FOREIGN KEY(class) REFERENCES Classes(class) EXCEPTIONS INTO Exceptions;

		  SELECT Ships.*,CONSTRAINT
		  FROM ships,EXCEPTIONS
			WHERE ships.rowid = exceptions.row_id;

		DELETE FROM SHIPS
		WHERE class in(
			SELECT CLASS
			FROM ships,EXCEPTIONS
			WHERE ships.rowid = exceptions.row_id);

			
		ALTER TABLE ships ADD CONSTRAINT ship_to_classes_fk FOREIGN key(class) REFERENCES classes(class);
		
		
		/*EX4.2*/
		ALTER TABLE battles ADD CONSTRAINT battles_pk PRIMARY KEY(name);
		ALTER TABLE outcomes ADD CONSTRAINT outcomes_to_battles_fk FOREIGN KEY(name) REFERENCES battles(name) EXCEPTIONS INTO Exceptions;



        /*EX4.3*/
		ALTER TABLE ships ADD CONSTRAINT ships_pk PRIMARY KEY(name);
		ALTER TABLE outcomes ADD CONSTRAINT outcomes_to_ships_fk FOREIGN KEY(ship) REFERENCES shipss(name) EXCEPTIONS INTO Exceptions;
		

		
		/*EX4.5*/
		alter table calsses add constraint check_bore check(numguns<=9 or bore<=14);
		
		/*EX4.6*/
		CREATE OR REPLACE VIEW OutcomesView AS
		SELECT ship, battle, result
		FROM Outcomes O
		WHERE NOT EXISTS (
		SELECT *
		FROM Ships S, Battles B
		WHERE S.name=O.ship AND O.battle=B.name AND
		S.launched > TO_NUMBER(TO_CHAR(B.date_fought, 'yyyy'))
		)
		WITH CHECK OPTION;
		
		
		/*EX4.7*/
		CREATE OR REPLACE VIEW ShipsView AS
		SELECT name,class,launched
		FROM Ships s
		WHERE NOT EXISTS (
		SELECT *
		FROM Ships s1
		WHERE s.class=s1.class AND s1.class=s1.name AND
		s1.launched > s.launched 
		)
		WITH CHECK OPTION;
		
		/*EX4.8*/
		create or replace view outcomesV as
		select ship,battle,result
		from outcomes x
		where not exists(
			select *
			from outcomes y
			where y.ship = x.ship and y.result = 'sunk' and
				(select date_fought from battles where name = x.battle)>(select date_fought from battles where name = y.battle)
			)
			with check option;

				

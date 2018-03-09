program feladat;

const maxall=1000;

type  allomas=record
                  leszall: integer;
                  felszall: integer;
                end;

var allomasok: array[1..maxall] of allomas;
	allomasszam: integer;
    max: integer;
    maxert: integer;     

  procedure Beolvas;
    var i: integer;
  begin
    readln(allomasszam);
    for i:=1 to allomasszam do
    begin
	  readln(allomasok[i].leszall,allomasok[i].felszall);
    end;	
  end;
	
  procedure Megold;
    var i: integer;
  begin
	maxert:=allomasok[2].leszall;
	max:=2;
	for i:=3 to allomasszam do
	begin
	  if maxert<allomasok[i].leszall then
	  begin
		maxert:=allomasok[i].leszall;
		max:=i;
	  end;
	end;
  end;
	
  procedure Kiir(const maxert: integer);
  begin
	writeln(maxert);
  end;

BEGIN
  Beolvas;
  Megold;
  Kiir(maxert);
END.

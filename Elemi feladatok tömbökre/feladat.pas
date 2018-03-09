Program betukkel;
  const Egyes:array[1..10] of string=('','egy','kettő','három','négy',
        'öt','hat','hét','nyolc','kilenc');
        Tizes:array[1..10] of string=('','tizen','huszon','harminc',
        'negyven','ötven','hatvan','hetven','nyolcvan','kilencven');

  var szam: integer;
      szoveg: string;
  
  Procedure Olvas;
  begin
    readln(szam);
  end;
  
  Procedure Szamit(szam: integer; var szoveg: string);
    var e,t: integer;
  begin
    if szam=10 then szoveg:='tíz'
    else if szam=20 then szoveg:='húsz'
    else
    begin
      e:=(szam mod 10)+1; t:=(szam div 10)+1;
      szoveg:=Tizes[t]+Egyes[e];
    end;
  end;

  Procedure Ir(szoveg: string);
  begin
    writeln(szoveg);
  end;
  
begin
  Olvas;
  Szamit(szam,szoveg);
  Ir(szoveg);
end.

Program lehules;
  const H:array[1..12] of string=('január','február','március','április',
        'május','június','július','augusztus','szeptember',
        'október','november','december');
  var nev: string;
      index: integer;
  
  Procedure Olvas;
  begin
    readln(nev);
  end;
  
  Procedure Szamit(nev: string; var index: integer);
    var i: integer;
  begin
    i:=1;
    while nev<>H[i] do i:=i+1;
    index:=i
  end;

  Procedure Ir(index: integer);
  begin
    writeln(index);
  end;
  
begin
  Olvas;
  Szamit(nev,index);
  Ir(index);
end.

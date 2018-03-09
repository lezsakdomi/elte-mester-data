Program szegenyek;
  const maxn=1000;
        maxm=10;
  var n,m: integer;
      letszam,jov: array[1..maxn] of longint;
      lm: array[1..maxm] of longint;
      db: integer;
  
  Procedure Olvas;
    var i: integer;
  begin
    readln(n,m);
    for i:=1 to n do
      readln(letszam[i],jov[i]);
    for i:=1 to m do
      readln(lm[i]);
  end;
  
  Procedure Szamit(var db: integer);
    var i: integer;
  begin
    db:=0;
    for i:=1 to N do
      if jov[i]<lm[letszam[i]] then db:=db+1;
  end;

  Procedure Ir(db: integer);
  begin
    writeln(db);
  end;
  
begin
  Olvas;
  Szamit(db);
  Ir(db);
end.

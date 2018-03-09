Program golkulonbseg;
  const maxn=1000;
  var n: integer;
      r,k: array[1..maxn] of integer;
      rug,kap: integer;
  
  Procedure Olvas;
    var i: integer;
  begin
    readln(n);
    for i:=1 to n do
      readln(r[i],k[i]);
  end;
  
  Procedure Szamit(var rug,kap: integer);
    var i: integer;
  begin
    rug:=0; kap:=0;
    for i:=1 to N do
    begin
      rug:=rug+r[i];
      kap:=kap+k[i];
    end;
  end;

  Procedure Ir(rug,kap: integer);
  begin
    writeln(rug-kap);
  end;
  
begin
  Olvas;
  Szamit(rug,kap);
  Ir(rug,kap);
end.

Program legtobb_gyerekes;
  const maxn=1000;
  var n,mgy: integer;
      anya: array[1..maxn] of integer;
  
  Procedure Olvas;
    var i,a,b: integer;
  begin
    readln(n);
    for i:=1 to n do anya[i]:=0;
    for i:=1 to n do
    begin
      readln(a,b);
      anya[b]:=a;
    end;
  end;
  
  Procedure Szamit(var mgy: integer);
    var i: integer;
        gy: array[1..maxn] of integer;
  begin
    for i:=1 to n do gy[i]:=0;
    for i:=1 to N do
      gy[Anya[i]]:=gy[Anya[i]]+1;
    mgy:=1;
    for i:=2 to N do
      if gy[i]>gy[mgy] then mgy:=i;
  end;

  Procedure Ir(mgy: integer);
  begin
    writeln(mgy);
  end;
  
begin
  Olvas;
  Szamit(mgy);
  Ir(mgy);
end.

Program verseny;
  const maxn=1000;
        maxm=10000;
  type tomb=array[1..maxn] of integer;
  var n,m: integer;
      max: integer;
  
  Procedure Olvas;
  begin
    readln(n,m);
  end;
  
  Procedure Szamit(var max: integer);
    var i,j,k: integer;
        Gy,V: array[0..maxn] of integer;
  begin
    for i:=1 to n do 
    begin
      Gy[i]:=0; V[i]:=0;
    end;
    Gy[0]:=-1;
    for i:=1 to m do
    begin
      readln(j,k);
      Gy[j]:=Gy[j]+1;
      V[k]:=V[k]+1;
    end;
    max:=0;
    for i:=1 to n do
      if V[i]>0 then if Gy[i]>Gy[max] then max:=i
  end;

  Procedure Ir(max: integer);
  begin
    writeln(max);
  end;
  
begin
  Olvas;
  Szamit(max);
  Ir(max);
end.

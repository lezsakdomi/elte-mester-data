Program verseny;
  const maxn=1000;
        maxm=10000;
  type tomb=array[1..maxn] of integer;
  var n,m: integer;
      A,B: tomb;
      Adb,Bdb: integer;
  
  Procedure Olvas;
  begin
    readln(n,m);
  end;
  
  Procedure Szamit(var A: tomb; var Adb: integer; var B: tomb; var Bdb: integer);
    var i,j,k: integer;
        Gy,V: array[1..maxn] of integer;
  begin
    for i:=1 to n do 
    begin
      Gy[i]:=0; V[i]:=0;
    end;
    for i:=1 to M do
    begin
      readln(j,k);
      Gy[j]:=Gy[j]+1;
      V[k]:=V[k]+1;
    end;
    Adb:=0;
    for i:=1 to N do
      if V[i]=0 then begin Adb:=Adb+1; A[Adb]:=i end;
    Bdb:=0;
    for i:=1 to N do
      if Gy[i]*V[i]>0 then begin Bdb:=Bdb+1; B[Bdb]:=i end;
  end;

  Procedure Ir(A: tomb;Adb: integer;B: tomb; Bdb: integer);
    var i: integer;
  begin
    for i:=1 to Adb do write(A[i],' '); writeln;
    for i:=1 to Bdb do write(B[i],' '); writeln;
  end;
  
begin
  Olvas;
  Szamit(A,Adb,B,Bdb);
  Ir(A,Adb,B,Bdb);
end.

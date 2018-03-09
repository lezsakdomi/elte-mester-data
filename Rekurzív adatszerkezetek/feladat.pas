program FaRek;
{Fa rekonstrukció}
const
  MaxN=300000;
type
  Par=record bal,jobb: longint end;
var
  n:longint;
  Ino,Preo,Hol:array[1..MaxN] of longint;
  Fa: array[1..MaxN] of Par;
  
function FaEpit(i1,j1,i2,j2:longint):longint;
Var
  x,k,b:longint;
Begin{FaEpit}
  x:=Preo[i1];
  FaEpit:=x;
  if i1=j1 then begin
     Fa[x].bal:=0; Fa[x].jobb:=0;
     exit;
  end;
  k:=Hol[x];
  b:=k-i2;
  if b>0 then
     Fa[x].bal:=FaEpit(i1+1,i1+b, i2,k-1)
  else
     Fa[x].bal:=0;
  if k+1<=j2 then
     Fa[x].jobb:=FaEpit(i1+b+1,j1, k+1, j2)
  else
    Fa[x].jobb:=0;
End{FaEpit}; 

var
  i,x:longint;
begin{prog}
  readln(n);
  for i:=1 to n do 
    read(Preo[i]);
  readLn();
  for i:=1 to n do begin
    read(x);
    Ino[i]:=x;
    Hol[x]:=i;
  end;
  FaEpit(1,n,1,n);
  for i:=1 to n do
    writelN(Fa[i].bal,' ',Fa[i].jobb);
end.

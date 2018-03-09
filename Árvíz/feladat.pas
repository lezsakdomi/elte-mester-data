program arvizek;
const maxn=10000;
type szakasz=record kezd,veg: longint; end;
	 tomb=array[1..maxn div 2] of szakasz;
var x:tomb1;
	   i,n,max:longint;
	   szakaszok: tomb;
	  
begin
  readln(n);
  for i:=1 to n do readln(x[i]);
  max:=x[1];
  for i:=2 to n do
    if x[i]>max then max:=x[i];
  writeln(max);
end.

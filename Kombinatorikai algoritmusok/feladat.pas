program Permutacio;
const
  MaxN=100000;
var
	P:array[0..maxN] of longint;
	n,i,ui,u,j,x:longint;
begin
	readln(n);
	ui:=0; P[0]:=n;
	for i:=1 to n do begin
		read(P[i]);
		if P[i-1]<P[i] then ui:=i-1;
	end;
	u:=P[ui];
	j:=ui+1;
	while P[j]>u do inc(j);
	dec(j);
	for i:=1 to ui-1 do write(P[i],' ');
	write(P[j],' ',u);
	for i:=j+1 to n do
		write(' ',P[i]);
	for x:=P[j]+1 to n do 
		write(' ',x);
	writeln;
end.

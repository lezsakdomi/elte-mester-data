program OptimalisPenzvaltas;
const
	maxN=1000;
	maxE=1000;
var
	P:array[1..maxN] of integer;
	Opt:array[0..maxE,0..maxN] of integer;
	S:array[1..maxN] of integer;
	n,E, i,x, m:integer;
begin
	readln(n,E);
	for i:=1 to n do read(P[i]);
	for x:=1 to E do Opt[x][0]:=n+1;
	for i:=1 to n do Opt[0][i]:=0;
	for i:=1 to n do begin
		for x:=1 to E do begin
			Opt[x][i]:=Opt[x][i-1];
			if (P[i]<=x) and (Opt[x-P[i]][i-1]+1<Opt[x][i]) then 
				Opt[x][i]:=Opt[x-P[i],i-1]+1
		end;
	end;
	if Opt[E][n]<=n then begin
		m:=0; x:=E;i:=n;
		repeat
			while (i>1)and(Opt[x][i]=Opt[x][i-1]) do dec(i);
			inc(m);
			S[m]:=i;
			x:=x-P[i];
			dec(i);
		until x=0;
		wrietln(m);
		for i:=1 to m do write(S[i], ' ');
	end else
		writeln(-1);
end.

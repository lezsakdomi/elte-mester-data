program Sejtek;
const
	maxN=1000000;
	maxAB=10000;
type Par=record a,b:integer end;
var
  n,x,y,M,Mi,hany,i,mAB:longint;
  S:array[1..maxN] of Par;
  E:array[0..maxAB] of longint;
  K:array[0..maxAB] of longint;
begin{prog}
  readln(n);
	for x:=0 to maxAB do begin
		E[x]:=0; K[x]:=0;
	end;
	mAB:=0;
	for i:=1 to n do begin
		readln(x,y);
		S[i].a:=x; S[i].b:=y;
		inc(E[y]);
		inc(K[x]);
		if mAB<x then mAB:=x;
		if mAB<y then mAB:=y;
	end;
	for x:=1 to mAB do E[x]:=E[x]+E[x-1];
	for x:=mAB-1 downto 1 do K[x]:=K[x]+K[x+1];
	M:=n+1;
	for i:=1 to n do begin
		hany:=E[S[i].a-1] + K[S[i].b+1];
		if hany<M then begin
			M:=hany; Mi:=i;
		end;
	end;
	writeln(Mi,' ',n-M-1);
end.

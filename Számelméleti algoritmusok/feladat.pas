program diofantoszi;
const 
  maxAB=1000;
  INF=maxAB*maxAB+1;
var
  Am:array[0..maxAB] of longint;
  Bm:array[0..maxAB] of longint;
  E:array[0..maxAB*maxAB] of boolean;
	A,B,N:longint;
	Z:int64;
	x:longint;
begin
  readln(A,B,N);
	E[0]:=true;
	for x:=1 to A-1 do Am[x]:=INF;
  for x:=1 to B-1 do Bm[x]:=INF;
  Am[0]:=A; Bm[0]:=B;
	for x:=1 to maxAB*maxAB do begin
		E[x]:=(x<=A)and(E[x-A]) or (x<=B)and(E[x-B]);
		if E[x] then begin
			if x<Am[x mod A] then Am[x mod A]:=x;
			if x<Bm[x mod B] then Bm[x mod B]:=x;
		end;
	end;
  for x:=1 to N do begin
		readln(Z);
		if (Z>=Am[Z mod A])or(Z>=Bm[Z mod B]) then
			writeln('Igen')
		else
			writeln('Nem')
  end;
end.

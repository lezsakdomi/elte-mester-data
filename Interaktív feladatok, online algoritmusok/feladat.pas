program Hirlanc;
uses adatok;
const
  MaxN=100000;                    {max. elemszám}
var
	Befok:array[1..maxN] of longint;
	F:array[1..maxN] of longint;
	Korben:array[1..maxN] of longint;
	Elore:array[1..maxN] of longint;
	N:longint;
	V:longint;
procedure Init;
var x:longint;
begin
	for x:=1 to N do begin
		F[x]:=0;
		BeFok[x]:=0;
		Korben[x]:=0;
		Elore[x]:=0;
	end;
	V:=N;
end;
function LancVeg(a:longint):longint;
var aa,x:longint;
begin
	aa:=a;
	while (Korben[aa]=0) and (F[aa]<>0) do begin
		if Elore[aa]>0 then
			aa:=Elore[aa]
		else
			aa:=F[aa]
	end;
	if a<>aa then begin
		x:=a;
		repeat
			Elore[x]:=aa;
			x:=F[x];
		until (x=0) or (x=aa);
	end;
	LancVeg:=aa;
end;
procedure szamol(a,b:longint);
var bb,x:longint;
	farok:boolean;
begin
	bb:=LancVeg(b);
	if BeFok[b]=0 then begin
		if bb=a then begin//1. vagy 2. eset
			x:=b;
			farok:=false;
			repeat
				Korben[x]:=1;
				x:=F[x];
				if (farok) or (BeFok[x]>1) then farok:=true;
			until x=0;
			if farok then begin
				dec(V);
				x:=b;
				repeat
					Korben[x]:=2;
					x:=F[x];
				until x=0;
			end;
		end else
			dec(V);
	end else begin
		if (Korben[b]=1) then begin//5. eset
			x:=b;
			repeat
				Korben[x]:=2;
				x:=F[x];
			until x=b;
			dec(V);
		end;
	end;
	F[a]:=b;
	inc(BeFok[b]);
end;
var
	a,b:longint;
Begin
	N:=kezd;
	Init;
	while true do begin
		ujadat(a,b);
		szamol(a,b);
		valasz(V);
	end;
end.
//az alábbi sorokat mentse el az adatok.pas fájlba
unit adatok;
interface
  function kezd:longint;
  procedure ujadat(var x,y:longint);
  procedure valasz(db:longint);
Implementation
const
  MaxN=100000;                    {max. elemszám}
var
	Befok:array[1..maxN] of longint;
	F:array[1..maxN] of longint;
	Korben:array[1..maxN] of longint;
	Elore:array[1..maxN] of longint;
	N,V:longint;
	A,B,M:array[1..maxN] of longint;
	mvolt:boolean; h:Longint;
	
function LancVeg(a:longint):longint;
var aa,x:longint;
begin
	aa:=a;
	while (Korben[aa]=0) and (F[aa]<>0) do begin
		if Elore[aa]>0 then
			aa:=Elore[aa]
		else
			aa:=F[aa]
	end;
	if a<>aa then begin
		x:=a;
		repeat
			Elore[x]:=aa;
			x:=F[x];
		until (x=0) or (x=aa);
	end;
	LancVeg:=aa;
end;
procedure szamol(a,b:longint);
var bb,x:longint;
	farok:boolean;
begin
	bb:=LancVeg(b);
	if BeFok[b]=0 then begin
		if bb=a then begin
			x:=b;
			farok:=false;
			repeat
				Korben[x]:=1;
				x:=F[x];
				if (farok) or (BeFok[x]>1) then farok:=true;
			until x=0;
			if farok then begin
				dec(V);
				x:=b;
				repeat
					Korben[x]:=2;
					x:=F[x];
				until x=0;
			end;
		end else
			dec(V);
	end else begin
		if (Korben[b]=1) then begin
			x:=b;
			repeat
				Korben[x]:=2;
				x:=F[x];
			until x=b;
			dec(V);
		end;
	end;
	F[a]:=b;
end;

function kezd:longint;
  var x,y,i:longint;
begin
  readln(N);
  V:=N;
  for x:=1 to N do begin
		F[x]:=0;
		Befok[x]:=0;
		Korben[x]:=0;
		Elore[x]:=0;
  end;
  mvolt:=false;
  h:=1; i:=1;
  while true do begin
		readln(x,y);
		A[i]:=x; B[i]:=y;
		if x=0 then break;
		szamol(x,y);
		M[i]:=V;
		inc(i);
  end;
  kezd:=N;
end;
procedure KI(s:string);
begin
	writeln(s);
	halt;
end;
procedure ujadat(var x,y:longint);
begin
  if mvolt then Ki('HIBA: protokoll hiba!');
  x:=A[h]; y:=B[h];
  mvolt:=true;
end;
procedure valasz(db:longint);
begin
  if not mvolt then Ki('HIBA: protokoll hiba!');
  if db<> M[h] then Ki('HIBA: hibás válasz!');
  inc(h);
  mvolt:=false;
  if A[h]=0 then begin
		Ki('Helyes');
		halt;
  end;
end;

begin
end.

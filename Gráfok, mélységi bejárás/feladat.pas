program Keptarlatogatas;
uses gvector;
const
	maxN=10001;
type 
	Vektor=specialize TVector<longint>;
	Graf=array[1..maxN] of Vektor; 	
var
	G:Graf;
	Honnan:array[1..maxN] of longint;
	n,i:longint;
	
procedure Beolvas;
var p,q:longint;
begin
	readln(n);
	for p:=1 to n do begin
		G[p]:=Vektor.Create;
	end;
	for p:=1 to n do begin
		read(q);
		while q>0 do begin
			G[p].PushBack(q);
			read(q);
		end;
		readln();
	end;
end{Beolvas};

procedure NemrekurzivBejar(var G:Graf; n:longint; p:longint);
var 
	hol,hova,i,q:longint;
	Honnan:array[1..maxN] of longint;
begin
	for q:=1 to n do 
		Honnan[q]:=-1;
	Honnan[p]:=0;
	hol:=p;
	while hol<>0 do begin
		write(hol,' ');
		i:=0;
		while (i<G[hol].size) and (Honnan[G[hol][i]]>=0) do inc(i);
		if i<G[hol].size then begin
			hova:=G[hol][i];
			Honnan[hova]:=hol;
			hol:=hova;
		end else
			hol:=Honnan[hol];
	end;
	writeln;
end;

procedure MelyBejar(p:longint);
//Globális: G, Honnan
var q:longint;
begin
	write(p,' ');
	for q in G[p] do
		if Honnan[q]<0 then begin
			Honnan[q]:=p;
			MelyBejar(q);
			write(p,' ');
		end;
end;

begin
	Beolvas;
	NemrekurzivBejar(G,n,1);
	for i:=1 to n do Honnan[i]:=-1;
	Honnan[1]:=0;
	MelyBejar(1);
	
end.

program Kozpont;
uses gvector;
const
	maxN=100001;
type 
	Vektor=specialize TVector<longint>;
	Graf=array[1..maxN] of Vektor; 	
var
	G, GT:Graf;
	E,ET:array[0..maxN] of boolean;
	n,p0,mego,p:longint;
	
procedure Beolvas;
var m,i,p,q:longint;
begin
	readln(n,m,p0);
	for i:=1 to n do begin
		G[i]:=Vektor.Create;
		GT[i]:=Vektor.Create;
	end;
	for i:=1 to m do begin
		readln(p,q);
		G[p].PushBack(q);
		GT[q].PushBack(p);
	end;
end{Beolvas};

procedure Eler(var G:Graf; p:longint; var E:array of boolean);
var	q:longint;
begin
	E[p]:=true;
	for q in G[p] do 
		if not E[q] then
			Eler(G,q,E);
end{Eler};

begin{program}
	Beolvas;
	for p:=1 to n do begin
		E[p]:=false;
		ET[p]:=false;
	end;
	Eler(G,p0,E);
	Eler(GT,p0,ET);
	mego:=0;
	for p:=1 to n do 
		if E[p] and not ET[p] then inc(mego);
	writeln(mego);
	for p:=1 to n do 
		if E[p] and not ET[p] then
			write(p,' ');
	writeln();
end.

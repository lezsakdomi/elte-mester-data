program Talalka;
uses gvector, gqueue;
const
	maxN=10001;
	Inf=maxN+1;
type 
	Vektor=specialize TVector<integer>;
	Sor=specialize TQueue<integer>;
	Graf=array[1..maxN] of Vektor; 	
var
	G:Graf;
	TavA,TavE:array[0..maxN] of integer;
	ApaA,ApaE, Ut:array[0..maxN] of integer;
	n,A,E,R,p,tav,hol:integer;
	
procedure Beolvas;
var m,i,p,q:longint;
begin
	readln(n,m,E,A);
	for i:=1 to n do begin
		G[i]:=Vektor.Create;
	end;
	for i:=1 to m do begin
		readln(p,q);
		G[p].PushBack(q);
	end;
end{Beolvas};

procedure SzeltBejar(var G:Graf; p:integer; var Tav, Apa:array of integer);
var	u,v:integer;
	S:Sor;
begin
	for u:=1 to n do Tav[u]:=Inf;
	Tav[p]:=0; Apa[p]:=0;
	S:=Sor.Create;
	S.Push(p);	
	while S.size>0 do begin
		u:=S.Front; S.Pop;
		for v in G[u] do
			if Tav[v]=Inf then begin
				Tav[v]:=Tav[u]+1;
				Apa[v]:=u;
				S.Push(v);
			end;
	end;
end{SzeltBejar};

begin{program}
	Beolvas;
	SzeltBejar(G,E,TavE,ApaE);
	SzeltBejar(G,A,TavA,ApaA);
	R:=0; tav:=Inf;
	for p:=1 to n do
		if (TavE[p]<tav)and(TavA[p]<Inf) then begin
			tav:=TavE[p];
			R:=p;
		end;
	writeln(R);
	p:=R; hol:=0;
	while p>0 do begin
		inc(hol); Ut[hol]:=p; 
		p:=ApaE[p];
	end;
	for p:=hol downto 1 do
		write(Ut[p],' ');
	writeln();
	p:=R; hol:=0;
	while p>0 do begin
		inc(hol); Ut[hol]:=p; 
		p:=ApaA[p];
	end;
	for p:=hol downto 1 do
		write(Ut[p],' ');
	writeln();
end.

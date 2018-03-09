program Kozpont;
uses gvector;
const
	maxN=100000;
type 
	Vektor=specialize TVector<longint>;
	Graf=array[1..maxN] of Vektor; 	
var
	G:Graf;
	Fok:array[1..maxN] of longint;
	F:array[1..maxN] of longint;
	n,i, p,q,eleje,vege,hany:longint;
	
procedure Beolvas;
var i,p,q:longint;
begin
	readln(n);
	for i:=1 to n do begin
		Fok[i]:=0;
		G[i]:=Vektor.Create;
	end;
	for i:=1 to n-1 do begin
		readln(p,q);
		G[p].PushBack(q);
		G[q].PushBack(p);
		inc(Fok[p]);
		inc(Fok[q]);
	end;
end{Beolvas};
  
begin
	Beolvas;
	eleje:=1;vege:=0;
	hany:=n;
	for i:=1 to n do
		if Fok[i]=1 then begin
			inc(vege);
			F[vege]:=i;
		end;
	while hany>1 do begin
		p:=F[eleje]; inc(eleje);
		dec(hany);
		writeln(p);
		for q in G[p] do begin
			dec(Fok[q]);
			if Fok[q]=1 then begin
				inc(vege);
				F[vege]:=q;
			end;
		end;
	end;
	writeln(F[eleje]);
end.

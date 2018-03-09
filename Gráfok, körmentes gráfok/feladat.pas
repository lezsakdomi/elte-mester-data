program Kozpont;
uses gvector;
const
	maxN=100001;
type 
	Vektor=specialize TVector<longint>;
	Graf=array[1..maxN] of Vektor; 	
var
	G:Graf;
	BeFok:array[1..maxN] of longint;
	Nap:array[1..maxN] of Vektor;
	n,i, p,q,van,hany:longint;
	
procedure Beolvas;
var m,i,p,q:longint;
begin
	readln(n,m);
	for i:=1 to n do begin
		BeFok[i]:=0;
		G[i]:=Vektor.Create;
	end;
	for i:=1 to m do begin
		readln(p,q);
		G[p].PushBack(q);
		inc(BeFok[q]);
	end;
end{Beolvas};
  
begin
	Beolvas;
	hany:=1;van:=n;
	Nap[1]:=Vektor.Create;
	for i:=1 to n do
		if BeFok[i]=0 then
			Nap[1].PushBack(i);
	while Nap[hany].size>0 do begin
		Nap[hany+1]:=Vektor.Create;
		for p in Nap[hany] do begin
			dec(van);
			for q in G[p] do begin
				dec(BeFok[q]);
				if BeFok[q]=0 then
					Nap[hany+1].PushBack(q);
			end;
		end;
		inc(hany);
	end;
	if van>0 then
		writeln(0)
	else begin
		writeln(hany-1);
		for i:=1 to hany-1 do begin
			for p in Nap[i] do
				write(p,' ');
			writeln();
		end;
	end;
end.

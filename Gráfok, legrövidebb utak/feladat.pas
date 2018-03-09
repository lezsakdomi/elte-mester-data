{$mode objfpc}
program Halozat;
//Hálózat feladat megoldása Dijkstra algoritmussal
uses gvector,gpriorityqueue;
const
	maxN=10001;
type 
	El=record suly,pont:longint end;
	Vektor=specialize TVector<El>;
	Graf=array[1..maxN] of Vektor; 	
	SorRend = class
    public
    class function c(a,b: El):boolean;inline;
  end;
	class function SorRend.c(a,b: El):boolean;inline;
	begin
		c:=a.suly<b.suly;
	end;
type
	PriSor = specialize TPriorityQueue<El, SorRend>;
var
	G:Graf;
	n,i:longint;
	S:PriSor;
	A,B:longint;
	Tav:array[1..maxN] of longint;
	Apa:array[1..maxN] of longint;
	Kesz:array[1..maxN] of boolean;
	
procedure Beolvas;
var i,p,q,s,m:longint;
	e:El;
begin
	readln(n,m);readln(A,B);
	for p:=1 to n do begin
		G[p]:=Vektor.Create;
	end;
	for i:=1 to m do begin
		readln(p, q, s);
		e.pont:=q; e.suly:=s;
		G[p].PushBack(e);
		e.pont:=p; 
		G[q].PushBack(e);
	end;
end{Beolvas};
	
procedure Dijkstra(r:longint);
//Globális: G,Tav,Kesz,Apa
var
	ujtav,p:longint;
	e,u,v:El;
	
begin
	for p:=1 to n do begin//inicializálás
		Kesz[p]:=false;
		Tav[p]:=0;
	end;
	Tav[r]:=maxint;
	Apa[r]:=0;
	e.suly:=maxint; e.pont:=r;
	S.Push(e);
	while S.size>0 do begin
		u:=S.Top; S.Pop;
		if Kesz[u.pont] then continue;
		for v in G[u.pont] do begin
			ujtav:=u.suly; if v.suly<ujtav then ujtav:=v.suly;
			if not Kesz[v.pont] and (ujtav>Tav[v.pont]) then begin
				e.pont:=v.pont; e.suly:=ujtav;
				S.Push(e);
				Tav[v.pont]:=ujtav;
				Apa[v.pont]:=u.pont;
      end;
		end;
	end;
end{Dijkstra};

var Ut:array[1..maxN] of longint;
	x,m:longint;
	e:El;
begin
	Beolvas;
	S:=PriSor.Create;
	Dijkstra(A);
  x:=B;
  m:=0;
	while (x<>A)do begin
      inc(m); Ut[m]:=x;
      x:=Apa[x];
   end;
	inc(m);
   Ut[m]:=A;
   writeln(Tav[B]);
	for i:=m downto 1 do
		write(Ut[i],' ');
	writeln;
end.

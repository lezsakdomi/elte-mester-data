{$mode objfpc}
program Halozatok;
//Hálózatok összekapcsolása feladat megoldása Kruskal algoritmussal
uses garrayutils;
const
	maxN=10000;
	maxM=500000;
type 
	El=record p,q,az,suly:longint end;
  SorRend = class
    public
    class function c(a,b: El):boolean;inline;
  end;

	class function SorRend.c(a,b: El):boolean;inline;
	begin
		c:=a.suly<b.suly;
	end;

type 
	Graf=array[0..maxM] of El;
  Rendezo = specialize TOrderingArrayUtils<Graf, El, SorRend>;
var
	G:Graf;
	n,k,m,i:longint;
	Apa:array[1..maxN] of longint;
	Fa:array[1..maxN] of longint;
	
procedure UnioHolvan(n:longint);
var i:longint;
begin
	for i:=1 to n do Apa[i]:=-1;
end;
function Holvan(x:longint):longint;
  var Nx,y:longint;
begin
   Nx:=x;
   while Apa[Nx]>0 do Nx:=Apa[Nx];
   {uttomorites}
   y:=x;
   while x<>Nx do  begin
     y:=Apa[x];
     Apa[x]:=Nx;
     x:=y;
	end;
	Holvan:=Nx;
end{Holvan};

function Unio(Nx,Ny:longint):longint;
var z:longint;
begin
	if Nx<>Ny then begin
		if Apa[Nx]>Apa[Ny] then begin//egyesítés a nagyobbikhoz
			z:=Nx; Nx:=Ny; Ny:=z;
		end;
		Apa[Nx]:=Apa[Nx]+Apa[Ny];
		Apa[Ny]:=Nx;
	end;
	Unio:=Nx;
end{Unio};

procedure Beolvas;
var x,y,Nx,Ny:longint;
begin
	readln(n,k,m);
	UnioHolvan(n);
	for i:=1 to k do begin
		read(x);
		Nx:=Holvan(x);
		while true do begin
			read(y);
			if y=0 then break;
			Ny:=Holvan(y);
			Nx:=Unio(Nx,Ny);
		end;
		readln;
	end;
	for i:=0 to m-1 do begin
		readln(G[i].p, G[i].q, G[i].suly);
		G[i].az:=i+1;
	end;
end{Beolvas};
var
	fel, okolts, Nx,Ny:longint;
begin{program}
	Beolvas;
	Rendezo.sort(G,  m);
	fel:=0; okolts:=0;
	for i:=0 to m-1 do begin
		Nx:=Holvan(G[i].p);
		Ny:=Holvan(G[i].q);
		if Nx<>Ny then begin
			Unio(Nx,Ny);
			inc(fel);
			Fa[fel]:=G[i].az;
			okolts:=okolts+G[i].suly;
		end;
	end;
	writeln(okolts,' ',fel);
	for i:=1 to fel do
		write(Fa[i],' ');
	writeln;
end.

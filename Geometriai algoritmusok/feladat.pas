{$mode objfpc}
program Poligon;
uses garrayutils;
const
	maxN=10000;
	maxM=500000;
type 
	Pont=record x,y:int64; azon:longint end;
var
	Q:Pont;//sarokpont
function Fordul(A,B,C:Pont): integer;
{
Kimenet: +1 ha A->B->C balra fordul,
          0  ha A--B--C kollineárisak,
         -1  ha A->B->C jobbra fordul.
}
var kereszt:int64;
begin
	kereszt:=(B.x-A.x)*(C.y-A.y)-(C.x-A.x)*(B.y-A.y);
	if kereszt<0 then
		Fordul:=-1
	else if kereszt>0 then
		Fordul:=1
	else
		Fordul:=0;
end;
function Kozte(A,B,C:Pont):boolean;
begin
	Kozte:= (abs(B.x-A.x) <= abs(C.x-A.x)) and
          (abs(C.x-B.x) <= abs(C.x-A.x)) and
          (abs(B.y-A.y) <= abs(C.y-A.y)) and
          (abs(C.y-B.y) <= abs(C.y-A.y)) ;
end;
type
  SarokRend = class
    public
    class function c(a,b: Pont):boolean;inline;
  end;

	class function SarokRend.c(a,b: Pont):boolean;inline;
	begin
		c:=(Fordul(Q,A,B)>0) or (Fordul(Q,A,B)=0) and Kozte(Q,A,B)
	end;

type 
	PontSor=array[0..maxM] of Pont;
  Rendezo = specialize TOrderingArrayUtils<PontSor, Pont, SarokRend>;
var
	P:PontSor;
	n,i,j:longint;

procedure Beolvas;
var i:longint;
begin
	readln(n);
	Q.x:=maxint;
	for i:=0 to n-1 do begin
		readln(P[i].x, P[i].y);
		p[i].azon:=i+1;
		if (P[i].x<Q.x)or(Q.x=P[i].x)and(P[i].y<Q.y) then
			Q:=P[i];
	end;
end{Beolvas};

begin{program}
	Beolvas;
	Rendezo.sort(P, n);	
	j:=n-2;
	while (j>0)and(Fordul(Q,P[n-1],P[j])=0) do dec(j);
	for i:=0 to j do
		write(P[i].azon, ' ');
	for i:=n-1 downto j+1 do
		write(P[i].azon,' ');
	writeln;
end.

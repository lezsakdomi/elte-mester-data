program Panzvaltas;
//nemrekurzív visszalépéses keresés
const
  MaxN=30; {a pénzek max. száma}
type
  Index = 1..MaxN;
  MTerPont=record
        E:Longint;
        P:Array[Index] of Word; {a pénzek}
        N:Index;       {az összes pénz száma}
        V:Array[0..MaxN] of Word; {a megoldáskezdemény}
        k:Integer;     {a megoldáskezdemény pénzeinek száma}
        osszeg:Longint;  {a megoldáskezdemény pénzeinek összege}
        Maradt:Longint;{a még választható pénzek összege}
      end;

{ Probléma-specifikus műveletek: }
  procedure UresX(var X:MTerPont);forward;
    { X az üres megoldáskezdemény lesz }
  function ElsoFiu(var X: MTerPont): boolean; forward;
    { Ha van X-nek fia, akkor X az első fiúra változik és a
     függvényhívás értéke True, egyébként False és X nem változik. }
  function Testver(var X: MTerPont): boolean; forward;
   { Ha van X-nek még benemjárt testvére, akkor X a következő testvér lesz
     és a függvényhívás értéke True, egyébként False és X nem változik.}
  function Apa(var X: MTerPont):boolean;  forward;
    { Ha van X-nek apja, akkor X az apjára változik és a
     függvényhívás értéke True, egyébként False és X nem változik. }
 
  function Megoldas (var X: MTerPont): boolean; forward;
    { akkor és csak akkor ad True értéket, ha X megoldása a problémának.}
  function Lehet(var X: MTerPont): boolean; forward;
    { Ha LehetMego(X) hamis, akkor nincs megoldás az X gyökerű részfában. }
    { Ha LehetMego(X) igaz, abból nem következik, hogy van is megoldás.   }
    { Olyan bejegyzéseket is tehet, amelyek a további LehetMego és Megoldás
      műveletek gyorsabb elvégzését segítik. }

function Keres(var X:MTerPont):boolean;
 { Bemenet: X a megoldástér fájának gyökere}
 { Kimenet: Van=True<=>ha van megoldás és X egy megoldás lesz}
var
 van,elsore:boolean;
begin{Keres}
  van:=true; elsore:=true; Keres:=true;
  while van do begin
		if elsore then begin
			if not Lehet(X) then
				elsore:=false
			else begin
				if Megoldas(X) then exit;
				elsore:=ElsoFiu(X);
			end
		end else begin
			elsore:=Testver(X);
			if not elsore then
				van:=Apa(X);
		end
  end;
  Keres:=van;
end{Keres};

procedure KiIr(X:MTerPont);
  var i:Integer;
  begin
   for i:=1 to X.N do Write(X.V[i]:3);
   WriteLn;
  end;

procedure UresX(var X:MTerPont);
var i:Integer;
begin
  with X do begin
    k:=0;
    V[0]:=0;
    Maradt:=0;
    osszeg:=0;
    for i:=1 to N do Maradt:=Maradt+P[i];
  end;
end;

function ElsoFiu(var X: MTerPont): boolean;
begin
  If X.V[X.k]<X.N then begin
    Inc(X.k);
    X.V[X.k]:=X.V[X.k-1]+1;
    dec(X.maradt, X.P[X.V[X.k]]);
    inc(X.osszeg, X.P[X.V[X.k]]);
    ElsoFiu:=True
  end Else
    ElsoFiu:=False;
end;

function Testver(var X: MTerPont): boolean;
begin
  If (X.k>0)And(X.V[X.k]<X.N) then begin
    Testver:=True;
    dec(X.osszeg, X.P[X.V[X.k]]);
    Inc(X.V[X.k]);
    inc(X.osszeg, X.P[X.V[X.k]]);
    dec(X.maradt, X.P[X.V[X.k]]);
  end Else
    Testver:=False;
end;

function Apa(var X: MTerPont):boolean;
begin
  If X.k>0 then begin
    Apa:=True;
    dec(X.osszeg, X.P[X.V[X.k]]);
    Dec(X.k);
  end Else
    Apa:=False;
end;

function Lehet(var X:MTerPont) : boolean;
begin
  Lehet:= True;
  With X do begin
    If k=0 then Exit;
    If (osszeg+V[k] <= E) And (osszeg+Maradt>=E)
    then begin
      osszeg:=osszeg+P[V[k]];
      Maradt:=Maradt-P[V[k]];
    end Else
      Lehet:= False
  end
end {Lehet};

function Megoldas (var X: MTerPont): boolean;
begin
  Megoldas:=X.osszeg=X.E
end;

begin

end.
//
program PanzvaltasR;
//rekurzív visszalépéses keresés
const
  MaxN=30; {a pénzek max. száma}
type
  Index = 1..MaxN;
  MTerPont=record
        k:integer;     {a megoldáskezdemény pénzeinek száma}
        u:integer;
        osszeg:Longint;  {a megoldáskezdemény pénzeinek összege}
        Maradt:Longint;{a még választható pénzek összege}
      end;
  Global=record
        E:Longint;
        P:array[Index] of longint; {a pénzek}
        N:Index;       {az összes pénz száma}
        V:array[0..MaxN] of Word; {a megoldáskezdemény}
      end;
      
{ Probléma-specifikus műveletek: }
  procedure UresX(var X:MTerPont);forward;
    { X az üres megoldáskezdemény lesz }
  function ElsoFiu(var X: MTerPont): boolean; forward;
    { Ha van X-nek fia, akkor X az első fiúra változik és a
     függvényhívás értéke True, egyébként False és X nem változik. }
  function Testver(var X: MTerPont): boolean; forward;
   { Ha van X-nek még benemjárt testvére, akkor X a következő testvér lesz
     és a függvényhívás értéke True, egyébként False és X nem változik.}
 
  function Megoldas (var X: MTerPont): boolean; forward;
    { akkor és csak akkor ad True értéket, ha X megoldása a problémának.}
  function Lehet(var X: MTerPont): boolean; forward;
    { Ha LehetMego(X) hamis, akkor nincs megoldás az X gyökerű részfában. }
    { Ha LehetMego(X) igaz, abból nem következik, hogy van is megoldás.   }
    { Olyan bejegyzéseket is tehet, amelyek a további LehetMego és Megoldás
      műveletek gyorsabb elvégzését segítik. }
var
	GData:Global;
function RKeres(X:MTerPont):boolean;
 { Bemenet: X a megoldástér fájának gyökere}
 { Kimenet: Van=True<=>ha van megoldás és X egy megoldás lesz}
begin{RKeres}
	RKeres:=true;
	if Megoldas(X) then exit;
	if not ElsoFiu(X) then begin RKeres:=false; exit; end;
	repeat
		if Lehet(X) then
			if RKeres(X) then begin
				GData.V[X.k]:=X.u;
				exit;
			end;
	until not Testver(X);
  RKeres:=false;
end{RKeres};

procedure KiIr(X:MTerPont);
  var i:Integer;
  begin
   for i:=1 to GData.N do Write(GData.V[i]:3);
   WriteLn;
  end;

procedure UresX(var X:MTerPont);
var i:Integer;
begin
  with X do begin
    k:=0;
    u:=0;
    Maradt:=0;
    osszeg:=0;
    for i:=1 to GData.N do Maradt:=Maradt+GData.P[i];
  end;
end;

function ElsoFiu(var X: MTerPont): boolean;
begin
  if X.u<GData.N then begin
    inc(X.k);
    inc(X.u);
    inc(X.osszeg,GData.P[X.u]);
    dec(X.maradt,GData.P[X.u]);
    ElsoFiu:=True
  end else
    ElsoFiu:=False;
end;

function Testver(var X: MTerPont): boolean;
begin
  if X.u<GData.N then begin
    Testver:=True;
    dec(X.osszeg,GData.P[X.u]);
    inc(X.u);
    inc(X.osszeg,GData.P[X.u]);
    dec(X.maradt,GData.P[X.u]);
  end else
    Testver:=False;
end;

function Lehet(var X:MTerPont) : boolean;
begin
  with X do begin
    if (osszeg <= GData.E) And (osszeg+Maradt>=GData.E)
    then 
      Lehet:= true
    else
			Lehet:=false;
  end
end {Lehet};

function Megoldas (var X: MTerPont): boolean;
begin
  Megoldas:=X.osszeg=GData.E
end;

begin

end.

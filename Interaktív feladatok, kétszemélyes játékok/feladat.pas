program Szamjatek;
uses Play; {a masodik játékost megvalósító modul}
const
  MaxN=1000;{maximális táblaméret}
var
  A:array[0..maxN] Of integer;{ a táblán lévő számok sorozata}
  N: integer;                 { a tábla mérete}
  Opt:array[1..MaxN,1..MaxN] of longint;
  {Opt[i,j] a max. pontszám, amit az 1. játékos az (i,j) játékállásból elérhet}
  Lep:array[1..MaxN,1..MaxN] of char; {az 1. játékos optimális lépései}

procedure Elofeldolgoz;
var i,j:integer;
  PontBal,PontJobb:integer;
begin
  for j:=1 To N Do begin
    Opt[j,j]:=0;
    for i:=j-1 downto 1 Do begin
      if odd(i+j) then begin{1. játékos lép}
        PontBal:=A[i]+Opt[i+1,j];
        PontJobb:=A[j]+Opt[i,j-1];
        if PontBal>PontJobb then begin
          Opt[i,j]:=PontBal;  Lep[i,j]:='B'
        end else begin
          Opt[i,j]:=PontJobb; Lep[i,j]:='J'
        end
      end else begin{2. játékos lép}
        if Opt[i+1,j]<Opt[i,j-1] then
          Opt[i,j]:=Opt[i+1,j]
        else
          Opt[i,j]:=Opt[i,j-1]
      end;
    end{for i};
  end{for j};
end {Elofeldolgoz};

procedure Jatszas;
var
  Bal,Jobb:integer;{az aktuális játékállás: A[Bal..Jobb]}
  L1,L2: char;     {a két játékos aktuális lépése}
begin
  Bal:=1; Jobb:=N;            {a kezdő játékállás beállítása}
  while Bal<=Jobb Do begin    {amíg nem üres a tábla}
    if Lep[Bal,Jobb]='B'then begin {a játékállás aktualizálása}
      Inc(Bal);
      Lepesem('B');
    end else begin
			Lepesem('J');
      dec(Jobb);
    end;
    L2:=Lepesed;             {az ellenfél lépése}
    if L2='B' then           {a játékállás aktualizálása}
      Inc(Bal)
    else
      dec(Jobb);
  end{while};
end{Jatszas};
var
	i:integer;
begin
  N:=TablaMeret;
  for i:=1 to N do A[i]:=Tabla(i);
  Elofeldolgoz;

  Jatszas;
end.
{Az alábbi sorokat mensük el a Play.pas állományba és töröljük innen!}
unit Play;
interface
	function TablaMeret:integer;
	function Tabla(i:integer):integer;
	procedure Lepesem(Lep:char);
	function Lepesed:char;
	
implementation
const
	maxN=1000;
	Init:boolean=true;
var
	N:integer;
	A:array[1..maxN] of integer;
	Nyer1,Nyer2:longint;
	AktBal,AktJobb:integer;
	Lep2:char;
	
	function TablaMeret:integer;
	var i:integer;
	begin
		readln(N);
		if Odd(N) then begin
			writeln('Hiba: N csak páros lehet!');
			halt;
		end;
		for i:=1 to N do
			read(A[i]);
		Nyer1:=0; Nyer2:=0;
		Init:=false;
		TablaMeret:=N;
		AktBal:=1; AktJobb:=N;
	end;
	function Tabla(i:integer):integer;
	begin
		if Init then begin
			writeln('Hiba:előbb TablaMeret-et kell hívni!');
			halt;
		end;
		Tabla:=A[i];
	end;
	procedure Lepesem(Lep:char);
	begin
		if Init then begin
			writeln('Hiba: lépés csak B vagy J lehet');
			halt;
		end;
		if not ((Lep='B')or(Lep='J')) then begin
			writeln('Hiba:előbb TablaMeret-et kell hívni!');
			halt;
		end;
		if Lep='B' then begin
			Nyer1:=Nyer1+A[AktBal];
			inc(AktBal);
		end else if Lep='J' then begin
			Nyer1:=Nyer1+A[AktJobb];
			dec(AktJobb);
		end;
		if A[AktBal]>A[AktJobb] then begin
				Lep2:='B';
				inc(Nyer2,A[AktBal]);
				inc(AktBal);
			end else begin
				Lep2:='J';
				inc(Nyer2,A[AktJobb]);
				dec(AktJobb);
			end;
			if AktBal>AktJobb then begin
				writeln(Nyer1,' ',Nyer2);
				halt;
			end;
	end;
	function Lepesed:char;
	begin
		if Init then begin
			writeln('Hiba:előbb TablaMeret-et kell hívni!');
			halt;
		end;
		Lepesed:=Lep2;
	end;
end.


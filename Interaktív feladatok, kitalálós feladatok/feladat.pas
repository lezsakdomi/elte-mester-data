program Select;
uses query;
const
  MaxN=30000;                    {max. elemszám}
  MaxK=20;                       {MaxN<=2^MaxK}
var
  N:1..MaxN;                     {a tanulók száma}
  M:0..MaxN;                     {az aktuális elemszám}
  Fel:Longint;                   {az aktuális elemszám fele}
  B:array[0..MaxK] of boolean;   {B[k]=true akkor és csak akkor, ha van 2^k elemű részhalmaz}
  Rep:array[0..MaxK] of 0..MaxN; {Rep[k] a B[k] reprezentánsa}
  Pow2:array[0..MaxK] of longint;{Pow2[k]=2^k}
  L:word;                        {a legynagyobb részhalmaz elemszáma 2^L}
  i,k:integer;
Begin
  Pow2[0]:=1;
  for k:=1 to MaxK do begin
		Pow2[k]:=Pow2[k-1] shl 1;
		B[k]:=false;
	end;
  N:=Size;
  if odd(N) then M:=N else M:=N-1;
  Fel:=M div 2 +1;
  L:=0;  i:=0;
  while i<N do begin              	  {amíg nincs elég ismeretünk}
    k:=0; B[0]:=True;
    Inc(i); Rep[0]:=i;
    Inc(i);                       	  {két új elem: i és i+1}
    if i>N then break;
    while B[k] do begin           	  {van két 2^k elemszámú részhalmaz}
      if Member(Rep[k],i)=1 then begin{egyesítsük a két részhalmazt}
        B[k]:=False;
        Inc(k);
        if k>L then L:=k;         	  {új legnagyobb részhalmaz}
      end else begin              	  {ellentétes részhalmazok}
        Dec(M, Pow2[k+1]);        	  {M:=M-2^(k+1)}
        Dec(Fel, Pow2[k]);       	  {Fel:=Fel-2^k}
        B[k]:=False;              	  {töröljük a részhalmazokat}
        if k=L then               	  {L aktualizálása}
          while (L>0)and not B[L] do dec(L);
        k:=-1;
        break;
      end;
    end{while B[k]};

    if k>=0 then begin
      B[k]:=True;                 	  {új 2^k elemszámú részhalmaz}
      Rep[k]:=i;                      {i a reprezentánsa}
    end;

    if (L>0)and(Pow2[L]>=Fel) then	  {van elég ismeret}
      break;
  end{while i<N};

  Answer(Rep[L]);                     {a negoldás}
end.
//az alábbi sorokat mentsük el a query.pas fájlba
unit Query;
interface
  function Size:integer;
  function Member(i,j:integer):integer;
  procedure Answer(i:integer);
Implementation
const
  MaxN=30000;
  MaxL=16;
  Init:boolean=True;
  B:array[Boolean] of 0..1=(0,1);
var
  N,
  M,
  Half,
  FullS,
  NQ:integer;       {# queries}
  T:array[0..MaxN] of integer;
  D:array[0..MaxN] of integer;
  Bit:set of 0..15 absolute M;

 procedure EndQuery;
 begin
   Writeln('0 Pont');
   Halt;
  end{EndQuery};

  procedure Start;
  var i:integer;
  begin
    ReadLn(N);

    for i:=1 to N do begin
      T[i]:=-1;
      D[i]:=0;
    end;
    T[0]:=0; D[0]:=0;
    if Odd(N) then M:=N else M:=N-1;
    Half:=M div 2 +1;

    Init:=False;
    NQ:=0;
    FullS:=0;
    for i:=0 to MaxL-1 do
      if i In Bit then Inc(FullS);
  end{Start};

  function Find(x:integer):integer;
  var Nx,xx:integer;
  begin
    Nx:=x;
    While T[Nx]>0 do Nx:=T[Nx];
    While x<>Nx do begin{path compression}
      xx:=T[x]; T[x]:=Nx;
      x:=xx;
    end;
    Find:=Nx;
  end{Find};

  procedure Union(var Nx:integer; Ny:integer);
  var X:integer;
  begin
    if Nx=0 then
      Nx:=Ny
    else if Ny<>0 then begin
      if T[Nx]>T[Ny] then begin
        X:=Nx; Nx:=Ny; Ny:=X;
      end;
      T[Nx]:=T[Nx]+T[Ny];
      T[Ny]:=Nx;
    end;
  end{Union};

  function Size:integer;
  begin
    if Init then Start;
    WriteLn('Size= ',N);
    Size:=N;
  end{Size};

function Member(i,j:integer):integer;
var Ri,Rj,Di,Dj,Si,Sj:integer;
  Ui,Vi,Uj,Vj:integer;
  SDi,SDj:integer;
  X:Word;
  SX:Set of 0..15 Absolute X;
  Ans:Boolean;
begin
  if Init then begin
    Writeln('HIBA: Illegal dialog. Size must be called first!');
    EndQuery;
  end;
  write(i:1,' ',j,' ');
  if (i<1)Or(i>N)Or (j<1)Or(j>N) then begin
    writeln(i:1,' ',j:1);
    writeln('HIBA: Value out of range'); 
    EndQuery;
  end;

  Inc(NQ);
  Ans:=False;
  Ri:=Find(i);
  Rj:=Find(j);
  Di:=D[Ri]; Dj:=D[Rj];
  if Ri=Rj then begin
    writeln(1);
    Member:=1;
    Exit;
  end;
  if (Ri=Dj)Or(Rj=Di) then begin
    writeln(0);
    Member:=0;
    Exit;
  end;
  Si:=Abs(T[Ri]); Sj:=Abs(T[Rj]);
  SDi:=Abs(T[Di]); SDj:=Abs(T[Dj]);
  if Si>=SDi then begin
    Ui:=Ri; Vi:=Di;
  end else begin
    Ui:=Di; Vi:=Ri;
    X:=Si; Si:=SDi; SDi:=X
  end;
  if Sj>=SDj then begin
    Uj:=Rj; Vj:=Dj;
  end else begin
    Uj:=Dj; Vj:=Rj;
    X:=Sj; Sj:=SDj; SDj:=X
  end;
  if Si+Sj>=Half then begin
    Union(Ui, Vj);
    Union(Vi, Uj);
    D[Ui]:=Vi; if Vi<>0 then D[Vi]:=Ui;
    Ans:=(Find(i)=Find(j));
  end else begin
    if Si+Sj<=SDi+SDj+2 then begin
      Union(Ui, Uj);
      Union(Vi, Vj);
      D[Ui]:=Vi; if Vi<>0 then D[Vi]:=Ui;
      Ans:=(Find(i)=Find(j));
    end else begin
      if Si+SDj=Sj+SDi then begin
        X:=Si+SDj+Sj+SDi;
        if SX * Bit=SX then begin
          Union(Ui, Vj);
          Union(Vi, Uj);
          D[Ui]:=Vi; if Vi<>0 then D[Vi]:=Ui;
          Bit:=Bit-SX;
          Dec(Half, Si+SDj);
	  Ans:=(Find(i)=Find(j));
        end else begin
          Union(Ui, Uj);
          Union(Vi, Vj);
          D[Ui]:=Vi; if Vi<>0 then D[Vi]:=Ui;
	  Ans:=(Find(i)=Find(j));
        end;
      end else begin{Si+SDj<>Sj+SDi}
        Union(Ui, Vj);
        Union(Vi, Uj);
        D[Ui]:=Vi; if Vi<>0 then D[Vi]:=Ui;
	 Ans:=(Find(i)=Find(j));
      end;
    end;
  end;

  Member:=B[Ans];
  writeln(B[Ans]);
end{Member};

procedure Answer(i:integer);
var Ri, Di,x,y,Nx:integer;
  Sum:integer;
  OK:Boolean;
  G:array[0..MaxN] Of Boolean;
  a,b:integer;
begin
  if Init then begin
    Writeln('HIBA: előbb Size-t kell hívni!');
    EndQuery;
  end;
  if (i<1)Or(i>N) then begin
    writeln('Válaszod: ',i);
    writeln('HIBA: tartományon kívüli érték');
    EndQuery;
  end;

  Ri:=Find(i);
  Di:=D[Ri];
  Sum:=0;

  for x:=1 to N do begin
    Nx:=Find(x);
    G[x]:= (Nx<>Ri)And(
           (T[Nx]<T[D[Nx]])Or
           (T[Nx]=T[D[Nx]]) And (Nx<D[Nx])Or
           (Nx=Di)
                      );
  end;
  for x:=1 to N do
    if (T[x]<0)And(x<>Di)And(x<>Ri) then begin
      y:=D[x];
      if T[x]<T[y] then
        Sum:=Sum+Abs(T[x])
      else
        Sum:=Sum+Abs(T[y]);
      T[x]:=0; T[y]:=0;
    end;
  {for x=1..N};
  Sum:=Sum+Abs(T[Di]);
  OK:=Sum<N Div 2+1;

  if OK then
    WriteLn('Válaszod: ',i, ', Helyes')
  else
    WriteLn('Válaszod: ',i, ', Nem helyes');

  if OK then
    WriteLn('Többségi csoport:')
  else
    WriteLn('Kisebbségi csoport:');
  a:=0; b:=0; G[0]:=True; G[N+1]:=True;
  for x:=1 to N+1 do begin
    if Not G[x] then begin
      if Not G[x-1] then
        b:=x
      else begin
        a:=x; b:=a;
      end;
    end else begin
      if a+1<b then
        Write(a:1,'..',b:1,' ')
      else if a<b then
        Write(a:1,' ',b:1,' ')
      else if (b=a)And(a<>0) then
        Write(a:1,' ');
      b:=0;
    end;
  end;
  writeln(); 
  if OK then
    WriteLn('Kisebbségi csoport:')
  else
    WriteLn('Többségi csoport:');
  a:=0; b:=0; G[0]:=False; G[N+1]:=False;
  for x:=1 to N+1 do begin
    if G[x] then begin
      if G[x-1] then
        b:=x
      else begin
        a:=x; b:=a;
      end;
    end else begin
      if a+1<b then
        Write(a:1,'..',b:1,' ')
      else if a<b then
        Write(a:1,' ',b:1,' ')
      else if (b=a)And(a<>0) then
        Write(a:1,' ');
      b:=0;
    end;
  end; WriteLn();

  WriteLn('A végrahajtott kérdések száma: ',NQ:1,' ');

  if OK then begin
    Sum:=N-NQ; if Sum<0 then Sum:=0;
    WriteLn('A lehetséges maximális pontszám: ', FullS);
    WriteLn('Pontszámod: ',Sum:1);
  end else begin
    WriteLn('A lehetséges maximális pontszám:: ', FullS);
    WriteLn('Pontszámod: ',0:1);
  end;

end{Answer};

end.

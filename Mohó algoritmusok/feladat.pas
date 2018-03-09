program Fenykepezes;
(*
Input : Intervallumok {[e1,t1],...,[en,tn]} halmaza.
Output: Legkevesebb elemszamu olyan H halmaz, hogy minden
        intervallumba esik H-nak legalabb egy eleme.
*)
const
  MaxN=3000000;                        { a vendégek max. szama  }
  MinE=1;
  MaxT=100000;												 { a maximális távozási idõ }
var
  N    :longint;                       { az intervallumok szama }
  Int  :array[1..MaxT] of longint;     { az intervallumok: [Int[t],t), ha Int[t]>0 }
  K:longint;                           { a megoldas intervallumainak szama}
  M:array[1..MaxT] of longint;      { a megoldás halmaz}
  Utolso,x:longint;

procedure Beolvas;
{Global:N, Int}
  var
    i,e,t:longint;
  begin
    for i:=1 to MaxT do Int[i]:=0;
    ReadLn(N);
    for i:=1 to N do begin
      ReadLn(e,t);
      if e>Int[t] then Int[t]:=e;
    end;
  end{Beolvas};

procedure KiIr;
{Global: K, M }
  var
    i:longint;
  begin
    WriteLn(K);
    for i:=1 to K-1 do
      Write(M[i],' ');
    WriteLn(M[K]);
  end{KiIr};

begin{Program}
  Beolvas;

  Utolso:=0;{az utolso bevalasztott pont}
  K:=0;     {a bevalasztott pontok szama}
  for x:=1 to MaxT do
    if (Int[x]>0) and (Utolso<Int[x]) then begin
      Utolso:=x-1;
      Inc(K);
      M[K]:=Utolso;
    end;
  {for x};

  KiIr;
End.


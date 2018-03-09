Program feladat;
Const
  MaxK=2000;                        { a kapcsolatok max. szama  }
  MaxN=1000;						{ az emberek max száma }
Type
	matrix=Array[1..MaxK,1..2] of integer;
	
Var
  N		:Integer;	{ az emberek száma }
  K		:Integer;	{ kapcsolatok száma }
  M		:Integer;	{ a kerdezett emberek szama }				   
  Szgy	:matrix;	{ a szülõ-gyerek mátrix }
  
 Procedure Beolvas;
  Var i:Integer;
  Begin
	For i:=1 To MaxK Do 
    begin
		Szgy[i,1]:=0;
		Szgy[i,2]:=0;
	end;
   
    Read(N);
	Readln(K);
    For i:=1 To K Do
    begin
      Read(Szgy[i,1]);
      Readln(Szgy[i,2]);
    end;
  End;
  
Procedure KiIr;
  Begin
	Writeln(M);
  End;
  
Begin{Program}
  
  Beolvas;
  M:=0;
  for i:=1 to K do 
    if Szgy[i,1]=Szgy[1,1] then inc(M);
  KiIr;

End.


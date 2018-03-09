Program verseny;
  const maxm=200;
  type tomb=array[1..maxm] of integer;
  var m: integer;
      arany,ezust,bronz,sor: tomb;
      db: integer;
  
  Procedure Olvas;
    var i: integer;
  begin
    readln(m);
    for i:=1 to m do
      readln(arany[i],ezust[i],bronz[i]);
  end;
  
  Procedure Szamit(var db: integer; var sor: tomb);
    var i,j,x,max: integer;

    Function nagyobb(i,j: integer): Boolean;
      var nagy: Boolean;
    begin
      nagy:=false;
      if Arany[i]>Arany[j] then nagy:=true
      else if Arany[i]=Arany[j] then
              if Ezust[i]>Ezust[j] then nagy:=true
              else if Ezust[i]=Ezust[j] then
                      if Bronz[i]>Bronz[j]then nagy:=true
                      else if (Bronz[i]=Bronz[j]) and (Sor[i]<Sor[j])
                              then nagy:=true;
      nagyobb:=nagy;
    end;

  begin
    for i:=1 to m do Sor[i]:=i;
    for i:=1 to M-1 do
    begin
      max:=i;
      for j:=i+1 to M do
        if nagyobb(Sor[j],Sor[max]) then max:=j;
      x:=Sor[max]; Sor[max]:=Sor[i]; Sor[i]:=x;
    end;
    Db:=m;
    while (Db>0) and
          (Arany[Sor[Db]]+Ezust[Sor[Db]]+Bronz[Sor[Db]]=0) do Db:=Db-1;
  end;

  Procedure Ir(db: integer; sor: tomb);
    var i: integer;
  begin
    for i:=1 to db do write(sor[i],' '); writeln;
  end;
  
begin
  Olvas;
  Szamit(db,sor);
  Ir(db,sor);
end.

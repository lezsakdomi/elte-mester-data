Program homerseklet;
  const maxn=1000;
  var n: integer;
      min,max: array[1..maxn] of integer;
  
  Procedure Olvas;
    var i: integer;
  begin
    readln(n);
    for i:=1 to n do readln(min[i],max[i]);
  end;
  
  Function Szamit: Boolean;
    var i: integer;
  begin
    i:=1;
    while (i<=n) and (min[i]<max[i]) do inc(i);
    Szamit:=(i<=n);
  end;

  Procedure Ir(v: Boolean);
  begin
    if v then writeln('VAN') else writeln('NINCS');
  end;
  
begin
  Olvas;
  Ir(Szamit);
end.

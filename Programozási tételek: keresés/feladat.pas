Program lehules;
  const maxn=1000;
  var n,s: integer;
      min,max: array[1..maxn] of integer;
      van: Boolean;
  
  Procedure Olvas;
    var i: integer;
  begin
    readln(n);
    for i:=1 to n do readln(min[i],max[i]);
  end;
  
  Procedure Szamit(var van: Boolean; var i: integer);
  begin
    i:=2;
    while (i<=n) and (min[i-1]<=max[i]) do inc(i);
    van:=(i<=n);
  end;

  Procedure Ir(v: Boolean; s: integer);
  begin
    if v then 
    begin
      writeln('VAN'); 
      writeln(s);
    end
    else writeln('NINCS');
  end;
  
begin
  Olvas;
  Szamit(van,s);
  Ir(van,s);
end.

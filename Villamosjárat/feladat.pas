Program villamosmegallok;
  const maxn=100;
  type megallo=record
                 t,erk,ind: integer;
               end;
  var i,n,min: integer;
      v: array[1..maxn] of megallo;
  
begin
  readln(n);
  for i:=1 to n do with v[i] do
    readln(t,erk,ind);
  min:=v[1].t;
  for i:=2 to n do
    if v[i].t<min then min:=v[i].t;
  writeln(min);
end.

Program kutya;
  const maxn=10; maxm=100;
  var n,m,i,j,mp: integer;
      max,min: array[1..maxm] of integer;
      p: array[1..maxn,1..maxm of integer;
begin
  readln(n,m);
  for i:=1 to m do read(max[i]); readln;
  for i:=1 to m do read(min[i]); readln;
  for i:=1 to n do
  begin
    for j:=1 to m do read(p[i,j]);
    readln;
  end;
  mp:=0;
  for i:=1 to n do
    for j:=1 to m do 
      if p[i,j]>mp then mp:=p[i,j];
  writeln(mp);
end.

program madarmegfigyeles;
  const maxm=50; maxn=200;
  var
    madarak: array [1..maxm, 1..maxn] of word;
    m,n,i,j,db: longint;

  procedure beolvas;
  var
    i, j: byte;
  begin
    readln(m,n);
    for i := 1 to m do
    begin
      for j := 1 to n do
        read(madarak[i,j]);
      readln;
    end;
  end;

begin
  beolvas;
  db:=0;
  for i:=1 to m do
    for j:=1 to n do
      db:=db+madarak[i,j];
  writeln(db);
end.

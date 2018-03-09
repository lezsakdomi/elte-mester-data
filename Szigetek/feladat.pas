program feladat;

type
  sziget = record
    bal, jobb: word;
  end;

var
  meresek: array [1..10000] of word;
  n: word;
  k: word;


procedure beolvas;
var
  i: word;
begin
  readln(n);
  for i := 1 to n do
    read(meresek[i]);
  readln;
end;

begin
  beolvas;
  i:=1;
  while not ((meresek[i]>0) and (meresek[i+1]=0)) do inc(i);
  writeln(i);
end.

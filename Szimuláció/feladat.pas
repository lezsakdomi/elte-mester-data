Program autok;
  const maxn=1000; max=100;
  var n,b,p,u: integer;
      be: array[1..max] of integer;
      ut: array[1..maxn+1] of integer;
      i,ido,db,j: integer;
begin
  readln(n);
  readln(b);
  readln(p,u);
  for i:=1 to b do 
  begin
    readln(be[i]);
  end;
  for i:=1 to n+1 do ut[i]:=0;
  db:=0; ido:=0; j:=1;
  while db<b do
  begin
    ido:=ido+1; 
    if ut[n+1]=1 then {kilépő}
    begin
      write(ido+n,' ');
      ut[n+1]:=0;
      db:=db+1;
    end;
    if ut[n]=1 then {nem piros lámpa}
      if (ido-1) mod p<p-u then 
      begin
        ut[n+1]:=1; ut[n]:=0;
      end;
    for i:=n-1 downto 1 do if (ut[i]=1) and (ut[i+2]=0) then {léptetés}
    begin
      ut[i+1]:=1; ut[i]:=0;
    end;  
    if (ido>=be[j]) and (ut[1]+ut[2]=0) then {belépő}
    begin
      ut[1]:=1; j:=j+1;
    end;
  end;
  writeln;
end.

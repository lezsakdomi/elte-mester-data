program Particio;
function P2(n,k:integer):int64;
begin
	if (n=1) or (k=1) then 
		P2:=1
	else begin
		if (k>=n) then
			P2:=1+P2(n,n-1)
		else
			P2:=P2(n,k-1)+P2(n-k,k)
	end;
end;
function P(n:integer):int64;
begin
	P:=P2(n,n);
end;
var
  n:longint;
begin{prog}
  readln(n);
  writeln(P(n));
end.

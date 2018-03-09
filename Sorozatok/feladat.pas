program Vasutirendezes;
const
	maxN=10000;
var
  m,n,t,i,l,u1,u3,u4:longint;
  x:byte;
  van2,van3,van4,van43,van32,van23 : boolean;
  K:array[1..maxN] of byte;
begin{prog}
  readln(m);
	for t:=1 to m do begin
		n:=0; u1:=0;
		while(true) do begin
			read(x);
			if x=0 then break;
			inc(n);
			K[n]:=x;
			if (x=1) then u1:=n;
		end;
		if u1=0 then begin
			writeln('Igen'); continue;
		end;
		u3:=0; u4:=0;
		van2:=false; van3:=false; van4:=false;
		van43:=false; van32:=false; van23:=false;
		for i:=u1-1 downto 1 do begin
			case K[i] of
				1: begin end;
				2: begin
						van2:=true;
						if u3>0 then van23:=true;
						if (u3=0)and(u4>0) then van32:=true;
					end;
				3: begin
						van3:=true;
						if u4=0 then van43:=true;
						if (u3=0)and(u4>0) then u3:=i
					end;
				4: begin
						van4:=true;
						if (u4=0) then u4:=i;
					end;
			end;
		end;
		if (not van2)or(not van3)or(not van4) then begin
			writeln('Igen'); continue;
		end;
		if van23 then begin//van 2-3-4 minta E-ben
			writeln('Nem'); continue;
		end;
		if van32 and van43 then begin//van 3-2-4-3 minta E-ben
			van4:=false;
			for l:=u1+1 to n do
				if K[l]=4 then van4:=true;
			if van4 then 
				writeln('Nem')
			else
				writeln('Igen');
		end else begin
			writeln('Igen');
		end;
	end{for m};
end.

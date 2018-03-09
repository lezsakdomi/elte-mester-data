Program vercsoport;
  var x,y: char;
      vcs: string;
  
  Procedure Olvas;
  begin
    readln(x,y);
  end;
  
  Procedure Szamit(x,y: char; var vcs: string);
    var vana,vanb: Boolean;
  begin
    vana:=(x='a') or (y='a');
    vanb:=(x='b') or (y='b');
    if vana then
       if vanb then Vcs:='AB' 
               else Vcs:='A'
    else if vanb then Vcs:='B'
                 else Vcs:='0'
  end;

  Procedure Ir(vcs: string);
  begin
    writeln(vcs);
  end;
  
begin
  Olvas;
  Szamit(x,y,vcs);
  Ir(vcs);
end.

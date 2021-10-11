unit UConstPal;

interface
uses windows,inifiles,sysUtils;

 function GetRGBPaletteEntry(p,n:byte):TPaletteEntry;
 procedure CreatePal(n:integer);
 Procedure LitIni;
 Procedure EcritIni;

var
 PalSelect:integer=1;
 NbCercles:integer=5;

  tablepoints:array[0..5,0..6,0..2] of byte=
  ((($00,$00,$00),($00,$00,$40),($00,$00,$00),($FF,$00,$00),($FF,$FF,$00),($FF,$FF,$FF),($FF,$FF,$FF))
  ,(($00,$00,$00),($40,$40,$40),($00,$00,$00),($00,$FF,$00),($00,$FF,$FF),($FF,$FF,$FF),($FF,$FF,$FF))
  ,(($00,$00,$00),($00,$00,$00),($00,$00,$00),($00,$00,$FF),($00,$FF,$FF),($FF,$FF,$FF),($FF,$FF,$FF))
  ,(($00,$00,$00),($00,$00,$40),($00,$00,$00),($FF,$00,$FF),($00,$00,$FF),($00,$FF,$FF),($FF,$FF,$FF))
  ,(($00,$00,$00),($FF,$00,$00),($FF,$FF,$00),($00,$FF,$00),($00,$FF,$FF),($00,$00,$FF),($FF,$00,$FF))
  ,(($00,$00,$00),($00,$00,$40),($00,$00,$00),($FF,$00,$00),($FF,$FF,$00),($FF,$FF,$FF),($FF,$FF,$FF)));

  pal:array[0..255] of dword;

implementation

const
 tablepos:array[0..6] of byte=(0,8,16,40,64,88,255);

Procedure LitIni;
Var
 Ini:TInifile;
 i:integer;
Begin
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'FLAMMES.INI');
  Try
    PalSelect := Ini.ReadInteger('FLAMMES','PalSelect',1);
    NbCercles := Ini.ReadInteger('FLAMMES','NbCercles',5);
    for i:=0 to 6 do
     begin
      tablepoints[5,i,0]:=Ini.ReadInteger('PERSO','colorR'+inttostr(i),0);
      tablepoints[5,i,1]:=Ini.ReadInteger('PERSO','colorG'+inttostr(i),0);
      tablepoints[5,i,2]:=Ini.ReadInteger('PERSO','colorB'+inttostr(i),0);
     end;
  Finally
    Ini.Free;
  End;
End;

Procedure EcritIni;
Var
 Ini:TInifile;
 i:integer;
Begin
  Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'FLAMMES.INI');
  Try
    Ini.WriteInteger('FLAMMES','PalSelect',PalSelect);
    Ini.WriteInteger('FLAMMES','NbCercles',NbCercles);
    for i:=0 to 6 do
     begin
      Ini.WriteInteger('PERSO','colorR'+inttostr(i),tablepoints[5,i,0]);
      Ini.WriteInteger('PERSO','colorG'+inttostr(i),tablepoints[5,i,1]);
      Ini.WriteInteger('PERSO','colorB'+inttostr(i),tablepoints[5,i,2]);
     end;
  Finally
    Ini.Free;
  End;
End;

procedure CreatePal(n:integer);
var
 i,j,len:integer;
 r,v,b:integer;
begin
 for i:=0 to 5 do
  begin
   len:=tablepos[i+1]-tablepos[i];
   for j:=0 to len do
    begin
     r:=(tablepoints[n,i,0]*(len-j)+ tablepoints[n,i+1,0]*j) div len;
     v:=(tablepoints[n,i,1]*(len-j)+ tablepoints[n,i+1,1]*j) div len;
     b:=(tablepoints[n,i,2]*(len-j)+ tablepoints[n,i+1,2]*j) div len;
     pal[tablepos[i]+j]:=rgb(r,v,b);
    end;
  end;
end;



function GetRGBPaletteEntry(p,n:byte):TPaletteEntry;
begin
result.peFlags:=0;
result.peRed:=GetRValue(pal[n]);;
result.peGreen:=GetGValue(pal[n]);;
result.peBlue:=GetBValue(pal[n]);;
end;

end.

program flammes;

uses
  Forms, Windows, SysUtils, Dialogs,
  Unit1 in 'Unit1.pas' {Form1},
  UCfg in 'UCfg.pas' {Form2},
  UConstPal in 'UConstPal.pas';

{$E scr}

{$R *.res}

var i:integer;

begin
 if hPrevInst = 0 // Handle preview instance = 0 s' il n' y pas d' instance du programme !!!
 then
 begin
 Application.Initialize;
 case (paramStr(1) + ' ')[2] of
 'S' : ScreenMode := scrNormal;
 's' : ScreenMode := scrApercu;
 'p' : ScreenMode := scrPreview;
 'c' : ScreenMode := scrConfig;
 else ScreenMode := scrNormal;
 end;

 if not (ScreenMode = scrConfig)
 then begin
 Application.CreateForm(TForm1, form1);
 ShowWindow(Application.Handle,SW_HIDE);

 if ScreenMode = scrNormal then SystemParametersInfo(SPI_SCREENSAVERRUNNING,1,@i,0);

 if ScreenMode = scrPreview
 then begin
 // Si il n'y a pas le handle de la petite fenetre de preview, on quitte
 if ParamCount < 2
 then Application.Terminate;

 // On place notre fenêtre comme enfant du preview :
 PreviewHandle :=StrToInt(ParamStr(2));
 form1.ParentWindow := PreviewHandle;
 // La fenêtre de propriété fera le Close de FrmPrin quand elle n' en aura plus besoin ...
 end
 else
 form1.Cursor:= -1; // On cache le cursor !

 // On agrandi la fenêtre, soit tout l'écran, soit dans la fenêtre preview
 if ScreenMode =scrNormal then form1.FormStyle:=fsStayOnTop;
 form1.WindowState:=WSMaximized;

 end
 else
 begin
 Application.CreateForm(tform2, form2);
 //application.Terminate;
 end;

Application.Run;
if ScreenMode = scrNormal then SystemParametersInfo(SPI_SCREENSAVERRUNNING,1,@i,0);
end;
end.

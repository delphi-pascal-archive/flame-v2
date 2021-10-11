unit unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, UConstPal;

type
  TScrMode = (scrNormal, scrApercu, scrPreview, scrConfig);

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
   { Dclarations prives }
    procedure DeactivateScrnSaver(var Msg: TMsg; var Handled: boolean);
  public
   { Dclarations publiques }
  end;

const
  maxcercles = 20;

var
  Form1: TForm1;
  buffer: PByteArray;
  image: tbitmap;
  im: tpoint;
  cerclepos: array[1..maxcercles] of record x, y, vx, vy: integer; end;
  crs: TPoint;

  ScreenMode: TScrMode;
  PreviewHandle: hwnd = 0;

implementation

{$R *.dfm}


{$D SCRNSAVE Ecran de veille Flames}

// crée une palette de 256 couleurs

function GenPalette: hpalette;
var
  i: integer;
  Mypalette: Plogpalette;
begin
  CreatePal(PalSelect);
  getmem(Mypalette, sizeof(Plogpalette) + 4 * 256);
  mypalette.palVersion := $300;
  mypalette.palNumEntries := 256;
  for i := 0 to 255 do mypalette^.palPalEntry[i] := GetRGBPaletteEntry(2, i);
  result := createpalette(mypalette^);
  freemem(Mypalette);
end;

// trace un cercle dans le buffer
// avec une sorte d'algorihtme de BRENSENHAM

procedure cercle(xc, yc, a: integer);
var
  d, y, x, x2m1: integer;

  procedure drawpoint(x, y: integer);
  begin
    if (x > 0) and (y > 1) and (x < im.x - 1) and (y < im.Y - 1) then
      buffer[x + y * im.X] := buffer[x + y * im.X] xor (random(5) * 64);
  end;

  procedure pixel(x, y: integer);
  begin
    drawpoint(xc + x, yc + y); drawpoint(xc + y, yc + x);
    drawpoint(xc - x, yc + y); drawpoint(xc - y, yc + x);
    drawpoint(xc + x, yc - y); drawpoint(xc + y, yc - x);
    drawpoint(xc - x, yc - y); drawpoint(xc - y, yc - x);
  end;

begin
  x := 0;
  y := a;
  d := -a;
  x2m1 := -1;
  pixel(0, a);
  while x < y do
  begin
    x2m1 := x2m1 + 2;
    d := d + x2m1;
    if (d >= 0) then
    begin
      dec(y);
      d := d - (y shl 1);
    end;
    pixel(x, y);
    inc(x);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
begin
 // lit les options de configuration
  LitIni;

  GetCursorPos(crs);
  Application.OnMessage := DeactivateScrnSaver;

 //évite le scintillement
  DoubleBuffered := true;
  Randomize;

 //create le bitmap de travail
  image := tbitmap.create;
  image.Width := screen.Width div 2;
  image.Height := screen.Height div 2;
  image.PixelFormat := pf8bit;
 // crée la palette pour que l'effet fonctionne
  image.palette := GenPalette;
  buffer := image.ScanLine[image.height - 1];
 // calcul les dimensions du buffer
  im.x := BytesPerScanline(image.Width, 8, 32);
  im.y := image.Height;
 //efface le buffer
  fillchar(buffer^, im.x * im.y, 0);
 // place les cercles et calcul leur vitesse au hasard
  for i := 1 to NbCercles do
  begin
    cerclepos[i].x := random(im.x - im.y shr 2) + im.y shr 3;
    cerclepos[i].y := random(im.y - im.y shr 2) + im.y shr 3;
    cerclepos[i].vx := random(5) - 2;
    cerclepos[i].vy := random(5) - 2;
  end;
 // lance le timer
  timer1.Enabled := true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i, x, y: integer;
  somme: integer;
begin

 // entretien le feu (les deux lignes du bas de l'image = les deux première ligne du buffer)
  for i := 1 to im.x shr 3 do
  begin
    x := random(im.x);
    buffer^[x] := random(2) * $FF;
    buffer^[im.x + x] := random(2) * $FF;
  end;

  // place les cercle de feu
  for i := 1 to NbCercles do
  begin
    cercle(cerclepos[i].x, cerclepos[i].y, im.y shr 3);
    if cerclepos[i].x + cerclepos[i].vx > im.x - im.y shr 3 then cerclepos[i].vx := -cerclepos[i].vx;
    if cerclepos[i].x + cerclepos[i].vx < im.y shr 3 then cerclepos[i].vx := -cerclepos[i].vx;
    if cerclepos[i].y + cerclepos[i].vy > im.y - im.y shr 3 then cerclepos[i].vy := -cerclepos[i].vy;
    if cerclepos[i].y + cerclepos[i].vy < im.y shr 3 then cerclepos[i].vy := -cerclepos[i].vy;
    cerclepos[i].x := cerclepos[i].x + cerclepos[i].vx;
    cerclepos[i].y := cerclepos[i].y + cerclepos[i].vy;
  end;

 // applique le filtre (un flou remontant...)
 { for y:=im.Y-2 downto 1 do
    for x:=1 to im.X-2 do
     begin
      somme:=(buffer^[x-1+im.x*(y-1)]+
              buffer^[x  +im.x*(y-1)]+
              buffer^[x+1+im.x*(y-1)]+
              buffer^[x-1+im.x*(y  )]+
              buffer^[x+1+im.x*(y  )]+
              buffer^[x-1+im.x*(y+1)]+
              buffer^[x  +im.x*(y+1)]+
              buffer^[x+1+im.x*(y+1)]) shr 3;
      if somme>0 then dec(somme);
      buffer^[x+im.x*(y+1)]:=somme;
     end;  }


  // la même chose mais en assembleur pour la rapidité
  asm
    mov eax,im.y
    sub eax,2
    mul im.x
    sub eax,2
    mov ecx,eax

    mov esi,buffer
    add esi,ecx
    mov edx,im.x
    add esi,edx
    add esi,edx



   @boucle:
    mov edi,esi

    xor ebx,ebx
    xor eax,eax

    mov al,[edi-1]
    add ebx,eax
    mov al,[edi]
    add ebx,eax
    mov al,[edi+1]
    add ebx,eax

    sub edi,edx

    mov al,[edi-1]
    add ebx,eax
    mov al,[edi+1]
    add ebx,eax

    sub edi,edx

    mov al,[edi-1]
    add ebx,eax
    mov al,[edi]
    add ebx,eax
    mov al,[edi+1]
    add ebx,eax

    shr ebx,3

    jz @null

    dec ebx

    @null:

    mov [esi],bl
    dec esi
    loop @boucle
  end;

 // tranfert directement les bytes sur le canvas poru l'affichage
  canvas.CopyRect(clientrect, image.Canvas, rect(0, 0, image.Width, image.Height - 3));
end;

// récupération des messages pour le traitement

procedure TForm1.DeactivateScrnSaver(var Msg: TMsg; var Handled: boolean);
var
  done: boolean;
begin
  if ScreenMode in [scrPreview, scrConfig] then exit;
 // si la souris bouge, on arrete
  if Msg.message = WM_MOUSEMOVE then
    done := (Abs(LOWORD(Msg.lParam) - crs.x) > 5) or
      (Abs(HIWORD(Msg.lParam) - crs.y) > 5)
  else
 // si on appuye sur une touche ou si une demande de fermeture arrive
    done := (Msg.message = WM_KEYDOWN) or (Msg.message = WM_ACTIVATE) or
      (Msg.message = WM_ACTIVATEAPP) or (Msg.message = WM_NCACTIVATE);
  if done then close;
end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  timer1.Free;
  image.Free;
end;

end.

unit UCfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, UConstPal;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    ComboBox1: TComboBox;
    ColorDialog1: TColorDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    procedure Panel1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Panel1Click(Sender: TObject);
begin
 if not colordialog1.Execute then exit;
 tpanel(sender).Color:=colordialog1.Color;
 tablepoints[5,tpanel(sender).Tag,0]:=getRValue(colordialog1.Color);
 tablepoints[5,tpanel(sender).Tag,1]:=getGValue(colordialog1.Color);
 tablepoints[5,tpanel(sender).Tag,2]:=getBValue(colordialog1.Color);

 self.ComboBox1.ItemIndex:=5;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
 close;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
 PalSelect:=combobox1.itemindex;
 panel1.Color:=rgb(tablepoints[PalSelect,0,0],tablepoints[PalSelect,0,1],tablepoints[PalSelect,0,2]);
 panel2.Color:=rgb(tablepoints[PalSelect,1,0],tablepoints[PalSelect,1,1],tablepoints[PalSelect,1,2]);
 panel3.Color:=rgb(tablepoints[PalSelect,2,0],tablepoints[PalSelect,2,1],tablepoints[PalSelect,2,2]);
 panel4.Color:=rgb(tablepoints[PalSelect,3,0],tablepoints[PalSelect,3,1],tablepoints[PalSelect,3,2]);
 panel5.Color:=rgb(tablepoints[PalSelect,4,0],tablepoints[PalSelect,4,1],tablepoints[PalSelect,4,2]);
 panel6.Color:=rgb(tablepoints[PalSelect,5,0],tablepoints[PalSelect,5,1],tablepoints[PalSelect,5,2]);
 panel7.Color:=rgb(tablepoints[PalSelect,6,0],tablepoints[PalSelect,6,1],tablepoints[PalSelect,6,2]);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
 EcritIni;
 close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
 LitIni;
 combobox1.ItemIndex:=PalSelect;
 ComboBox1Change(nil);
 spinedit1.Value:=NbCercles;
end;

procedure TForm2.SpinEdit1Change(Sender: TObject);
begin
 if spinedit1.text='' then exit;
 nbcercles:=spinedit1.Value;
end;

end.

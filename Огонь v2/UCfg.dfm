object Form2: TForm2
  Left = 620
  Top = 206
  BorderStyle = bsDialog
  Caption = 'Flammes Config'
  ClientHeight = 221
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 10
    Width = 95
    Height = 13
    Caption = 'Nombre de cercles :'
  end
  object Label2: TLabel
    Left = 20
    Top = 50
    Width = 97
    Height = 13
    Caption = 'Palette de couleurs :'
  end
  object Button1: TButton
    Left = 14
    Top = 180
    Width = 111
    Height = 31
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 198
    Top = 180
    Width = 111
    Height = 31
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 1
    OnClick = Button2Click
  end
  object SpinEdit1: TSpinEdit
    Left = 120
    Top = 10
    Width = 71
    Height = 22
    MaxValue = 20
    MinValue = 0
    TabOrder = 2
    Value = 5
    OnChange = SpinEdit1Change
  end
  object ComboBox1: TComboBox
    Left = 130
    Top = 50
    Width = 171
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 3
    Text = 'Classique'
    OnChange = ComboBox1Change
    Items.Strings = (
      'Classique'
      'Vert'
      'Bleu'
      'Violet'
      'Arc-en-Ciel'
      'Personnalis'#233)
  end
  object Panel1: TPanel
    Left = 20
    Top = 90
    Width = 31
    Height = 31
    TabOrder = 4
    OnClick = Panel1Click
  end
  object Panel2: TPanel
    Tag = 1
    Left = 60
    Top = 90
    Width = 31
    Height = 31
    TabOrder = 5
    OnClick = Panel1Click
  end
  object Panel3: TPanel
    Tag = 2
    Left = 100
    Top = 90
    Width = 31
    Height = 31
    TabOrder = 6
    OnClick = Panel1Click
  end
  object Panel4: TPanel
    Tag = 3
    Left = 140
    Top = 90
    Width = 31
    Height = 31
    TabOrder = 7
    OnClick = Panel1Click
  end
  object Panel5: TPanel
    Tag = 4
    Left = 180
    Top = 90
    Width = 31
    Height = 31
    TabOrder = 8
    OnClick = Panel1Click
  end
  object Panel6: TPanel
    Tag = 5
    Left = 220
    Top = 90
    Width = 31
    Height = 31
    TabOrder = 9
    OnClick = Panel1Click
  end
  object Panel7: TPanel
    Tag = 6
    Left = 260
    Top = 90
    Width = 31
    Height = 31
    TabOrder = 10
    OnClick = Panel1Click
  end
  object ColorDialog1: TColorDialog
    Left = 144
    Top = 130
  end
end

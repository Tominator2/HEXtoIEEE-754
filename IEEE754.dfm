object Form1: TForm1
  Left = 191
  Top = 118
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'IEEE754'
  ClientHeight = 113
  ClientWidth = 199
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 16
    Width = 22
    Height = 13
    Caption = 'HEX'
  end
  object Label2: TLabel
    Left = 11
    Top = 43
    Width = 47
    Height = 13
    Caption = 'DECIMAL'
  end
  object Button1: TButton
    Left = 64
    Top = 74
    Width = 75
    Height = 25
    Caption = 'Convert'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 64
    Top = 40
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = '0'
  end
  object Edit1: TEdit
    Left = 64
    Top = 11
    Width = 121
    Height = 21
    MaxLength = 8
    TabOrder = 2
    Text = '00000000'
  end
end

object SSMainForm: TSSMainForm
  Left = 268
  Top = 159
  Caption = #25991#20214#22841#26234#33021#21516#27493#24037#20855' V1.1'
  ClientHeight = 422
  ClientWidth = 590
  Color = clBtnFace
  Constraints.MinHeight = 460
  Constraints.MinWidth = 606
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object StatusBar: TStatusBar
    Left = 0
    Top = 403
    Width = 590
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object pnl1: TPanel
    Left = 0
    Top = 105
    Width = 590
    Height = 298
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      590
      298)
    object lbl3: TLabel
      Left = 8
      Top = 6
      Width = 54
      Height = 12
      Caption = #22791#20221#21015#34920':'
    end
    object lbl4: TLabel
      Left = 349
      Top = 272
      Width = 150
      Height = 12
      Anchors = [akRight, akBottom]
      Caption = #24050#29992' 0:00:00 '#21097#20313' 0:00:00'
      ExplicitLeft = 357
      ExplicitTop = 299
    end
    object ListView: TListView
      Tag = 1
      Left = 8
      Top = 24
      Width = 502
      Height = 236
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = '#'
          Width = 30
        end
        item
          Caption = #28304#25991#20214#22841
          Width = 100
        end
        item
          Caption = #30446#26631#25991#20214#22841
          Width = 100
        end
        item
          Caption = #24573#30053#25991#20214
          Width = 100
        end
        item
          Caption = #24573#30053#30446#24405
          Width = 100
        end
        item
          Caption = #23376#25991#20214#22841
          Width = 60
        end>
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
    end
    object btnAdd: TButton
      Tag = 1
      Left = 517
      Top = 23
      Width = 65
      Height = 21
      Anchors = [akTop, akRight]
      Caption = #28155#21152'(&A)'
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnDel: TButton
      Tag = 1
      Left = 517
      Top = 48
      Width = 65
      Height = 21
      Anchors = [akTop, akRight]
      Caption = #21024#38500'(&D)'
      TabOrder = 2
      OnClick = btnDelClick
    end
    object btnClear: TButton
      Tag = 1
      Left = 517
      Top = 72
      Width = 65
      Height = 21
      Anchors = [akTop, akRight]
      Caption = #28165#31354'(&L)'
      TabOrder = 3
      OnClick = btnClearClick
    end
    object btnUp: TButton
      Tag = 1
      Left = 517
      Top = 97
      Width = 65
      Height = 21
      Anchors = [akTop, akRight]
      Caption = #19978#31227'(&U)'
      TabOrder = 4
      OnClick = btnUpClick
    end
    object btnDown: TButton
      Tag = 1
      Left = 517
      Top = 122
      Width = 65
      Height = 21
      Anchors = [akTop, akRight]
      Caption = #19979#31227'(&W)'
      TabOrder = 5
      OnClick = btnDownClick
    end
    object btnImport: TButton
      Tag = 1
      Left = 517
      Top = 146
      Width = 65
      Height = 21
      Anchors = [akTop, akRight]
      Caption = #23548#20837'(&I)'
      TabOrder = 6
      OnClick = btnImportClick
    end
    object btnExport: TButton
      Tag = 1
      Left = 517
      Top = 171
      Width = 65
      Height = 21
      Anchors = [akTop, akRight]
      Caption = #23548#20986'(&E)'
      TabOrder = 7
      OnClick = btnExportClick
    end
    object btnExecute: TButton
      Left = 517
      Top = 267
      Width = 65
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = #21516#27493'(&I)'
      TabOrder = 10
      OnClick = btnExecuteClick
    end
    object pb1: TProgressBar
      Left = 8
      Top = 270
      Width = 334
      Height = 16
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 11
    end
    object btnAbout: TButton
      Tag = 1
      Left = 516
      Top = 217
      Width = 65
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = #20851#20110'(&B)'
      TabOrder = 8
      OnClick = btnAboutClick
    end
    object btnExit: TButton
      Tag = 1
      Left = 516
      Top = 241
      Width = 65
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = #36864#20986'(&X)'
      TabOrder = 9
      OnClick = btnExitClick
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 590
    Height = 105
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      590
      105)
    object lbl1: TLabel
      Left = 8
      Top = 8
      Width = 54
      Height = 12
      Caption = #28304#25991#20214#22841':'
    end
    object lbl2: TLabel
      Left = 8
      Top = 38
      Width = 66
      Height = 12
      Caption = #30446#26631#25991#20214#22841':'
    end
    object btnSrcDir: TSpeedButton
      Left = 558
      Top = 8
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Caption = '...'
      OnClick = btnSrcDirClick
    end
    object btnDstDir: TSpeedButton
      Left = 558
      Top = 34
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Caption = '...'
      OnClick = btnDstDirClick
    end
    object lbl5: TLabel
      Left = 8
      Top = 64
      Width = 54
      Height = 12
      Caption = #24573#30053#25991#20214':'
    end
    object lbl6: TLabel
      Left = 278
      Top = 63
      Width = 54
      Height = 12
      Caption = #24573#30053#30446#24405':'
    end
    object chkIncSub: TCheckBox
      Tag = 1
      Left = 79
      Top = 88
      Width = 145
      Height = 17
      Caption = #21253#21547#23376#25991#20214#22841'(&S)'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object edtSrc: TEdit
      Tag = 1
      Left = 79
      Top = 8
      Width = 472
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object edtDst: TEdit
      Tag = 1
      Left = 79
      Top = 34
      Width = 473
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object edtIgnoreFile: TEdit
      Tag = 1
      Left = 79
      Top = 60
      Width = 186
      Height = 20
      Hint = #25903#25345#26631#20934#36890#37197#31526#65292#22810#39033#20197#36887#21495#20998#38548
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object edtIgnoreDir: TEdit
      Tag = 1
      Left = 349
      Top = 60
      Width = 203
      Height = 20
      Hint = #25903#25345#26631#20934#36890#37197#31526#65292#22810#39033#20197#36887#21495#20998#38548
      Anchors = [akLeft, akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'ssb'
    Filter = #22791#20221#37197#32622'(*.ssb)|*.ssb'
    Left = 304
    Top = 216
  end
  object dlgSave: TSaveDialog
    DefaultExt = 'ssb'
    Filter = #22791#20221#37197#32622'(*.ssb)|*.ssb'
    Left = 336
    Top = 216
  end
  object tmr1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmr1Timer
    Left = 376
    Top = 216
  end
end

object ViewPrincipal: TViewPrincipal
  Left = 0
  Top = 0
  Caption = 'Agrofit - Consulta de Defensivos Agr'#237'colas'
  ClientHeight = 615
  ClientWidth = 700
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 20
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 700
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Color = clGreen
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 16
      Top = 16
      Width = 421
      Height = 23
      Caption = 'Sistema de Consultas Agrofit - API Embrapa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 60
    Width = 700
    Height = 555
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object grpConsulta: TGroupBox
      AlignWithMargins = True
      Left = 16
      Top = 16
      Width = 668
      Height = 93
      Margins.Left = 16
      Margins.Top = 16
      Margins.Right = 16
      Margins.Bottom = 0
      Align = alTop
      Caption = ' Consulta '
      TabOrder = 0
      object grdConsulta: TGridPanel
        Left = 2
        Top = 22
        Width = 664
        Height = 69
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 33.333333333333340000
          end
          item
            Value = 33.333333333333340000
          end
          item
            Value = 33.333333333333310000
          end>
        ControlCollection = <
          item
            Column = 0
            ColumnSpan = 2
            Control = pnlConsultaFields
            Row = 0
          end>
        ParentColor = True
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 0
        object pnlConsultaFields: TPanel
          Left = 0
          Top = 0
          Width = 443
          Height = 69
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object lblNumeroRegistro: TLabel
            AlignWithMargins = True
            Left = 16
            Top = 0
            Width = 411
            Height = 20
            Margins.Left = 16
            Margins.Top = 0
            Margins.Right = 16
            Margins.Bottom = 0
            Align = alTop
            Caption = 'N'#250'mero do Registro (digite ou selecione)'
            ExplicitWidth = 275
          end
          object btnConsultar: TButton
            AlignWithMargins = True
            Left = 297
            Top = 22
            Width = 130
            Height = 30
            Cursor = crHandPoint
            Hint = 'Consulta na API se n'#227'o existir no banco local'
            Margins.Left = 4
            Margins.Top = 2
            Margins.Right = 16
            Margins.Bottom = 17
            Align = alRight
            Caption = 'Consultar'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = btnConsultarClick
            ExplicitTop = 23
            ExplicitHeight = 28
          end
          object cmbNumeroRegistro: TComboBox
            AlignWithMargins = True
            Left = 16
            Top = 23
            Width = 273
            Height = 28
            Cursor = crHandPoint
            Margins.Left = 16
            Margins.Right = 4
            Margins.Bottom = 0
            Align = alClient
            TabOrder = 0
          end
        end
      end
    end
    object grpDados: TGroupBox
      AlignWithMargins = True
      Left = 16
      Top = 125
      Width = 668
      Height = 414
      Margins.Left = 16
      Margins.Top = 16
      Margins.Right = 16
      Margins.Bottom = 16
      Align = alClient
      Caption = ' Dados do Defensivo '
      TabOrder = 1
      object grdDados: TGridPanel
        Left = 2
        Top = 22
        Width = 664
        Height = 346
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = pnlNumeroRegistro
            Row = 0
          end
          item
            Column = 0
            ColumnSpan = 2
            Control = edtMarcaComercial
            Row = 1
          end
          item
            Column = 0
            ColumnSpan = 2
            Control = edtClasseCategoria
            Row = 2
          end
          item
            Column = 0
            ColumnSpan = 2
            Control = edtTitularRegistro
            Row = 3
          end
          item
            Column = 0
            ColumnSpan = 2
            Control = edtClassificacaoToxicologica
            Row = 4
          end>
        ParentColor = True
        RowCollection = <
          item
            Value = 20.000000000000000000
          end
          item
            Value = 20.000000000000000000
          end
          item
            Value = 20.000000000000000000
          end
          item
            Value = 20.000000000000000000
          end
          item
            Value = 20.000000000000000000
          end>
        TabOrder = 0
        object pnlNumeroRegistro: TPanel
          Left = 0
          Top = 0
          Width = 332
          Height = 69
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object lblOrigemDados: TLabel
            AlignWithMargins = True
            Left = 16
            Top = 52
            Width = 300
            Height = 15
            Margins.Left = 16
            Margins.Top = 0
            Margins.Right = 16
            Align = alTop
            Alignment = taRightJustify
            Caption = 'Retorno procedimento'
            Color = clBlack
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            ExplicitLeft = 188
            ExplicitWidth = 128
          end
          object edtNumeroRegistroExibicao: TLabeledEdit
            AlignWithMargins = True
            Left = 16
            Top = 24
            Width = 300
            Height = 28
            Margins.Left = 16
            Margins.Top = 24
            Margins.Right = 16
            Margins.Bottom = 0
            Align = alTop
            EditLabel.Width = 135
            EditLabel.Height = 20
            EditLabel.Caption = 'N'#250'mero do Registro'
            ParentColor = True
            ReadOnly = True
            TabOrder = 0
            Text = ''
          end
        end
        object edtMarcaComercial: TLabeledEdit
          AlignWithMargins = True
          Left = 16
          Top = 93
          Width = 632
          Height = 28
          Margins.Left = 16
          Margins.Top = 24
          Margins.Right = 16
          Margins.Bottom = 0
          Align = alTop
          EditLabel.Width = 112
          EditLabel.Height = 20
          EditLabel.Caption = 'Marca Comercial'
          ParentColor = True
          ReadOnly = True
          TabOrder = 1
          Text = ''
        end
        object edtClasseCategoria: TLabeledEdit
          AlignWithMargins = True
          Left = 16
          Top = 162
          Width = 632
          Height = 28
          Margins.Left = 16
          Margins.Top = 24
          Margins.Right = 16
          Margins.Bottom = 0
          Align = alTop
          EditLabel.Width = 198
          EditLabel.Height = 20
          EditLabel.Caption = 'Classe/Categoria Agron'#244'mica'
          ParentColor = True
          ReadOnly = True
          TabOrder = 2
          Text = ''
        end
        object edtTitularRegistro: TLabeledEdit
          AlignWithMargins = True
          Left = 16
          Top = 232
          Width = 632
          Height = 28
          Margins.Left = 16
          Margins.Top = 24
          Margins.Right = 16
          Margins.Bottom = 0
          Align = alTop
          EditLabel.Width = 123
          EditLabel.Height = 20
          EditLabel.Caption = 'Titular do Registro'
          ParentColor = True
          ReadOnly = True
          TabOrder = 3
          Text = ''
        end
        object edtClassificacaoToxicologica: TLabeledEdit
          AlignWithMargins = True
          Left = 16
          Top = 301
          Width = 632
          Height = 28
          Margins.Left = 16
          Margins.Top = 24
          Margins.Right = 16
          Margins.Bottom = 0
          Align = alTop
          EditLabel.Width = 173
          EditLabel.Height = 20
          EditLabel.Caption = 'Classifica'#231#227'o Toxicol'#243'gica'
          ParentColor = True
          ReadOnly = True
          TabOrder = 4
          Text = ''
        end
      end
      object pnlBotoes: TPanel
        Left = 2
        Top = 368
        Width = 664
        Height = 44
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object btnSalvar: TButton
          AlignWithMargins = True
          Left = 518
          Top = 0
          Width = 130
          Height = 30
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 16
          Margins.Bottom = 14
          Align = alRight
          Caption = 'Salvar no Banco'
          TabOrder = 0
          OnClick = btnSalvarClick
          ExplicitHeight = 28
        end
      end
    end
  end
end

unit Agrofit.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Agrofit.Controller.DefensivoAgricola,
  Agrofit.Service.ApiClient,
  Agrofit.Repository.DefensivoAgricola,
  Agrofit.Domain.DefensivoAgricola,
  System.Generics.Collections, Vcl.Mask;

type
  TViewPrincipal = class(TForm)
    pnlTop: TPanel;
    lblTitulo: TLabel;
    pnlCenter: TPanel;
    grpConsulta: TGroupBox;
    grpDados: TGroupBox;
    grdDados: TGridPanel;
    pnlNumeroRegistro: TPanel;
    edtNumeroRegistroExibicao: TLabeledEdit;
    edtMarcaComercial: TLabeledEdit;
    edtClasseCategoria: TLabeledEdit;
    edtTitularRegistro: TLabeledEdit;
    edtClassificacaoToxicologica: TLabeledEdit;
    lblOrigemDados: TLabel;
    pnlBotoes: TPanel;
    btnSalvar: TButton;
    grdConsulta: TGridPanel;
    pnlConsultaFields: TPanel;
    lblNumeroRegistro: TLabel;
    cmbNumeroRegistro: TComboBox;
    btnConsultar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
  private
    FController: TDefensivoAgricolaController;
    FDefensivoAtual: TDefensivoAgricola;
    procedure LimparCampos;
    procedure ExibirDadosDefensivo(ADefensivo: TDefensivoAgricola; AOrigemDados: TOrigemDados);
    procedure CarregarComboRegistros;

    /// <summary>
    ///   Só habilita se:
    ///   <para>1. Tem defensivo carregado;</para>
    ///   <para>2. Veio da API (não do banco);</para>
    ///   <para>3. Não está salvo ainda.</para>
    /// </summary>
    procedure HabilitarBotaoSalvar(AOrigemDados: TOrigemDados);
  public
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

uses
  Agrofit.Core.MyLib;

{$R *.dfm}

procedure TViewPrincipal.FormCreate(Sender: TObject);
var
  LApiClient: iApiClient;
  LRepository: iDefensivoAgricolaRepository;
begin
  LApiClient := TAgrofitApiClient.Create;
  LRepository := TDefensivoAgricolaRepository.Create;

  FController := TDefensivoAgricolaController.Create(LApiClient, LRepository);
  FDefensivoAtual := nil;

  btnSalvar.Enabled := False;
  Self.LimparCampos;
  Self.CarregarComboRegistros;
end;

procedure TViewPrincipal.FormDestroy(Sender: TObject);
begin
  if Assigned(FDefensivoAtual) then
    FreeAndNil(FDefensivoAtual);
  FreeAndNil(FController);
end;

procedure TViewPrincipal.btnConsultarClick(Sender: TObject);
var
  LNumeroRegistro: string;
  LOrigemDados: TOrigemDados;
begin
  LNumeroRegistro := Trim(cmbNumeroRegistro.Text);

  if LNumeroRegistro = EmptyStr then
  begin
    TLib.MsgAtencao('Informe o número do registro.');
    cmbNumeroRegistro.SetFocus;
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    try
      if Assigned(FDefensivoAtual) then
        FreeAndNil(FDefensivoAtual);

      FDefensivoAtual := FController.ConsultarDefensivo(LNumeroRegistro, LOrigemDados); // =>

      Self.ExibirDadosDefensivo(FDefensivoAtual, LOrigemDados);

      Self.HabilitarBotaoSalvar(LOrigemDados);

      if LOrigemDados = odAPI then
        Self.CarregarComboRegistros;
    except
      on E: Exception do
      begin
        TLib.MsgErro('Erro ao consultar: ' + E.Message);
        Self.LimparCampos;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TViewPrincipal.btnSalvarClick(Sender: TObject);
begin
  if not Assigned(FDefensivoAtual) then
  begin
    TLib.MsgAtencao('Nenhum defensivo consultado para salvar.');
    Exit;
  end;

  if TLib.MsgConfirmacao('Confirma a gravação no banco?') then
    try
      FController.SalvarDefensivo(FDefensivoAtual); // =>
      TLib.MsgInformacao('Defensivo salvo com sucesso.');

      Self.CarregarComboRegistros;
      btnSalvar.Enabled := False;

      lblOrigemDados.Caption := 'Dados salvos no banco local';
      lblOrigemDados.Font.Color := clGreen;
    except
      on E: Exception do
        TLib.MsgErro('Erro ao salvar: ' + E.Message);
    end;
end;

procedure TViewPrincipal.LimparCampos;
begin
  Tlib.LimparComponentes([
    edtNumeroRegistroExibicao,
    edtMarcaComercial,
    edtClasseCategoria,
    edtTitularRegistro,
    edtClassificacaoToxicologica,
    lblOrigemDados
    ]);
  btnSalvar.Enabled := False;
end;

procedure TViewPrincipal.ExibirDadosDefensivo(ADefensivo: TDefensivoAgricola; AOrigemDados: TOrigemDados);
begin
  if Assigned(ADefensivo) then
  begin
    edtNumeroRegistroExibicao.Text := ADefensivo.NumeroRegistro;
    edtMarcaComercial.Text := ADefensivo.MarcaComercial;
    edtClasseCategoria.Text := ADefensivo.ClasseCategoria;
    edtTitularRegistro.Text := ADefensivo.TitularRegistro;
    edtClassificacaoToxicologica.Text := ADefensivo.ClassificacaoToxicologica;

    if AOrigemDados = odBanco then
    begin
      lblOrigemDados.Caption := 'Dados do banco local';
      lblOrigemDados.Font.Color := clBlue;
    end
    else
    begin
      lblOrigemDados.Caption := 'Dados atualizados da API';
      lblOrigemDados.Font.Color := clGreen;
    end;
  end
  else
    Self.LimparCampos;
end;

procedure TViewPrincipal.CarregarComboRegistros;
var
  LNumerosRegistro: TList<string>;
  LNumeroRegistro: string;
  LTextoAtual: string;
begin
  LTextoAtual := cmbNumeroRegistro.Text;
  cmbNumeroRegistro.Items.Clear;

  try
    LNumerosRegistro := FController.ListarNumerosRegistrados;
    try
      for LNumeroRegistro in LNumerosRegistro do
        cmbNumeroRegistro.Items.Add(LNumeroRegistro);

      if LTextoAtual <> EmptyStr then
        cmbNumeroRegistro.Text := LTextoAtual;
    finally
      LNumerosRegistro.Free;
    end;
  except
    on E: Exception do
      TLib.MsgErro('Erro ao carregar números do registro salvos: ' + E.Message);
  end;
end;

procedure TViewPrincipal.HabilitarBotaoSalvar(AOrigemDados: TOrigemDados);
begin
  if Assigned(FDefensivoAtual) and (AOrigemDados = odAPI) then
    btnSalvar.Enabled := not FController.ExisteNoBanco(FDefensivoAtual.NumeroRegistro)
  else
    btnSalvar.Enabled := False;
end;

end.


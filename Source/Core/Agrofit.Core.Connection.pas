unit Agrofit.Core.Connection;

interface

uses
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.UI,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.Intf,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.Async,
  FireDAC.Stan.Def,
  FireDAC.Stan.Error,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Pool,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  System.Classes,
  System.IniFiles,
  System.SysUtils;

type
  TDatabaseConnection = class
  private
    FConnection: TFDConnection;
    FWaitCursor: TFDGUIxWaitCursor;
    FFDPhysFBDriverLink: TFDPhysFBDriverLink;
    class var FInstance: TDatabaseConnection;

    /// <summary>Parâmetros de conexão para o FConnection.</summary>
    procedure SetupConnectionFirebird(const ACaminhoArquivoIni: string);
    function SetupFDPhysFBDriverLinkFirebird(const ACaminhoArquivoIni: string): string;
    function GetValorArquivoIni(const ACaminhoArquivo, ASecao, AChave: string): string;
  public
    /// <summary>Verifica a existência do arquivo Config.ini, que contém os parâmetros de conexão com o banco de dados.</summary>
    /// <remarks>A depender, <see cref='SetupConnectionFirebird'/> poderá ser acionado.</remarks>
    constructor Create;
    destructor Destroy; override;
    class function GetInstance: TDatabaseConnection;
    class procedure DestroyInstance;
    function GetConnection: TFDConnection;
    function GetQuery: TFDQuery;
  end;

const
  C_MSG_ERRO_SUPORTE: string = 'Entre em contato com o Suporte. O aplicativo será finalizado.';

implementation

uses
  Vcl.Forms,
  Winapi.Windows;

constructor TDatabaseConnection.Create;
var
  LCaminhoArquivoIni: string;
begin
  inherited Create;

  {$REGION 'Config.ini'}
  LCaminhoArquivoIni := ExtractFilePath(Application.ExeName) + 'Config.ini';
  if not FileExists(LCaminhoArquivoIni) then
  begin
    Application.MessageBox(PChar(Format(
      'O arquivo %s não foi encontrado no mesmo diretório do sistema.' + sLineBreak +
        '%s', [LCaminhoArquivoIni, C_MSG_ERRO_SUPORTE]
      )),
      'Erro', MB_ICONERROR + MB_OK);
    Application.Terminate;
    Application.ProcessMessages;
    ExitProcess(0);
  end;
  {$ENDREGION}

  {$REGION 'FFDPhysFBDriverLink'}
  if not Assigned(FFDPhysFBDriverLink) then
  begin
    FFDPhysFBDriverLink := TFDPhysFBDriverLink.Create(nil);
    try
      FFDPhysFBDriverLink.VendorLib := Self.SetupFDPhysFBDriverLinkFirebird(LCaminhoArquivoIni);
    except
      on E: Exception do
      begin
        Application.Terminate;
        Application.ProcessMessages;
        ExitProcess(0);
      end;
    end;
  end;
  {$ENDREGION}

  {$REGION 'FConnection'}
  if not Assigned(FConnection) then
  begin
    FConnection := TFDConnection.Create(nil);
    try
      Self.SetupConnectionFirebird(LCaminhoArquivoIni);

      FConnection.LoginPrompt := False;
      FConnection.Connected := True;
    except
      on E: Exception do
      begin
        Application.Terminate;
        Application.ProcessMessages;
        ExitProcess(0);
      end;
    end;
  end;
  {$ENDREGION}

  if not Assigned(FWaitCursor) then
    FWaitCursor := TFDGUIxWaitCursor.Create(nil);
end;

destructor TDatabaseConnection.Destroy;
begin
  FWaitCursor.Free;
  FFDPhysFBDriverLink.Free;
  FConnection.Free;
  inherited;
end;

class procedure TDatabaseConnection.DestroyInstance;
begin
  if Assigned(FInstance) then
    FreeAndNil(FInstance);
end;

function TDatabaseConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

class function TDatabaseConnection.GetInstance: TDatabaseConnection;
begin
  if not Assigned(FInstance) then
    FInstance := TDatabaseConnection.Create;
  Result := FInstance;
end;

function TDatabaseConnection.GetQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConnection;
end;

function TDatabaseConnection.GetValorArquivoIni(const ACaminhoArquivo, ASecao, AChave: string): string;
var
  LArquivoIni: TIniFile;
begin
  LArquivoIni := TIniFile.Create(ACaminhoArquivo);
  try
    try
      Result := LArquivoIni.ReadString(ASecao, AChave, 'Erro ao ler o valor');
      if Result = EmptyStr then
        raise Exception.CreateFmt('Erro ao tentar ler um valor do arquivo %s' + sLineBreak +
          '%s', [ACaminhoArquivo, C_MSG_ERRO_SUPORTE]);
    except
      on E: Exception do
      begin
        Application.Terminate;
        Application.ProcessMessages;
        ExitProcess(0);
      end;
    end;
  finally
    FreeAndNil(LArquivoIni);
  end;
end;

procedure TDatabaseConnection.SetupConnectionFirebird(const ACaminhoArquivoIni: string);
begin
  FConnection.Params.Clear;
  FConnection.Params.Add(Format('DriverName=%s', [Self.GetValorArquivoIni(ACaminhoArquivoIni, 'Database', 'DriverName')]));
  FConnection.Params.Add('DriverID=FB');
  FConnection.Params.Add(Format('Database=%s', [Self.GetValorArquivoIni(ACaminhoArquivoIni, 'Database', 'PathDB')]));
  FConnection.Params.Add(Format('Server=%s', [Self.GetValorArquivoIni(ACaminhoArquivoIni, 'Database', 'Server')]));
  FConnection.Params.Add('User_name=SYSDBA'); // !!!
  FConnection.Params.Add('Password=masterkey'); // !!!
  FConnection.Params.Add(Format('Port=%s', [Self.GetValorArquivoIni(ACaminhoArquivoIni, 'Database', 'Port')]));

  if (FConnection.Params.Values['DriverName'] = EmptyStr) or
    (FConnection.Params.Values['Database'] = EmptyStr) or
    (FConnection.Params.Values['Server'] = EmptyStr) or
    (FConnection.Params.Values['Port'] = EmptyStr) then
    raise Exception.CreatefMT('Erro ao obter os parâmetros de conexão com o banco de dados.' + sLineBreak +
      '%s', [C_MSG_ERRO_SUPORTE]);
end;

function TDatabaseConnection.SetupFDPhysFBDriverLinkFirebird(const ACaminhoArquivoIni: string): string;
begin
  Result := Self.GetValorArquivoIni(ACaminhoArquivoIni, 'FireDAC', 'VendorLib');
  if Result = EmptyStr then
    raise Exception.CreateFmt('Erro ao obter o parâmetro do fbclient.dll de Config.ini.' + sLineBreak +
      '%s', [C_MSG_ERRO_SUPORTE]);
end;

initialization

finalization
  TDatabaseConnection.DestroyInstance;

end.

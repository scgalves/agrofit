unit Agrofit.Repository.DefensivoAgricola;

interface

uses
  Agrofit.Domain.DefensivoAgricolaDB,
  Agrofit.Core.Connection,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  System.SysUtils,
  System.Generics.Collections;

type
  iDefensivoAgricolaRepository = interface
    procedure Inserir(const ADefensivoAgricolaDB: TDefensivoAgricolaDB);
    function BuscarPorNumeroRegistro(const ANumeroRegistro: string): TDefensivoAgricolaDB;
    function ListarTodosNumerosRegistro: TList<string>;
    function Existe(const ANumeroRegistro: string): Boolean;
  end;

  TDefensivoAgricolaRepository = class(TInterfacedObject, iDefensivoAgricolaRepository)
  public
    procedure Inserir(const ADefensivoAgricolaDB: TDefensivoAgricolaDB);
    function BuscarPorNumeroRegistro(const ANumeroRegistro: string): TDefensivoAgricolaDB;
    function ListarTodosNumerosRegistro: TList<string>;
    function Existe(const ANumeroRegistro: string): Boolean;
  end;

implementation

uses
  FireDAC.DApt;

procedure TDefensivoAgricolaRepository.Inserir(const ADefensivoAgricolaDB: TDefensivoAgricolaDB);
var
  LQry: TFDQuery;
begin
  LQry := nil;
  try
    try
      LQry := TDatabaseConnection
        .GetInstance
        .GetQuery;

      LQry.Connection.StartTransaction;

      LQry.SQL.Text :=
        'insert into DEFENSIVO_AGRICOLA' +
        ' (NUMERO_REGISTRO, MARCA_COMERCIAL, CLASSE_CATEGORIA_AGRONOMICA, TITULAR_REGISTRO, CLASSIFICACAO_TOXICOLOGICA) ' +
        'values' +
        ' (:NUMERO_REGISTRO, :MARCA_COMERCIAL, :CLASSE_CATEGORIA_AGRONOMICA, :TITULAR_REGISTRO, :CLASSIFICACAO_TOXICOLOGICA)';
      LQry.ParamByName('NUMERO_REGISTRO').AsString := ADefensivoAgricolaDB.NumeroRegistro;
      LQry.ParamByName('MARCA_COMERCIAL').AsString := ADefensivoAgricolaDB.MarcaComercial;
      LQry.ParamByName('CLASSE_CATEGORIA_AGRONOMICA').AsString := ADefensivoAgricolaDB.ClasseCategoria;
      LQry.ParamByName('TITULAR_REGISTRO').AsString := ADefensivoAgricolaDB.TitularRegistro;
      LQry.ParamByName('CLASSIFICACAO_TOXICOLOGICA').AsString := ADefensivoAgricolaDB.ClassificacaoToxicologica;
      LQry.ExecSQL;

      LQry.Connection.Commit;
    except
      on E: Exception do
      begin
        if Assigned(LQry) and Assigned(LQry.Connection) then
          LQry.Connection.Rollback;

        E.Message := 'Ocorreu um erro na tentativa de inserir o defensivo agrícola: ' + E.Message;
        raise;
      end;
    end;
  finally
    FreeAndNil(LQry);
  end;
end;

function TDefensivoAgricolaRepository.BuscarPorNumeroRegistro(const ANumeroRegistro: string): TDefensivoAgricolaDB;
var
  LQry: TFDQuery;
begin
  Result := nil;
  LQry := nil;
  try
    LQry := TDatabaseConnection
      .GetInstance
      .GetQuery;

    // 1. Buscar dados principais
    LQry.SQL.Text :=
      'select ID, NUMERO_REGISTRO, MARCA_COMERCIAL, CLASSE_CATEGORIA_AGRONOMICA, TITULAR_REGISTRO, CLASSIFICACAO_TOXICOLOGICA ' +
      'from DEFENSIVO_AGRICOLA ' +
      'where NUMERO_REGISTRO = :NUMERO_REGISTRO';
    LQry.ParamByName('NUMERO_REGISTRO').AsString := ANumeroRegistro;
    LQry.Open;

    if not LQry.IsEmpty then
    begin
      Result := TDefensivoAgricolaDB.Create;
      Result.Id := LQry.FieldByName('ID').AsInteger;
      Result.NumeroRegistro := LQry.FieldByName('NUMERO_REGISTRO').AsString;
      Result.MarcaComercial := LQry.FieldByName('MARCA_COMERCIAL').AsString;
      Result.ClasseCategoria := LQry.FieldByName('CLASSE_CATEGORIA_AGRONOMICA').AsString;
      Result.TitularRegistro := LQry.FieldByName('TITULAR_REGISTRO').AsString;
      Result.ClassificacaoToxicologica := LQry.FieldByName('CLASSIFICACAO_TOXICOLOGICA').AsString;
    end;
  finally
    LQry.Close;
    FreeAndNil(LQry);
  end;
end;

function TDefensivoAgricolaRepository.ListarTodosNumerosRegistro: TList<string>;
var
  LQry: TFDQuery;
begin
  Result := TList<string>.Create;
  LQry := nil;
  try
    LQry := TDatabaseConnection
      .GetInstance
      .GetQuery;

    LQry.SQL.Text :=
      'select NUMERO_REGISTRO ' +
      'from DEFENSIVO_AGRICOLA ' +
      'order by NUMERO_REGISTRO';
    LQry.Open;

    while not LQry.Eof do
    begin
      Result.Add(LQry.FieldByName('NUMERO_REGISTRO').AsString);
      LQry.Next;
    end;
  finally
    LQry.Close;
    FreeAndNil(LQry);
  end;
end;

function TDefensivoAgricolaRepository.Existe(const ANumeroRegistro: string): Boolean;
var
  LQry: TFDQuery;
begin
  LQry := nil;
  try
    LQry := TDatabaseConnection
      .GetInstance
      .GetQuery;

    LQry.SQL.Text :=
      'select count(*) as TOTAL ' +
      'from DEFENSIVO_AGRICOLA ' +
      'where NUMERO_REGISTRO = :NUMERO_REGISTRO';
    LQry.ParamByName('NUMERO_REGISTRO').AsString := ANumeroRegistro;
    LQry.Open;

    Result := LQry.FieldByName('TOTAL').AsInteger > 0;
  finally
    LQry.Close;
    FreeAndNil(LQry);
  end;
end;

end.

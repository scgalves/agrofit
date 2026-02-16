unit Agrofit.Service.ApiClient;

interface

uses
  Agrofit.DTO.DefensivoAgricola,
  System.Net.HttpClient,
  System.JSON,
  System.SysUtils,
  System.Classes;

type
  iApiClient = interface
    function ConsultarDefensivo(const ANumeroRegistro: string): TDefensivoAgricolaDTO;
  end;

  TAgrofitApiClient = class(TInterfacedObject, iApiClient)
  private
    const C_API_URL = 'https://api.cnptia.embrapa.br/agrofit/v1/produtos-tecnicos/';
    const C_API_TOKEN = '9c9e9246-6835-33b3-90f7-fb1cff941bae';
    function ArrayToString(const AJSONArray: TJSONArray): string;
    function ParseJSON(const AJSON: string): TDefensivoAgricolaDTO;
  public
    function ConsultarDefensivo(const ANumeroRegistro: string): TDefensivoAgricolaDTO;
  end;

implementation

uses
  System.Generics.Collections,
  System.Net.URLClient;

function TAgrofitApiClient.ArrayToString(const AJSONArray: TJSONArray): string;
var
  I: Integer;
begin
  Result := EmptyStr;
  if Assigned(AJSONArray) then
    for I := 0 to AJSONArray.Count - 1 do
    begin
      if I > 0 then
        Result := Result + ', ';
      Result := Result + AJSONArray.Items[I].Value;
    end;
end;

function TAgrofitApiClient.ConsultarDefensivo(const ANumeroRegistro: string): TDefensivoAgricolaDTO;
var
  LHttpClient: THTTPClient;
  LResponse: IHTTPResponse;
  LURL: string;
  LHeaders: TNetHeaders;
begin
  LHttpClient := THTTPClient.Create;
  try
    SetLength(LHeaders, 1);
    LHeaders[0].Name := 'Authorization';
    LHeaders[0].Value := 'Bearer ' + C_API_TOKEN;
    LURL := C_API_URL + ANumeroRegistro;

    LResponse := LHttpClient.Get(LURL, nil, LHeaders);

    if LResponse.StatusCode = 200 then
      Result := ParseJSON(LResponse.ContentAsString)
    else
      raise Exception.CreateFmt('Erro ao consultar API. Status: %d - %s', [LResponse.StatusCode, LResponse.StatusText]);
  finally
    LHttpClient.Free;
  end;
end;

function TAgrofitApiClient.ParseJSON(const AJSON: string): TDefensivoAgricolaDTO;
var
  LJSONArray,
    LMarcaComercialArray,
    LClasseCategoriaArray: TJSONArray;
  LJSONObject: TJSONObject;
begin
  Result := TDefensivoAgricolaDTO.Create;
  try
    LJSONArray := TJSONObject.ParseJSONValue(AJSON) as TJSONArray;
    try
      if (Assigned(LJSONArray)) and (LJSONArray.Count > 0) then
      begin
        LJSONObject := LJSONArray.Items[0] as TJSONObject;
        
        Result.NumeroRegistro := LJSONObject.GetValue<string>('numero_registro', '');
        Result.TitularRegistro := LJSONObject.GetValue<string>('titular_registro', '');
        Result.ClassificacaoToxicologica := LJSONObject.GetValue<string>('classificacao_toxicologica', '');
        
        LMarcaComercialArray := LJSONObject.GetValue<TJSONArray>('marca_comercial');
        Result.MarcaComercial := Self.ArrayToString(LMarcaComercialArray);

        LClasseCategoriaArray := LJSONObject.GetValue<TJSONArray>('classe_categoria_agronomica');
        Result.ClasseCategoria := Self.ArrayToString(LClasseCategoriaArray);
      end
      else
        raise Exception.Create('Nenhum produto encontrado para o código de registro informado.');
    finally
      LJSONArray.Free;
    end;
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao processar resposta da API: ' + E.Message);
    end;
  end;
end;

end.

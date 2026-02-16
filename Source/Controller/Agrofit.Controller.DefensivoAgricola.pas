unit Agrofit.Controller.DefensivoAgricola;

interface

uses
  Agrofit.Domain.DefensivoAgricola,
  Agrofit.Domain.DefensivoAgricolaDB,
  Agrofit.DTO.DefensivoAgricola,
  Agrofit.Repository.DefensivoAgricola,
  Agrofit.Service.ApiClient,
  Agrofit.Service.Mapper,
  System.Generics.Collections,
  System.SysUtils;

type
  TOrigemDados = (odBanco, odAPI);

  TDefensivoAgricolaController = class
  private
    FApiClient: iApiClient;
    FRepository: iDefensivoAgricolaRepository;
  public
    constructor Create(AApiClient: iApiClient; ARepository: iDefensivoAgricolaRepository);
    function ConsultarDefensivo(const ANumeroRegistro: string; out AOrigemDados: TOrigemDados): TDefensivoAgricola;
    function ExisteNoBanco(const ANumeroRegistro: string): Boolean;
    function ListarNumerosRegistrados: TList<string>;
    procedure SalvarDefensivo(const ADefensivo: TDefensivoAgricola);
  end;

implementation

constructor TDefensivoAgricolaController.Create(AApiClient: iApiClient; ARepository: iDefensivoAgricolaRepository);
begin
  inherited Create;
  FApiClient := AApiClient;
  FRepository := ARepository;
end;

function TDefensivoAgricolaController.ConsultarDefensivo(const ANumeroRegistro: string; out AOrigemDados: TOrigemDados): TDefensivoAgricola;
var
  LDomainDB: TDefensivoAgricolaDB;
  LDTO: TDefensivoAgricolaDTO;
begin
  if Trim(ANumeroRegistro) = EmptyStr then
    raise Exception.Create('Informe o número do registro.');

  LDomainDB := nil;
  LDTO := nil;

  try
    LDomainDB := FRepository.BuscarPorNumeroRegistro(ANumeroRegistro); // 1. Buscar no DB

    if Assigned(LDomainDB) then
    begin
      Result := TDefensivoAgricolaMapper.DomainDBToDomain(LDomainDB);
      AOrigemDados := odBanco;
      Exit;
    end;

    LDTO := FApiClient.ConsultarDefensivo(ANumeroRegistro); // 2. Não está no DB, então, buscar na API

    Result := TDefensivoAgricolaMapper.DTOToDomain(LDTO);
    AOrigemDados := odAPI;
  finally
    if Assigned(LDomainDB) then
      LDomainDB.Free;
    if Assigned(LDTO) then
      LDTO.Free;
  end;
end;

function TDefensivoAgricolaController.ExisteNoBanco(const ANumeroRegistro: string): Boolean;
begin
  Result := FRepository.Existe(ANumeroRegistro);
end;

function TDefensivoAgricolaController.ListarNumerosRegistrados: TList<string>;
begin
  Result := FRepository.ListarTodosNumerosRegistro;
end;

procedure TDefensivoAgricolaController.SalvarDefensivo(const ADefensivo: TDefensivoAgricola);
var
  LDefensivoAgricolaDB: TDefensivoAgricolaDB;
begin
  {$REGION 'Validações'}
  if not Assigned(ADefensivo) then
    raise Exception.Create('Nenhum defensivo para salvar.');

  if Trim(ADefensivo.NumeroRegistro) = '' then
    raise Exception.Create('O Número do registro não pode estar vazio.');

  if FRepository.Existe(ADefensivo.NumeroRegistro) then
    raise Exception.CreateFmt('O Número do registro "%s" já foi salvo no banco de dados.', [ADefensivo.NumeroRegistro]);
  {$ENDREGION}

  LDefensivoAgricolaDB := nil;
  try
    LDefensivoAgricolaDB := TDefensivoAgricolaMapper.DomainToDomainDB(ADefensivo);

    FRepository.Inserir(LDefensivoAgricolaDB); // =>
  finally
    LDefensivoAgricolaDB.Free;
  end;
end;

end.

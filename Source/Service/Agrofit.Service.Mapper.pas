unit Agrofit.Service.Mapper;

interface

uses
  Agrofit.Domain.DefensivoAgricola,
  Agrofit.Domain.DefensivoAgricolaDB,
  Agrofit.DTO.DefensivoAgricola,
  System.SysUtils;

type
  TDefensivoAgricolaMapper = class
  public
    class function DomainDBToDomain(const ADomainDB: TDefensivoAgricolaDB): TDefensivoAgricola;
    class function DomainToDomainDB(const ADomain: TDefensivoAgricola): TDefensivoAgricolaDB;
    class function DomainToDTO(const ADomain: TDefensivoAgricola): TDefensivoAgricolaDTO;
    class function DTOToDomain(const ADTO: TDefensivoAgricolaDTO): TDefensivoAgricola;
  end;

implementation

class function TDefensivoAgricolaMapper.DomainDBToDomain(const ADomainDB: TDefensivoAgricolaDB): TDefensivoAgricola;
begin
  Result := TDefensivoAgricola.Create;
  Result.NumeroRegistro := ADomainDB.NumeroRegistro;
  Result.MarcaComercial := ADomainDB.MarcaComercial;
  Result.ClasseCategoria := ADomainDB.ClasseCategoria;
  Result.TitularRegistro := ADomainDB.TitularRegistro;
  Result.ClassificacaoToxicologica := ADomainDB.ClassificacaoToxicologica;
end;

class function TDefensivoAgricolaMapper.DomainToDomainDB(const ADomain: TDefensivoAgricola): TDefensivoAgricolaDB;
begin
  Result := TDefensivoAgricolaDB.Create;
  Result.NumeroRegistro := ADomain.NumeroRegistro;
  Result.MarcaComercial := ADomain.MarcaComercial;
  Result.ClasseCategoria := ADomain.ClasseCategoria;
  Result.TitularRegistro := ADomain.TitularRegistro;
  Result.ClassificacaoToxicologica := ADomain.ClassificacaoToxicologica;
end;

class function TDefensivoAgricolaMapper.DomainToDTO(const ADomain: TDefensivoAgricola): TDefensivoAgricolaDTO;
begin
  Result := TDefensivoAgricolaDTO.Create;
  Result.NumeroRegistro := ADomain.NumeroRegistro;
  Result.MarcaComercial := ADomain.MarcaComercial;
  Result.ClasseCategoria := ADomain.ClasseCategoria;
  Result.TitularRegistro := ADomain.TitularRegistro;
  Result.ClassificacaoToxicologica := ADomain.ClassificacaoToxicologica;
end;

class function TDefensivoAgricolaMapper.DTOToDomain(const ADTO: TDefensivoAgricolaDTO): TDefensivoAgricola;
begin
  Result := TDefensivoAgricola.Create;
  Result.NumeroRegistro := ADTO.NumeroRegistro;
  Result.MarcaComercial := ADTO.MarcaComercial;
  Result.ClasseCategoria := ADTO.ClasseCategoria;
  Result.TitularRegistro := ADTO.TitularRegistro;
  Result.ClassificacaoToxicologica := ADTO.ClassificacaoToxicologica;
end;

end.

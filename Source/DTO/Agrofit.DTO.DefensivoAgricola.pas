unit Agrofit.DTO.DefensivoAgricola;

interface

type
  TDefensivoAgricolaDTO = class
  private
    FNumeroRegistro: string;
    FMarcaComercial: string;
    FClasseCategoria: string;
    FTitularRegistro: string;
    FClassificacaoToxicologica: string;
  public
    property NumeroRegistro: string read FNumeroRegistro write FNumeroRegistro;
    property MarcaComercial: string read FMarcaComercial write FMarcaComercial;
    property ClasseCategoria: string read FClasseCategoria write FClasseCategoria;
    property TitularRegistro: string read FTitularRegistro write FTitularRegistro;
    property ClassificacaoToxicologica: string read FClassificacaoToxicologica write FClassificacaoToxicologica;
  end;

implementation

end.

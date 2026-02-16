program Agrofit;

uses
  Vcl.Forms,
  Agrofit.View.Principal in 'Source\View\Agrofit.View.Principal.pas' {ViewPrincipal},
  Agrofit.Controller.DefensivoAgricola in 'Source\Controller\Agrofit.Controller.DefensivoAgricola.pas',
  Agrofit.Service.ApiClient in 'Source\Service\Agrofit.Service.ApiClient.pas',
  Agrofit.Service.Mapper in 'Source\Service\Agrofit.Service.Mapper.pas',
  Agrofit.Repository.DefensivoAgricola in 'Source\Repository\Agrofit.Repository.DefensivoAgricola.pas',
  Agrofit.Domain.DefensivoAgricola in 'Source\Domain\Agrofit.Domain.DefensivoAgricola.pas',
  Agrofit.Domain.DefensivoAgricolaDB in 'Source\Domain\Agrofit.Domain.DefensivoAgricolaDB.pas',
  Agrofit.DTO.DefensivoAgricola in 'Source\DTO\Agrofit.DTO.DefensivoAgricola.pas',
  Agrofit.Core.Connection in 'Source\Core\Agrofit.Core.Connection.pas',
  Agrofit.Core.MyLib in 'Source\Core\Agrofit.Core.MyLib.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.Run;
end.

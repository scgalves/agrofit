unit Agrofit.Core.MyLib;

interface

uses
  System.Classes;

type
  TLib = class
  public
    class function MsgConfirmacao(const ATextoMensagem: string): Boolean;
    class procedure LimparComponentes(const AArrayComponentes: array of TComponent);
    class procedure MsgAtencao(const ATextoMensagem: string);
    class procedure MsgErro(const ATextoMensagem: string);
    class procedure MsgInformacao(const ATextoMensagem: string);
  end;

implementation

uses
  System.SysUtils,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Winapi.Windows;

class procedure TLib.LimparComponentes(const AArrayComponentes: array of TComponent);
var
  LObj: TComponent;
begin
  for LObj in AArrayComponentes do
  begin
    if LObj is TLabeledEdit then
    begin
      TLabeledEdit(LObj).Clear;
      Continue;
    end;

    if LObj is TLabel then
    begin
      TLabel(LObj).Caption := EmptyStr;
      Continue;
    end;
  end;
end;

class procedure TLib.MsgAtencao(const ATextoMensagem: string);
begin
  Application.MessageBox(PChar(ATextoMensagem), 'Atenção', MB_ICONWARNING + MB_OK);
end;

class procedure TLib.MsgErro(const ATextoMensagem: string);
begin
  Application.MessageBox(PChar(ATextoMensagem), 'Erro', MB_ICONERROR + MB_OK);
end;

class procedure TLib.MsgInformacao(const ATextoMensagem: string);
begin
  Application.MessageBox(PChar(ATextoMensagem), 'Informação', MB_ICONINFORMATION + MB_OK);
end;

class function TLib.MsgConfirmacao(const ATextoMensagem: string): Boolean;
begin
  Result := Application.MessageBox(PChar(ATextoMensagem), 'Confirmação', MB_ICONQUESTION + MB_YESNO) = IDYES;
end;

end.

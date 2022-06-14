program CadastroCliente;

uses
  Vcl.Forms,
  uMain in 'src\uMain.pas' {frmMain},
  uClassApi in 'src\Class\uClassApi.pas',
  uClassUtils in 'src\Class\uClassUtils.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := true;
  {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

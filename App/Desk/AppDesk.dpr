program AppDesk;

uses
  System.StartUpCopy,
  FMX.Forms,
  view.Teste in 'View\view.Teste.pas' {Form4},
  view.Main in 'View\view.Main.pas' {frmMain},
  view.Padrao in 'View\view.Padrao.pas' {frmCadPadrao},
  view.Cad.Pessoa in 'View\view.Cad.Pessoa.pas' {frmCadPessoa};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

program AppDesk;

uses
  System.StartUpCopy,
  FMX.Forms,
  view.Teste in 'View\view.Teste.pas' {Form4},
  view.Main in 'View\view.Main.pas' {frmMain},
  view.Padrao in 'View\view.Padrao.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

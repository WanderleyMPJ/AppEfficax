program AppDesk;

uses
  System.StartUpCopy,
  FMX.Forms,
  view.Teste in 'View\view.Teste.pas' {fom4},
  view.Main in 'View\view.Main.pas' {frmMain},
  view.Padrao in 'View\view.Padrao.pas' {frmCadPadrao},
  view.Cad.Pessoa in 'View\view.Cad.Pessoa.pas' {frmCadPessoa},
  view.Cad.User in 'View\view.Cad.User.pas' {frmCadUser},
  view.Busca in 'View\view.Busca.pas' {frmBusca},
  view.Cont.Os in 'View\view.Cont.Os.pas' {frmOs},
  view.Frm.Os in 'View\view.Frm.Os.pas' {frmFormOs},
  view.Home in 'View\view.Home.pas' {frmHome},
  view.Orcamento in 'View\view.Orcamento.pas' {frmOrcamento},
  view.Cad.Produtos in 'View\view.Cad.Produtos.pas' {frmCadProd};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmOrcamento, frmOrcamento);
  Application.CreateForm(TfrmCadProd, frmCadProd);
  Application.Run;
end.

program AppDesk;

uses
  System.StartUpCopy,
  FMX.Forms,
  view.Teste in 'View\view.Teste.pas' {Form4},
  view.Main in 'View\view.Main.pas' {frmMain},
  view.Padrao in 'View\view.Padrao.pas' {frmCadPadrao},
  view.Cad.Pessoa in 'View\view.Cad.Pessoa.pas' {frmCadPessoa},
  view.Cad.User in 'View\view.Cad.User.pas' {frmCadUser},
<<<<<<< HEAD
  view.Busca in 'View\view.Busca.pas' {frmBusca},
  view.Cont.Os in 'View\view.Cont.Os.pas' {frmOs},
  view.Frm.Os in 'View\view.Frm.Os.pas' {frmFormOs},
  view.Home in 'View\view.Home.pas' {frmHome},
  view.Orcamento in 'View\view.Orcamento.pas' {frmOrcamento},
<<<<<<< HEAD
<<<<<<< HEAD
  view.Cad.Produtos in 'View\view.Cad.Produtos.pas' {frmCadProd},
  Classe.Pessoa in 'Class\Classe.Pessoa.pas',
  Classe.PContato in 'Class\Classe.PContato.pas',
  Classe.PEndereco in 'Class\Classe.PEndereco.pas',
  Classe.Cotacao in 'Class\Classe.Cotacao.pas',
  Classe.CItem in 'Class\Classe.CItem.pas',
<<<<<<< HEAD
  Classe.Produto in 'Class\Classe.Produto.pas',
  dm.Connection in 'Conection\dm.Connection.pas' {dmConnection: TDataModule};
=======
  view.Cad.Produtos in 'View\view.Cad.Produtos.pas' {frmCadProd};
>>>>>>> parent of 6157654... 22/09/2017
=======
  Classe.Produto in 'Class\Classe.Produto.pas';
>>>>>>> parent of 5e66f97... 29/09/2017
=======
  view.Cad.Produtos in 'View\view.Cad.Produtos.pas' {frmCadProd};
>>>>>>> parent of 6157654... 22/09/2017
=======
  view.Busca in 'View\view.Busca.pas' {frmBusca};
>>>>>>> parent of 975c066... 19/09

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

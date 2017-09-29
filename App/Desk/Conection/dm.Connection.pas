unit dm.Connection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.UI, FMX.Dialogs, Classe.Pessoa;

type
  TdmConnection = class(TDataModule)
    conexao: TFDConnection;
    driver: TFDPhysMySQLDriverLink;
    fdqrGeral: TFDQuery;
    MemTable: TFDMemTable;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure insertProduto;
    procedure BuscaProduto;
  end;

var
  dmConnection: TdmConnection;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TdmConnection }

procedure TdmConnection.BuscaProduto;
begin
with fdqrGeral do
begin
  conexao.Connected := True;
  close;
  sql.Clear;
  sql.Text :='SELECT * FROM PRODUTOS';
  open;

end;
end;

procedure TdmConnection.insertProduto;
begin

with fdqrGeral do
begin
  conexao.Connected := true;
  Sql.Clear;
  sql.Add('INSERT INTO PRODUTOS (DESCRICAO_PROD, VALOR, DESCRIMINACAO_PROD,TIPO,CALC_HR)');
  sql.Add(' values ("TESTE","22","TESTE DE CADASTRO DE PRODUTOS","1","0")');
  ExecSQL;
  conexao.Connected := False;
  sql.Clear;
end;
end;

end.

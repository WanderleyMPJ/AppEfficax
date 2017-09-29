unit view.Cad.Produtos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  view.Padrao, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListBox, FMX.Layouts, System.Actions,
  FMX.ActnList, FMX.TabControl, FMX.Objects, FMX.ListView, FMX.Edit,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, dm.Connection,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmCadProd = class(TfrmCadPadrao)
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    CalloutPanel1: TCalloutPanel;
    ListBoxItem5: TListBoxItem;
    Label6: TLabel;
    Label7: TLabel;
    swServico: TSwitch;
    lbPorHora: TLabel;
    swPorHora: TSwitch;
    lbghCadProdServ: TListBoxGroupHeader;
    MemTable: TFDMemTable;
    MemTableID: TIntegerField;
    MemTableDESCRICAO: TStringField;
    MemTableVALOR: TStringField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    procedure swServicoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadProd: TfrmCadProd;

implementation

{$R *.fmx}

procedure TfrmCadProd.FormCreate(Sender: TObject);
begin
  inherited;
  with DmConnection do
  begin
    BuscaProduto;

   (*
      MemTable.Active;
      MemTable.Edit;
      MemTable.Open;
      MemTableID.Value := fdqrGeral.FieldByName('ID').AsInteger;
      MemTableDescricao.Value := fdqrGeral.FieldByName('descricao_prod').AsAnsiString;
      MemTableValor.Value := fdqrGeral.FieldByName('valor').AsAnsiString;
      MemTable.Close;

   *)
  end;

end;

procedure TfrmCadProd.swServicoClick(Sender: TObject);
begin
  inherited;
  if (swServico.IsChecked) = True then
  begin
  lbPorHora.Visible := True;
  swPorHora.Visible := True;
  lbghCadProdServ.Text := 'Cadastrando um Serviço'
  end
  else
  if (swServico.IsChecked) = False then
  begin
  lbPorHora.Visible := False;
  swPorHora.Visible := False;
  lbghCadProdServ.Text := 'Cadastrando um Produto'
  end;
end;

end.

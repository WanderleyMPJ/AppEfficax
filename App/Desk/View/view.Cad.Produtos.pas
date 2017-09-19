unit view.Cad.Produtos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  view.Padrao, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListBox, FMX.Layouts, System.Actions,
  FMX.ActnList, FMX.TabControl, FMX.Objects, FMX.ListView, FMX.Edit,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

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
    procedure swServicoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadProd: TfrmCadProd;

implementation

{$R *.fmx}

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

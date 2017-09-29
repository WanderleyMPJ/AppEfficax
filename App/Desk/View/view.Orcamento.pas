unit view.Orcamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  view.Padrao, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, System.Actions, FMX.ActnList, FMX.TabControl,
  FMX.Objects, FMX.ListView, FMX.Edit, FMX.ListBox, FMX.Controls.Presentation,
  FMX.Layouts, FMX.DateTimeCtrls;

type
  TfrmOrcamento = class(TfrmCadPadrao)
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    lbCliente: TLabel;
    lbServicos: TLabel;
    lbValidade: TLabel;
    lbPrazo: TLabel;
    ListBoxItem5: TListBoxItem;
    lbValorTotal: TLabel;
    ListBoxItem6: TListBoxItem;
    lbDesconto: TLabel;
    ListBoxItem7: TListBoxItem;
    lvServicos: TListView;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    Edit2: TEdit;
    Edit3: TEdit;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    lbVlTotal: TLabel;
    Edit4: TEdit;
    cbApliDesc: TCornerButton;
    cbAddServ: TCornerButton;
    SearchEditButton1: TSearchEditButton;
    SearchEditButton2: TSearchEditButton;
    ListBox2: TListBox;
    ListBoxItem8: TListBoxItem;
    ListBoxHeader1: TListBoxHeader;
    Label1: TLabel;
    CornerButton1: TCornerButton;
    CornerButton2: TCornerButton;
    Label4: TLabel;
    procedure spbSalvClick(Sender: TObject);
    procedure SearchEditButton2Click(Sender: TObject);
    procedure SearchEditButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOrcamento: TfrmOrcamento;

implementation

{$R *.fmx}

procedure TfrmOrcamento.SearchEditButton1Click(Sender: TObject);
begin
  inherited;
  ChamaBusca;
end;

procedure TfrmOrcamento.SearchEditButton2Click(Sender: TObject);
begin
  inherited;
  ChamaBusca;
end;

procedure TfrmOrcamento.spbSalvClick(Sender: TObject);
begin
  inherited;
  recPopUp.Visible := True;
  recPopUp.Align := TAlignLayout.Contents;
  ppBusca.BringToFront;
  ppBusca.visible := True;
  TabControl2.ActiveTab := tbiMensagem;
end;

end.

unit view.Cad.Pessoa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  view.Padrao, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, System.Actions, FMX.ActnList, FMX.TabControl,
  FMX.ListView, FMX.Edit, FMX.ListBox, FMX.Controls.Presentation, FMX.Layouts;

type
  TfrmCadPessoa = class(TfrmCadPadrao)
    ListBox1: TListBox;
    tbcDadosAdd: TTabControl;
    tbiDoc: TTabItem;
    tbiEnd: TTabItem;
    tbiCont: TTabItem;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBox2: TListBox;
    ListBoxItem5: TListBoxItem;
    lbiSuframa: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBox3: TListBox;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxHeader3: TListBoxHeader;
    ListBox4: TListBox;
    lbiDescCont: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    ListBoxHeader4: TListBoxHeader;
    ListBoxHeader2: TListBoxHeader;
    lbPessoaFisica: TLabel;
    lbRSNM: TLabel;
    lbNFAP: TLabel;
    lbDtFDtN: TLabel;
    swPesFisica: TSwitch;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    lbCPFCNPJ: TLabel;
    Edit6: TEdit;
    lbSuframa: TLabel;
    Edit7: TEdit;
    lbIERG: TLabel;
    Edit8: TEdit;
    lbIMTE: TLabel;
    Edit9: TEdit;
    Label11: TLabel;
    Edit10: TEdit;
    Label12: TLabel;
    Edit12: TEdit;
    Label14: TLabel;
    Edit13: TEdit;
    Label15: TLabel;
    Edit14: TEdit;
    Label16: TLabel;
    Edit16: TEdit;
    Label18: TLabel;
    spbEnd: TSpeedButton;
    spbCont: TSpeedButton;
    spbDoc: TSpeedButton;
    spbEnde: TSpeedButton;
    ListBoxHeader1: TListBoxHeader;
    ListBoxItem17: TListBoxItem;
    Label19: TLabel;
    Edit17: TEdit;
    Label20: TLabel;
    Edit18: TEdit;
    Label13: TLabel;
    Edit11: TEdit;
    Label17: TLabel;
    Edit15: TEdit;
    Label21: TLabel;
    Edit19: TEdit;
    Label22: TLabel;
    Edit20: TEdit;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    ctaDocumentos: TChangeTabAction;
    ctaEndereco: TChangeTabAction;
    ctaContato: TChangeTabAction;
    Label26: TLabel;
    lbiOGUF: TListBoxItem;
    Label1: TLabel;
    Edit21: TEdit;
    Label4: TLabel;
    Edit22: TEdit;
    ListBoxItem6: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    CornerButton1: TCornerButton;
    CornerButton2: TCornerButton;
    lbghEndCad: TListBoxGroupHeader;
    Label5: TLabel;
    lbghContCad: TListBoxGroupHeader;
    Label6: TLabel;
    lvEnderecos: TListView;
    lvContatos: TListView;
    procedure spbEndClick(Sender: TObject);
    procedure spbEndeClick(Sender: TObject);
    procedure spbDocClick(Sender: TObject);
    procedure spbContClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Switch1Switch(Sender: TObject);
    procedure swPesFisicaClick(Sender: TObject);
    procedure CornerButton2Click(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure VerificaTipo(Tp : integer);
  public
    { Public declarations }
  end;

var
  frmCadPessoa: TfrmCadPessoa;

implementation

{$R *.fmx}

procedure TfrmCadPessoa.CornerButton1Click(Sender: TObject);
begin
  inherited;
  lbghContCad.Visible := True;
  lvContatos.Visible := True;
end;

procedure TfrmCadPessoa.CornerButton2Click(Sender: TObject);
begin
  inherited;
  lbghEndCad.Visible := True;
  lvEnderecos.Visible := True;
end;

procedure TfrmCadPessoa.FormCreate(Sender: TObject);
begin
  inherited;
  tbcDadosAdd.TabPosition := TTabPosition.None;
  tbcDadosAdd.ActiveTab := tbiDoc;
end;

procedure TfrmCadPessoa.spbContClick(Sender: TObject);
begin
  inherited;
  ctaContato.Execute;
end;

procedure TfrmCadPessoa.spbDocClick(Sender: TObject);
begin
  inherited;
  ctaDocumentos.Execute;
end;

procedure TfrmCadPessoa.spbEndClick(Sender: TObject);
begin
  inherited;
  ctaEndereco.Execute;
end;

procedure TfrmCadPessoa.spbEndeClick(Sender: TObject);
begin
  inherited;
  ctaEndereco.Execute;
end;

procedure TfrmCadPessoa.Switch1Switch(Sender: TObject);
begin
  inherited;
  VerificaTipo(2);
end;

procedure TfrmCadPessoa.swPesFisicaClick(Sender: TObject);
begin
  inherited;
  if (swPesFisica.IsChecked) = True then
  VerificaTipo(2)
  else
  VerificaTipo(1);
end;

procedure TfrmCadPessoa.VerificaTipo(Tp: integer);
begin
//Pessoa Jurídica
if tp = 1 then
begin
  lbiSuframa.Visible := True;
  lbRSNM.Text := 'Razão Social:';
  lbNFAP.Text := 'Nome Fantasia:';
  lbDtFDtN.Text := 'Data de Fundação:';
  lbCPFCNPJ.Text := 'CNPJ:';
  lbIERG.Text := 'Inscrição Estadual:';
  lbIMTE.Text := 'Inscrição Municipal:';
  lbiOGUF.Visible := False;
  lbiDescCont.Visible := True;
end
else
//Pessoa Física
if tp = 2 then
begin
  lbiSuframa.Visible := False;
  lbRSNM.Text := 'Nome Completo:';
  lbNFAP.Text := 'Apelido:';
  lbDtFDtN.Text := 'Data de Nascimento:';
  lbCPFCNPJ.Text := 'CPF:';
  lbIERG.Text := 'RG:';
  lbIMTE.Text := 'Título de Eleitor:';
  lbiOGUF.Visible := True;
  lbiDescCont.Visible := False;
end;


end;

end.

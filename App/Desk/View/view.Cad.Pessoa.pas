unit view.Cad.Pessoa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  view.Padrao, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, System.Actions, FMX.ActnList, FMX.TabControl,
  FMX.ListView, FMX.Edit, FMX.ListBox, FMX.Controls.Presentation, FMX.Layouts,
  FMX.Objects;

type
  TfrmCadPessoa = class(TfrmCadPadrao)
    ListBox1: TListBox;
    tbcDadosAdd: TTabControl;
    tbiDoc: TTabItem;
    tbiEnd: TTabItem;
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
    spbEnd: TSpeedButton;
    spbCont: TSpeedButton;
    spbDoc: TSpeedButton;
    ListBoxItem17: TListBoxItem;
    Label19: TLabel;
    Edit17: TEdit;
    Label20: TLabel;
    Edit18: TEdit;
    Label13: TLabel;
    Edit11: TEdit;
    Label23: TLabel;
    Label24: TLabel;
    ctaDocumentos: TChangeTabAction;
    ctaEndereco: TChangeTabAction;
    ctaContato: TChangeTabAction;
    lbiOGUF: TListBoxItem;
    Label1: TLabel;
    Edit21: TEdit;
    Label4: TLabel;
    Edit22: TEdit;
    ListBoxItem6: TListBoxItem;
    CornerButton2: TCornerButton;
    tbiCont: TTabItem;
    Contatos: TListBox;
    ListBoxHeader5: TListBoxHeader;
    Label7: TLabel;
    lbiNumTel: TListBoxItem;
    Edit23: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Edit24: TEdit;
    lbiDescTel: TListBoxItem;
    Edit25: TEdit;
    Label10: TLabel;
    lbiTelefones: TListBoxItem;
    lvTelefones: TListView;
    lbiEmail: TListBoxItem;
    lbiCEmail: TListBoxItem;
    Edit26: TEdit;
    Label27: TLabel;
    lbiDescEmail: TListBoxItem;
    Edit28: TEdit;
    Label29: TLabel;
    CornerButton4: TCornerButton;
    lvEmail: TListView;
    CornerButton3: TCornerButton;
    spbEnde: TSpeedButton;
    Telefones: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    Panel1: TPanel;
    Panel2: TPanel;
    lbtelefones: TLabel;
    lbEmail: TLabel;
    spbTel: TSpeedButton;
    spbEmail: TSpeedButton;
    ListBoxItem11: TListBoxItem;
    Label5: TLabel;
    Switch1: TSwitch;
    Label6: TLabel;
    Switch2: TSwitch;
    Label15: TLabel;
    Switch3: TSwitch;
    ListBoxHeader1: TListBoxHeader;
    Label26: TLabel;
    procedure spbEndClick(Sender: TObject);
    procedure spbEndeClick(Sender: TObject);
    procedure spbDocClick(Sender: TObject);
    procedure spbContClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Switch1Switch(Sender: TObject);
    procedure swPesFisicaClick(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure spbSalvClick(Sender: TObject);
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
  lbiTelefones.Visible := True;
end;

procedure TfrmCadPessoa.FormCreate(Sender: TObject);
begin
  inherited;
  tbcDadosAdd.TabPosition := TTabPosition.None;
  tbcDadosAdd.ActiveTab := tbiDoc;
end;

procedure TfrmCadPessoa.Panel1Click(Sender: TObject);
begin
  inherited;
  if spbTel.StyleLookup = 'arrowlefttoolbutton' then
  begin
    lbitelefones.Visible := False;
    lbiDescTel.Visible := False;
    lbiNumTel.Visible := False;
    spbTel.StyleLookup := 'arrowdowntoolbuttonborderedright';
  end
  else
  if spbTel.StyleLookup = 'arrowdowntoolbuttonborderedright' then
  begin
   lbiTelefones.Visible := true;
   lbiDescTel.Visible := true;
   lbiNumTel.Visible := true;
   spbtel.StyleLookup := 'arrowlefttoolbutton';
  end;

end;

procedure TfrmCadPessoa.Panel2Click(Sender: TObject);
begin
  inherited;
  if spbEmail.StyleLookup = 'arrowlefttoolbutton' then
  begin
    lbiEmail.Visible := False;
    lbiDescEmail.Visible := False;
    lbiCEmail.Visible := False;
    spbEmail.StyleLookup := 'arrowdowntoolbuttonborderedright';
  end
  else
  if spbEmail.StyleLookup = 'arrowdowntoolbuttonborderedright' then
  begin
   lbiEmail.Visible := true;
   lbiDescEmail.Visible := true;
   lbiCEmail.Visible := true;
   spbEmail.StyleLookup := 'arrowlefttoolbutton';
  end;

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

procedure TfrmCadPessoa.spbSalvClick(Sender: TObject);
begin
  inherited;
  lbTitulo.Text := 'Cadastro de Pessoa';
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
  lbTitulo.Text := 'Cadastrando Pessoa Jurídica';
  lbiOGUF.Visible := False;
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
  lbTitulo.Text := 'Cadastrando Pessoa Física';
  lbiOGUF.Visible := True;
end;


end;

end.

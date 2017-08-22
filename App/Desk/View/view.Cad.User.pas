unit view.Cad.User;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  view.Padrao, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, System.Actions, FMX.ActnList, FMX.TabControl,
  FMX.ListView, FMX.Edit, FMX.ListBox, FMX.Controls.Presentation, FMX.Layouts,
  view.Busca, FMX.Objects;

type
  TfrmCadUser = class(TfrmCadPadrao)
    CalloutPanel1: TCalloutPanel;
    lbDdBasicos: TListBox;
    ListBoxHeader1: TListBoxHeader;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    Label1: TLabel;
    lbPessoa: TLabel;
    Edit2: TEdit;
    lbLogin: TLabel;
    Edit3: TEdit;
    lbSenha: TLabel;
    edtSenha: TEdit;
    lbCSenha: TLabel;
    edtCSenha: TEdit;
    lbGrupo: TLabel;
    Edit6: TEdit;
    sebPessoa: TSearchEditButton;
    sebGrupo: TSearchEditButton;
    pebVerSenha: TPasswordEditButton;
    pebVerCSenha: TPasswordEditButton;
    procedure sebPessoaClick(Sender: TObject);
    procedure sebGrupoClick(Sender: TObject);
    procedure pebVerSenhaMouseEnter(Sender: TObject);
    procedure pebVerSenhaMouseLeave(Sender: TObject);
    procedure pebVerCSenhaMouseLeave(Sender: TObject);
    procedure pebVerCSenhaMouseEnter(Sender: TObject);
  private
    { Private declarations }
//    procedure AbreBusca(tp : integer);
  public
    { Public declarations }
  end;

var
  frmCadUser: TfrmCadUser;

implementation

{$R *.fmx}

procedure TfrmCadUser.pebVerCSenhaMouseEnter(Sender: TObject);
begin
  inherited;
  edtCSenha.Password := false;
end;

procedure TfrmCadUser.pebVerCSenhaMouseLeave(Sender: TObject);
begin
  inherited;
  edtCSenha.Password := true;
end;

procedure TfrmCadUser.pebVerSenhaMouseEnter(Sender: TObject);
begin
  inherited;
  edtSenha.Password := false;
end;

procedure TfrmCadUser.pebVerSenhaMouseLeave(Sender: TObject);
begin
  inherited;
  edtSenha.Password := true;
end;

procedure TfrmCadUser.sebGrupoClick(Sender: TObject);
begin
  inherited;
//Código 2 para grupo
  ChamaBusca;
end;

procedure TfrmCadUser.sebPessoaClick(Sender: TObject);
begin
//Código um para Pessoa
 ChamaBusca;
end;

{
  procedure TfrmCadUser.AbreBusca(tp : integer);
  var
   lytBase: TComponent;
  begin
   if Assigned(FActiveForm) then
   begin
     if FActiveForm.ClassType = TfrmBusca then
     exit
     else
     begin
       FActiveForm.DisposeOf;
       FActiveForm := nil;
     end;
   end;
   Application.CreateForm(TfrmBusca, FActiveForm);
   lytBase := FActiveForm.FindComponent('lytBase');
   if Assigned(lytBase) then
   lytCBusca.AddObject(TLayout(lytBase));

    recPopUp.Visible := True;
    recPopUp.Align := TAlignLayout.Contents;
    ppBusca.BringToFront;
    ppBusca.visible := True;

  end;
}

end.

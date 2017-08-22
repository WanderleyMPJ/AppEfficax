
unit view.Padrao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Edit, FMX.ListBox, FMX.StdCtrls, FMX.ListView, FMX.TabControl,
  FMX.Controls.Presentation, FMX.Layouts, System.Actions, FMX.ActnList,
  view.Busca, FMX.Objects;

type
  TfrmCadPadrao = class(TForm)
    lytBase: TLayout;
    ToolBar1: TToolBar;
    spbMenu: TSpeedButton;
    spbAdd: TSpeedButton;
    spbEdt: TSpeedButton;
    spbCanc: TSpeedButton;
    spbBack: TSpeedButton;
    spbExc: TSpeedButton;
    TabControl1: TTabControl;
    tbiLista: TTabItem;
    tbiFormulario: TTabItem;
    ToolBar2: TToolBar;
    ListView1: TListView;
    StyleBook1: TStyleBook;
    lbTitulo: TLabel;
    spbSalv: TSpeedButton;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    SpeedButton7: TSpeedButton;
    ActionList1: TActionList;
    ctaFormulario: TChangeTabAction;
    ctaLista: TChangeTabAction;
    lytFormulario: TLayout;
    ppBusca: TPopup;
    lytCBusca: TLayout;
    recPopUp: TRectangle;
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure spbEdtClick(Sender: TObject);
    procedure spbSalvClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure spbAddClick(Sender: TObject);
    procedure spbCancClick(Sender: TObject);
    procedure spbExcClick(Sender: TObject);
    procedure spbBackClick(Sender: TObject);
    procedure recPopUpClick(Sender: TObject);
  private
    { Private declarations }
    procedure VerificaOperacao(I: integer);
    procedure AlterEdt(b : boolean);
  public
    { Public declarations }
    FActiveForm : TForm;
    procedure ChamaBusca;
  end;

var
  frmCadPadrao: TfrmCadPadrao;

implementation

uses
  Winapi.Windows;

{$R *.fmx}

{ TForm1 }

procedure TfrmCadPadrao.ChamaBusca;
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

procedure TfrmCadPadrao.AlterEdt(b : boolean);
var
I : integer;
begin
for I := 0 to Self.ComponentCount -1 do
begin
if (Self.Components[i] is TEdit) then
(Self.Components[i] as TEdit).Enabled := b
else if (Self.Components[i] is TSwitch) then
 (Self.Components[i] as TSwitch).Enabled := b;
end;
end;

procedure TfrmCadPadrao.FormCreate(Sender: TObject);
begin
 VerificaOperacao(1);
 ctaLista.Execute;
end;


procedure TfrmCadPadrao.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
 ctaFormulario.Execute;
end;

procedure TfrmCadPadrao.recPopUpClick(Sender: TObject);
begin
  ppBusca.Visible := false;
  recPopUp.Visible := False;
  FActiveForm.DisposeOf;
  FActiveForm := nil;
end;

procedure TfrmCadPadrao.spbAddClick(Sender: TObject);
begin
 VerificaOperacao(3);
 ctaFormulario.Execute;
end;

procedure TfrmCadPadrao.spbBackClick(Sender: TObject);
begin
VerificaOperacao(1);
ctaLista.Execute;
end;

procedure TfrmCadPadrao.spbCancClick(Sender: TObject);
begin
 VerificaOperacao(1);
 ctaLista.Execute;
end;

procedure TfrmCadPadrao.spbEdtClick(Sender: TObject);
begin
 ctaFormulario.Execute;
 VerificaOperacao(2);
end;

procedure TfrmCadPadrao.spbExcClick(Sender: TObject);
begin
 VerificaOperacao(1);
 if TabControl1.ActiveTab = tbiFormulario then
  ctaLista.Execute;

end;

procedure TfrmCadPadrao.spbSalvClick(Sender: TObject);
begin
 VerificaOperacao(4);
end;

procedure TfrmCadPadrao.VerificaOperacao(I: integer);
begin
//Tela de busca
if I = 1 then
  begin
   spbAdd.Visible := true;
   spbExc.Visible := true;
   spbEdt.Visible := true;
   spbCanc.Visible := false;
   spbSalv.Visible := false;
   spbBack.Visible := false;
   spbMenu.Visible := True;
   AlterEdt(False);
  end
//Editando
  else
   if I = 2 then
    begin
      spbAdd.Visible := false;
      spbExc.Visible := true;
      spbEdt.Visible := false;
      spbCanc.Visible := true;
      spbSalv.Visible := true;
      spbBack.Visible := true;
      spbMenu.Visible := False;
      AlterEdt(True);
    end
//Incluindo
    else
     if I = 3 then
      begin
        spbAdd.Visible := false;
        spbExc.Visible := false;
        spbEdt.Visible := false;
        spbCanc.Visible := true;
        spbSalv.Visible := true;
        spbBack.Visible := true;
        spbMenu.Visible := False;
        AlterEdt(True);
      end
//Salvo
     else
      if I = 4 then
       begin
        spbAdd.Visible := true;
        spbExc.Visible := true;
        spbEdt.Visible := true;
        spbCanc.Visible := false;
        spbSalv.Visible := false;
        spbBack.Visible := true;
        spbMenu.Visible := False;
        AlterEdt(false);
       end;
end;

end.

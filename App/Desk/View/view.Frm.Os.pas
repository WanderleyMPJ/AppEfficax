unit view.Frm.Os;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListBox,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.TabControl, FMX.DateTimeCtrls, FMX.Objects, FMX.ScrollBox,
  FMX.Memo, view.Busca;

type
  TfrmFormOs = class(TForm)
    StyleBook1: TStyleBook;
    lytBase: TLayout;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    lytBaseOS: TLayout;
    ToolBar1: TToolBar;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    lbCliente: TLabel;
    SearchEditButton1: TSearchEditButton;
    cbAgendar: TCornerButton;
    cbRetomar: TCornerButton;
    cbTransferir: TCornerButton;
    cbParar: TCornerButton;
    Label2: TLabel;
    ListView1: TListView;
    ListBoxItem8: TListBoxItem;
    cbFinalizar: TCornerButton;
    Layout1: TLayout;
    spbSalv: TSpeedButton;
    spbMenu: TSpeedButton;
    spbCanc: TSpeedButton;
    spbAdd: TSpeedButton;
    tedtInic: TTimeEdit;
    ppGeral: TPopup;
    TabControl1: TTabControl;
    tbiBusca: TTabItem;
    tbiMensagem: TTabItem;
    lytCBusc: TLayout;
    Layout2: TLayout;
    ListBox2: TListBox;
    ListBoxHeader1: TListBoxHeader;
    ListBoxItem9: TListBoxItem;
    lbiDestPend: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    lbTitMens: TLabel;
    mmMotSoc: TMemo;
    lbMotSoc: TLabel;
    lbDestPend: TLabel;
    cbDestPend: TComboBox;
    cbCanc: TCornerButton;
    cbSalv: TCornerButton;
    recPopUp: TRectangle;
    Rectangle1: TRectangle;
    lbiDtHr: TListBoxItem;
    lbDtHr: TLabel;
    tedtDataHora: TTimeEdit;
    dedtDataHora: TDateEdit;
    cbPendencia: TCornerButton;
    spbEdtInic: TSpeedButton;
    procedure cbAgendarClick(Sender: TObject);
    procedure cbPararClick(Sender: TObject);
    procedure cbRetomarClick(Sender: TObject);
    procedure cbTransferirClick(Sender: TObject);
    procedure cbFinalizarClick(Sender: TObject);
    procedure SearchEditButton1Click(Sender: TObject);
    procedure cbPendenciaClick(Sender: TObject);
    procedure recPopUpClick(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure spbEdtInicClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure spbSalvClick(Sender: TObject);
    procedure cbCancClick(Sender: TObject);
  private
    { Private declarations }
    FActiveForm : TForm;
    procedure SecTp (i : integer);
    procedure AbrirPopUp;
    procedure AlterEdt(b : boolean);
  public
    { Public declarations }
  end;

var
  frmFormOs: TfrmFormOs;

implementation

{$R *.fmx}

{ TfrmFormOs }

procedure TfrmFormOs.AbrirPopUp;
begin
  recPopUp.Visible := True;
  recPopUp.Align := TAlignLayout.Contents;
  ppGeral.BringToFront;
  ppGeral.visible := True;
end;

procedure TfrmFormOs.AlterEdt(b: boolean);
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

procedure TfrmFormOs.cbAgendarClick(Sender: TObject);
begin
  SecTp(1);
end;

procedure TfrmFormOs.cbCancClick(Sender: TObject);
begin
  ppGeral.Visible := false;
  recPopUp.Visible := False;
  FActiveForm.DisposeOf;
  FActiveForm := nil;
end;

procedure TfrmFormOs.cbFinalizarClick(Sender: TObject);
begin
  SecTp(5);
end;

procedure TfrmFormOs.cbPararClick(Sender: TObject);
begin
  SecTp(2);
end;

procedure TfrmFormOs.cbPendenciaClick(Sender: TObject);
begin
  SecTp(7);
end;

procedure TfrmFormOs.cbRetomarClick(Sender: TObject);
begin
  SecTp(3);
end;

procedure TfrmFormOs.cbTransferirClick(Sender: TObject);
begin
  SecTp(4);
end;

procedure TfrmFormOs.FormCreate(Sender: TObject);
begin
  SecTp(0);
end;

procedure TfrmFormOs.recPopUpClick(Sender: TObject);
begin
  ppGeral.Visible := false;
  recPopUp.Visible := False;
  FActiveForm.DisposeOf;
  FActiveForm := nil;
end;

procedure TfrmFormOs.Rectangle1Click(Sender: TObject);
begin
  ppGeral.Visible := false;
  recPopUp.Visible := False;
  FActiveForm.DisposeOf;
  FActiveForm := nil;
end;

procedure TfrmFormOs.SearchEditButton1Click(Sender: TObject);
begin
  SecTp(6);
end;

procedure TfrmFormOs.SecTp(i: integer);
var
lytBase : TComponent;
begin
// 0 = Inicio
  if i = 0 then
   begin
    cbAgendar.Visible := True;
    cbTransferir.Visible := true;
    cbPendencia.Visible := True;
    cbParar.Visible := true;
    cbRetomar.Visible := False;
    spbAdd.Visible := False;
   end
   else
// 1 = Agendar
  if i = 1 then
   begin
    lbTitMens.Text := 'AGENDAR';
    lbiDestPend.Visible := False;
    lbiDtHr.Visible := True;
    lbMotSoc.Text := 'Motivo Agendamento:';

    cbAgendar.Visible := True;
    cbRetomar.Visible := False;
    cbTransferir.Visible := True;
    cbParar.Visible := True;
    cbPendencia.Visible := True;
    cbFinalizar.Enabled := False;

    TabControl1.ActiveTab := tbiMensagem;

    AbrirPopUp;
   end
  else
// 2 = Parar
  if i = 2 then
   begin
    lbTitMens.Text := 'PARAR ATENDIMENTO';
    lbiDestPend.Visible := False;
    lbiDtHr.Visible := True;
    lbMotSoc.Text := 'Motivo:';

    cbAgendar.Visible := True;
    cbRetomar.Visible := true;
    cbTransferir.Visible := true;
    cbParar.Visible := false;
    cbPendencia.Visible := True;
    cbFinalizar.Enabled := false;

    TabControl1.ActiveTab := tbiMensagem;

    AbrirPopUp;
   end
  else
// 3 = Retomar
  if i = 3 then
   begin
    //ALTERAÇÃO DE BOTÔES
    cbAgendar.Visible := True;
    cbRetomar.Visible := False;
    cbTransferir.Visible := True;
    cbParar.Visible := True;
    cbPendencia.Visible := True;
    cbFinalizar.Enabled := True;
   end
  else
// 4 = Transferir
  if i = 4 then
   begin
    lbTitMens.Text := 'TRANSFERIR ATENDIMENTO';
    lbiDestPend.Visible := True;
    lbDestPend.Text := 'Transferir Para:';
    lbiDtHr.Visible := False;
    lbMotSoc.Text := 'Motivo de Transferência:';

    //Definir Como se comportar

    TabControl1.ActiveTab := tbiMensagem;

    AbrirPopUp;
   end
  else
// 5 = Finalizar
  if i = 5 then
   begin
    lbTitMens.Text := 'Finalizar Atendimento';
    lbiDestPend.Visible := False;
    lbiDtHr.Visible := True;
    lbMotSoc.Text := 'Solução:';

    TabControl1.ActiveTab := tbiMensagem;

    AbrirPopUp;
   end
  else
// 6 = Busca
  if i = 6 then
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
           lytCBusc.AddObject(TLayout(lytBase));

           TabControl1.ActiveTab := tbiBusca;

            AbrirPopUp;
    end
  else
// 7 = Pendência
  if i = 7  then
   begin
    lbTitMens.Text := 'PENDÊNCIA';
    lbiDestPend.Visible := true;
    lbDestPend.Text := 'Pendente Com:';
    lbiDtHr.Visible := false;
    lbMotSoc.Text := 'Motivo Pendência: ';

    cbAgendar.Visible := True;
    cbRetomar.Visible := true;
    cbTransferir.Visible := True;
    cbParar.Visible := false;
    cbPendencia.Visible := false;
    cbFinalizar.Enabled := false;

    AbrirPopUp;

   end;

end;

procedure TfrmFormOs.spbEdtInicClick(Sender: TObject);
begin
 tedtInic.Locked := False;
end;

procedure TfrmFormOs.spbSalvClick(Sender: TObject);
begin
 AlterEdt(false);
end;

end.


unit view.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Layouts, FMX.ListBox,
  view.Padrao, view.Cad.Pessoa, view.Cad.User, view.Cont.Os, view.Home,
  view.Orcamento, view.Cad.Produtos;

type
  TfrmMain = class(TForm)
    lytConteiner: TLayout;
    MultiView1: TMultiView;
    tbMenu: TToolBar;
    spbMenu: TSpeedButton;
    spbExit: TSpeedButton;
    ListBox1: TListBox;
    ListBoxHeader1: TListBoxHeader;
    ListBoxItem1: TListBoxItem;
    Menu: TLabel;
    StyleBook1: TStyleBook;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    lbiOs: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    ListBoxGroupHeader2: TListBoxGroupHeader;
    ListBoxGroupHeader3: TListBoxGroupHeader;
    procedure ListBoxItem1Click(Sender: TObject);
    procedure spbExitClick(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure ListBoxItem3Click(Sender: TObject);
    procedure lbiOsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxItem4Click(Sender: TObject);
    procedure ListBoxItem5Click(Sender: TObject);
    procedure ListBoxItem6Click(Sender: TObject);
  private
    { Private declarations }
    FActiveForm : TForm;
    procedure AbreForm(AFormClass: TComponentClass);
    procedure AbrirHome;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

{ TfrmMain }

procedure TfrmMain.AbreForm(AFormClass: TComponentClass);
var
 lytBase, spbBack : TComponent;
begin
 if Assigned(FActiveForm) then
 begin
   if FActiveForm.ClassType = AformClass then
   exit
   else
   begin
     FActiveForm.DisposeOf;
     FActiveForm := nil;
   end;
 end;
 Application.CreateForm(AFormClass, FActiveForm);
 lytBase := FActiveForm.FindComponent('lytBase');
 if Assigned(lytBase) then
  frmMain.lytConteiner.AddObject(TLayout(lytBase));

  spbBack := FActiveForm.FindComponent('spbMenu');
  if Assigned(spbBack) then
  frmMain.MultiView1.MasterButton := TControl(spbBack);

  frmMain.tbMenu.Visible := False;
  frmMain.MultiView1.HideMaster;


end;

procedure TfrmMain.AbrirHome;
var
 lytBase : TComponent;
begin
 if Assigned(FActiveForm) then
 begin
   if FActiveForm.ClassType = TfrmHome then
   exit
   else
   begin
     FActiveForm.DisposeOf;
     FActiveForm := nil;
   end;
 end;
 Application.CreateForm(TfrmHome, FActiveForm);
 lytBase := FActiveForm.FindComponent('lytBase');
 if Assigned(lytBase) then
  frmMain.lytConteiner.AddObject(TLayout(lytBase));

 tbMenu.Visible := True;
 MultiView1.HideMaster;
 MultiView1.MasterButton := spbMenu;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
AbrirHome;
end;

procedure TfrmMain.lbiOsClick(Sender: TObject);
begin
 AbreForm(TfrmOs);
end;

procedure TfrmMain.ListBoxItem1Click(Sender: TObject);
begin
 AbreForm(TfrmCadPessoa);
end;

procedure TfrmMain.ListBoxItem2Click(Sender: TObject);
begin
 close;
 free;
end;

procedure TfrmMain.ListBoxItem3Click(Sender: TObject);
begin
  AbreForm(TfrmCadUser);
end;

procedure TfrmMain.ListBoxItem4Click(Sender: TObject);
begin
 AbrirHome;
end;

procedure TfrmMain.ListBoxItem5Click(Sender: TObject);
begin
 AbreForm(TfrmOrcamento);
end;

procedure TfrmMain.ListBoxItem6Click(Sender: TObject);
begin
 AbreForm(TfrmCadProd);
end;

procedure TfrmMain.spbExitClick(Sender: TObject);
begin
 close;
 free;
end;

end.

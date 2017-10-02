unit view.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Layouts, FMX.ListBox,
  view.Padrao, view.Cad.Pessoa, view.Cad.User;

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
    Label1: TLabel;
    StyleBook1: TStyleBook;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    procedure ListBoxItem1Click(Sender: TObject);
    procedure spbExitClick(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure ListBoxItem3Click(Sender: TObject);
  private
    { Private declarations }
    FActiveForm : TForm;
    procedure AbreForm(AFormClass: TComponentClass);
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

procedure TfrmMain.spbExitClick(Sender: TObject);
begin
 close;
 free;
end;

end.

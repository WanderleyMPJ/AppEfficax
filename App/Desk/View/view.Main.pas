unit view.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Layouts, FMX.ListBox;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

end.

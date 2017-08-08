unit view.Padrao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Edit, FMX.ListBox, FMX.StdCtrls, FMX.ListView, FMX.TabControl,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TForm1 = class(TForm)
    lytBase: TLayout;
    ToolBar1: TToolBar;
    spbMenu: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    TabControl1: TTabControl;
    tbiLista: TTabItem;
    tbiFormulario: TTabItem;
    ToolBar2: TToolBar;
    ListView1: TListView;
    StyleBook1: TStyleBook;
    Label1: TLabel;
    SpeedButton6: TSpeedButton;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    SpeedButton7: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

end.

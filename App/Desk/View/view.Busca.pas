unit view.Busca;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.StdCtrls, FMX.ListView, FMX.Layouts, FMX.Controls.Presentation,
  FMX.TabControl, FMX.Edit, FMX.ListBox;

type
  TfrmBusca = class(TForm)
    StyleBook1: TStyleBook;
    ToolBar1: TToolBar;
    lytBase: TLayout;
    ListView1: TListView;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    TabControl1: TTabControl;
    tbiLista: TTabItem;
    tbiForm: TTabItem;
    ToolBar2: TToolBar;
    spbCanc: TSpeedButton;
    spbBack: TSpeedButton;
    spbSalv: TSpeedButton;
    lytCFormulario: TLayout;
    ToolBar3: TToolBar;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    SpeedButton7: TSpeedButton;
    ListView2: TListView;
    SpeedButton3: TSpeedButton;
  private
    { Private declarations }
    FActiveForm : TForm;
  public
    { Public declarations }
    tipo: string;
  end;

var
  frmBusca: TfrmBusca;

implementation

{$R *.fmx}

{ TForm1 }

end.

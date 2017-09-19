unit view.Cont.Os;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  view.Padrao, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, System.Actions, FMX.ActnList, FMX.TabControl,
  FMX.Objects, FMX.ListView, FMX.Edit, FMX.ListBox, FMX.Controls.Presentation,
  FMX.Layouts, view.Frm.Os;

type
  TfrmOs = class(TfrmCadPadrao)
    procedure spbAddClick(Sender: TObject);
    procedure spbEdtClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOs: TfrmOs;

implementation

{$R *.fmx}

procedure TfrmOs.spbAddClick(Sender: TObject);
begin
  ChamaOS;
  inherited;
end;

procedure TfrmOs.spbEdtClick(Sender: TObject);
begin
   ChamaOS;
  inherited;
end;

end.

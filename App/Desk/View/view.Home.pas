unit view.Home;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ExtCtrls, System.ImageList,
  FMX.ImgList, dm.Connection;

type
  TfrmHome = class(TForm)
    StyleBook1: TStyleBook;
    lytBase: TLayout;
    Layout1: TLayout;
    Layout14: TLayout;
    Layout15: TLayout;
    Layout16: TLayout;
    Layout20: TLayout;
    cbAtendimento: TCornerButton;
    Layout21: TLayout;
    Layout22: TLayout;
    Layout23: TLayout;
    Layout24: TLayout;
    ImageList1: TImageList;
    CornerButton1: TCornerButton;
    CornerButton2: TCornerButton;
    procedure cbAtendimentoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHome: TfrmHome;

implementation

{$R *.fmx}

procedure TfrmHome.cbAtendimentoClick(Sender: TObject);
begin
dmConnection.BuscaProduto;
end;

end.

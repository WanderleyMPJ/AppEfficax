unit Classe.Cotacao;

interface

uses
  System.Classes, Classe.CItem;
type TCotacao = Class
  private
    Fvl_total: string;
    Fdesconto: string;
    Fid_pessoa: integer;
    FlistItem: TList;
    Fid: integer;
    Fpv_entrega: string;
    Fvalidade: string;
    procedure Setdesconto(const Value: string);
    procedure Setid(const Value: integer);
    procedure Setid_pessoa(const Value: integer);
    procedure SetlistItem(const Value: TList);
    procedure Setpv_entrega(const Value: string);
    procedure Setvalidade(const Value: string);
    procedure Setvl_total(const Value: string);

  protected

  public
  property id : integer read Fid write Setid;
  property id_pessoa : integer read Fid_pessoa write Setid_pessoa;
  property validade : string read Fvalidade write Setvalidade;
  property pv_entrega : string read Fpv_entrega write Setpv_entrega;
  property desconto : string read Fdesconto write Setdesconto;
  property vl_total : string read Fvl_total write Setvl_total;
  property listItem : TList read FlistItem write SetlistItem;
  published
End;

implementation

{ TCotacao }

procedure TCotacao.Setdesconto(const Value: string);
begin
  Fdesconto := Value;
end;

procedure TCotacao.Setid(const Value: integer);
begin
  Fid := Value;
end;

procedure TCotacao.Setid_pessoa(const Value: integer);
begin
  Fid_pessoa := Value;
end;

procedure TCotacao.SetlistItem(const Value: TList);
begin
  FlistItem := Value;
end;

procedure TCotacao.Setpv_entrega(const Value: string);
begin
  Fpv_entrega := Value;
end;

procedure TCotacao.Setvalidade(const Value: string);
begin
  Fvalidade := Value;
end;

procedure TCotacao.Setvl_total(const Value: string);
begin
  Fvl_total := Value;
end;

end.

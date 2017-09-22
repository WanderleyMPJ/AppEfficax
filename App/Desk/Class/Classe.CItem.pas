unit Classe.CItem;

interface
type TC_Item = class
  private
    Fid_produto: integer;
    Fid_cotacao: integer;
    Fvl_produto: string;
    Fqtd_produto: string;
    procedure Setid_cotacao(const Value: integer);
    procedure Setid_produto(const Value: integer);
    procedure Setqtd_produto(const Value: string);
    procedure Setvl_produto(const Value: string);

  protected

  public
  property id_cotacao : integer read Fid_cotacao write Setid_cotacao;
  property id_produto : integer read Fid_produto write Setid_produto;
  property qtd_produto : string read Fqtd_produto write Setqtd_produto;
  property vl_produto : string read Fvl_produto write Setvl_produto;
  published

end;

implementation

{ TC_Item }

procedure TC_Item.Setid_cotacao(const Value: integer);
begin
  Fid_cotacao := Value;
end;

procedure TC_Item.Setid_produto(const Value: integer);
begin
  Fid_produto := Value;
end;

procedure TC_Item.Setqtd_produto(const Value: string);
begin
  Fqtd_produto := Value;
end;

procedure TC_Item.Setvl_produto(const Value: string);
begin
  Fvl_produto := Value;
end;

end.

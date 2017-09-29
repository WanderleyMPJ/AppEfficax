unit Classe.Produto;

interface
type TProdutos = class
  private
    Fvalor: string;
    Fcalc_hr: integer;
    Fdescrim_prod: string;
    Fid: integer;
    Ftipo: integer;
    Fdescricao_prod: string;
    procedure Setcalc_hr(const Value: integer);
    procedure Setdescricao_prod(const Value: string);
    procedure Setdescrim_prod(const Value: string);
    procedure Setid(const Value: integer);
    procedure Settipo(const Value: integer);
    procedure Setvalor(const Value: string);

  protected

  public
  property id : integer read Fid write Setid;
  property descricao_prod : string read Fdescricao_prod write Setdescricao_prod;
  property valor : string read Fvalor write Setvalor;
  property descrim_prod : string read Fdescrim_prod write Setdescrim_prod;
  property tipo : integer read Ftipo write Settipo;
  property calc_hr : integer read Fcalc_hr write Setcalc_hr;
  published

end;

implementation

{ TProdutos }

procedure TProdutos.Setcalc_hr(const Value: integer);
begin
  Fcalc_hr := Value;
end;

procedure TProdutos.Setdescricao_prod(const Value: string);
begin
  Fdescricao_prod := Value;
end;

procedure TProdutos.Setdescrim_prod(const Value: string);
begin
  Fdescrim_prod := Value;
end;

procedure TProdutos.Setid(const Value: integer);
begin
  Fid := Value;
end;

procedure TProdutos.Settipo(const Value: integer);
begin
  Ftipo := Value;
end;

procedure TProdutos.Setvalor(const Value: string);
begin
  Fvalor := Value;
end;

end.

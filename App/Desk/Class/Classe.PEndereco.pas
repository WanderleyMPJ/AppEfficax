unit Classe.PEndereco;

interface
type TP_Endereco = class
  private
    Fbairro: string;
    Fid_pessoa: integer;
    Fdescricao: string;
    Fcd_ibge: string;
    Fcep: string;
    Fid: integer;
    Fnumero: string;
    Fcidade: string;
    Festado: string;
    Frua: string;
    procedure Setbairro(const Value: string);
    procedure Setcd_ibge(const Value: string);
    procedure Setcep(const Value: string);
    procedure Setcidade(const Value: string);
    procedure Setdescricao(const Value: string);
    procedure Setestado(const Value: string);
    procedure Setid(const Value: integer);
    procedure Setid_pessoa(const Value: integer);
    procedure Setnumero(const Value: string);
    procedure Setrua(const Value: string);


  protected

  public
  property id_pessoa : integer read Fid_pessoa write Setid_pessoa;
  property id : integer read Fid write Setid;
  property descricao : string read Fdescricao write Setdescricao;
  property rua : string read Frua write Setrua;
  property bairro : string read Fbairro write Setbairro;
  property cep : string read Fcep write Setcep;
  property cidade : string read Fcidade write Setcidade;
  property estado : string read Festado write Setestado;
  property numero : string read Fnumero write Setnumero;
  property cd_ibge : string read Fcd_ibge write Setcd_ibge;
  published

end;

implementation

{ TP_Endereco }

procedure TP_Endereco.Setbairro(const Value: string);
begin
  Fbairro := Value;
end;

procedure TP_Endereco.Setcd_ibge(const Value: string);
begin
  Fcd_ibge := Value;
end;

procedure TP_Endereco.Setcep(const Value: string);
begin
  Fcep := Value;
end;

procedure TP_Endereco.Setcidade(const Value: string);
begin
  Fcidade := Value;
end;

procedure TP_Endereco.Setdescricao(const Value: string);
begin
  Fdescricao := Value;
end;

procedure TP_Endereco.Setestado(const Value: string);
begin
  Festado := Value;
end;

procedure TP_Endereco.Setid(const Value: integer);
begin
  Fid := Value;
end;

procedure TP_Endereco.Setid_pessoa(const Value: integer);
begin
  Fid_pessoa := Value;
end;

procedure TP_Endereco.Setnumero(const Value: string);
begin
  Fnumero := Value;
end;

procedure TP_Endereco.Setrua(const Value: string);
begin
  Frua := Value;
end;

end.

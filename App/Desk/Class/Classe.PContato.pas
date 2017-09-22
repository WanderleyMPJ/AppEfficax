unit Classe.PContato;

interface

type TP_Contato = class
  private
    Femail: string;
    Fid_pessoa: integer;
    Fdescricao: string;
    Fid: integer;
    Ftelefone: string;
    procedure Setdescricao(const Value: string);
    procedure Setemail(const Value: string);
    procedure Setid(const Value: integer);
    procedure Setid_pessoa(const Value: integer);
    procedure Settelefone(const Value: string);

  protected

  public
  property id_pessoa : integer read Fid_pessoa write Setid_pessoa;
  property id : integer read Fid write Setid;
  property email : string read Femail write Setemail;
  property telefone : string read Ftelefone write Settelefone;
  property descricao : string read Fdescricao write Setdescricao;

  published
end;


implementation

{ TP_Contato }

procedure TP_Contato.Setdescricao(const Value: string);
begin
  Fdescricao := Value;
end;

procedure TP_Contato.Setemail(const Value: string);
begin
  Femail := Value;
end;

procedure TP_Contato.Setid(const Value: integer);
begin
  Fid := Value;
end;

procedure TP_Contato.Setid_pessoa(const Value: integer);
begin
  Fid_pessoa := Value;
end;

procedure TP_Contato.Settelefone(const Value: string);
begin
  Ftelefone := Value;
end;

end.

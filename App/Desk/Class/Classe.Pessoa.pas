unit Classe.Pessoa;

interface

uses
  System.Classes, Classe.PContato, Classe.PEndereco;

type TPessoa = class
  private
    Fcpf_cnpj: string;
    Fnome_razsoc: string;
    Fdtnas_dtfund: string;
    Fid: integer;
    Fsuframa: string;
    Foguf: string;
    Ftp_peddoa: integer;
    Fnmfant_apelido: string;
    Frg_inscest: string;
    Fcontato: TList;
    Fendereco: Tlist;
    procedure Setcpf_cnpj(const Value: string);
    procedure Setdtnas_dtfund(const Value: string);
    procedure Setid(const Value: integer);
    procedure Setnmfant_apelido(const Value: string);
    procedure Setnome_razsoc(const Value: string);
    procedure Setoguf(const Value: string);
    procedure Setrg_inscest(const Value: string);
    procedure Setsuframa(const Value: string);
    procedure Settp_peddoa(const Value: integer);
    procedure Setcontato(const Value: TList);
    procedure Setendereco(const Value: Tlist);
  {Private declarations}
  protected
  {Protected declarations}
  public
  {Public declarations}
  property endereco : Tlist(TP_Endereco) read Fendereco write Setendereco;
  property contato : TList(TP_Contato) read Fcontato write Setcontato;
  property id : integer read Fid write Setid;
  property tp_peddoa : integer read Ftp_peddoa write Settp_peddoa;
  property nome_razsoc : string read Fnome_razsoc write Setnome_razsoc;
  property cpf_cnpj : string read Fcpf_cnpj write Setcpf_cnpj;
  property rg_inscest : string read Frg_inscest write Setrg_inscest;
  property suframa : string read Fsuframa write Setsuframa;
  property nmfant_apelido : string read Fnmfant_apelido write Setnmfant_apelido;
  property dtnas_dtfund : string read Fdtnas_dtfund write Setdtnas_dtfund;
  property oguf : string read Foguf write Setoguf;
end;

implementation

{ TPessoas }

procedure TPessoa.Setcontato(const Value: TList);
begin
  Fcontato := Value;
end;

procedure TPessoa.Setcpf_cnpj(const Value: string);
begin
  Fcpf_cnpj := Value;
end;

procedure TPessoa.Setdtnas_dtfund(const Value: string);
begin
  Fdtnas_dtfund := Value;
end;

procedure TPessoa.Setendereco(const Value: Tlist);
begin
  Fendereco := Value;
end;

procedure TPessoa.Setid(const Value: integer);
begin
  Fid := Value;
end;

procedure TPessoa.Setnmfant_apelido(const Value: string);
begin
  Fnmfant_apelido := Value;
end;

procedure TPessoa.Setnome_razsoc(const Value: string);
begin
  Fnome_razsoc := Value;
end;

procedure TPessoa.Setoguf(const Value: string);
begin
  Foguf := Value;
end;

procedure TPessoa.Setrg_inscest(const Value: string);
begin
  Frg_inscest := Value;
end;

procedure TPessoa.Setsuframa(const Value: string);
begin
  Fsuframa := Value;
end;

procedure TPessoa.Settp_peddoa(const Value: integer);
begin
  Ftp_peddoa := Value;
end;

end.

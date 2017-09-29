unit ormbr.model.master;

interface

uses
  Classes, 
  DB, 
  SysUtils, 
  Generics.Collections, 
  /// orm 
  ormbr.mapping.attributes,
  ormbr.types.mapping,
  ormbr.mapping.classes,
  ormbr.types.lazy,
  ormbr.model.detail,
  ormbr.model.client,
  ormbr.mapping.register;

type
  [Entity]
  [Table('master','')]
  [PrimaryKey('master_id', AutoInc, NoSort, True, 'Chave primária')]
  [Sequence('SEQUENCE')]
  [OrderBy('description DESC')]
  Tmaster = class
  private
    { Private declarations }
    Fmaster_id: Integer;
    Fdescription: String;
    Fregisterdate: TDateTime;
    Fupdatedate: TDateTime;
    Fclient_id: Integer;
    Fclient_name: string;
    Fdetail: TObjectList<Tdetail>;
    Fclient: Tclient;
    function GetTotal: Double;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    [Restrictions([NoUpdate, NotNull])]
    [Column('master_id', ftInteger)]
    [Dictionary('master_Id','Mensagem de validação','0','','',taCenter)]
    property master_id: Integer Index 0 read Fmaster_id write Fmaster_id;

    [Column('description', ftString, 60)]
    [Dictionary('description','Mensagem de validação','','','',taLeftJustify)]
    property description: String Index 1 read Fdescription write Fdescription;

    [Restrictions([NotNull])]
    [Column('registerdate', ftDate)]
    [Dictionary('registerdate','Mensagem de validação','Date','','!##/##/####;1;_',taCenter)]
    property registerdate: TDateTime Index 2 read Fregisterdate write Fregisterdate;

    [Restrictions([NotNull])]
    [Column('updatedate', ftDate)]
    [Dictionary('updatedate','Mensagem de validação','Date','','!##/##/####;1;_',taCenter)]
    property updatedate: TDateTime Index 3 read Fupdatedate write Fupdatedate;

    [Restrictions([NotNull])]
    [Column('client_id', ftInteger)]
    [ForeignKey('client', 'client_id')]
    [Dictionary('client_id','Mensagem de validação','','','',taCenter)]
    property client_id: Integer Index 4 read Fclient_id write Fclient_id;

    [Restrictions([NoInsert, NoUpdate])]
    [Column('client_name', ftString, 60)]
    [JoinColumn('client_name','client','client_id',InnerJoin)]
    [Dictionary('Nome do Cliente')]
    property client_name: string index 5 read fclient_name write fclient_name;

    [Association(OneToOne,'client_id','client_id','client_name; client_foto')]
    property client: Tclient read Fclient write Fclient;

    [Association(OneToMany,'master_id','master_id')]
    property detail: TObjectList<Tdetail> read Fdetail; // write Fdetail;

    [Restrictions([NoInsert, NoUpdate])]
    property total: Double read GetTotal;
  end;

implementation

{ Tmaster }

constructor Tmaster.Create;
begin
   Fdetail := TObjectList<Tdetail>.Create;
   Fclient := Tclient.Create;
end;

destructor Tmaster.Destroy;
begin
  Fdetail.Free;
  Fclient.Free;
  inherited;
end;

function Tmaster.GetTotal: Double;
var
  iFor: Integer;
begin
  Result := 0;
  for iFor := 0 to Fdetail.Count -1 do
    Result := Result + Fdetail.Items[iFor].price;
end;

initialization
  TRegisterClass.RegisterEntity(Tmaster);

end.

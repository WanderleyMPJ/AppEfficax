unit ormbr.model.detail;

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
  ormbr.model.lookup,
  ormbr.mapping.register;

type
  [Entity]
  [Table('detail','')]
  [PrimaryKey('detail_id; master_id', 'Chave primária')]
  Tdetail = class
  private
    { Private declarations }
    Fdetail_id: Integer;
    Fmaster_id: Integer;
    Flookup_id: Integer;
    Flookup_description: String;
    Fprice: Double;
  public
    { Public declarations }
    [Restrictions([NoUpdate, NotNull])]
    [Column('detail_id', ftInteger)]
    [Dictionary('ID Detalhe','Mensagem de validação','','','',taCenter)]
    property detail_id: Integer Index 0 read Fdetail_id write Fdetail_id;

    [Restrictions([NotNull])]
    [Column('master_id', ftInteger)]
    [ForeignKey('master', 'master_id', Cascade, Cascade)]
    [Dictionary('ID Mestre','Mensagem de validação','','','',taCenter)]
    property master_id: Integer Index 1 read Fmaster_id write Fmaster_id;

    [Restrictions([NotNull])]
    [Column('lookup_id', ftInteger)]
    [ForeignKey('Lookup', 'lookup_id', None, None)]
    [Dictionary('ID Lookup','Mensagem de validação','0','','',taCenter)]
    property lookup_id: Integer Index 2 read Flookup_id write Flookup_id;

    [Column('lookup_description', ftString, 30)]
    [Dictionary('Descrição Lookup','Mensagem de validação','','','',taLeftJustify)]
    property lookup_description: String Index 3 read Flookup_description write Flookup_description;

    [Restrictions([NotNull])]
    [Column('price', ftFloat, 18, 3)]
    [Dictionary('Preço Unitário','Mensagem de validação','0','#,###,##0.00','',taRightJustify)]
    property price: Double Index 4 read Fprice write Fprice;
  end;

implementation

initialization
  TRegisterClass.RegisterEntity(Tdetail);

end.

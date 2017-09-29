{
      ORM Brasil é um ORM simples e descomplicado para quem utiliza Delphi

                   Copyright (c) 2016, Isaque Pinheiro
                          All rights reserved.

                    GNU Lesser General Public License
                      Versão 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos é permitido copiar e distribuir cópias deste documento de
       licença, mas mudá-lo não é permitido.

       Esta versão da GNU Lesser General Public License incorpora
       os termos e condições da versão 3 da GNU General Public License
       Licença, complementado pelas permissões adicionais listadas no
       arquivo LICENSE na pasta principal.
}

{ @abstract(ORMBr Framework.)
  @created(20 Jul 2016)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @author(Skype : ispinheiro)
  @abstract(Website : http://www.ormbr.com.br)
  @abstract(Telagram : https://t.me/ormbr)

  ORM Brasil é um ORM simples e descomplicado para quem utiliza Delphi.
}

unit ormbr.objects.manager;

interface

uses
  DB,
  Rtti,
  Types,
  Classes,
  SysUtils,
  Variants,
  Generics.Collections,
  /// ormbr
  ormbr.criteria,
  ormbr.types.mapping,
  ormbr.mapping.classes,
  ormbr.command.factory,
  ormbr.factory.interfaces,
  ormbr.mapping.explorer,
  ormbr.mapping.explorerstrategy;

type
  TObjectManager<M: class, constructor> = class abstract
  private
    FOwner: TObject;
    FUpdateInternal: M;
    FObjectInternal: M;
    FFetchingRecords: Boolean;
    FModifiedFields: TList<string>;
    procedure FillAssociation(AObject: M);
    procedure ExecuteOneToOne(AObject: TObject; AProperty: TRttiProperty;
      AAssociation: TAssociationMapping);
    procedure ExecuteOneToMany(AObject: TObject; AProperty: TRttiProperty;
      AAssociation: TAssociationMapping);
    procedure ModifyFieldsCompare(AObjectSource, AObjectUpdate: M);
  protected
    FConnection: IDBConnection;
    /// <summary>
    /// Fábrica de comandos a serem executados
    /// </summary>
    FDMLCommandFactory: TDMLCommandFactoryAbstract;
    /// <summary>
    /// Instancia a class que mapea todas as class do tipo Entity
    /// </summary>
    FExplorer: IMappingExplorerStrategy;
    /// <summary>
    /// Controle de paginação vindo do banco de dados
    /// </summary>
    FPageSize: Integer;
  public
    constructor Create(const AOwner: TObject; const AConnection: IDBConnection; const APageSize: Integer); virtual;
    destructor Destroy; override;
    procedure InsertInternal(AObject: M); virtual;
    procedure UpdateInternal(AObject: M); virtual;
    procedure DeleteInternal(AObject: M); virtual;
    procedure ModifyInternal(AObjectSource: M); virtual;
    function SelectInternalAll: IDBResultSet; virtual;
    function SelectInternalID(AID: TValue): IDBResultSet; virtual;
    function SelectInternal(ASQL: String): IDBResultSet; virtual;
    function SelectInternalWhere(AWhere: string; AOrderBy: string): string; virtual;
    function GetDMLCommand: string;
    function Find: TObjectList<M>; overload;
    function Find(ASQL: String): TObjectList<M>; overload;
    function Find(AID: TValue): M; overload;
    function FindWhere(AWhere: string; AOrderBy: string): TObjectList<M>;
    function ExistSequence: Boolean;
    function NextPacket: IDBResultSet; virtual;
    procedure NextPacketList(AObjectList: TObjectList<M>); virtual;
    property Explorer: IMappingExplorerStrategy read FExplorer;
    property FetchingRecords: Boolean read FFetchingRecords write FFetchingRecords;
    property ModifiedFields: TList<string> read FModifiedFields write FModifiedFields;
  end;

implementation

uses
  TypInfo,
  ormbr.objectset.bind,
  ormbr.types.database,
  ormbr.objects.helper,
  ormbr.mapping.attributes,
  ormbr.mapping.rttiutils,
  ormbr.session.manager,
  ormbr.rtti.helper,
  ormbr.types.blob;

{ TObjectManager<M> }

constructor TObjectManager<M>.Create(const AOwner: TObject; const AConnection: IDBConnection;
  const APageSize: Integer);
begin
  FOwner := AOwner;
  FPageSize := APageSize;
  if not (AOwner is TSessionAbstract<M>) then
    raise Exception.Create('O Object Manager não deve ser instênciada diretamente, use as classes TSessionObject<M> ou TSessionDataSet<M>');

  FConnection := AConnection;
  FExplorer := TMappingExplorer.GetInstance;
  FObjectInternal := M.Create;
  /// <summary>
  /// Lista de campos alterados
  /// </summary>
  FModifiedFields := TList<string>.Create;
  /// <summary>
  /// Fabrica de comandos SQL
  /// </summary>
  FDMLCommandFactory := TDMLCommandFactory.Create(FObjectInternal,
                                                  AConnection,
                                                  AConnection.GetDriverName);
end;

procedure TObjectManager<M>.ModifyFieldsCompare(AObjectSource, AObjectUpdate: M);
const
  cPropertyTypes = [tkUnknown,tkInterface,tkClass,tkClassRef,tkPointer,tkProcedure];
var
  oRttiType: TRttiType;
  oProperty: TRttiProperty;
  oColumn: TCustomAttribute;
  oSourceAsPointer, oUpdateAsPointer: Pointer;
begin
  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AObjectSource.ClassType);
  try
    Move(AObjectSource, oSourceAsPointer, SizeOf(Pointer));
    Move(AObjectUpdate, oUpdateAsPointer, SizeOf(Pointer));
    /// <summary>
    /// Loop na lista de propriedades
    /// </summary>
    for oProperty in oRttiType.GetProperties do
    begin
      /// <summary>
      /// Checa se no modelo o campo deve fazer parte do UPDATE
      /// </summary>
      if oProperty.IsNoUpdate then
        Continue;
      /// <summary>
      /// Validação para entrar no IF somente propriedades que o tipo nao esteja na lista
      /// </summary>
      if not (oProperty.PropertyType.TypeKind in cPropertyTypes) then
      begin
        /// <summary>
        /// Se o tipo da property for tkRecord provavelmente tem Nullable nela
        /// Se não for tkRecord entra no ELSE e pega o valor de forma direta
        /// </summary>
        if oProperty.PropertyType.TypeKind = tkRecord then // Nullable, Proxy ou TBlob
        begin
          if TRttiSingleton.GetInstance.IsBlob(oProperty.PropertyType.Handle) then
          begin
            if oProperty.GetNullableValue(oSourceAsPointer).AsType<TBlob>.ToSize <>
               oProperty.GetNullableValue(oUpdateAsPointer).AsType<TBlob>.ToSize then
            begin
              oColumn := oProperty.GetColumn;
              if oColumn <> nil then
                FModifiedFields.Add(Column(oColumn).ColumnName);
            end;
          end
          else
          if TRttiSingleton.GetInstance.IsNullable(oProperty.PropertyType.Handle) then
          begin
            if oProperty.GetNullableValue(oSourceAsPointer).AsVariant <>
               oProperty.GetNullableValue(oUpdateAsPointer).AsVariant then
            begin
              oColumn := oProperty.GetColumn;
              if oColumn <> nil then
                FModifiedFields.Add(Column(oColumn).ColumnName);
            end;
          end;
        end
        else
        begin
          if oProperty.GetNullableValue(oSourceAsPointer).AsVariant <>
             oProperty.GetNullableValue(oUpdateAsPointer).AsVariant then
          begin
            oColumn := oProperty.GetColumn;
            if oColumn <> nil then
              FModifiedFields.Add(Column(oColumn).ColumnName);
          end;
        end;
      end;
    end;
  except
    raise;
  end;
end;

destructor TObjectManager<M>.Destroy;
begin
  FExplorer := nil;
  FDMLCommandFactory.Free;
  FObjectInternal.Free;
  FModifiedFields.Free;
  if Assigned(FUpdateInternal) then
    FUpdateInternal.Free;
  inherited;
end;

procedure TObjectManager<M>.DeleteInternal(AObject: M);
begin
  FDMLCommandFactory.GeneratorDelete(AObject);
end;

function TObjectManager<M>.SelectInternalAll: IDBResultSet;
begin
  Result := FDMLCommandFactory.GeneratorSelectAll(M, FPageSize);
end;

function TObjectManager<M>.SelectInternalID(AID: TValue): IDBResultSet;
begin
  Result := FDMLCommandFactory.GeneratorSelectID(M, AID);
end;

function TObjectManager<M>.SelectInternalWhere(AWhere: string; AOrderBy: string): string;
begin
  Result := FDMLCommandFactory.GeneratorSelectWhere(M, AWhere, AOrderBy, FPageSize);
end;

procedure TObjectManager<M>.FillAssociation(AObject: M);
var
  oAssociationList: TAssociationMappingList;
  oAssociation: TAssociationMapping;
begin
  oAssociationList := FExplorer.GetMappingAssociation(AObject.ClassType);
  if oAssociationList <> nil then
  begin
    for oAssociation in oAssociationList do
    begin
       if oAssociation.Multiplicity in [OneToOne, ManyToOne] then
          ExecuteOneToOne(AObject, oAssociation.PropertyRtti, oAssociation)
       else
       if oAssociation.Multiplicity in [OneToMany, ManyToMany] then
          ExecuteOneToMany(AObject, oAssociation.PropertyRtti, oAssociation);
    end;
  end;
end;

procedure TObjectManager<M>.ExecuteOneToOne(AObject: TObject; AProperty: TRttiProperty;
  AAssociation: TAssociationMapping);
var
 oResultSet: IDBResultSet;
begin
  oResultSet := FDMLCommandFactory.GeneratorSelectOneToOne(AObject,
                                                           AProperty.PropertyType.AsInstance.MetaclassType,
                                                           AAssociation);
  try
    while oResultSet.NotEof do
    begin
      TBindObject.GetInstance.SetFieldToProperty(oResultSet,
                                                 AProperty.GetNullableValue(AObject).AsObject,
                                                 AAssociation);
    end;
  finally
    oResultSet.Close;
  end;
end;

procedure TObjectManager<M>.ExecuteOneToMany(AObject: TObject; AProperty: TRttiProperty;
  AAssociation: TAssociationMapping);
var
  oPropertyType: TRttiType;
  oPropertyObject: TObject;
  oResultSet: IDBResultSet;
begin
  oPropertyType := AProperty.PropertyType;
  oPropertyType := TRttiSingleton.GetInstance.GetListType(oPropertyType);
  oResultSet := FDMLCommandFactory.GeneratorSelectOneToMany(AObject,
                                                            oPropertyType.AsInstance.MetaclassType,
                                                            AAssociation);
  try
    while oResultSet.NotEof do
    begin
      /// <summary>
      /// Instancia o objeto da lista
      /// </summary>
      oPropertyObject := oPropertyType.AsInstance.MetaclassType.Create;
      /// <summary>
      /// Preenche o objeto com os dados do ResultSet
      /// </summary>
      TBindObject.GetInstance.SetFieldToProperty(oResultSet, oPropertyObject, AAssociation);
      /// <summary>
      /// Adiciona o objeto a lista
      /// </summary>
      TRttiSingleton.GetInstance.MethodCall(AProperty.GetNullableValue(AObject).AsObject,'Add',[oPropertyObject]);
    end;
  finally
    oResultSet.Close;
  end;
end;

function TObjectManager<M>.ExistSequence: Boolean;
begin
  Result := FDMLCommandFactory.ExistSequence;
end;

function TObjectManager<M>.GetDMLCommand: string;
begin
  Result := FDMLCommandFactory.GetDMLCommand;
end;

function TObjectManager<M>.NextPacket: IDBResultSet;
begin
  Result := FDMLCommandFactory.GeneratorNextPacket;
  if Result.FetchingAll then
    FFetchingRecords := True;
end;

procedure TObjectManager<M>.NextPacketList(AObjectList: TObjectList<M>);
var
 oResultSet: IDBResultSet;
begin
  oResultSet := NextPacket;
  try
    while oResultSet.NotEof do
    begin
      AObjectList.Add(M.Create);
      TBindObject.GetInstance.SetFieldToProperty(oResultSet, TObject(AObjectList.Last));
      /// <summary>
      /// Alimenta registros das associações existentes 1:1 ou 1:N
      /// </summary>
      FillAssociation(AObjectList.Last);
    end;
  finally
    /// <summary>
    /// Fecha o DataSet interno para limpar os dados dele da memória.
    /// </summary>
    oResultSet.Close;
  end;
end;

function TObjectManager<M>.SelectInternal(ASQL: String): IDBResultSet;
begin
  Result := FDMLCommandFactory.GeneratorSelect(ASQL, FPageSize);
end;

procedure TObjectManager<M>.UpdateInternal(AObject: M);
begin
  /// <summary>
  /// Gera a lista com as propriedades que foram alteradas
  /// Se Count > 0, a lista está sendo preenchida na classe.
  /// </summary>
  if FModifiedFields.Count = 0 then
    ModifyFieldsCompare(AObject, FUpdateInternal);
  /// <summary>
  ///
  /// </summary>
  FDMLCommandFactory.GeneratorUpdate(TObject(AObject), FModifiedFields);
end;

procedure TObjectManager<M>.InsertInternal(AObject: M);
begin
  FDMLCommandFactory.GeneratorInsert(AObject);
end;

procedure TObjectManager<M>.ModifyInternal(AObjectSource: M);
const
  cPropertyTypes = [tkUnknown,tkInterface,tkClass,tkClassRef,tkPointer,tkProcedure];
var
  oRttiType: TRttiType;
  oProperty: TRttiProperty;
  oSourceAsPointer, oUpdateAsPointer: Pointer;
begin
  /// <summary>
  /// Toda vez libera FUpdateInternal da memória, para que não fique vestigio de
  /// informações antigos de outros UPDATEs na variável.
  /// </summary>
  if Assigned(FUpdateInternal) then
    FUpdateInternal.Free;
  /// <summary>
  /// Como toda vez que chamado esse método o FUpdateInternal é liberado acima
  /// ele tem que ser recriado.
  /// </summary>
  FUpdateInternal := M.Create;
  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AObjectSource.ClassType);
  try
    Move(AObjectSource, oSourceAsPointer, SizeOf(Pointer));
    Move(FUpdateInternal, oUpdateAsPointer, SizeOf(Pointer));
    /// <summary>
    /// Loop na lista de propriedades
    /// </summary>
    for oProperty in oRttiType.GetProperties do
    begin
      /// <summary>
      /// Checa se no modelo o campo deve fazer parte do UPDATE
      /// </summary>
      if oProperty.IsNoUpdate then
        Continue;
      /// <summary>
      /// Validação para entrar no IF somente propriedades que o tipo não esteja na lista
      /// </summary>
      if not (oProperty.PropertyType.TypeKind in cPropertyTypes) then
        oProperty.SetValue(oUpdateAsPointer, oProperty.GetNullableValue(oSourceAsPointer));
    end;
  except
    raise;
  end;
end;

function TObjectManager<M>.Find(ASQL: String): TObjectList<M>;
var
 oResultSet: IDBResultSet;
begin
  Result := TObjectList<M>.Create;
  if ASQL = '' then
    oResultSet := SelectInternalAll
  else
    oResultSet := SelectInternal(ASQL);
  try
    while oResultSet.NotEof do
    begin
      TBindObject.GetInstance.SetFieldToProperty(oResultSet, TObject(Result.Items[Result.Add(M.Create)]));
      /// <summary>
      /// Alimenta registros das associações existentes 1:1 ou 1:N
      /// </summary>
      FillAssociation(Result.Items[Result.Count -1]);
    end;
  finally
    oResultSet.Close;
  end;
end;

function TObjectManager<M>.Find: TObjectList<M>;
begin
  Result := Find('');
end;

function TObjectManager<M>.Find(AID: TValue): M;
var
 oResultSet: IDBResultSet;
begin
  oResultSet := SelectInternalID(AID);
  try
    if oResultSet.RecordCount = 1 then
    begin
      Result := M.Create;
      TBindObject.GetInstance.SetFieldToProperty(oResultSet, TObject(Result));
      /// <summary>
      /// Alimenta registros das associações existentes 1:1 ou 1:N
      /// </summary>
      FillAssociation(Result);
    end
    else
      Result := nil;
  finally
    /// <summary>
    /// Fecha o DataSet interno para limpar os dados dele da memória.
    /// </summary>
    oResultSet.Close;
  end;
end;

function TObjectManager<M>.FindWhere(AWhere: string; AOrderBy: string): TObjectList<M>;
begin
  Result := Find(SelectInternalWhere(AWhere, AOrderBy));
end;

end.


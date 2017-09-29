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

unit ormbr.dml.generator;

interface

uses
  DB,
  Rtti,
  SysUtils,
  Classes,
  StrUtils,
  Variants,
  TypInfo,
  Generics.Collections,
  ormbr.utils,
  ormbr.mapping.classes,
  ormbr.mapping.explorer,
  ormbr.rtti.helper,
  ormbr.objects.helper,
  ormbr.mapping.attributes,
  ormbr.types.mapping,
  ormbr.factory.interfaces,
  ormbr.dml.interfaces,
  ormbr.criteria,
  ormbr.dml.commands;

type
  /// <summary>
  /// Classe de conexões abstract
  /// </summary>
  TDMLGeneratorAbstract = class abstract(TInterfacedObject, IDMLGeneratorCommand)
  private
    function GetPropertyValue(AObject: TObject; AProperty: TRttiProperty): Variant;
    procedure SetJoinColumn(AClass: TClass; ATable: TTableMapping; ACriteria: ICriteria);
  protected
    FConnection: IDBConnection;
    FDateFormat: string;
    FTimeFormat: string;
    function GetCriteriaSelect(AClass: TClass; AID: TValue): ICriteria; virtual;
    function GetGeneratorSelect(ACriteria: ICriteria): string; virtual;
    function ExecuteSequence(ASQL: string): Int64; virtual;
  public
    constructor Create; virtual; abstract;
    procedure SetConnection(const AConnaction: IDBConnection); virtual;
    function GeneratorSelectAll(AClass: TClass; APageSize: Integer; AID: TValue): string; virtual; abstract;
    function GeneratorSelectWhere(AClass: TClass; AWhere: string; AOrderBy: string; APageSize: Integer): string; virtual; abstract;
    function GenerateSelectOneToOne(AOwner: TObject; AClass: TClass; AAssociation: TAssociationMapping): string; virtual;
    function GenerateSelectOneToOneMany(AOwner: TObject; AClass: TClass; AAssociation: TAssociationMapping): string; virtual;
    function GeneratorUpdate(AObject: TObject; AParams: TParams; AModifiedFields: TList<string>): string; virtual;
    function GeneratorInsert(AObject: TObject; ACommandInsert: TDMLCommandInsert): string; virtual;
    function GeneratorDelete(AObject: TObject; AParams: TParams): string; virtual;
    function GeneratorSequenceCurrentValue(AObject: TObject; ACommandInsert: TDMLCommandInsert): Int64; virtual; abstract;
    function GeneratorSequenceNextValue(AObject: TObject; ACommandInsert: TDMLCommandInsert): Int64; virtual; abstract;
    function GeneratorPageNext(ACommandSelect: string; APageSize: Integer; APageNext: Integer): string; virtual;
  end;

implementation

uses
  ormbr.mapping.rttiutils,
  ormbr.types.blob;

{ TDMLGeneratorAbstract }

function TDMLGeneratorAbstract.ExecuteSequence(ASQL: string): Int64;
var
  oDBResultSet: IDBResultSet;
begin
  oDBResultSet := FConnection.ExecuteSQL(ASQL);
  if oDBResultSet.RecordCount > 0 then
    Result := VarAsType(oDBResultSet.GetFieldValue(0), varInt64)
  else
    Result := 0;
end;

function TDMLGeneratorAbstract.GenerateSelectOneToOne(AOwner: TObject;
  AClass: TClass; AAssociation: TAssociationMapping): string;

  function GetValue(AIndex: Integer): Variant;
  var
    oColumn: TColumnMapping;
    oColumns: TColumnMappingList;
  begin
    oColumns := TMappingExplorer.GetInstance.GetMappingColumn(AOwner.ClassType);
    for oColumn in oColumns do
      if oColumn.ColumnName = AAssociation.ColumnsName[AIndex] then
        Exit(GetPropertyValue(AOwner, oColumn.PropertyRtti));
  end;

var
  oTable: TTableMapping;
  oOrderBy: TOrderByMapping;
  oColumn: string;
  oCriteria: ICriteria;
  iFor: Integer;
begin
  oTable := TMappingExplorer.GetInstance.GetMappingTable(AClass);
  oCriteria := CreateCriteria.Select.From(oTable.Name);
  /// Columns
  if AAssociation.Multiplicity in [OneToOne, OneToMany] then
  begin
    if AAssociation.ColumnsSelectRef.Count > 0 then
      for oColumn in AAssociation.ColumnsSelectRef do
        oCriteria.Column(oTable.Name + '.' + oColumn)
    else
      oCriteria.All;
  end;
  /// Association Multi-Columns
  for iFor := 0 to AAssociation.ColumnsNameRef.Count -1 do
    oCriteria.Where(oTable.Name + '.' + AAssociation.ColumnsNameRef[iFor] + ' = ' + GetValue(iFor));
  /// OrderBy
  oOrderBy := TMappingExplorer.GetInstance.GetMappingOrderBy(AClass);
  if oOrderBy <> nil then
    oCriteria.OrderBy(oOrderBy.ColumnsName);
  /// Result
  Result := oCriteria.AsString;
end;

function TDMLGeneratorAbstract.GenerateSelectOneToOneMany(AOwner: TObject;
  AClass: TClass; AAssociation: TAssociationMapping): string;

  function GetValue(Aindex: Integer): Variant;
  var
    oColumn: TColumnMapping;
    oColumns: TColumnMappingList;
  begin
    oColumns := TMappingExplorer.GetInstance.GetMappingColumn(AOwner.ClassType);
    for oColumn in oColumns do
      if oColumn.ColumnName = AAssociation.ColumnsName[Aindex] then
        Exit(GetPropertyValue(AOwner, oColumn.PropertyRtti));
  end;

var
  oTable: TTableMapping;
  oOrderBy: TOrderByMapping;
  oCriteria: ICriteria;
  iFor: Integer;
begin
  oTable := TMappingExplorer.GetInstance.GetMappingTable(AClass);
  oCriteria := CreateCriteria.Select.All.From(oTable.Name);
  /// Association Multi-Columns
  for iFor := 0 to AAssociation.ColumnsNameRef.Count -1 do
    oCriteria.Where(oTable.Name + '.' + AAssociation.ColumnsNameRef[iFor] + ' = ' + GetValue(iFor));
  /// OrderBy
  oOrderBy := TMappingExplorer.GetInstance.GetMappingOrderBy(AClass);
  if oOrderBy <> nil then
    oCriteria.OrderBy(oOrderBy.ColumnsName);
  /// Result
  Result := oCriteria.AsString;
end;

function TDMLGeneratorAbstract.GeneratorDelete(AObject: TObject; AParams: TParams): string;
var
  iFor: Integer;
  oTable: TTableMapping;
  oCriteria: ICriteria;
begin
  oTable := TMappingExplorer.GetInstance.GetMappingTable(AObject.ClassType);
  oCriteria := CreateCriteria.Delete;
  oCriteria.From(oTable.Name);
  /// <exception cref="oTable.Name + '.'"></exception>
  for iFor := 0 to AParams.Count -1 do
    oCriteria.Where(AParams.Items[iFor].Name + ' = :' +
                    AParams.Items[iFor].Name);
  Result := oCriteria.AsString;
end;

function TDMLGeneratorAbstract.GeneratorInsert(AObject: TObject;
  ACommandInsert: TDMLCommandInsert): string;
var
  oTable: TTableMapping;
  oColumn: TColumnMapping;
  oColumns: TColumnMappingList;
  oCriteria: ICriteria;
begin
  Result := '';
  oTable := TMappingExplorer.GetInstance.GetMappingTable(AObject.ClassType);
  oColumns := TMappingExplorer.GetInstance.GetMappingColumn(AObject.ClassType);
  oCriteria := CreateCriteria.Insert.Into(oTable.Name);
  for oColumn in oColumns do
  begin
    if TRttiSingleton.GetInstance.IsNullValue(AObject, oColumn.PropertyRtti) then
      Continue;
    /// Restrictions
    if oColumn.IsNoInsert then
      Continue;
    /// <summary>
    /// Set(Campo=Value)
    /// </summary>
    /// <exception cref="oTable.Name + '.'"></exception>
    oCriteria.&Set(oColumn.ColumnName, ':' +
                   oColumn.ColumnName);
  end;
  Result := oCriteria.AsString;
end;

function TDMLGeneratorAbstract.GeneratorPageNext(ACommandSelect: string;
  APageSize: Integer; APageNext: Integer): string;
begin
  if APageSize > -1 then
     Result := Format(ACommandSelect, [APageSize, APageNext]);
end;

function TDMLGeneratorAbstract.GetGeneratorSelect(ACriteria: ICriteria): string;
begin
  Result := '';
end;

function TDMLGeneratorAbstract.GetCriteriaSelect(AClass: TClass; AID: TValue): ICriteria;
var
  oTable: TTableMapping;
  oOrderBy: TOrderByMapping;
  oColumns: TColumnMappingList;
  oColumn: TColumnMapping;
  oPrimaryKey: TPrimaryKeyMapping;
  oCriteria: ICriteria;
  oOrderByList: TStringList;
  iFor: Integer;
begin
  /// Table
  oTable := TMappingExplorer.GetInstance.GetMappingTable(AClass);
  oCriteria := CreateCriteria.Select.From(oTable.Name);
  /// Columns
  oColumns := TMappingExplorer.GetInstance.GetMappingColumn(AClass);
  for oColumn in oColumns do
  begin
    if oColumn.IsJoinColumn then
      Continue;
    oCriteria.Column(oTable.Name + '.' + oColumn.ColumnName);
  end;
  /// JoinColumn
  SetJoinColumn(AClass, oTable, oCriteria);
  /// PrimaryKey
  if AID.AsInteger > 0 then
  begin
    oPrimaryKey := TMappingExplorer.GetInstance.GetMappingPrimaryKey(AClass);
    if oPrimaryKey <> nil then
      oCriteria.Where(oPrimaryKey.Columns[0] + ' = ' + IntToStr(AID.AsInteger));
  end;
  /// OrderBy
  oOrderBy := TMappingExplorer.GetInstance.GetMappingOrderBy(AClass);
  if oOrderBy <> nil then
  begin
    oOrderByList := TStringList.Create;
    try
      TUtilSingleton.GetInstance.Delimiter(oOrderByList, ',', oOrderBy.ColumnsName);
      for iFor := 0 to oOrderByList.Count -1 do
        oCriteria.OrderBy(oTable.Name + '.' + oOrderByList[iFor]);
    finally
      oOrderByList.Free;
    end;
  end;
  Result := oCriteria;
end;

function TDMLGeneratorAbstract.GetPropertyValue(AObject: TObject;
  AProperty: TRttiProperty): Variant;
begin
  case TRttiSingleton.GetInstance.GetFieldType(AProperty.PropertyType.Handle) of
     ftString, ftWideString, ftMemo, ftWideMemo, ftFmtMemo:
        Result := QuotedStr(AProperty.GetNullableValue(AObject).AsString);
     ftLargeint:
        Result := IntToStr(AProperty.GetNullableValue(AObject).AsInt64);
     ftInteger, ftWord, ftSmallint:
        Result := IntToStr(AProperty.GetNullableValue(AObject).AsInteger);
     ftVariant:
        Result := VarToStr(AProperty.GetNullableValue(AObject).AsVariant);
     ftDateTime, ftDate:
        Result := QuotedStr(FormatDateTime(FDateFormat,
                                           AProperty.GetNullableValue(AObject).AsExtended));
     ftTime, ftTimeStamp, ftOraTimeStamp:
        Result := QuotedStr(FormatDateTime(FTimeFormat,
                                           AProperty.GetNullableValue(AObject).AsExtended));
     ftCurrency, ftBCD, ftFMTBcd:
       begin
         Result := CurrToStr(AProperty.GetNullableValue(AObject).AsCurrency);
         Result := ReplaceStr(Result, ',', '.');
       end;
     ftFloat:
       begin
         Result := FloatToStr(AProperty.GetNullableValue(AObject).AsExtended);
         Result := ReplaceStr(Result, ',', '.');
       end;
     ftBlob, ftGraphic, ftOraBlob, ftOraClob:
       Result := AProperty.GetNullableValue(AObject).AsType<TBlob>.ToBytes;
  else
     Result := '';
  end;
end;

procedure TDMLGeneratorAbstract.SetConnection(const AConnaction: IDBConnection);
begin
  FConnection := AConnaction;
end;

procedure TDMLGeneratorAbstract.SetJoinColumn(AClass: TClass;
  ATable: TTableMapping; ACriteria: ICriteria);
var
  oJoinList: TJoinColumnMappingList;
  oJoin: TJoinColumnMapping;
  oJoinExist: TList<string>;
begin
  oJoinExist := TList<string>.Create;
  try
    /// JoinColumn
    oJoinList := TMappingExplorer.GetInstance.GetMappingJoinColumn(AClass);
    if oJoinList <> nil then
    begin
      for oJoin in oJoinList do
      begin
        ACriteria.Column(oJoin.RefTableName + '.' + oJoin.RefColumnNameSelect);
        if oJoinExist.IndexOf(oJoin.RefTableName) = -1 then
        begin
          oJoinExist.Add(oJoin.RefTableName);
          /// Join Inner, Left, Right, Full
          if oJoin.Join = InnerJoin then
            ACriteria.InnerJoin(oJoin.RefTableName).
                      &On([oJoin.RefTableName + '.' +
                           oJoin.RefColumnName,' = ',ATable.Name + '.' +
                           oJoin.ColumnName])
          else
          if oJoin.Join = LeftJoin then
            ACriteria.LeftJoin(oJoin.RefTableName).
                      &On([oJoin.RefTableName + '.' +
                           oJoin.RefColumnName,' = ',ATable.Name + '.' +
                           oJoin.ColumnName])
          else
          if oJoin.Join = RightJoin then
            ACriteria.RightJoin(oJoin.RefTableName).
                      &On([oJoin.RefTableName + '.' +
                           oJoin.RefColumnName,' = ',ATable.Name + '.' +
                           oJoin.ColumnName])
          else
          if oJoin.Join = FullJoin then
            ACriteria.FullJoin(oJoin.RefTableName).
                      &On([oJoin.RefTableName + '.' +
                           oJoin.RefColumnName,' = ',ATable.Name + '.' +
                           oJoin.ColumnName]);
        end;
      end;
    end;
  finally
    oJoinExist.Free;
  end;
end;

function TDMLGeneratorAbstract.GeneratorUpdate(AObject: TObject; AParams: TParams;
  AModifiedFields: TList<string>): string;
var
  iFor: Integer;
  oTable: TTableMapping;
  oCriteria: ICriteria;
  sColumnName: string;
begin
  oTable := TMappingExplorer.GetInstance.GetMappingTable(AObject.ClassType);
  oCriteria := CreateCriteria.Update(oTable.Name);
  /// <summary>
  /// Varre a lista de campos alterados para montar o UPDATE
  /// </summary>
  for sColumnName in AModifiedFields do
  begin
    /// <summary>
    /// SET Field=Value alterado
    /// </summary>
    /// <exception cref="oTable.Name + '.'"></exception>
    oCriteria.&Set(sColumnName, ':' + sColumnName);
  end;
  for iFor := 0 to AParams.Count -1 do
    oCriteria.Where(AParams.Items[iFor].Name + ' = :' + AParams.Items[iFor].Name);

  Result := oCriteria.AsString;
end;

end.

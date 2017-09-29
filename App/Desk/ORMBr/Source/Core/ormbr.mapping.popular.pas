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

unit ormbr.mapping.popular;

interface

uses
  DB,
  Classes,
  Rtti,
  TypInfo,
  StrUtils,
  Generics.Collections,
  ormbr.mapping.rttiutils,
  ormbr.mapping.attributes,
  ormbr.mapping.classes,
  ormbr.rtti.helper,
  ormbr.types.mapping,
  ormbr.mapping.explorerstrategy;

type
  TMappingPopular = class
  private
    FMappingExplorerStrategy: TMappingExplorerStrategy;
  public
    constructor Create(AMappingExplorerStrategy: TMappingExplorerStrategy);
    function PopularTable(ARttiType: TRttiType): TTableMapping;
    function PopularOrderBy(ARttiType: TRttiType): TOrderByMapping;
    function PopularSequence(ARttiType: TRttiType): TSequenceMapping;
    function PopularPrimaryKey(ARttiType: TRttiType): TPrimaryKeyMapping;
    function PopularForeignKey(ARttiType: TRttiType): TForeignKeyMappingList;
    function PopularIndexe(ARttiType: TRttiType): TIndexeMappingList;
    function PopularCheck(ARttiType: TRttiType): TCheckMappingList;
    function PopularColumn(ARttiType: TRttiType; AClass: TClass): TColumnMappingList;
    function PopularAssociation(ARttiType: TRttiType): TAssociationMappingList;
    function PopularJoinColumn(ARttiType: TRttiType): TJoinColumnMappingList;
    function PopularTrigger(ARttiType: TRttiType): TTriggerMappingList;
    function PopularView(ARttiType: TRttiType): TViewMapping;
  end;

implementation

{ TMappingPopular }

constructor TMappingPopular.Create(AMappingExplorerStrategy: TMappingExplorerStrategy);
begin
  FMappingExplorerStrategy := AMappingExplorerStrategy;
end;

function TMappingPopular.PopularCheck(ARttiType: TRttiType): TCheckMappingList;
var
  oAttrib: TCustomAttribute;
begin
  Result := nil;
  for oAttrib in ARttiType.GetAttributes do
  begin
    if oAttrib is Check then // Check
    begin
       if Result = nil then
          Result := TCheckMappingList.Create;
       Result.Add(TCheckMapping.Create(Check(oAttrib).Name,
                                       Check(oAttrib).Condition,
                                       Check(oAttrib).Description));
    end;
  end;
end;

function TMappingPopular.PopularColumn(ARttiType: TRttiType; AClass: TClass): TColumnMappingList;
var
  oProperty: TRttiProperty;
  oAttrib: TCustomAttribute;
  oDictionary: TCustomAttribute;
begin
  Result := nil;
  for oProperty in ARttiType.GetProperties do
  begin
    oDictionary := oProperty.GetDictionary;
    for oAttrib in oProperty.GetAttributes do
    begin
      if oAttrib is Column then // Column
      begin
        if Result = nil then
          Result := TColumnMappingList.Create;
        Result.Add(TColumnMapping.Create);
        Result.Last.ColumnName := Column(oAttrib).ColumnName;
        Result.Last.FieldType :=  Column(oAttrib).FieldType;
        Result.Last.Scale := Column(oAttrib).Scale;
        Result.Last.Size := Column(oAttrib).Size;
        Result.Last.Precision := Column(oAttrib).Precision;
        Result.Last.PropertyRtti := oProperty;
        Result.Last.FieldIndex := (oProperty as TRttiInstanceProperty).Index;
        Result.Last.IsJoinColumn := oProperty.IsJoinColumn;
        Result.Last.IsNotNull := oProperty.IsNotNull;
        Result.Last.IsUnique := oProperty.IsUnique;
        Result.Last.IsNoUpdate := oProperty.IsNoUpdate;
        Result.Last.IsNoInsert := oProperty.IsNoInsert;
        Result.Last.IsCheck := oProperty.IsCheck;
        Result.Last.IsRequired := oProperty.IsRequired;
        Result.Last.IsHidden := oProperty.IsHidden;
        Result.Last.IsPrimaryKey := oProperty.IsPrimaryKey(AClass);
        Result.Last.DefaultValue := '';

        if oDictionary <> nil then
         if not MatchStr(Dictionary(oDictionary).DefaultExpression, ['Date', 'Now']) then
           Result.Last.DefaultValue := Dictionary(oDictionary).DefaultExpression
      end;
    end;
  end;
end;

function TMappingPopular.PopularForeignKey(ARttiType: TRttiType): TForeignKeyMappingList;
var
  oProperty: TRttiProperty;
  oAttrib: TCustomAttribute;
begin
  Result := nil;
  /// Atributos da classe
  for oAttrib in ARttiType.GetAttributes do
  begin
    if oAttrib is ForeignKey then // ForeignKey
    begin
       if Result = nil then
          Result := TForeignKeyMappingList.Create;
       Result.Add(TForeignKeyMapping.Create(ForeignKey(oAttrib).Name,
                                            ForeignKey(oAttrib).TableNameRef,
                                            ForeignKey(oAttrib).FromColumns,
                                            ForeignKey(oAttrib).ToColumns,
                                            ForeignKey(oAttrib).RuleDelete,
                                            ForeignKey(oAttrib).RuleUpdate,
                                            ForeignKey(oAttrib).Description));
    end;
  end;
  /// Atributos das propriedades
  for oProperty in ARttiType.GetProperties do
  begin
    for oAttrib in oProperty.GetAttributes do
    begin
      if oAttrib is ForeignKey then // ForeignKey
      begin
         if Result = nil then
            Result := TForeignKeyMappingList.Create;
         Result.Add(TForeignKeyMapping.Create(ForeignKey(oAttrib).Name,
                                              ForeignKey(oAttrib).TableNameRef,
                                              ForeignKey(oAttrib).FromColumns,
                                              ForeignKey(oAttrib).ToColumns,
                                              ForeignKey(oAttrib).RuleDelete,
                                              ForeignKey(oAttrib).RuleUpdate,
                                              ForeignKey(oAttrib).Description));
      end;
    end;
  end;
end;

function TMappingPopular.PopularIndexe(ARttiType: TRttiType): TIndexeMappingList;
var
  oAttrib: TCustomAttribute;
begin
  Result := nil;
  for oAttrib in ARttiType.GetAttributes do
  begin
    if oAttrib is Indexe then // Indexe
    begin
       if Result = nil then
          Result := TIndexeMappingList.Create;
       Result.Add(TIndexeMapping.Create(Indexe(oAttrib).Name,
                                        Indexe(oAttrib).Columns,
                                        Indexe(oAttrib).SortingOrder,
                                        Indexe(oAttrib).Unique,
                                        Indexe(oAttrib).Description));
    end;
  end;
end;

function TMappingPopular.PopularJoinColumn(ARttiType: TRttiType): TJoinColumnMappingList;
var
  oProperty: TRttiProperty;
  oAttrib: TCustomAttribute;
begin
  Result := nil;
  for oProperty in ARttiType.GetProperties do
  begin
    for oAttrib in oProperty.GetAttributes do
    begin
      if oAttrib is JoinColumn then // JoinColumn
      begin
        if Length(JoinColumn(oAttrib).RefTableName) > 0 then
        begin
          if Result = nil then
             Result := TJoinColumnMappingList.Create;
          Result.Add(TJoinColumnMapping.Create(JoinColumn(oAttrib).ColumnName,
                                               JoinColumn(oAttrib).RefTableName,
                                               JoinColumn(oAttrib).RefColumnName,
                                               JoinColumn(oAttrib).RefColumnNameSelect,
                                               JoinColumn(oAttrib).Join));
        end;
      end;
    end;
  end;
end;

function TMappingPopular.PopularOrderBy(ARttiType: TRttiType): TOrderByMapping;
var
  oAttrib: TCustomAttribute;
begin
  Result := nil;
  for oAttrib in ARttiType.GetAttributes do
  begin
    if oAttrib is OrderBy then // OrderBy
    begin
      Result := TOrderByMapping.Create;
      Result.ColumnsName := OrderBy(oAttrib).ColumnsName;
    end;
  end;
end;

function TMappingPopular.PopularPrimaryKey(ARttiType: TRttiType): TPrimaryKeyMapping;
var
  oAttrib: TCustomAttribute;
begin
  Result := nil;
  for oAttrib in ARttiType.GetAttributes do
  begin
    if oAttrib is PrimaryKey then // PrimaryKey
    begin
       Result := TPrimaryKeyMapping.Create(PrimaryKey(oAttrib).Columns,
                                           PrimaryKey(oAttrib).SequenceType = AutoInc,
                                           PrimaryKey(oAttrib).SortingOrder,
                                           PrimaryKey(oAttrib).Unique,
                                           PrimaryKey(oAttrib).Description);
    end;
  end;
end;

function TMappingPopular.PopularSequence(ARttiType: TRttiType): TSequenceMapping;
var
  oAttrib: TCustomAttribute;
  oTable: Table;
begin
  Result := nil;
  oTable := nil;
  for oAttrib in ARttiType.GetAttributes do
  begin
    if oAttrib is Table then // Table
      oTable := Table(oAttrib);

    if oAttrib is Sequence then // Sequence
    begin
      Result := TSequenceMapping.Create;
      Result.Name := Sequence(oAttrib).Name;
      Result.Initial := Sequence(oAttrib).Initial;
      Result.Increment := Sequence(oAttrib).Increment;
    end;
  end;
  if Result <> nil then
    Result.TableName := oTable.Name;
end;

function TMappingPopular.PopularAssociation(ARttiType: TRttiType): TAssociationMappingList;
var
  oRttiType: TRttiType;
  oProperty: TRttiProperty;
  oAttrib: TCustomAttribute;
  oColumns: TArray<string>;
  iFor: Integer;
begin
  Result := nil;
  for oProperty in ARttiType.GetProperties do
  begin
    for oAttrib in oProperty.GetAttributes do
    begin
      if oAttrib is Association then // Association
      begin
        SetLength(oColumns,0);
        if Length(Association(oAttrib).ColumnsNameRef) > 0 then
        begin
          if Result = nil then
             Result := TAssociationMappingList.Create;

          if Length(Association(oAttrib).ColumnsSelectRef) > 0 then
          begin
            SetLength(oColumns, Length(Association(oAttrib).ColumnsSelectRef));
            for iFor := 0 to High(Association(oAttrib).ColumnsSelectRef) do
              oColumns[iFor] := Association(oAttrib).ColumnsSelectRef[iFor];
          end;
          oRttiType := ARttiType.GetProperty(oProperty.Name).PropertyType;
          oRttiType := TRttiSingleton.GetInstance.GetListType(oRttiType);
          if oRttiType <> nil then
             Result.Add(TAssociationMapping.Create(Association(oAttrib).Multiplicity,
                                                   Association(oAttrib).ColumnsName,
                                                   Association(oAttrib).ColumnsNameRef,
                                                   oRttiType.AsInstance.MetaclassType.ClassName,
                                                   oProperty,
                                                   oColumns))
          else
             Result.Add(TAssociationMapping.Create(Association(oAttrib).Multiplicity,
                                                   Association(oAttrib).ColumnsName,
                                                   Association(oAttrib).ColumnsNameRef,
                                                   oProperty.PropertyType.Name,
                                                   oProperty,
                                                   oColumns));
        end;
      end;
    end;
  end;
end;

function TMappingPopular.PopularTable(ARttiType: TRttiType): TTableMapping;
var
  oAttrib: TCustomAttribute;
begin
  Result := nil;
  for oAttrib in ARttiType.GetAttributes do
  begin
    if oAttrib is Table then // Table
    begin
      Result := TTableMapping.Create;
      Result.Name := Table(oAttrib).Name;
      Result.Schema := '';
      Result.Description := Table(oAttrib).Description;
    end;
  end;
end;

function TMappingPopular.PopularTrigger(ARttiType: TRttiType): TTriggerMappingList;
var
  oAttrib: TCustomAttribute;
begin
  Result := nil;
  for oAttrib in ARttiType.GetAttributes do
  begin
    if oAttrib is Trigger then // Trigger
    begin
      if Result = nil then
         Result := TTriggerMappingList.Create;
      Result.Add(TTriggerMapping.Create(Trigger(oAttrib).Name,
                                        ''));
    end;
  end;
end;

function TMappingPopular.PopularView(ARttiType: TRttiType): TViewMapping;
var
  oAttrib: TCustomAttribute;
begin
  Result := nil;
  for oAttrib in ARttiType.GetAttributes do
  begin
    if oAttrib is View then // View
    begin
      Result := TViewMapping.Create;
      Result.Name := Table(oAttrib).Name;
      Result.Description := Table(oAttrib).Description;
      Result.Script := '';
    end;
  end;
end;

end.


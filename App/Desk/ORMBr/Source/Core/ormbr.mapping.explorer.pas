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

unit ormbr.mapping.explorer;

interface

uses
  Classes,
  SysUtils,
  Rtti,
  DB,
  Generics.Collections,
  /// orm
  ormbr.mapping.classes,
  ormbr.mapping.popular,
  ormbr.mapping.explorerstrategy,
  ormbr.mapping.repository,
  ormbr.mapping.register;

type
  TMappingExplorer = class(TMappingExplorerStrategy)
  private
  class var
    FInstance: IMappingExplorerStrategy;
  private
    FRepositoryMapping: TMappingRepository;
    FPopularMapping: TMappingPopular;
    FTableMapping: TDictionary<string, TTableMapping>;
    FOrderByMapping: TDictionary<string, TOrderByMapping>;
    FSequenceMapping: TDictionary<string, TSequenceMapping>;
    FPrimaryKeyMapping: TDictionary<string, TPrimaryKeyMapping>;
    FForeingnKeyMapping: TDictionary<string, TForeignKeyMappingList>;
    FIndexeMapping: TDictionary<string, TIndexeMappingList>;
    FCheckMapping: TDictionary<string, TCheckMappingList>;
    FColumnMapping: TDictionary<string, TColumnMappingList>;
    FAssociationMapping: TDictionary<string, TAssociationMappingList>;
    FJoinColumnMapping: TDictionary<string, TJoinColumnMappingList>;
    FTriggerMapping: TDictionary<string, TTriggerMappingList>;
    FViewMapping: TDictionary<string, TViewMapping>;
    constructor CreatePrivate;
  protected
    function GetRepositoryMapping: TMappingRepository; override;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    class function GetInstance: IMappingExplorerStrategy;
    function GetMappingTable(AClass: TClass): TTableMapping; override;
    function GetMappingOrderBy(AClass: TClass): TOrderByMapping; override;
    function GetMappingSequence(AClass: TClass): TSequenceMapping; override;
    function GetMappingPrimaryKey(AClass: TClass): TPrimaryKeyMapping; override;
    function GetMappingForeignKey(AClass: TClass): TForeignKeyMappingList; override;
    function GetMappingColumn(AClass: TClass): TColumnMappingList; override;
    function GetMappingAssociation(AClass: TClass): TAssociationMappingList; override;
    function GetMappingJoinColumn(AClass: TClass): TJoinColumnMappingList; override;
    function GetMappingIndexe(AClass: TClass): TIndexeMappingList; override;
    function GetMappingCheck(AClass: TClass): TCheckMappingList; override;
    function GetMappingTrigger(AClass: TClass): TTriggerMappingList; override;
    function GetMappingView(AClass: TClass): TViewMapping; override;
    function GetColumnByName(AClass: TClass; AColumnName: string): TColumnMapping; override;
    property Repository: TMappingRepository read GetRepositoryMapping;
  end;

implementation

uses
  ormbr.mapping.rttiutils;

{ TMappingExplorer }

function TMappingExplorer.GetColumnByName(AClass: TClass; AColumnName: string): TColumnMapping;
begin
  inherited;
  for Result in GetMappingColumn(AClass) do
    if SameText(Result.ColumnName, AColumnName) then
      Exit;
  Result := nil;
end;

constructor TMappingExplorer.Create;
begin
   raise Exception.Create('Para usar o MappingEntity use o método TMappingExplorerClass.GetInstance()');
end;

constructor TMappingExplorer.CreatePrivate;
begin
  inherited;
  FRepositoryMapping  := TMappingRepository.Create(TRegisterClass.GetAllEntityClass, TRegisterClass.GetAllViewClass);
  FPopularMapping     := TMappingPopular.Create(Self);
  FTableMapping       := TObjectDictionary<string, TTableMapping>.Create([doOwnsValues]);
  FOrderByMapping     := TObjectDictionary<string, TOrderByMapping>.Create([doOwnsValues]);
  FSequenceMapping    := TObjectDictionary<string, TSequenceMapping>.Create([doOwnsValues]);
  FPrimaryKeyMapping  := TObjectDictionary<string, TPrimaryKeyMapping>.Create([doOwnsValues]);
  FForeingnKeyMapping := TObjectDictionary<string, TForeignKeyMappingList>.Create([doOwnsValues]);
  FColumnMapping      := TObjectDictionary<string, TColumnMappingList>.Create([doOwnsValues]);
  FAssociationMapping := TObjectDictionary<string, TAssociationMappingList>.Create([doOwnsValues]);
  FJoinColumnMapping  := TObjectDictionary<string, TJoinColumnMappingList>.Create([doOwnsValues]);
  FIndexeMapping      := TObjectDictionary<string, TIndexeMappingList>.Create([doOwnsValues]);
  FCheckMapping       := TObjectDictionary<string, TCheckMappingList>.Create([doOwnsValues]);
  FTriggerMapping     := TObjectDictionary<string, TTriggerMappingList>.Create([doOwnsValues]);
  FViewMapping        := TObjectDictionary<string, TViewMapping>.Create([doOwnsValues]);
end;

destructor TMappingExplorer.Destroy;
begin
  FPopularMapping.Free;
  FTableMapping.Free;
  FOrderByMapping.Free;
  FSequenceMapping.Free;
  FPrimaryKeyMapping.Free;
  FForeingnKeyMapping.Free;
  FColumnMapping.Free;
  FAssociationMapping.Free;
  FJoinColumnMapping.Free;
  FIndexeMapping.Free;
  FTriggerMapping.Free;
  FCheckMapping.Free;
  FViewMapping.Free;
  if Assigned(FRepositoryMapping) then
     FRepositoryMapping.Free;
  inherited;
end;

class function TMappingExplorer.GetInstance: IMappingExplorerStrategy;
begin
   if not Assigned(FInstance) then
      FInstance := TMappingExplorer.CreatePrivate;

   Result := FInstance;
end;

function TMappingExplorer.GetMappingPrimaryKey(AClass: TClass): TPrimaryKeyMapping;
var
  oRttiType: TRttiType;
begin
  if FPrimaryKeyMapping.ContainsKey(AClass.ClassName) then
     Exit(FPrimaryKeyMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularPrimaryKey(oRttiType);
   /// Add List
  if Result <> nil then
    FPrimaryKeyMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetMappingSequence(AClass: TClass): TSequenceMapping;
var
  oRttiType: TRttiType;
begin
  if FSequenceMapping.ContainsKey(AClass.ClassName) then
     Exit(FSequenceMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularSequence(oRttiType);
   /// Add List
  if Result <> nil then
    FSequenceMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetMappingCheck(AClass: TClass): TCheckMappingList;
var
  oRttiType: TRttiType;
begin
  if FCheckMapping.ContainsKey(AClass.ClassName) then
     Exit(FCheckMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularCheck(oRttiType);
   /// Add List
  if Result <> nil then
    FCheckMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetMappingColumn(AClass: TClass): TColumnMappingList;
var
  oRttiType: TRttiType;
begin
  if FColumnMapping.ContainsKey(AClass.ClassName) then
     Exit(FColumnMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularColumn(oRttiType, AClass);
   /// Add List
  if Result <> nil then
    FColumnMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetMappingForeignKey(AClass: TClass): TForeignKeyMappingList;
var
  oRttiType: TRttiType;
begin
  if FForeingnKeyMapping.ContainsKey(AClass.ClassName) then
     Exit(FForeingnKeyMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularForeignKey(oRttiType);
   /// Add List
  if Result <> nil then
    FForeingnKeyMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetMappingIndexe(AClass: TClass): TIndexeMappingList;
var
  oRttiType: TRttiType;
begin
  if FIndexeMapping.ContainsKey(AClass.ClassName) then
     Exit(FIndexeMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularIndexe(oRttiType);
   /// Add List
  if Result <> nil then
    FIndexeMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetMappingJoinColumn(AClass: TClass): TJoinColumnMappingList;
var
  oRttiType: TRttiType;
begin
  if FJoinColumnMapping.ContainsKey(AClass.ClassName) then
     Exit(FJoinColumnMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularJoinColumn(oRttiType);
  /// Add List
  if Result <> nil then
    FJoinColumnMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetMappingOrderBy(AClass: TClass): TOrderByMapping;
var
  oRttiType: TRttiType;
begin
  if FOrderByMapping.ContainsKey(AClass.ClassName) then
     Exit(FOrderByMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularOrderBy(oRttiType);
   /// Add List
  if Result <> nil then
    FOrderByMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetMappingAssociation(AClass: TClass): TAssociationMappingList;
var
  oRttiType: TRttiType;
begin
  if FAssociationMapping.ContainsKey(AClass.ClassName) then
     Exit(FAssociationMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularAssociation(oRttiType);
  /// Add List
  if Result <> nil then
    FAssociationMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetMappingTable(AClass: TClass): TTableMapping;
var
  oRttiType: TRttiType;
begin
  if FTableMapping.ContainsKey(AClass.ClassName) then
     Exit(FTableMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularTable(oRttiType);
  /// Add List
  if Result <> nil then
    FTableMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetMappingTrigger(AClass: TClass): TTriggerMappingList;
var
  oRttiType: TRttiType;
begin
  if FTriggerMapping.ContainsKey(AClass.ClassName) then
     Exit(FTriggerMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularTrigger(oRttiType);
  /// Add List
  if Result <> nil then
    FTriggerMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetMappingView(AClass: TClass): TViewMapping;
var
  oRttiType: TRttiType;
begin
  if FViewMapping.ContainsKey(AClass.ClassName) then
     Exit(FViewMapping[AClass.ClassName]);

  oRttiType := TRttiSingleton.GetInstance.GetRttiType(AClass);
  Result    := FPopularMapping.PopularView(oRttiType);
  /// Add List
  if Result <> nil then
    FViewMapping.Add(AClass.ClassName, Result);
end;

function TMappingExplorer.GetRepositoryMapping: TMappingRepository;
begin
  Result := FRepositoryMapping;
end;

end.


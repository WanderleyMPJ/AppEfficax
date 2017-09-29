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

  ORM Brasil é um ORM simples e descomplicado para quem utiliza Delphi.
}

unit ormbr.mapping.repository;

interface

uses
  SysUtils,
  Rtti,
  Generics.Collections,
  ormbr.mapping.exceptions;

type
  TRepository = class
  private
    FEntitys: TObjectDictionary<TClass, TList<TClass>>;
    FViews: TObjectDictionary<TClass, TList<TClass>>;
    FTriggers: TObjectDictionary<TClass, TList<TClass>>;
    function GetEntity: TEnumerable<TClass>;
    function GetView: TEnumerable<TClass>;
    function GetTrigger: TEnumerable<TClass>;
  protected
    property EntityList: TObjectDictionary<TClass, TList<TClass>> read FEntitys;
    property ViewList: TObjectDictionary<TClass, TList<TClass>> read FViews;
    property TriggerList: TObjectDictionary<TClass, TList<TClass>> read FTriggers;
  public
    constructor Create;
    destructor Destroy; override;
    property Entitys: TEnumerable<TClass> read GetEntity;
    property Views: TEnumerable<TClass> read GetView;
    property Trigger: TEnumerable<TClass> read GetTrigger;
  end;

  TMappingRepository = class
  private
    FRepository: TRepository;
    function FindEntity(AClass: TClass): TList<TClass>;
  public
    constructor Create(AEntity, AView: TArray<TClass>);
    destructor Destroy; override;
    function GetEntity(AClass: TClass): TEnumerable<TClass>;
    function FindEntityByName(ClassName: string): TClass;
    property List: TRepository read FRepository;
  end;

implementation

{ TMappingRepository }

constructor TMappingRepository.Create(AEntity, AView: TArray<TClass>);
var
  oClass: TClass;
begin
  FRepository := TRepository.Create;
  /// <summary>
  /// Entitys
  /// </summary>
  if AEntity <> nil then
    for oClass in AEntity do
      if not FRepository.EntityList.ContainsKey(oClass) then
        FRepository.EntityList.Add(oClass, TList<TClass>.Create);

  for oClass in FRepository.Entitys do
    if FRepository.EntityList.ContainsKey(oClass.ClassParent) then
      FRepository.EntityList[oClass.ClassParent].Add(oClass);

  /// <summary>
  /// Views
  /// </summary>
  if AView <> nil then
    for oClass in AView do
      if not FRepository.ViewList.ContainsKey(oClass) then
        FRepository.ViewList.Add(oClass, TList<TClass>.Create);

  for oClass in FRepository.Views do
    if FRepository.ViewList.ContainsKey(oClass.ClassParent) then
      FRepository.ViewList[oClass.ClassParent].Add(oClass);
end;

destructor TMappingRepository.Destroy;
begin
  FRepository.Free;
  inherited;
end;

function TMappingRepository.FindEntityByName(ClassName: string): TClass;
var
  oClass: TClass;
begin
  for oClass in List.Entitys do
     if SameText(oClass.ClassName, ClassName) then
        Exit(oClass);
  Result := nil;
end;

function TMappingRepository.FindEntity(AClass: TClass): TList<TClass>;
var
  oClass: TClass;
  oListClass: TList<TClass>;
begin
  Result := TList<TClass>.Create;
  Result.AddRange(GetEntity(AClass));

  for oClass in GetEntity(AClass) do
  begin
    oListClass := FindEntity(oClass);
    try
      Result.AddRange(oListClass);
    finally
      oListClass.Free;
    end;
  end;
end;

function TMappingRepository.GetEntity(AClass: TClass): TEnumerable<TClass>;
begin
  if not FRepository.EntityList.ContainsKey(AClass) then
     EClassNotRegistered.Create(AClass);

  Result := FRepository.EntityList[AClass];
end;

{ TRepository }

constructor TRepository.Create;
begin
  FEntitys := TObjectDictionary<TClass, TList<TClass>>.Create([doOwnsValues]);
  FViews := TObjectDictionary<TClass, TList<TClass>>.Create([doOwnsValues]);
end;

destructor TRepository.Destroy;
begin
  FEntitys.Free;
  FViews.Free;
  inherited;
end;

function TRepository.GetEntity: TEnumerable<TClass>;
begin
  Result := FEntitys.Keys;
end;

function TRepository.GetTrigger: TEnumerable<TClass>;
begin
  Result := FTriggers.Keys;
end;

function TRepository.GetView: TEnumerable<TClass>;
begin
  Result := FViews.Keys;
end;

end.


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

unit ormbr.mapping.rttiutils;

interface

uses
  Classes,
  SysUtils,
  Rtti,
  DB,
  TypInfo,
  Math,
  StrUtils,
  Types,
  Variants,
  Generics.Collections,
  /// orm
  ormbr.mapping.attributes,
  ormbr.mapping.classes,
  ormbr.types.mapping;

type
  IRttiSingleton = interface
    ['{AF40524E-2027-46C3-AAAE-5F4267689CD8}']
    function GetRttiType(AClass: TClass): TRttiType;
    function GetListType(ARttiType: TRttiType): TRttiType;
    function GetFieldType(ATypeInfo: PTypeInfo): TFieldType;
    function TryGetUnderlyingTypeInfo(ATypeInfo: PTypeInfo; out AUnderlyingTypeInfo: PTypeInfo): Boolean;

    function IsNullable(ATypeInfo: PTypeInfo): Boolean;
    function IsLazy(ARttiType: TRttiType): Boolean;
    function IsBlob(ATypeInfo: PTypeInfo): Boolean;
    function IsNullValue(AObject: TObject; AProperty: TRttiProperty): Boolean;
    function RunValidade(AClass: TClass): Boolean;
    function MethodCall(AObject: TObject; AMethodName: string; const AParameters: array of TValue): TValue;
  end;

  TRttiSingleton = class(TInterfacedObject, IRttiSingleton)
  private
  class var
    FInstance: IRttiSingleton;
  private
    FContext: TRttiContext;
    constructor CreatePrivate;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    class function GetInstance: IRttiSingleton;

    function GetRttiType(AClass: TClass): TRttiType;
    function GetListType(ARttiType: TRttiType): TRttiType;
    function GetFieldType(ATypeInfo: PTypeInfo): TFieldType;
    function TryGetUnderlyingTypeInfo(ATypeInfo: PTypeInfo; out AUnderlyingTypeInfo: PTypeInfo): Boolean;

    function IsNullable(ATypeInfo: PTypeInfo): Boolean;
    function IsLazy(ARttiType: TRttiType): Boolean;
    function IsBlob(ATypeInfo: PTypeInfo): Boolean;
    function IsNullValue(AObject: TObject; AProperty: TRttiProperty): Boolean;
    function RunValidade(AClass: TClass): Boolean;
    function MethodCall(AObject: TObject; AMethodName: string; const AParameters: array of TValue): TValue;
  end;

implementation

uses
  ormbr.mapping.explorer,
  ormbr.types.blob,
  ormbr.rtti.helper;

{ TRttiSingleton }

constructor TRttiSingleton.Create;
begin
   raise Exception.Create('Para usar o MappingEntity use o método TRttiSingleton.GetInstance()');
end;

constructor TRttiSingleton.CreatePrivate;
begin
   inherited;
   FContext := TRttiContext.Create;
end;

destructor TRttiSingleton.Destroy;
begin
  FContext.Free;
  inherited;
end;

function TRttiSingleton.GetRttiType(AClass: TClass): TRttiType;
begin
  Result := FContext.GetType(AClass);
end;

function TRttiSingleton.GetFieldType(ATypeInfo: PTypeInfo): TFieldType;
var
  oTypeInfo: PTypeInfo;
begin
   Result := ftUnknown;
   case ATypeInfo.Kind of
     tkInteger, tkSet:
     begin
       if ATypeInfo = TypeInfo(Word) then
          Result := ftWord
       else
       if ATypeInfo = TypeInfo(SmallInt) then
          Result := ftSmallint
       else
          Result := ftInteger;
     end;
     tkEnumeration:
     begin
       if ATypeInfo = TypeInfo(Boolean) then
          Result := ftBoolean
       else
          Result := ftInteger;
     end;
     tkFloat:
     begin
       if ATypeInfo = TypeInfo(TDate) then
          Result := ftDate
       else
       if ATypeInfo = TypeInfo(TDateTime) then
          Result := ftDateTime
       else
       if ATypeInfo = TypeInfo(Currency) then
          Result := ftCurrency
       else
       if ATypeInfo = TypeInfo(TTime) then
          Result := ftTime
       else
          Result := ftFloat;
     end;
     tkString, tkLString, tkChar:
        Result := ftString;
     tkUString:
       Result := ftWideString;
     {$IFDEF DELPHI15_UP}
     tkWideChar, tkWideString:
       Result := ftWideString;
     {$ENDIF DELPHI15_UP}
     tkVariant, tkArray, tkDynArray:
        Result := ftVariant;
     tkClass:
     begin
       if ATypeInfo = TypeInfo(TStringStream) then
          Result := ftMemo
       else
          Result := ftBlob;
     end;
     tkRecord:
     begin
       if IsNullable(ATypeInfo) then
       begin
          TryGetUnderlyingTypeInfo(ATypeInfo, oTypeInfo);
          Result := GetFieldType(oTypeInfo);
       end
       else
       if IsBlob(ATypeInfo) then
         Result := ftBlob
     end;
     tkInt64:
       Result := ftLargeint;
   end;
   /// tkShortString, tkAnsiString, tkUnicodeString, tkWString, tkAnsiChar, tkWChar:
end;

function TRttiSingleton.TryGetUnderlyingTypeInfo(ATypeInfo: PTypeInfo; out AUnderlyingTypeInfo: PTypeInfo): Boolean;
var
  Context: TRttiContext;
  ARttiType: TRttiType;
  ValueField: TRttiField;
begin
  Result := IsNullable(ATypeInfo);
  if Result then
  begin
    ARttiType := Context.GetType(ATypeInfo);
    ValueField := ARttiType.GetField('FValue');
    Result := Assigned(ValueField);
    if Result then
       AUnderlyingTypeInfo := ValueField.FieldType.Handle
    else
       AUnderlyingTypeInfo := nil;
  end;
end;

class function TRttiSingleton.GetInstance: IRttiSingleton;
begin
  if not Assigned(FInstance) then
    FInstance := TRttiSingleton.CreatePrivate;
   Result := FInstance;
end;

function TRttiSingleton.GetListType(ARttiType: TRttiType): TRttiType;
var
  sTypeName: string;
  oContext: TRttiContext;
begin
   oContext := TRttiContext.Create;
   try
     sTypeName := ARttiType.ToString;
     sTypeName := StringReplace(sTypeName,'TObjectList<','',[]);
     sTypeName := StringReplace(sTypeName,'TList<','',[]);
     sTypeName := StringReplace(sTypeName,'>','',[]);
     ///
     Result := oContext.FindType(sTypeName);
   finally
     oContext.Free;
   end;
end;

function TRttiSingleton.RunValidade(AClass: TClass): Boolean;
var
  oColumn: TColumnMapping;
  oColumns: TColumnMappingList;
  oAttribute: TCustomAttribute;
begin
  Result := False;
  oColumns := TMappingExplorer.GetInstance.GetMappingColumn(AClass);
  for oColumn in oColumns do
  begin
     /// <summary>
     /// Valida se o valor é NULO
     /// </summary>
     oAttribute := oColumn.PropertyRtti.GetNotNullConstraint;
     if oAttribute <> nil then
       NotNullConstraint(oAttribute).Validate(oColumn.ColumnName, oColumn.PropertyRtti.GetNullableValue(AClass));

     /// <summary>
     /// Valida se o valor é menor que ZERO
     /// </summary>
     oAttribute := oColumn.PropertyRtti.GetZeroConstraint;
     if oAttribute <> nil then
        ZeroConstraint(oAttribute).Validate(oColumn.ColumnName, oColumn.PropertyRtti.GetNullableValue(AClass));
  end;
  Result := True;
end;

function TRttiSingleton.MethodCall(AObject: TObject; AMethodName: string;
  const AParameters: array of TValue): TValue;
var
  oRttiType: TRttiType;
  oMethod: TRttiMethod;
begin
  oRttiType := GetRttiType(AObject.ClassType);
  oMethod   := oRttiType.GetMethod(AMethodName);
  if Assigned(oMethod) then
     Result := oMethod.Invoke(AObject, AParameters)
  else
     raise Exception.CreateFmt('Cannot find method "%s" in the object',[AMethodName]);
end;

function TRttiSingleton.IsNullable(ATypeInfo: PTypeInfo): Boolean;
const
  PrefixString = 'Nullable<';
begin
  Result := Assigned(ATypeInfo) and (ATypeInfo.Kind = tkRecord) and StartsText(PrefixString, GetTypeName(ATypeInfo));
end;

function TRttiSingleton.IsNullValue(AObject: TObject; AProperty: TRttiProperty): Boolean;
begin
  Result := False;
  if AProperty.PropertyType.TypeKind in [tkUnknown,tkEnumeration,tkClass,tkArray,tkDynArray,tkMethod,
                                         tkPointer,tkSet,tkClassRef,tkProcedure,tkInterface] then
     Exit(True);

  if AProperty.PropertyType.TypeKind in [tkString, tkUString] then
    if UpperCase(AProperty.GetNullableValue(AObject).ToString) = 'NULL' then
       Exit(True);

  if AProperty.PropertyType.TypeKind in [tkString, tkUString] then
    if Length(AProperty.GetNullableValue(AObject).ToString) = 0 then
      if AProperty.IsNotNull = False then
        Exit(True);

  if AProperty.PropertyType.TypeKind in [tkFloat] then
    if AProperty.PropertyType.Handle = TypeInfo(TDateTime) then
       if AProperty.GetNullableValue(AObject).AsExtended = 0 then
         Exit(True);

  if AProperty.PropertyType.TypeKind in [tkFloat] then
    if AProperty.PropertyType.Handle = TypeInfo(TTime) then
       if AProperty.GetNullableValue(AObject).AsExtended = 0 then
         Exit(True);

  if AProperty.PropertyType.TypeKind in [tkRecord] then
    if AProperty.PropertyType.Handle = TypeInfo(TBlob) then
      if AProperty.GetNullableValue(AObject).AsType<TBlob>.ToSize = 0 then
        Exit(True);
end;

function TRttiSingleton.IsBlob(ATypeInfo: PTypeInfo): Boolean;
begin
  Result := Assigned(ATypeInfo) and (ATypeInfo.Kind = tkRecord) and (ATypeInfo = TypeInfo(TBlob));
end;

function TRttiSingleton.IsLazy(ARttiType: TRttiType): boolean;
begin
  Result := (ARttiType is TRttiRecordType) and (Pos('Lazy', ARttiType.Name) > 0);
end;

end.


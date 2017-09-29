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

unit ormbr.rtti.helper;

interface

uses
  Rtti,
  SysUtils,
  TypInfo,
  ormbr.mapping.rttiutils,
  ormbr.types.nullable,
  ormbr.mapping.attributes,
  ormbr.types.mapping,
  ormbr.mapping.classes;

type
  TRttiTypeHelper = class helper for TRttiType
  public
    function GetPrimaryKey: TArray<TCustomAttribute>;
  end;

  TRttiPropertyHelper = class helper for TRttiProperty
  public
    function  IsNoUpdate: Boolean;
    function  IsNoInsert: Boolean;
    function  IsNotNull: Boolean;
    function  IsJoinColumn: Boolean;
    function  IsCheck: Boolean;
    function  IsUnique: Boolean;
    function  IsHidden: Boolean;
    function  IsRequired: Boolean;
    function  IsPrimaryKey(AClass: TClass): Boolean;
    function  GetAssociation: TCustomAttribute;
    function  GetRestriction: TCustomAttribute;
    function  GetDictionary: TCustomAttribute;
    function  GetColumn: TCustomAttribute;
    function  GetNotNullConstraint: TCustomAttribute;
    function  GetZeroConstraint: TCustomAttribute;
    function  GetNullableValue(AInstance: Pointer): TValue;
    function  GetIndex: Integer;
    procedure SetNullableValue(AInstance: Pointer; ATypeInfo: PTypeInfo; AValue: Variant);
  end;

implementation

uses
  ormbr.mapping.explorer;

{ TRttiPropertyHelper }

function TRttiPropertyHelper.GetAssociation: TCustomAttribute;
var
  oAttribute: TCustomAttribute;
begin
   for oAttribute in Self.GetAttributes do
   begin
      if oAttribute is Association then // Association
         Exit(oAttribute);
   end;
   Exit(nil);
end;

function TRttiPropertyHelper.GetColumn: TCustomAttribute;
var
  oAttribute: TCustomAttribute;
begin
   for oAttribute in Self.GetAttributes do
   begin
      if oAttribute is Column then // Column
         Exit(oAttribute);
   end;
   Exit(nil);
end;

function TRttiPropertyHelper.GetDictionary: TCustomAttribute;
var
  oAttribute: TCustomAttribute;
begin
   for oAttribute in Self.GetAttributes do
   begin
      if oAttribute is Dictionary then // Dictionary
         Exit(oAttribute);
   end;
   Exit(nil);
end;

function TRttiPropertyHelper.GetIndex: Integer;
begin
  Result := (Self as TRttiInstanceProperty).Index +1;
end;

function TRttiPropertyHelper.GetNotNullConstraint: TCustomAttribute;
var
  oAttribute: TCustomAttribute;
begin
   for oAttribute in Self.GetAttributes do
   begin
      if oAttribute is NotNullConstraint then // NotNullConstraint
         Exit(oAttribute);
   end;
   Exit(nil);
end;

function TRttiPropertyHelper.GetNullableValue(AInstance: Pointer): TValue;
var
  oValue: TValue;
  oValueField: TRttiField;
  oHasValueField: TRttiField;
begin
  if TRttiSingleton.GetInstance.IsNullable(Self.PropertyType.Handle) then
  begin
     oValue := Self.GetValue(AInstance);
     oHasValueField := Self.PropertyType.GetField('FHasValue');
     if Assigned(oHasValueField) then
     begin
       oValueField := Self.PropertyType.GetField('FValue');
       if Assigned(oValueField) then
          Result := oValueField.GetValue(oValue.GetReferenceToRawData);
     end
  end
  else
     Result := Self.GetValue(AInstance);
end;

function TRttiPropertyHelper.GetRestriction: TCustomAttribute;
var
  oAttribute: TCustomAttribute;
begin
   for oAttribute in Self.GetAttributes do
   begin
      if oAttribute is Restrictions then // Restrictions
         Exit(oAttribute);
   end;
   Exit(nil);
end;

function TRttiPropertyHelper.GetZeroConstraint: TCustomAttribute;
var
  oAttribute: TCustomAttribute;
begin
   for oAttribute in Self.GetAttributes do
   begin
      if oAttribute is ZeroConstraint then // ZeroConstraint
         Exit(oAttribute);
   end;
   Exit(nil);
end;

function TRttiPropertyHelper.IsCheck: Boolean;
var
  oAttribute: TCustomAttribute;
begin
   for oAttribute in Self.GetAttributes do
   begin
      if oAttribute is Check then // Check
         Exit(True);
   end;
   Exit(False);
end;

function TRttiPropertyHelper.IsHidden: Boolean;
var
  oAttribute: TCustomAttribute;
begin
   oAttribute := Self.GetRestriction;
   if oAttribute <> nil then
   begin
     if Hidden in Restrictions(oAttribute).Restrictions then
       Exit(True);
   end;
   Exit(False);
end;

function TRttiPropertyHelper.IsNoInsert: Boolean;
var
  oAttribute: TCustomAttribute;
begin
   oAttribute := Self.GetRestriction;
   if oAttribute <> nil then
   begin
     if NoInsert in Restrictions(oAttribute).Restrictions then
       Exit(True);
   end;
   Exit(False);
end;

function TRttiPropertyHelper.IsJoinColumn: Boolean;
var
  oAttribute: TCustomAttribute;
begin
   for oAttribute in Self.GetAttributes do
   begin
      if oAttribute is JoinColumn then // JoinColumn
         Exit(True);
   end;
   Exit(False);
end;

function TRttiPropertyHelper.IsNotNull: Boolean;
var
  oAttribute: TCustomAttribute;
begin
   oAttribute := Self.GetRestriction;
   if oAttribute <> nil then
   begin
     if NotNull in Restrictions(oAttribute).Restrictions then
       Exit(True);
   end;
   Exit(False);
end;

function TRttiPropertyHelper.IsNoUpdate: Boolean;
var
  oAttribute: TCustomAttribute;
begin
  oAttribute := Self.GetRestriction;
  if oAttribute <> nil then
  begin
    if NoUpdate in Restrictions(oAttribute).Restrictions then
      Exit(True);
  end;
  Exit(False);
end;

function TRttiPropertyHelper.IsPrimaryKey(AClass: TClass): Boolean;
var
  oPrimaryKey: TPrimaryKeyMapping;
  sColumnName: string;
begin
  oPrimaryKey := TMappingExplorer.GetInstance.GetMappingPrimaryKey(AClass);
  if oPrimaryKey <> nil then
  begin
    for sColumnName in oPrimaryKey.Columns do
      if SameText(sColumnName, Self.Name) then
        Exit(True);
  end;
  Exit(False);
end;

function TRttiPropertyHelper.IsRequired: Boolean;
var
  oAttribute: TCustomAttribute;
begin
  oAttribute := Self.GetRestriction;
  if oAttribute <> nil then
  begin
    if Required in Restrictions(oAttribute).Restrictions then
      Exit(True);
  end;
  Exit(False);
end;

function TRttiPropertyHelper.IsUnique: Boolean;
var
  oAttribute: TCustomAttribute;
begin
   oAttribute := Self.GetRestriction;
   if oAttribute <> nil then
   begin
     if Unique in Restrictions(oAttribute).Restrictions then
       Exit(True);
   end;
   Exit(False);
end;

procedure TRttiPropertyHelper.SetNullableValue(AInstance: Pointer;
  ATypeInfo: PTypeInfo; AValue: Variant);
begin
   if ATypeInfo = TypeInfo(Nullable<Integer>) then
      Self.SetValue(AInstance, TValue.From(Nullable<Integer>.Create(AValue)))
   else
   if ATypeInfo = TypeInfo(Nullable<String>) then
      Self.SetValue(AInstance, TValue.From(Nullable<String>.Create(AValue)))
   else
   if ATypeInfo = TypeInfo(Nullable<TDateTime>) then
      Self.SetValue(AInstance, TValue.From(Nullable<TDateTime>.Create(AValue)))
   else
   if ATypeInfo = TypeInfo(Nullable<Currency>) then
      Self.SetValue(AInstance, TValue.From(Nullable<Currency>.Create(AValue)))
   else
   if ATypeInfo = TypeInfo(Nullable<Double>) then
      Self.SetValue(AInstance, TValue.From(Nullable<Double>.Create(AValue)))
   else
   if ATypeInfo = TypeInfo(Nullable<Boolean>) then
      Self.SetValue(AInstance, TValue.From(Nullable<Boolean>.Create(AValue)))
   else
   if ATypeInfo = TypeInfo(Nullable<TDate>) then
      Self.SetValue(AInstance, TValue.From(Nullable<TDate>.Create(AValue)))
end;

{ TRttiTypeHelper }

//function TRttiTypeHelper.GetAssociation: TArray<TCustomAttribute>;
//var
//  oProperty: TRttiProperty;
//  oAttrib: TCustomAttribute;
//  iLength: Integer;
//begin
//   iLength := -1;
//   for oProperty in Self.GetProperties do
//   begin
//      for oAttrib in oProperty.GetAttributes do
//      begin
//         if oAttrib is Association then // Association
//         begin
//           Inc(iLength);
//           SetLength(Result, iLength+1);
//           Result[iLength] := oAttrib;
//         end;
//      end;
//   end;
//end;

function TRttiTypeHelper.GetPrimaryKey: TArray<TCustomAttribute>;
var
  oAttrib: TCustomAttribute;
  iLength: Integer;
begin
  iLength := -1;
  for oAttrib in Self.GetAttributes do
  begin
     if oAttrib is PrimaryKey then // PrimaryKey
     begin
       Inc(iLength);
       SetLength(Result, iLength+1);
       Result[iLength] := oAttrib;
     end;
  end;
end;

end.

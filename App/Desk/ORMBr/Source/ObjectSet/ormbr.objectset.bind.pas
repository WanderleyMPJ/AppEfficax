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

unit ormbr.objectset.bind;

interface

uses
  Classes,
  SysUtils,
  Rtti,
  DB,
  TypInfo,
  Variants,
  StrUtils,
  /// orm
  ormbr.mapping.rttiutils,
  ormbr.factory.interfaces,
  ormbr.mapping.classes,
  ormbr.rtti.helper,
  ormbr.objects.helper,
  ormbr.mapping.attributes,
  ormbr.types.mapping;

type
  IBindObject = interface
    ['{5B46A5E9-FE26-4FB0-A6EF-758D00BC0600}']
    procedure SetFieldToProperty(AResultSet: IDBResultSet; AObject: TObject); overload;
    procedure SetFieldToProperty(AResultSet: IDBResultSet; AObject: TObject; AAssociation: TAssociationMapping); overload;
  end;

  TBindObject = class(TInterfacedObject, IBindObject)
  private
  class var
    FInstance: IBindObject;
    FContext: TRttiContext;
    procedure SetPropertyValue(AResultSet: IDBResultSet; AObject: TObject; AColumn: TColumnMapping);
  private
    constructor CreatePrivate;
  public
    { Public declarations }
    constructor Create;
    class function GetInstance: IBindObject;
    procedure SetFieldToProperty(AResultSet: IDBResultSet; AObject: TObject); overload;
    procedure SetFieldToProperty(AResultSet: IDBResultSet; AObject: TObject; AAssociation: TAssociationMapping); overload;
  end;

implementation

uses
  ormbr.mapping.explorer,
  ormbr.types.blob;

{ TBindObject }

constructor TBindObject.Create;
begin
   raise Exception.Create('Para usar o MappingEntity use o método TBindObject.GetInstance()');
end;

constructor TBindObject.CreatePrivate;
begin
   inherited;
   FContext := TRttiContext.Create;
end;

class function TBindObject.GetInstance: IBindObject;
begin
   if not Assigned(FInstance) then
      FInstance := TBindObject.CreatePrivate;

   Result := FInstance;
end;

procedure TBindObject.SetFieldToProperty(AResultSet: IDBResultSet;
  AObject: TObject; AAssociation: TAssociationMapping);
var
  LColumn: TColumnMapping;
  LColumns: TColumnMappingList;
begin
  LColumns := TMappingExplorer.GetInstance.GetMappingColumn(AObject.ClassType);
  for LColumn in LColumns do
  begin
    if AAssociation.Multiplicity in [OneToOne, ManyToOne] then
    begin
      if AAssociation.ColumnsSelectRef.Count > 0 then
      begin
        if AAssociation.ColumnsSelectRef.IndexOf(LColumn.ColumnName) > -1 then
          SetPropertyValue(AResultSet, AObject, LColumn);
      end
      else
        SetPropertyValue(AResultSet, AObject, LColumn);
    end
    else
    if AAssociation.Multiplicity in [OneToMany, ManyToMany] then
      SetPropertyValue(AResultSet, AObject, LColumn);
  end;
end;

procedure TBindObject.SetPropertyValue(AResultSet: IDBResultSet;
  AObject: TObject; AColumn: TColumnMapping);
var
  LValue: Variant;
  LBlobField: TBlob;
begin
  LValue := AResultSet.GetFieldValue(AColumn.ColumnName);
  case AColumn.PropertyRtti.PropertyType.TypeKind of
    tkString, tkWString, tkUString, tkWChar, tkLString, tkChar:
      if TVarData(LValue).VType <= varNull then
        AColumn.PropertyRtti.SetValue(AObject, String(''))
      else
        AColumn.PropertyRtti.SetValue(AObject, String(LValue));
    tkInteger, tkEnumeration, tkSet, tkInt64:
      if TVarData(LValue).VType <= varNull then
        AColumn.PropertyRtti.SetValue(AObject, Integer(0))
      else
        AColumn.PropertyRtti.SetValue(AObject, Integer(LValue));
    tkFloat:
      begin
        if TVarData(LValue).VType <= varNull then
          AColumn.PropertyRtti.SetValue(AObject, Integer(0))
        else
        if AColumn.PropertyRtti.PropertyType.Handle = TypeInfo(TDateTime) then
          AColumn.PropertyRtti.SetValue(AObject, TDateTime(LValue))
        else
        if AColumn.PropertyRtti.PropertyType.Handle = TypeInfo(TTime) then
          AColumn.PropertyRtti.SetValue(AObject, TDateTime(LValue))
        else
          AColumn.PropertyRtti.SetValue(AObject, Currency(LValue))
      end;
    tkRecord:
      begin
        if TRttiSingleton.GetInstance.IsBlob(AColumn.PropertyRtti.PropertyType.Handle) then
        begin
          if (not VarIsEmpty(LValue)) and (not VarIsNull(LValue)) then
          begin
            LBlobField := AColumn.PropertyRtti.GetValue(AObject).AsType<TBlob>;
            LBlobField.SetBytes(LValue);
            AColumn.PropertyRtti.SetValue(AObject, TValue.From<TBlob>(LBlobField));
          end;
        end
        else
          AColumn.PropertyRtti.SetNullableValue(AObject,
                                                AColumn.PropertyRtti.PropertyType.Handle,
                                                LValue);
      end;
  end;
end;

procedure TBindObject.SetFieldToProperty(AResultSet: IDBResultSet; AObject: TObject);
var
  LColumn: TColumnMapping;
  LColumns: TColumnMappingList;
begin
  LColumns := TMappingExplorer.GetInstance.GetMappingColumn(AObject.ClassType);
  for LColumn in LColumns do
    SetPropertyValue(AResultSet, AObject, LColumn);
end;

end.

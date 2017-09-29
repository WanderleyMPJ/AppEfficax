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

unit ormbr.command.updater;

interface

uses
  DB,
  Rtti,
  Classes,
  Generics.Collections,
  ormbr.rtti.helper,
  ormbr.mapping.attributes,
  ormbr.command.abstract,
  ormbr.factory.interfaces,
  ormbr.types.database,
  ormbr.types.blob;

type
  TCommandUpdater = class(TDMLCommandAbstract)
  public
    constructor Create(AConnection: IDBConnection; ADriverName: TDriverName; AObject: TObject); override;
    function GenerateUpdate(AObject: TObject; AModifiedFields: TList<string>): string;
  end;

implementation

uses
  ormbr.objects.helper,
  ormbr.mapping.rttiutils;

{ TCommandUpdater }

constructor TCommandUpdater.Create(AConnection: IDBConnection; ADriverName: TDriverName; AObject: TObject);
var
  oProperty: TRttiProperty;
begin
  inherited Create(AConnection, ADriverName, AObject);
  for oProperty in AObject.GetPrimaryKey do
  begin
    with FParams.Add as TParam do
    begin
      Name := oProperty.Name;
      DataType := TRttiSingleton.GetInstance.GetFieldType(oProperty.PropertyType.Handle);
    end;
  end;
end;

function TCommandUpdater.GenerateUpdate(AObject: TObject; AModifiedFields: TList<string>): string;
var
  LFor: Integer;
  LRttiType: TRttiType;
  LProperty: TRttiProperty;
  LParams: TParams;
  LColumnAtt: TCustomAttribute;
  LColumnName: string;
begin
  /// <summary>
  /// Variavel local é usado como parâmetro para montar o script só com os
  /// campos PrimaryKey.
  /// </summary>
  LParams := TParams.Create(nil);
  try
    for LProperty in AObject.GetPrimaryKey do
    begin
      with LParams.Add as TParam do
      begin
        Name := LProperty.Name;
        DataType := TRttiSingleton.GetInstance.GetFieldType(LProperty.PropertyType.Handle);
        Value := LProperty.GetNullableValue(AObject).AsVariant;
      end;
    end;
    FCommand := FGeneratorCommand.GeneratorUpdate(AObject, LParams, AModifiedFields);
    Result := FCommand;
    /// <summary>
    /// Gera todos os parâmetros, sendo os campos alterados primeiro e o do
    /// PrimaryKey por último, usando LParams criado local.
    /// </summary>
    LRttiType := TRttiSingleton.GetInstance.GetRttiType(AObject.ClassType);
    for LProperty in LRttiType.GetProperties do
    begin
      if LProperty.IsNoUpdate then
        Continue;
      LColumnAtt := LProperty.GetColumn;
      if LColumnAtt <> nil then
      begin
        LColumnName := Column(LColumnAtt).ColumnName;
        if AModifiedFields.IndexOf(LColumnName) > -1 then
        begin
          with LParams.Add as TParam do
          begin
            Name := LColumnName;
            DataType := TRttiSingleton.GetInstance.GetFieldType(LProperty.PropertyType.Handle);
            if DataType <> ftBlob then
              Value := LProperty.GetNullableValue(AObject).AsVariant
            else
              Value := LProperty.GetNullableValue(AObject).AsType<TBlob>.ToBytes;
          end;
        end;
      end;
    end;
    FParams.Clear;
    for LFor := 0 to LParams.Count -1 do
    begin
      with FParams.Add as TParam do
      begin
        Name := LParams.Items[LFor].Name;
        DataType := LParams.Items[LFor].DataType;
        Value := LParams.Items[LFor].Value;
      end;
    end;
  finally
    LParams.Free;
  end;
end;

end.

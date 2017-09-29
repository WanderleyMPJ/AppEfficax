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

unit ormbr.command.deleter;

interface

uses
  DB,
  Rtti,
  ormbr.command.abstract,
  ormbr.factory.interfaces,
  ormbr.rtti.helper,
  ormbr.types.database;

type
  TCommandDeleter = class(TDMLCommandAbstract)
  public
    constructor Create(AConnection: IDBConnection; ADriverName: TDriverName; AObject: TObject); override;
    function GenerateDelete(AObject: TObject): string;
  end;

implementation

uses
  ormbr.objects.helper,
  ormbr.mapping.rttiutils;

{ TCommandDeleter }

constructor TCommandDeleter.Create(AConnection: IDBConnection; ADriverName: TDriverName;
  AObject: TObject);
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

function TCommandDeleter.GenerateDelete(AObject: TObject): string;
var
  oProperty: TRttiProperty;
begin
  FCommand := FGeneratorCommand.GeneratorDelete(AObject, FParams);
  Result := FCommand;

  for oProperty in AObject.GetPrimaryKey do
    FParams.ParamByName(oProperty.Name).Value := oProperty.GetNullableValue(AObject).AsVariant;
end;

end.

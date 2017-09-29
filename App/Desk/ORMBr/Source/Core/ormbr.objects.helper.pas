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

unit ormbr.objects.helper;

interface

uses
  Rtti,
  ormbr.mapping.attributes;

type
  TObjectHelper = class helper for TObject
  private
  public
    function &GetType(out AType: TRttiType): Boolean;
    function GetTable: Table;
    function GetSequence: Sequence;
    function GetPrimaryKey: TArray<TRttiProperty>; overload;
    function GetColumns: TArray<TRttiProperty>;
  end;

implementation

var
  Context: TRttiContext;

{ TObjectHelper }

function TObjectHelper.GetColumns: TArray<TRttiProperty>;
var
  oType: TRttiType;
  oProperty: TRttiProperty;
  oAttribute: TCustomAttribute;
  iLength: Integer;
begin
   iLength := -1;
   if &GetType(oType) then
   begin
      for oProperty in oType.GetProperties do
      begin
         for oAttribute in oProperty.GetAttributes do
         begin
            if (oAttribute is Column) then // Column
            begin
              Inc(iLength);
              SetLength(Result, iLength +1);
              Result[iLength] := oProperty;
            end;
         end;
      end;
   end;
end;

function TObjectHelper.GetPrimaryKey: TArray<TRttiProperty>;
var
  oType: TRttiType;
  oAttribute: TCustomAttribute;
  iCols: Integer;
begin
  if &GetType(oType) then
  begin
    for oAttribute in oType.GetAttributes do
    begin
      if oAttribute is PrimaryKey then // PrimaryKey
      begin
        SetLength(Result, Length(PrimaryKey(oAttribute).Columns));
        for iCols := Low(PrimaryKey(oAttribute).Columns) to High(PrimaryKey(oAttribute).Columns) do
          Result[iCols] := oType.GetProperty(PrimaryKey(oAttribute).Columns[iCols]);
      end;
    end;
  end
  else
    Exit(nil)
end;

function TObjectHelper.GetSequence: Sequence;
var
  oType: TRttiType;
  oAttribute: TCustomAttribute;
begin
  if &GetType(oType) then
  begin
    for oAttribute in oType.GetAttributes do
    begin
      if oAttribute is Sequence then // Sequence
        Exit(Sequence(oAttribute));
    end;
    Exit(nil);
  end
  else
    Exit(nil);
end;

function TObjectHelper.GetTable: Table;
var
  oType: TRttiType;
  oAttribute: TCustomAttribute;
begin
  if &GetType(oType) then
  begin
    for oAttribute in oType.GetAttributes do
    begin
      if oAttribute is Table then // Table
        Exit(Table(oAttribute));
    end;
    Exit(nil);
  end
  else
    Exit(nil);
end;

function TObjectHelper.&GetType(out AType: TRttiType): Boolean;
begin
  Result := False;
  if Assigned(Self) then
  begin
    AType  := Context.GetType(Self.ClassType);
    Result := Assigned(AType);
  end;
end;

end.

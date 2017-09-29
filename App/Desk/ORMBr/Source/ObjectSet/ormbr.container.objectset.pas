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

unit ormbr.container.objectset;

interface

uses
  Classes,
  SysUtils,
  Rtti,
  DB,
  TypInfo,
  Variants,
  StrUtils,
  Generics.Collections,
  /// orm
  ormbr.factory.interfaces,
  ormbr.session.manager,
  ormbr.container.objectset.interfaces;

type
  /// <summary>
  /// M - Object M
  /// </summary>
  TContainerObjectSet<M: class, constructor> = class(TInterfacedObject, IContainerObjectSet<M>)
  protected
    FSession: TSessionObjectSet<M>;
    FConnection: IDBConnection;
  public
    constructor Create(AConnection: IDBConnection; APageSize: Integer = -1); virtual;
    destructor Destroy; override;
    function ExistSequence: Boolean;
    function ModifiedFields: TList<string>;
    function Find: TObjectList<M>; overload;
    function Find(AID: TValue): M; overload;
    function Find(AWhere: string; AOrderBy: string = ''): TObjectList<M>; overload;
    function FindWhere(AWhere: string): TObjectList<M>; deprecated 'Use Find(where)';
    function FindOrderBy(AOrderBy: string): TObjectList<M>; deprecated 'Use Find('', orderby)';
    procedure Insert(AObject: M);
    procedure Update(AObject: M);
    procedure Delete(AObject: M);
    procedure NextPacket(AObjectList: TObjectList<M>);
    procedure Modify(AObject: M);
  end;

implementation

{ TContainerObjectSet<M> }

constructor TContainerObjectSet<M>.Create(AConnection: IDBConnection;
  APageSize: Integer);
begin
  FConnection := AConnection;
  FSession := TSessionObjectSet<M>.Create(AConnection, APageSize);
end;

procedure TContainerObjectSet<M>.Delete(AObject: M);
begin
  FSession.Delete(AObject);
end;

destructor TContainerObjectSet<M>.Destroy;
begin
  FSession.Free;
  inherited;
end;

function TContainerObjectSet<M>.ExistSequence: Boolean;
begin
  Result := FSession.ExistSequence;
end;

function TContainerObjectSet<M>.Find(AWhere, AOrderBy: string): TObjectList<M>;
begin
  Result := FSession.Find(AWhere, AOrderBy);
end;

function TContainerObjectSet<M>.Find(AID: TValue): M;
begin
  Result := FSession.Find(AID);
end;

function TContainerObjectSet<M>.Find: TObjectList<M>;
begin
  Result := FSession.Find;
end;

function TContainerObjectSet<M>.FindOrderBy(AOrderBy: string): TObjectList<M>;
begin
  Result := FSession.FindOrderBy(AOrderBy);
end;

function TContainerObjectSet<M>.FindWhere(AWhere: string): TObjectList<M>;
begin
  Result := FSession.FindWhere(AWhere);
end;

procedure TContainerObjectSet<M>.Insert(AObject: M);
begin
  FSession.Insert(AObject);
end;

function TContainerObjectSet<M>.ModifiedFields: TList<string>;
begin
  Result := FSession.ModifiedFields;
end;

procedure TContainerObjectSet<M>.Modify(AObject: M);
begin
  FSession.Modify(AObject);
end;

procedure TContainerObjectSet<M>.NextPacket(AObjectList: TObjectList<M>);
begin
  FSession.NextPacket(AObjectList);
end;

procedure TContainerObjectSet<M>.Update(AObject: M);
begin
  FSession.Update(AObject);
end;

end.

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

unit ormbr.session.manager;

interface

uses
  Classes,
  Generics.Collections,
  SysUtils,
  Windows,
  DB,
  Rtti,
  /// orm
  ormbr.criteria,
  ormbr.objects.manager,
  ormbr.types.mapping,
  ormbr.mapping.explorerstrategy,
  ormbr.factory.interfaces;

type
  /// <summary>
  /// M - Sessão Abstract
  /// </summary>
  TSessionAbstract<M: class, constructor> = class abstract
  private
    /// <summary>
    /// Instancia a class do tipo generics recebida
    /// </summary>
    FManager: TObjectManager<M>;
    /// <summary>
    /// Se não usar DataSet, preenche a lista de objetos que é usada como cache em memória.
    /// </summary>
    function GetManager: TObjectManager<M>;
  protected
    property Manager: TObjectManager<M> read GetManager;
  public
    constructor Create(AConnection: IDBConnection; APageSize: Integer = -1); virtual;
    destructor Destroy; override;
    procedure Insert(AObject: M);
    procedure Update(AObject: M);
    procedure Delete(AObject: M);
    function ExistSequence: Boolean;
    function ModifiedFields: TList<string>;
    /// ObjectSet
    function Find: TObjectList<M>; overload;
    function Find(AID: TValue): M; overload;
    function Find(AWhere: string; AOrderBy: string = ''): TObjectList<M>; overload;
    function FindWhere(AWhere: string): TObjectList<M>; deprecated 'Use Find(where)';
    function FindOrderBy(AOrderBy: string): TObjectList<M>; deprecated 'Use Find('', orderby)';
    procedure NextPacket(AObjectList: TObjectList<M>);
    procedure Modify(AObject: M);
  end;

  /// <summary>
  /// M - Sessão Objeto
  /// </summary>
  TSessionObjectSet<M: class, constructor> = class(TSessionAbstract<M>)
  public
  end;

  /// <summary>
  /// M - Sessão DataSet
  /// </summary>
  TSessionDataSet<M: class, constructor> = class(TSessionAbstract<M>)
  private
    FDeleteList: TObjectList<M>;
  public
    constructor Create(AConnection: IDBConnection; APageSize: Integer = -1); override;
    destructor Destroy; override;
    function Open: IDBResultSet; overload;
    function Open(AID: TValue): IDBResultSet; overload;
    function Open(ASQL: string): IDBResultSet; overload;
    function OpenWhere(AWhere: string; AOrderBy: string = ''): string;
    function NextPacket: IDBResultSet;
    function FetchingRecords: Boolean;
    function Explorer: IMappingExplorerStrategy;
    property DeleteList: TObjectList<M> read FDeleteList; // write FDeleteList;
  end;

implementation

uses
  ormbr.objects.helper;

{ TSessionAbstract<M> }

constructor TSessionAbstract<M>.Create(AConnection: IDBConnection; APageSize: Integer);
begin
  FManager := TObjectManager<M>.Create(Self, AConnection, APageSize);
end;

procedure TSessionAbstract<M>.Insert(AObject: M);
begin
  FManager.InsertInternal(AObject);
end;

function TSessionAbstract<M>.ModifiedFields: TList<string>;
begin
  Result := FManager.ModifiedFields;
end;

procedure TSessionAbstract<M>.Delete(AObject: M);
begin
  FManager.DeleteInternal(AObject);
end;

destructor TSessionAbstract<M>.Destroy;
begin
  FManager.Free;
  inherited;
end;

function TSessionAbstract<M>.ExistSequence: Boolean;
begin
  Result := FManager.ExistSequence;
end;

function TSessionAbstract<M>.GetManager: TObjectManager<M>;
begin
  Result := FManager;
end;

procedure TSessionAbstract<M>.Update(AObject: M);
begin
  FManager.UpdateInternal(AObject);
end;

function TSessionAbstract<M>.Find: TObjectList<M>;
begin
  Result := FManager.Find;
end;

function TSessionAbstract<M>.Find(AID: TValue): M;
begin
  Result := FManager.Find(AID);
end;

function TSessionAbstract<M>.Find(AWhere: string; AOrderBy: string): TObjectList<M>;
begin
  Result := FManager.FindWhere(AWhere, AOrderBy);
end;

function TSessionAbstract<M>.FindWhere(AWhere: string): TObjectList<M>;
begin
  Result := Find(AWhere);
end;

procedure TSessionAbstract<M>.NextPacket(AObjectList: TObjectList<M>);
begin
  if not FManager.FetchingRecords then
    FManager.NextPacketList(AObjectList);
end;

function TSessionAbstract<M>.FindOrderBy(AOrderBy: string): TObjectList<M>;
begin
  Result := FManager.FindWhere('', AOrderBy);
end;

procedure TSessionAbstract<M>.Modify(AObject: M);
begin
  FManager.ModifyInternal(AObject);
end;

{ TSessionDataSet<M> }

function TSessionDataSet<M>.Open(AID: TValue): IDBResultSet;
begin
  FManager.FetchingRecords := False;
  Result := FManager.SelectInternalID(AID);
end;

function TSessionDataSet<M>.Open(ASQL: string): IDBResultSet;
begin
  FManager.FetchingRecords := False;
  if ASQL = '' then
    Result := FManager.SelectInternalAll
  else
    Result := FManager.SelectInternal(ASQL);
end;

function TSessionDataSet<M>.OpenWhere(AWhere: string; AOrderBy: string): string;
begin
  Result := FManager.SelectInternalWhere(AWhere, AOrderBy);
end;

function TSessionDataSet<M>.Open: IDBResultSet;
begin
  FManager.FetchingRecords := False;
  Result := FManager.SelectInternalAll;
end;

constructor TSessionDataSet<M>.Create(AConnection: IDBConnection; APageSize: Integer);
begin
  inherited Create(AConnection, APageSize);
  FDeleteList := TObjectList<M>.Create;
end;

destructor TSessionDataSet<M>.Destroy;
begin
  FDeleteList.Free;
  inherited;
end;

function TSessionDataSet<M>.FetchingRecords: Boolean;
begin
  Result := FManager.FetchingRecords;
end;

function TSessionDataSet<M>.Explorer: IMappingExplorerStrategy;
begin
  Result := FManager.Explorer;
end;

function TSessionDataSet<M>.NextPacket: IDBResultSet;
begin
  if not FManager.FetchingRecords then
    Result := FManager.NextPacket;
end;

end.

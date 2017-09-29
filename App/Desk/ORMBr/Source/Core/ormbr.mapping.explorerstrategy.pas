{
      ORM Brasil � um ORM simples e descomplicado para quem utiliza Delphi

                   Copyright (c) 2016, Isaque Pinheiro
                          All rights reserved.

                    GNU Lesser General Public License
                      Vers�o 3, 29 de junho de 2007

       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos � permitido copiar e distribuir c�pias deste documento de
       licen�a, mas mud�-lo n�o � permitido.

       Esta vers�o da GNU Lesser General Public License incorpora
       os termos e condi��es da vers�o 3 da GNU General Public License
       Licen�a, complementado pelas permiss�es adicionais listadas no
       arquivo LICENSE na pasta principal.
}

{ @abstract(ORMBr Framework.)
  @created(20 Jul 2016)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @author(Skype : ispinheiro)

  ORM Brasil � um ORM simples e descomplicado para quem utiliza Delphi.
}

unit ormbr.mapping.explorerstrategy;

interface

uses
  ormbr.mapping.classes,
  ormbr.mapping.repository;

type
  IMappingExplorerStrategy = interface
    ['{78E9D06E-57C6-4839-96DF-D39268245D24}']
    function GetRepositoryMapping: TMappingRepository;
    function GetMappingTable(AClass: TClass): TTableMapping;
    function GetMappingOrderBy(AClass: TClass): TOrderByMapping;
    function GetMappingPrimaryKey(AClass: TClass): TPrimaryKeyMapping;
    function GetMappingForeignKey(AClass: TClass): TForeignKeyMappingList;
    function GetMappingColumn(AClass: TClass): TColumnMappingList;
    function GetMappingAssociation(AClass: TClass): TAssociationMappingList;
    function GetMappingJoinColumn(AClass: TClass): TJoinColumnMappingList;
    function GetMappingIndexe(AClass: TClass): TIndexeMappingList;
    function GetMappingCheck(AClass: TClass): TCheckMappingList;
    function GetMappingSequence(AClass: TClass): TSequenceMapping;
    function GetMappingTrigger(AClass: TClass): TTriggerMappingList;
    function GetMappingView(AClass: TClass): TViewMapping;
    function GetColumnByName(AClass: TClass; AColumnName: string): TColumnMapping;
    property Repository: TMappingRepository read GetRepositoryMapping;
  end;

  TMappingExplorerStrategy = class abstract(TInterfacedObject, IMappingExplorerStrategy)
  strict protected
    function GetRepositoryMapping: TMappingRepository; virtual; abstract;
  public
    function GetMappingTable(AClass: TClass): TTableMapping; virtual; abstract;
    function GetMappingOrderBy(AClass: TClass): TOrderByMapping; virtual; abstract;
    function GetMappingPrimaryKey(AClass: TClass): TPrimaryKeyMapping; virtual; abstract;
    function GetMappingForeignKey(AClass: TClass): TForeignKeyMappingList; virtual; abstract;
    function GetMappingColumn(AClass: TClass): TColumnMappingList; virtual; abstract;
    function GetMappingAssociation(AClass: TClass): TAssociationMappingList; virtual; abstract;
    function GetMappingJoinColumn(AClass: TClass): TJoinColumnMappingList; virtual; abstract;
    function GetMappingIndexe(AClass: TClass): TIndexeMappingList; virtual; abstract;
    function GetMappingCheck(AClass: TClass): TCheckMappingList; virtual; abstract;
    function GetMappingSequence(AClass: TClass): TSequenceMapping; virtual; abstract;
    function GetMappingTrigger(AClass: TClass): TTriggerMappingList; virtual; abstract;
    function GetMappingView(AClass: TClass): TViewMapping; virtual; abstract;
    function GetColumnByName(AClass: TClass; AColumnName: string): TColumnMapping; virtual; abstract;
    property Repository: TMappingRepository read GetRepositoryMapping;
  end;

implementation

end.

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

unit ormbr.container.objectset.interfaces;

interface

uses
  Rtti,
  Generics.Collections;

type
  IContainerObjectSet<M: class, constructor> = interface
    ['{427CBF16-5FD5-4144-9699-09B08335D545}']
    function ExistSequence: Boolean;
    function ModifiedFields: TList<string>;
    function Find: TObjectList<M>; overload;
    function Find(AID: TValue): M; overload;
    function Find(AWhere: string; AOrderBy: string): TObjectList<M>; overload;
    function FindWhere(AWhere: string): TObjectList<M>; deprecated 'Use Find(where)';
    function FindOrderBy(AOrderBy: string): TObjectList<M>; deprecated 'Use Find('', orderby)';
    procedure Insert(AObject: M);
    procedure Update(AObject: M);
    procedure Delete(AObject: M);
    procedure NextPacket(AObjectList: TObjectList<M>);
    procedure Modify(AObject: M);
  end;

implementation

end.

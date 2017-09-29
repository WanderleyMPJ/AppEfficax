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

{$INCLUDE ..\ormbr.inc}

unit ormbr.Json;

interface

uses
  Rtti,
  SysUtils,
  Classes,
  Contnrs,
  Variants,
  TypInfo,
  Generics.Collections,
  /// ormbr
  ormbr.mapping.rttiutils,
  ormbr.types.blob,
  ormbr.utils,
  ormbr.rtti.helper;

type
  TORMBrJsonOption = (joIgnoreEmptyStrings,
                      joIgnoreEmptyArrays,
                      joDateIsUTC,
                      joDateFormatUnix,
                      joDateFormatISO8601,
                      joDateFormatMongo,
                      joDateFormatParse);
  TORMBrJsonOptions = set of TORMBrJsonOption;

  EJSONException = class(Exception);

  TStringDynamicArray = array of string;
  TVariantDynamicArray = array of Variant;

  PJSONVariantData = ^TJSONVariantData;

  TByteDynArray = array of byte;
  PByteDynArray = ^TByteDynArray;

  TJSONVariantKind = (jvUndefined, jvObject, jvArray);
  TJSONParserKind = (kNone, kNull, kFalse, kTrue, kString, kInteger, kFloat, kObject, kArray);

  TJSONVariantData = object
  protected
    FVType: TVarType;
    FVKind: TJSONVariantKind;
    FVCount: Integer;
    function GetKind: TJSONVariantKind;
    function GetCount: Integer;
    function GetVarData(const AName: string; var ADest: TVarData): Boolean;
    function GetValue(const AName: string): Variant;
    function GetValueCopy(const AName: string): Variant;
    procedure SetValue(const AName: string; const AValue: Variant);
    function GetItem(AIndex: Integer): Variant;
    procedure SetItem(AIndex: Integer; const AItem: Variant);
  public
    FNames: TStringDynamicArray;
    FValues: TVariantDynamicArray;
    procedure Init; overload;
    procedure Init(const AJson: string); overload;
    procedure InitFrom(const AValues: TVariantDynamicArray); overload;
    procedure Clear;
    function Data(const AName: string): PJSONVariantData; inline;
    function EnsureData(const APath: string): PJSONVariantData;
    function AddItem: PJSONVariantData;
    function NameIndex(const AName: string): Integer;
    function FromJSON(const AJson: string): Boolean;
    function ToJSON: string;
    function ToObject(AObject: TObject): Boolean;
    function ToNewObject: TObject;
    procedure AddValue(const AValue: Variant);
    procedure AddNameValue(const AName: string; const AValue: Variant);
    procedure SetPath(const APath: string; const AValue: Variant);
    property Kind: TJSONVariantKind read GetKind;
    property Count: Integer read GetCount;
    property Value[const AName: string]: Variant read GetValue write SetValue; default;
    property ValueCopy[const AName: string]: Variant read GetValueCopy;
    property Item[AIndex: Integer]: Variant read GetItem write SetItem;
  end;

  TJSONParser = object
    FJson: string;
    FIndex: Integer;
    FJsonLength: Integer;
    procedure Init(const AJson: string; AIndex: Integer);
    function GetNextChar: Char; inline;
    function GetNextNonWhiteChar: Char; inline;
    function CheckNextNonWhiteChar(AChar: Char): Boolean; inline;
    function GetNextString(out AStr: string): Boolean; overload;
    function GetNextString: string; overload; inline;
    function GetNextJSON(out AValue: Variant): TJSONParserKind;
    function CheckNextIdent(const AExpectedIdent: string): Boolean;
    function GetNextAlphaPropName(out AFieldName: string): Boolean;
    function ParseJSONObject(var AData: TJSONVariantData): Boolean;
    function ParseJSONArray(var AData: TJSONVariantData): Boolean;
    procedure GetNextStringUnEscape(var AStr: string);
  end;

  TJSONVariant = class(TInvokeableVariantType)
  public
    procedure Copy(var ADest: TVarData; const ASource: TVarData;
      const AIndirect: Boolean); override;
    procedure Clear(var AVarData: TVarData); override;
    function GetProperty(var ADest: TVarData; const AVarData: TVarData; const AName: string): Boolean; override;
    function SetProperty(const AVarData: TVarData; const AName: string;
      const AValue: TVarData): Boolean; override;
    procedure Cast(var ADest: TVarData; const ASource: TVarData); override;
    procedure CastTo(var ADest: TVarData; const ASource: TVarData;
      const AVarType: TVarType); override;
  end;

  TJSONObjectORMBr = class
  private
    function JSONVariant(const AJson: string): Variant; overload;
    function JSONVariant(const AValues: TVariantDynamicArray): Variant; overload;
    function JSONVariantFromConst(const constValues: array of Variant): Variant;
    function JSONVariantDataSafe(const JSONVariant: Variant;
      ExpectedKind: TJSONVariantKind = jvUndefined): PJSONVariantData;
    function GetInstanceProp(AInstance: TObject; AProperty: TRttiProperty): Variant;
    function JSONToValue(const AJson: string): Variant;
    function NowToIso8601: string;
    function JSONToNewObject(const AJson: string): Pointer;
    procedure RegisterClassForJSON(const AClasses: array of TClass);
    class function JSONVariantData(const JSONVariant: Variant): PJSONVariantData;
    class function IdemPropName(const APropName1, APropName2: string): Boolean; inline;
    class function FindClassForJSON(const AClassName: string): Integer;
    class function CreateClassForJSON(const AClassName: string): TObject;
    class function StringToJSON(const AText: string): string;
    class function ValueToJSON(const AValue: Variant): string;
    class function DateTimeToJSON(AValue: TDateTime): string;
    class procedure AppendChar(var AStr: string; AChr: char);
    class procedure DoubleToJSON(AValue: Double; var AResult: string);
    class procedure SetInstanceProp(AInstance: TObject; AProperty:
      TRttiProperty; const AValue: Variant);
  public
    function ObjectToJSON(AObject: TObject; AStoreClassName: Boolean = False): string;
    function JSONToObject(AObject: TObject; const AJson: string): Boolean; overload;
    function JSONToObject<T: class, constructor>(const AJson: string): T; overload;
    function JSONToObjectList<T: class, constructor>(const AJson: string): TList<T>;
  end;

var
  JSONVariantType: TInvokeableVariantType;
  BASE64DECODE: array of ShortInt;
  FSettingsUS: TFormatSettings;
  RegisteredClass: array of record
    ClassName: string;
    ClassType: TClass;
  end;

const
  JSON_BASE64_MAGIC: array [0..2] of byte = ($EF, $BF, $B0);
  JSON_BASE64_MAGIC_LEN = sizeof(JSON_BASE64_MAGIC) div sizeof(char);
  BASE64: array [0 .. 63] of char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  JSONVariantDataFake: TJSONVariantData = ();

implementation

{ TJSONObjectORMBr }

procedure TJSONObjectORMBr.RegisterClassForJSON(const AClasses: array of TClass);
var
  iFor, iIdx: integer;
  sName: string;
begin
  for iFor := 0 to High(AClasses) do
  begin
    sName := String(AClasses[iFor].ClassName);
    iIdx := FindClassForJSON(sName);
    if iIdx>=0 then
      Continue;
    iIdx := length(RegisteredClass);
    SetLength(RegisteredClass,iIdx+1);
    RegisteredClass[iIdx].ClassName := sName;
    RegisteredClass[iIdx].ClassType := AClasses[iFor];
  end;
end;

class function TJSONObjectORMBr.IdemPropName(const APropName1, APropName2: string): Boolean;
var
  iLen, iFor: Integer;
begin
  Result := False;
  iLen := Length(APropName2);
  if Length(APropName1) <> iLen then
    Exit;
  for iFor := 1 to iLen do
    if (Ord(APropName1[iFor]) xor Ord(APropName2[iFor])) and $DF <> 0 then
      Exit;
  Result := True;
end;

function TJSONObjectORMBr.JSONVariant(const AJson: string): Variant;
begin
  VarClear(Result);
  TJSONVariantData(Result).FromJSON(AJson);
end;

function TJSONObjectORMBr.JSONVariant(const AValues: TVariantDynamicArray): Variant;
begin
  VarClear(Result);
  TJSONVariantData(Result).Init;
  TJSONVariantData(Result).FVKind := jvArray;
  TJSONVariantData(Result).FVCount := Length(AValues);
  TJSONVariantData(Result).FValues := AValues;
end;

function TJSONObjectORMBr.JSONVariantFromConst(const constValues: array of Variant): Variant;
var
  iFor: Integer;
begin
  VarClear(Result);
  with TJSONVariantData(Result) do
  begin
    Init;
    FVKind := jvArray;
    FVCount := Length(FValues);
    SetLength(FValues, FVCount);
    for iFor := 0 to FVCount - 1 do
      FValues[iFor] := constValues[iFor];
  end;
end;

class function TJSONObjectORMBr.JSONVariantData(const JSONVariant: Variant): PJSONVariantData;
begin
  with TVarData(JSONVariant) do
  begin
    if VType = JSONVariantType.VarType then
      Result := @JSONVariant
    else
    if VType = varByRef or varVariant then
      Result := JSONVariantData(PVariant(VPointer)^)
    else
      raise EJSONException.CreateFmt('JSONVariantData.Data(%d<>JSONVariant)', [VType]);
  end;
end;

function TJSONObjectORMBr.JSONVariantDataSafe(const JSONVariant: Variant;
  ExpectedKind: TJSONVariantKind = jvUndefined): PJSONVariantData;
begin
  with TVarData(JSONVariant) do
  begin
    if VType = JSONVariantType.VarType then
      if (ExpectedKind = jvUndefined) or (TJSONVariantData(JSONVariant).FVKind = ExpectedKind) then
        Result := @JSONVariant
      else
        Result := @JSONVariantDataFake
      else
      if VType = varByRef or varVariant then
        Result := JSONVariantDataSafe(PVariant(VPointer)^)
      else
        Result := @JSONVariantDataFake;
  end;
end;

class procedure TJSONObjectORMBr.AppendChar(var AStr: string; AChr: Char);
var
  iLen: Integer;
begin
  iLen := Length(AStr);
  SetLength(AStr, iLen + 1);
  PChar(Pointer(AStr))[iLen] := AChr;
end;

class function TJSONObjectORMBr.StringToJSON(const AText: string): string;
var
  iLen, iFor: Integer;

  procedure DoEscape;
  var
    iChr: Integer;
  begin
    Result := '"' + Copy(AText, 1, iFor - 1);
    for iChr := iFor to iLen do
    begin
      case AText[iChr] of
        #8:  Result := Result + '\b';
        #9:  Result := Result + '\t';
        #10: Result := Result + '\n';
        #12: Result := Result + '\f';
        #13: Result := Result + '\r';
        '\': Result := Result + '\\';
        '"': Result := Result + '\"';
      else
        if AText[iChr] < ' ' then
          Result := Result + '\u00' + IntToHex(Ord(AText[iChr]), 2)
        else
          AppendChar(Result, AText[iChr]);
      end;
    end;
    AppendChar(Result, '"');
  end;

begin
  iLen := Length(AText);
  for iFor := 1 to iLen do
    case AText[iFor] of
      #0 .. #31, '\', '"':
        begin
          DoEscape;
          Exit;
        end;
    end;
  Result := '"' + AText + '"';
end;

class procedure TJSONObjectORMBr.DoubleToJSON(AValue: Double; var AResult: string);
begin
  AResult := FloatToStr(AValue, FSettingsUS);
end;

/// <summary>
/// // "YYYY-MM-DD" "Thh:mm:ss" or "YYYY-MM-DDThh:mm:ss"
/// </summary>
class function TJSONObjectORMBr.DateTimeToJSON(AValue: TDateTime): string;
begin
  Result := '"' + TUtilSingleton.GetInstance.DateTimeToIso8601(AValue) + '"';
end;

function TJSONObjectORMBr.NowToIso8601: string;
begin
  Result := TUtilSingleton.GetInstance.DateTimeToIso8601(Now);
end;

class function TJSONObjectORMBr.ValueToJSON(const AValue: Variant): string;
var
  iInt64: Int64;
begin
  if TVarData(AValue).VType = JSONVariantType.VarType then
    Result := TJSONVariantData(AValue).ToJSON
  else
  if (TVarData(AValue).VType = varByRef or varVariant) then
    Result := ValueToJSON(PVariant(TVarData(AValue).VPointer)^)
  else
  if TVarData(AValue).VType <= varNull then
    Result := 'null'
  else
  if TVarData(AValue).VType = varBoolean then
  begin
    if TVarData(AValue).VBoolean then
      Result := 'true'
    else
      Result := 'false';
  end
  else
  if TVarData(AValue).VType = varDate then
    Result := DateTimeToJSON(TVarData(AValue).VDouble)
  else
  if VarIsOrdinal(AValue) then
  begin
    iInt64 := AValue;
    Result := IntToStr(iInt64);
  end
  else
  if VarIsFloat(AValue) then
    DoubleToJSON(AValue, Result)
  else
  if VarIsStr(AValue) then
    Result := StringToJSON(AValue)
  else
    Result := AValue;
end;

function TJSONObjectORMBr.JSONToValue(const AJson: string): Variant;
var
  Parser: TJSONParser;
begin
  Parser.Init(AJson, 1);
  Parser.GetNextJSON(Result);
end;

function TJSONObjectORMBr.GetInstanceProp(AInstance: TObject; AProperty: TRttiProperty): Variant;
var
  oClass: TObject;
begin
  case AProperty.PropertyType.TypeKind of
    tkInt64:
      Result := AProperty.GetNullableValue(AInstance).AsInt64;
    tkEnumeration, tkInteger, tkSet:
      Result := AProperty.GetNullableValue(AInstance).AsInteger;
    tkUString, tkLString, tkWString, tkString, tkChar, tkWChar:
      Result := AProperty.GetNullableValue(AInstance).AsString;
    tkFloat:
      if AProperty.PropertyType.Handle = TypeInfo(TDateTime) then
        Result := TUtilSingleton.GetInstance.DateTimeToIso8601(AProperty.GetNullableValue(AInstance).AsExtended)
      else
        Result := AProperty.GetNullableValue(AInstance).AsCurrency;
    tkVariant:
      Result := AProperty.GetNullableValue(AInstance).AsVariant;
    tkRecord:
      begin
        if TRttiSingleton.GetInstance.IsBlob(AProperty.PropertyType.Handle) then
          Result := AProperty.GetNullableValue(AInstance).AsType<TBlob>.ToBytesString
        else
          Result := AProperty.GetNullableValue(AInstance).AsVariant;
      end;
    tkClass:
      begin
        oClass := AProperty.GetNullableValue(AInstance).AsObject;
        if oClass = nil then
          Result := null
        else
          TJSONVariantData(Result).Init(ObjectToJSON(oClass));
      end;
    tkDynArray:;
  end;
end;

class procedure TJSONObjectORMBr.SetInstanceProp(AInstance: TObject;
  AProperty: TRttiProperty; const AValue: Variant);
var
  oClass: TObject;
  oBlob: TBlob;
begin
  if (AProperty <> nil) and (AInstance <> nil) then
    case AProperty.PropertyType.TypeKind of
      tkString, tkWString, tkUString, tkWChar, tkLString, tkChar:
        if TVarData(AValue).VType <= varNull then
          AProperty.SetValue(AInstance, '')
        else
          AProperty.SetValue(AInstance, String(AValue));
      tkInteger, tkEnumeration, tkSet, tkInt64:
        AProperty.SetValue(AInstance, Integer(AValue));
      tkFloat:
        if TVarData(AValue).VType <= varNull then
          AProperty.SetValue(AInstance, 0)
        else
        if AProperty.PropertyType.Handle = TypeInfo(TDateTime) then
          AProperty.SetValue(AInstance, TUtilSingleton.GetInstance.Iso8601ToDateTime(AValue))
        else
        if AProperty.PropertyType.Handle = TypeInfo(TTime) then
          AProperty.SetValue(AInstance, TUtilSingleton.GetInstance.Iso8601ToDateTime(AValue))
        else
          AProperty.SetValue(AInstance, Currency(AValue));
      tkVariant:
        AProperty.SetValue(AInstance, TValue.FromVariant(AValue));
      tkRecord:
        begin
          if TRttiSingleton.GetInstance.IsBlob(AProperty.PropertyType.Handle) then
          begin
            oBlob.ToBytesString(AValue);
            AProperty.SetValue(AInstance, TValue.From<TBlob>(oBlob));
          end
          else
            AProperty.SetNullableValue(AInstance,
                                       AProperty.PropertyType.Handle,
                                       AValue);
        end;
      tkDynArray:;
      tkClass:
        begin
          oClass := AProperty.GetNullableValue(AInstance).AsObject;
          if oClass <> nil then
            JSONVariantData(AValue).ToObject(oClass);
        end;
    end;
end;

function TJSONObjectORMBr.JSONToObjectList<T>(const AJson: string): TList<T>;
var
  LDoc: TJSONVariantData;
  LItem: TObject;
  LFor: Integer;
begin
  LDoc.Init(AJson);
  if (LDoc.FVKind <> jvArray) then
    Result := nil
  else
  begin
    Result := TList<T>.Create;
    for LFor := 0 to LDoc.Count - 1 do
    begin
      LItem := T.Create;
      if not JSONVariantData(LDoc.FValues[LFor]).ToObject(LItem) then
      begin
        FreeAndNil(Result);
        Exit;
      end;
      Result.Add(LItem);
    end;
  end;
end;

function TJSONObjectORMBr.JSONToObject(AObject: TObject; const AJson: string): Boolean;
var
  oDoc: TJSONVariantData;
begin
  if AObject = nil then
    Result := False
  else
  begin
    oDoc.Init(AJson);
    Result := oDoc.ToObject(AObject);
  end;
end;

function TJSONObjectORMBr.JSONToObject<T>(const AJson: string): T;
begin
  Result := T.Create;
  if not JSONToObject(TObject(Result), AJson) then
    raise Exception.Create('Error Message');
end;

function TJSONObjectORMBr.JSONToNewObject(const AJson: string): Pointer;
var
  oDoc: TJSONVariantData;
begin
  oDoc.Init(AJson);
  Result := oDoc.ToNewObject;
end;

class function TJSONObjectORMBr.FindClassForJSON(const AClassName: string): Integer;
begin
  for Result := 0 to High(RegisteredClass) do
    if IdemPropName(RegisteredClass[Result].ClassName, AClassName) then
      Exit;
  Result := -1;
end;

class function TJSONObjectORMBr.CreateClassForJSON(const AClassName: string): TObject;
var
  iFor: Integer;
begin
  iFor := FindClassForJSON(AClassName);
  if iFor < 0 then
    Result := nil
  else
    Result := RegisteredClass[iFor].ClassType.Create;
end;

function TJSONObjectORMBr.ObjectToJSON(AObject: TObject; AStoreClassName: Boolean): string;
var
  LTypeInfo: TRttiType;
  LProperty: TRttiProperty;
  {$IFDEF DELPHI15_UP}
  LMethodToArray: TRttiMethod;
  {$ENDIF DELPHI15_UP}
  LFor: Integer;
  LValue: TValue;
begin
  LValue := nil;
  if AObject = nil then
  begin
    Result := 'null';
    Exit;
  end;
  if AObject.InheritsFrom(TList) then
  begin
    if TList(AObject).Count = 0 then
      Result := '[]'
    else
    begin
      Result := '[';
      for LFor := 0 to TList(AObject).Count - 1 do
        Result := Result +
                  ObjectToJSON(TObject(TList(AObject).List[LFor]),
                  AStoreClassName) + ',';
      Result[Length(Result)] := ']';
    end;
    Exit;
  end;
  if AObject.InheritsFrom(TStrings) then
  begin
    if TStrings(AObject).Count = 0 then
      Result := '[]'
    else
    begin
      Result := '[';
      for LFor := 0 to TStrings(AObject).Count - 1 do
        Result := Result +
                  StringToJSON(TStrings(AObject).Strings[LFor]) + ',';
      Result[Length(Result)] := ']';
    end;
    Exit;
  end;
  if AObject.InheritsFrom(TCollection) then
  begin
    if TCollection(AObject).Count = 0 then
      Result := '[]'
    else
    begin
      Result := '[';
      for LFor := 0 to TCollection(AObject).Count - 1 do
        Result := Result +
                  ObjectToJSON(TCollection(AObject).Items[LFor],
                  AStoreClassName) + ',';
      Result[Length(Result)] := ']';
    end;
    Exit;
  end;
  LTypeInfo := TRttiSingleton.GetInstance.GetRttiType(AObject.ClassType);
  if LTypeInfo = nil then
  begin
    Result := 'null';
    Exit;
  end;
  if (Pos('TObjectList<', AObject.ClassName) > 0) or
     (Pos('TList<', AObject.ClassName) > 0) then
  begin
    {$IFDEF DELPHI15_UP}
    LMethodToArray := LTypeInfo.GetMethod('ToArray');
    if LMethodToArray <> nil then
    begin
      LValue := LMethodToArray.Invoke(AObject, []);
      Assert(LValue.IsArray);
      if LValue.GetArrayLength = 0 then
        Result := '[]'
      else
      begin
        Result := '[';
        for LFor := 0 to LValue.GetArrayLength -1 do
          Result := Result +
                    ObjectToJSON(LValue.GetArrayElement(LFor).AsObject, AStoreClassName) + ',';
         Result[Length(Result)] := ']';
      end
    end;
    {$ELSE DELPHI15_UP}
    if TList(AObject).Count = 0 then
      Result := '[]'
    else
    begin
      Result := '[';
      for LFor := 0 to TList(AObject).Count -1 do
        Result := Result +
                  ObjectToJSON(TList(AObject).Items[LFor], AStoreClassName) + ',';
      Result[Length(Result)] := ']';
    end;
    {$ENDIF DELPHI15_UP}
    Exit;
  end;
  if AStoreClassName then
    Result := '{"ClassName":"' + string(AObject.ClassName) + '",'
  else
    Result := '{';
  for LProperty in LTypeInfo.GetProperties do
  begin
    Result := Result + StringToJSON(LProperty.Name) + ':' +
                       ValueToJSON(GetInstanceProp(AObject, LProperty)) + ',';
  end;
  Result[Length(Result)] := '}';
end;

{ TJSONParser }

procedure TJSONParser.Init(const AJson: string; AIndex: Integer);
begin
  FJson := AJson;
  FJsonLength := Length(FJson);
  FIndex := AIndex;
end;

function TJSONParser.GetNextChar: char;
begin
  if FIndex <= FJsonLength then
  begin
    Result := FJson[FIndex];
    Inc(FIndex);
  end
  else
    Result := #0;
end;

function TJSONParser.GetNextNonWhiteChar: char;
begin
  if FIndex <= FJsonLength then
    repeat
      if FJson[FIndex] > ' ' then
      begin
        Result := FJson[FIndex];
        Inc(FIndex);
        Exit;
      end;
      Inc(FIndex);
    until FIndex > FJsonLength;
    Result := #0;
end;

function TJSONParser.CheckNextNonWhiteChar(AChar: Char): Boolean;
begin
  if FIndex <= FJsonLength then
    repeat
      if FJson[FIndex] > ' ' then
      begin
        Result := FJson[FIndex] = aChar;
        if Result then
          Inc(FIndex);
        Exit;
      end;
      Inc(FIndex);
    until FIndex > FJsonLength;
    Result := False;
end;

procedure TJSONParser.GetNextStringUnEscape(var AStr: string);
var
  cChar: char;
  sCopy: string;
  iUnicode, iErr: Integer;
begin
  repeat
    cChar := GetNextChar;
    case cChar of
      #0:  Exit;
      '"': Break;
      '\': begin
           cChar := GetNextChar;
           case cChar of
             #0 : Exit;
             'b': TJSONObjectORMBr.AppendChar(AStr, #08);
             't': TJSONObjectORMBr.AppendChar(AStr, #09);
             'n': TJSONObjectORMBr.AppendChar(AStr, #$0a);
             'f': TJSONObjectORMBr.AppendChar(AStr, #$0c);
             'r': TJSONObjectORMBr.AppendChar(AStr, #$0d);
             'u':
             begin
               sCopy := Copy(FJson, FIndex, 4);
               if Length(sCopy) <> 4 then
                 Exit;
               Inc(FIndex, 4);
               Val('$' + sCopy, iUnicode, iErr);
               if iErr <> 0 then
                 Exit;
               TJSONObjectORMBr.AppendChar(AStr, char(iUnicode));
             end;
           else
             TJSONObjectORMBr.AppendChar(AStr, cChar);
           end;
         end;
    else
      TJSONObjectORMBr.AppendChar(AStr, cChar);
    end;
  until False;
end;

function TJSONParser.GetNextString(out AStr: string): Boolean;
var
  iFor: Integer;
begin
  for iFor := FIndex to FJsonLength do
  begin
    case FJson[iFor] of
      '"': begin // end of string without escape -> direct copy
             AStr := Copy(FJson, FIndex, iFor - FIndex);
             FIndex := iFor + 1;
             Result := True;
             Exit;
           end;
      '\': begin // need unescaping
             AStr := Copy(FJson, FIndex, iFor - FIndex);
             FIndex := iFor;
             GetNextStringUnEscape(AStr);
             Result := True;
             Exit;
           end;
    end;
  end;
  Result := False;
end;

function TJSONParser.GetNextString: string;
begin
  if not GetNextString(Result) then
    Result := '';
end;

function TJSONParser.GetNextAlphaPropName(out AFieldName: string): Boolean;
var
  iFor: Integer;
begin
  Result := False;
  if (FIndex >= FJsonLength) or not (Ord(FJson[FIndex]) in [Ord('A') ..
                                                            Ord('Z'),
                                                            Ord('a') ..
                                                            Ord('z'),
                                                            Ord('_'),
                                                            Ord('$')]) then
    Exit;
  for iFor := FIndex + 1 to FJsonLength do
    case Ord(FJson[iFor]) of
         Ord('0') ..
         Ord('9'),
         Ord('A') ..
         Ord('Z'),
         Ord('a') ..
         Ord('z'),
         Ord('_'):; // allow MongoDB extended syntax, e.g. {age:{$gt:18}}
         Ord(':'),
         Ord('='):
      begin
        AFieldName := Copy(FJson, FIndex, iFor - FIndex);
        FIndex := iFor + 1;
        Result := True;
        Exit;
      end;
    else
      Exit;
    end;
end;

function TJSONParser.GetNextJSON(out AValue: Variant): TJSONParserKind;
var
  sStr: string;
  iInt64: Int64;
  dValue: double;
  iStart, iErr: Integer;
begin
  Result := kNone;
  case GetNextNonWhiteChar of
    'n': if Copy(FJson, FIndex, 3) = 'ull' then
         begin
           Inc(FIndex, 3);
           Result := kNull;
           AValue := null;
         end;
    'f': if Copy(FJson, FIndex, 4) = 'alse' then
         begin
           Inc(FIndex, 4);
           Result := kFalse;
           AValue := False;
         end;
    't': if Copy(FJson, FIndex, 3) = 'rue' then
         begin
           Inc(FIndex, 3);
           Result := kTrue;
           AValue := True;
         end;
    '"': if GetNextString(sStr) = True then
         begin
           Result := kString;
           AValue := sStr;
         end;
    '{': if ParseJSONObject(TJSONVariantData(AValue)) then
           Result := kObject;
    '[': if ParseJSONArray(TJSONVariantData(AValue)) then
           Result := kArray;
    '-', '0' .. '9':
      begin
        iStart := FIndex - 1;
        while True do
          case FJson[FIndex] of
            '-', '+', '0' .. '9', '.', 'E', 'e':
              Inc(FIndex);
          else
            Break;
          end;
        sStr := Copy(FJson, iStart, FIndex - iStart);
        Val(sStr, iInt64, iErr);
        if iErr = 0 then
        begin
          AValue := iInt64;
          Result := kInteger;
        end
        else
        begin
          Val(sStr, dValue, iErr);
          if iErr <> 0 then
            Exit;
          AValue := dValue;
          Result := kFloat;
        end;
      end;
  end;
end;

function TJSONParser.CheckNextIdent(const AExpectedIdent: string): Boolean;
begin
  Result := (GetNextNonWhiteChar = '"') and
            (CompareText(GetNextString, AExpectedIdent) = 0) and
            (GetNextNonWhiteChar = ':');
end;

function TJSONParser.ParseJSONArray(var AData: TJSONVariantData): Boolean;
var
  vItem: Variant;
begin
  Result := False;
  AData.Init;
  if not CheckNextNonWhiteChar(']') then
  begin
    repeat
      if GetNextJSON(vItem) = kNone then
        Exit;
      AData.AddValue(vItem);
      case GetNextNonWhiteChar of
        ',': Continue;
        ']': Break;
      else
        Exit;
      end;
    until False;
    SetLength(AData.FValues, AData.FVCount);
  end;
  AData.FVKind := jvArray;
  Result := True;
end;

function TJSONParser.ParseJSONObject(var AData: TJSONVariantData): Boolean;
var
  sKey: string;
  vItem: Variant;
begin
  Result := False;
  AData.Init;
  if not CheckNextNonWhiteChar('}') then
  begin
    repeat
      if CheckNextNonWhiteChar('"') then
      begin
        if (not GetNextString(sKey)) or (GetNextNonWhiteChar <> ':') then
          Exit;
      end
      else
      if not GetNextAlphaPropName(sKey) then
        Exit;
      if GetNextJSON(vItem) = kNone then
        Exit;
      AData.AddNameValue(sKey, vItem);
      case GetNextNonWhiteChar of
        ',': Continue;
        '}': Break;
      else
        Exit;
      end;
    until False;
    SetLength(AData.FNames, AData.FVCount);
  end;
  SetLength(AData.FValues, AData.FVCount);
  AData.FVKind := jvObject;
  Result := True;
end;


{ TJSONVariantData }

procedure TJSONVariantData.Init;
begin
  FVType := JSONVariantType.VarType;
  FVKind := jvUndefined;
  FVCount := 0;
  Pointer(FNames) := nil;
  Pointer(FValues) := nil;
end;

procedure TJSONVariantData.Init(const AJson: string);
begin
  Init;
  FromJSON(AJson);
  if FVType = varNull then
    FVKind := jvObject
  else
  if FVType <> JSONVariantType.VarType then
    Init;
end;

procedure TJSONVariantData.InitFrom(const AValues: TVariantDynamicArray);
begin
  Init;
  FVKind := jvArray;
  FValues := AValues;
  FVCount := Length(AValues);
end;

procedure TJSONVariantData.Clear;
begin
  FNames := nil;
  FValues := nil;
  Init;
end;

procedure TJSONVariantData.AddNameValue(const AName: string;
  const AValue: Variant);
begin
  if FVKind = jvUndefined then
    FVKind := jvObject
  else if FVKind <> jvObject then
    raise EJSONException.CreateFmt('AddNameValue(%s) over array', [AName]);
  if FVCount <= Length(FValues) then
  begin
    SetLength(FValues, FVCount + FVCount shr 3 + 32);
    SetLength(FNames, FVCount + FVCount shr 3 + 32);
  end;
  FValues[FVCount] := AValue;
  FNames[FVCount] := AName;
  Inc(FVCount);
end;

procedure TJSONVariantData.AddValue(const AValue: Variant);
begin
  if FVKind = jvUndefined then
    FVKind := jvArray
  else if FVKind <> jvArray then
    raise EJSONException.Create('AddValue() over object');
  if FVCount <= Length(FValues) then
    SetLength(FValues, FVCount + FVCount shr 3 + 32);
  FValues[FVCount] := aValue;
  Inc(FVCount);
end;

function TJSONVariantData.FromJSON(const AJson: string): Boolean;
var
  oParser: TJSONParser;
begin
  oParser.Init(AJson, 1);
  Result := oParser.GetNextJSON(Variant(Self)) in [kObject, kArray];
end;

function TJSONVariantData.Data(const AName: string): PJSONVariantData;
var
  iFor: Integer;
begin
  iFor := NameIndex(AName);
  if (iFor < 0) or (TVarData(FValues[iFor]).VType <> JSONVariantType.VarType) then
    Result := nil
  else
    Result := @FValues[iFor];
end;

function TJSONVariantData.GetKind: TJSONVariantKind;
begin
  if (@Self = nil) or (FVType <> JSONVariantType.VarType) then
    Result := jvUndefined
  else
    Result := FVKind;
end;

function TJSONVariantData.GetCount: Integer;
begin
  if (@Self = nil) or (FVType <> JSONVariantType.VarType) then
    Result := 0
  else
    Result := FVCount;
end;

function TJSONVariantData.GetValue(const AName: string): Variant;
begin
  VarClear(Result);
  if (@Self <> nil) and (FVType = JSONVariantType.VarType) and (FVKind = jvObject) then
    GetVarData(AName, TVarData(Result));
end;

function TJSONVariantData.GetValueCopy(const AName: string): Variant;
var
  iFor: Cardinal;
begin
  VarClear(Result);
  if (@Self <> nil) and (FVType = JSONVariantType.VarType) and
    (FVKind = jvObject) then
  begin
    iFor := Cardinal(NameIndex(AName));
    if iFor < Cardinal(Length(FValues)) then
      Result := FValues[iFor];
  end;
end;

function TJSONVariantData.GetItem(AIndex: Integer): Variant;
begin
  VarClear(Result);
  if (@Self <> nil) and (FVType = JSONVariantType.VarType) and (FVKind = jvArray)
    then
    if Cardinal(AIndex) < Cardinal(FVCount) then
      Result := FValues[AIndex];
end;

procedure TJSONVariantData.SetItem(AIndex: Integer; const AItem: Variant);
begin
  if (@Self <> nil) and (FVType = JSONVariantType.VarType) and (FVKind = jvArray)
    then
    if Cardinal(AIndex) < Cardinal(FVCount) then
      FValues[AIndex] := AItem;
end;

function TJSONVariantData.GetVarData(const AName: string;
  var ADest: TVarData): Boolean;
var
  iFor: Cardinal;
begin
  iFor := Cardinal(NameIndex(AName));
  if iFor < Cardinal(Length(FValues)) then
  begin
    ADest.VType := varVariant or varByRef;
    ADest.VPointer := @FValues[iFor];
    Result := True;
  end
  else
    Result := False;
end;

function TJSONVariantData.NameIndex(const AName: string): Integer;
begin
  if (@Self <> nil) and (FVType = JSONVariantType.VarType) and (FNames <> nil) then
    for Result := 0 to FVCount - 1 do
      if FNames[Result] = AName then
        Exit;
  Result := -1;
end;

procedure TJSONVariantData.SetPath(const APath: string; const AValue: Variant);
var
  iFor: Integer;
begin
  for iFor := Length(APath) downto 1 do
  begin
    if APath[iFor] = '.' then
    begin
      EnsureData(Copy(APath, 1, iFor - 1))^.SetValue(Copy(APath, iFor + 1, maxInt), AValue);
      Exit;
    end;
  end;
  SetValue(APath, AValue);
end;

function TJSONVariantData.EnsureData(const APath: string): PJSONVariantData;
var
  iFor: Integer;
  oNew: TJSONVariantData;
begin
  iFor := Pos('.', APath);
  if iFor = 0 then
  begin
    iFor := NameIndex(APath);
    if iFor < 0 then
    begin
      oNew.Init;
      AddNameValue(APath, Variant(oNew));
      Result := @FValues[FVCount - 1];
    end
    else
    begin
      if TVarData(FValues[iFor]).VType <> JSONVariantType.VarType then
      begin
        VarClear(FValues[iFor]);
        TJSONVariantData(FValues[iFor]).Init;
      end;
      Result := @FValues[iFor];
    end;
  end
  else
    Result := EnsureData(Copy(APath, 1, iFor - 1))^.EnsureData(Copy(APath, iFor + 1, maxInt));
end;

function TJSONVariantData.AddItem: PJSONVariantData;
var
  oNew: TJSONVariantData;
begin
  oNew.Init;
  AddValue(Variant(oNew));
  Result := @FValues[FVCount - 1];
end;

procedure TJSONVariantData.SetValue(const AName: string; const AValue: Variant);
var
  iFor: Integer;
begin
  if @Self = nil then
    raise EJSONException.Create('Unexpected Value[] access');
  if AName = '' then
    raise EJSONException.Create('Unexpected Value['''']');
  iFor := NameIndex(AName);
  if iFor < 0 then
    AddNameValue(AName, AValue)
  else
    FValues[iFor] := AValue;
end;

function TJSONVariantData.ToJSON: string;
var
  iFor: Integer;
begin
  case FVKind of
    jvObject:
      if FVCount = 0 then
        Result := '{}'
      else
      begin
        Result := '{';
        for iFor := 0 to FVCount - 1 do
          Result := Result +
                    TJSONObjectORMBr.StringToJSON(FNames[iFor]) + ':' +
                    TJSONObjectORMBr.ValueToJSON(FValues[iFor]) + ',';
        Result[Length(Result)] := '}';
      end;
    jvArray:
      if FVCount = 0 then
        Result := '[]'
      else
      begin
        Result := '[';
        for iFor := 0 to FVCount - 1 do
          Result := Result +
                    TJSONObjectORMBr.ValueToJSON(FValues[iFor]) + ',';
        Result[Length(Result)] := ']';
      end;
  else
    Result := 'null';
  end;
end;

function TJSONVariantData.ToNewObject: TObject;
var
  oType: TRttiType;
  oProperty: TRttiProperty;
  iIdx, iFor: Integer;
begin
  Result := nil;
  if (Kind <> jvObject) or (Count = 0) then
    Exit;
  iIdx := NameIndex('ClassName');
  if iIdx < 0 then
    Exit;
  Result := TJSONObjectORMBr.CreateClassForJSON(FValues[iIdx]);
  if Result = nil then
    Exit;
  oType := TRttiSingleton.GetInstance.GetRttiType(Result.ClassType);
  if oType <> nil then
  begin
    if oType <> nil then
    begin
      for iFor := 0 to Count - 1 do
      begin
        if iFor <> iIdx then
        begin
          oProperty := oType.GetProperty(FNames[iFor]);
          if oProperty <> nil then
            TJSONObjectORMBr.SetInstanceProp(Result, oProperty, FValues[iFor]);
        end;
      end;
    end;
  end;
end;

function TJSONVariantData.ToObject(AObject: TObject): Boolean;
var
  iFor: Integer;
  oItem: TCollectionItem;
  oType: TRttiType;
  oProperty: TRttiProperty;
  oObjectType: TObject;
begin
  Result := False;
  if AObject = nil then
    Exit;
  case Kind of
    jvObject:
      begin
        oType := TRttiSingleton.GetInstance.GetRttiType(AObject.ClassType);
        if oType <> nil then
        begin
          for iFor := 0 to Count - 1 do
          begin
            oProperty := oType.GetProperty(FNames[iFor]);
            if oProperty <> nil then
              TJSONObjectORMBr.SetInstanceProp(AObject, oProperty, FValues[iFor]);
          end;
        end;
      end;
    jvArray:
      if AObject.InheritsFrom(TCollection) then
      begin
        TCollection(AObject).Clear;
        for iFor := 0 to Count - 1 do
        begin
          oItem := TCollection(AObject).Add;
          if not TJSONObjectORMBr.JSONVariantData(FValues[iFor]).ToObject(oItem) then
            Exit;
        end;
      end
      else
      if AObject.InheritsFrom(TStrings) then
        try
          TStrings(AObject).BeginUpdate;
          TStrings(AObject).Clear;
          for iFor := 0 to Count - 1 do
            TStrings(AObject).Add(FValues[iFor]);
        finally
          TStrings(AObject).EndUpdate;
        end
      else
      if (Pos('TObjectList<', AObject.ClassName) > 0) or
         (Pos('TList<', AObject.ClassName) > 0) then
      begin
        oType := TRttiSingleton.GetInstance.GetRttiType(AObject.ClassType);
        oType := TRttiSingleton.GetInstance.GetListType(oType);
        if oType.IsInstance then
        begin
          for iFor := 0 to Count - 1 do
          begin
            oObjectType := oType.AsInstance.MetaclassType.Create;
            if not TJSONObjectORMBr.JSONVariantData(FValues[iFor]).ToObject(oObjectType) then
              Exit;
            TRttiSingleton.GetInstance.MethodCall(AObject, 'Add', [oObjectType]);
          end;
        end;
      end
      else
        Exit;
  else
    Exit;
  end;
  Result := True;
end;

{ TJSONVariant }

procedure TJSONVariant.Cast(var ADest: TVarData; const ASource: TVarData);
begin
  CastTo(ADest, ASource, VarType);
end;

procedure TJSONVariant.CastTo(var ADest: TVarData; const ASource: TVarData;
  const AVarType: TVarType);
begin
  if ASource.VType <> VarType then
    RaiseCastError;
  Variant(ADest) := TJSONVariantData(ASource).ToJSON;
end;

procedure TJSONVariant.Clear(var AVarData: TVarData);
begin
  AVarData.VType := varEmpty;
  Finalize(TJSONVariantData(AVarData).FNames);
  Finalize(TJSONVariantData(AVarData).FValues);
end;

procedure TJSONVariant.Copy(var ADest: TVarData; const ASource: TVarData;
  const AIndirect: Boolean);
begin
  if AIndirect then
    SimplisticCopy(ADest, ASource, True)
  else
  begin
    VarClear(Variant(ADest));
    TJSONVariantData(ADest).Init;
    TJSONVariantData(ADest) := TJSONVariantData(ASource);
  end;
end;

function TJSONVariant.GetProperty(var ADest: TVarData; const AVarData: TVarData;
  const AName: string): Boolean;
begin
  if not TJSONVariantData(AVarData).GetVarData(AName, ADest) then
    ADest.VType := varNull;
  Result := True;
end;

function TJSONVariant.SetProperty(const AVarData: TVarData; const AName: string;
  const AValue: TVarData): Boolean;
begin
  TJSONVariantData(AVarData).SetValue(AName, Variant(AValue));
  Result := True;
end;

initialization

JSONVariantType := TJSONVariant.Create;
{$IFDEF FORMATSETTINGS}
SettingsUS := TFormatSettings.Create('en_US');
{$ELSE FORMATSETTINGS}
GetLocaleFormatSettings($0409, FSettingsUS);
{$ENDIF FORMATSETTINGS}

end.

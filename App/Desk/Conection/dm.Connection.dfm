object dmConnection: TdmConnection
  OldCreateOrder = False
  Height = 275
  Width = 389
  object conexao: TFDConnection
    Params.Strings = (
      'Database=orcamento'
      'User_Name=root'
      'Server=localhost'
      'DriverID=mySQL')
    LoginPrompt = False
    Left = 40
    Top = 24
  end
  object driver: TFDPhysMySQLDriverLink
    VendorLib = 
      'C:\Program Files (x86)\EasyPHP-Devserver-17\eds-binaries\dbserve' +
      'r\mysql5717x86x170718104507\lib\libmysql.dll'
    Left = 160
    Top = 24
  end
  object fdqrGeral: TFDQuery
    Connection = conexao
    Left = 64
    Top = 120
  end
  object MemTable: TFDMemTable
    CachedUpdates = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 176
    Top = 120
  end
end

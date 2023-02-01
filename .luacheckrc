codes = true
stds.qsys = {
  read_globals = {
    ChannelGroup = {
      fields = {
        Index = {}
      }
    },
    Component = {
      fields = {
        New = {},
        GetComponents = {},
        GetControls = {}
      }
    },
    Controls = {
      other_fields = true,
      read_only = false,
    },
    Crypto = {
      fields = {
        Base64Encode = {},
        Base64Decode = {},
        CRC16Compute = {},
        Cipher = {},
        Decrypt = {},
        Digest = {},
        Encrypt = {},
        GetRandomBytes = {},
        Hash = {},
        HMAC = {},
        MD5Compute = {},
        PBKDF2 = {}
      }
    },
    DanteBrowser = {
      fields = {
        New = {},
        Browse = {}
      }
    },
    Design = {
      fields = {
        GetStatus = {},
        GetInventory = {}
      }
    },
    dir = {
      fields = {
        get = {},
        create = {},
        remove = {}
      }
    },
    Email = {
      fields = {
        Send = {}
      }
    },
    HttpClient = {
      fields = {
        Download = {},
        Upload = {},
        CreateUrl = {},
        EncodeParams = {},
        EncodeString = {},
        DecodeString = {},
        Get = {},
        Put = {},
        Post = {},
        Patch = {},
        Delete = {}
      }
    },
    Log = {
      fields = {
        Message = {},
        Error = {}
      }
    },
    Mixer = {
      fields = {
        New = {},
      }
    },
    NamedControl = {
      fields = {
        SetString = {},
        GetString = {},
        SetPosition = {},
        GetPosition = {},
        SetValue = {},
        GetValue = {},
        Trigger = {}
      }
    },
    Network = {
      fields = {
        GetHostByName = {},
        Interfaces = {},
      }
    },
    Notifications = {
      fields = {
        Subscribe = {},
        Publish = {},
        Unsubscribe = {}
      }
    },
    Ping = {
      fields = {
        New = {}
      }
    },
    QRCode = {
      fields = {
        GenerateSVG = {}
      }
    },
    SerialPorts = {
      other_fields = true,
      read_only = false
    },
    SerialServerPorts = {
      other_fields = true,
      read_only = false
    },
    Snapshot = {
      fields = {
        GetNames = {},
        Load = {},
        Save = {}
      }
    },
    SNMP = {
      fields = {
        SessionType = {
          fields = {
            v3 = {},
            V2c = {},
          }
        }
      }
    },
    SNMPSession = {
      fields = {
        New = {}
      }
    },
    SNMPTrap = {
      fields = {
        New = {}
      }
    },
    Ssh = {
      fields = {
        New = {}
      }
    },
    System = {
      fields = {
        System = {},
        LockingId = {},
        IsEmulating = {},
        MajorVersion = {},
        MinorVersion = {},
        Version = {}
      }
    },
    TcpSocket = {
      fields = {
        New = {},
        Events = {
          fields = {
            Connected = {},
            Reconnect = {},
            Data = {},
            Closed = {},
            Error = {},
            Timeout = {}
          }
        },
        EOL = {
          fields = {
            Any = {},
            CrLf = {},
            CrLfStrict = {},
            Lf = {},
            Null = {},
            Custom = {}
          }
        }
      }
    },
    TcpSocketServer = {
      fields = {
        New = {}
      }
    },
    Timer = {
      fields = {
        CallAfter = {},
        New = {},
        Now = {}
      }
    },
    Uci = {
      fields = {
        ShowDialog = {},
        SetScreen = {},
        SetUCI = {},
        SetPage = {},
        SetLayerVisibility = {},
        SetSharedLayerVisibility = {},
        LogOff = {}
      }
    },
    UdpSocket = {
      fields = {
        New = {}
      }
    }
  }
}
std = "min+qsys"

part of mcdart;

/// Minecraft server class for API access.
class Minecraft {
  String serverIP;
  Socket apiSocket;
  String _ipAddress;
  int _port;

  /// Connect to the Minecraft server.
  connect(String ipAddress, int port) async {
    try {
      _ipAddress = ipAddress;
      _port = port;
      Socket client = await Socket.connect(_ipAddress, _port);
      apiSocket = client;
      print("Connected $ipAddress:$port");
    } catch (e) {
      print(e);
    }
  }

  /// Close the socket connection.
  disconnect() async {
    await apiSocket.close();
  }

  //Socket connect.
  handleConnect(Socket s) {
    apiSocket = s;
    print("Connected");
  }

  //Connection error.
  handleError(e) {
    print("Error connecting");
  }

  //Response received.
  incomingResponse(List<int> Resp) {
    print(Resp);
  }

  /// Send a command with no response.
  _sendCmd(String cmd) {
    if (apiSocket != null) apiSocket.write(cmd);
    else print("No socket.");
  }

  /// Send a msg to the chat room.
  chat(String msg) {
    print("CHAT : $msg");
    _sendCmd('chat.post($msg)\n');
  }

  /// Set a block to a particular type.
  setBlock(int x, int y, int z, int blockTypeID, [int data = -1]) {
    if (data < 0) {
      _sendCmd('world.setBlock($x,$y,$z,$blockTypeID)\n');
    } else {
      _sendCmd('world.setBlock($x,$y,$z,$blockTypeID,$data)\n');
    }
  }

  /// Handle returned data to the command.
  dataHandler(data, sink) {
    sink.add(new String.fromCharCodes(data));
  }

  /// Return the player's position as List<int>.
  Future<List> getPos() async {
    // Workaround ;-)
    await disconnect();
    apiSocket = await Socket.connect(_ipAddress, _port);

    StreamTransformer fromByte =
        new StreamTransformer<List<int>, List<int>>.fromHandlers(
            handleData: dataHandler);

    List<int> XYZ = new List<int>();
    if (apiSocket != null) {
      apiSocket.write('player.getPos()\n');
    }

    String s;
    s = await apiSocket.transform(fromByte).first;
    var lp = s.toString().split(',');

    XYZ
      ..add(double.parse(lp[0]).truncate())
      ..add(double.parse(lp[1]).truncate())
      ..add(double.parse(lp[2]).truncate());

    return XYZ;
  }
}

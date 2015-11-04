part of mcdart;

/// Minecraft server class for API access.
class Minecraft {
  String serverIP;
  Socket apiSocket;

  /// Connect to the Minecraft server.
  connect(String ipAddress, int port) async {
    try {
      Socket client = await Socket.connect(ipAddress, port);
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
  dh(data, sink) {
    sink.add(new String.fromCharCodes(data));
  }

  /// Return the player's position.
  Future<List> getPos() async {
    var fromByte = new StreamTransformer<List<int>, List<int>>.fromHandlers(
        handleData: dh);

    var s;
    if (apiSocket != null) {
      apiSocket.write('player.getPos()\n');

      s = await apiSocket.transform(fromByte).first;
    }

    return s;
  }
}

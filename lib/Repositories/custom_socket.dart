import 'package:socket_io_client/socket_io_client.dart';

import '../Services/auth_service.dart';

class CustomSocketWrapper {
  late Socket _socket;
  Socket get socket => _socket;

  CustomSocketWrapper(String socketPath) {
    _socket = io(socketPath, OptionBuilder().setTransports(['websocket']).disableAutoConnect().build());

    AuthService.userTokenStream.stream.listen((userTokenId) {
      _socket.io.options?["extraHeaders"] = {"Authorization": "Bearer $userTokenId"};
      if (!socket.connected) {
        _socket.io.connect();
      }
    });
  }
}

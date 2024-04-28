import 'package:firebase_auth/firebase_auth.dart';
import 'package:socket_io_client/socket_io_client.dart';

class CustomSocketWrapper {
  late Socket _socket;
  Socket get socket => _socket;
  CustomSocketWrapper(String socketPath, String userTokenId) {
    _socket = io(socketPath,
        OptionBuilder().setTransports(['websocket']).setExtraHeaders({"Authorization": "Bearer $userTokenId"}).build());

    _socket.onAny((event, data) async {
      print("$data,$event");
      if (event.contains("FORBIDDEN")) {
        //reconnecting with socket
        _socket.disconnect();

        var token = await FirebaseAuth.instance.currentUser?.getIdToken();
        _socket.io.options!["extraHeaders"] = {"Authorization": "Bearer $token"};
        _socket.connect();
      }
    });
  }
}

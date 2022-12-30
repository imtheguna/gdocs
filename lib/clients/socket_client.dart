import 'package:docs/models/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient {
  io.Socket? socket;

  static SocketClient? _instance;

  SocketClient._insternal() {
    socket = io.io(host, <String, dynamic>{
      'transport': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient._insternal();

    return _instance!;
  }
}

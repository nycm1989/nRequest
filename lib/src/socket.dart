import 'dart:async' show Future, StreamSubscription, Timer;
import 'dart:io' show SocketException, WebSocketException;
import 'package:flutter/foundation.dart' show ChangeNotifier, kDebugMode;
import 'package:web_socket_channel/web_socket_channel.dart' show WebSocketChannel, WebSocketChannelException;

class NSocketData extends ChangeNotifier {
  final String name;
  String url;
  final void Function(dynamic message) function;

  /// Canal del para conectar a un socket
  WebSocketChannel? channel;

  /// Listener para el channel
  StreamSubscription<dynamic>? socket;

  /// Sirve para iniciar un contador en caso de que el método del socket mande false
  Timer? timer;

  bool hasChannelConnection = false;
  bool hasSocketConnection  = false;

  NSocketData({
    required this.name,
    required this.url,
    required this.function,
  });

  closeChannel(){
    hasSocketConnection = false;
    channel?.sink.close();
    channel = null;
  }

  closeSocket(){
    hasChannelConnection = false;
    socket?.cancel();
    socket = null;
  }

  closeTimer(){
    timer?.cancel();
    timer = null;
  }

  changeChannelConnection({required bool status, String? error}){
    hasChannelConnection = status;
    if ( !status ) {
      closeChannel();
      closeSocket();
      if(kDebugMode) print("$name -> $url can't connect to channel 👎${error != null ? "\n$error" : ''}");
    }
    notifyListeners();
  }

  changeSocketConnection({required bool status, String? error}){
    hasSocketConnection = status;
    if ( status ) {
      if(kDebugMode) print("$name channel listening 👍");
    } else {
      closeChannel();
      closeSocket();
      if(kDebugMode) print("$name channel error 👎${error != null ? "\n$error" : ''}");
    }
    notifyListeners();
  }

}

class NSocketController{
  final List<NSocketData> sockets;

  NSocketController.group({ required this.sockets });

  factory NSocketController.single({required final NSocketData socket}) => NSocketController.group(sockets: [socket]);

  // -------------------------------------------------------------------------
  listen() async {
    for(int index = 0; index < sockets.length; index++) {
      sockets[index].timer = Timer.periodic( const Duration(seconds: 1), (timer) async {
        await Future(() async {
          if(!sockets[index].hasChannelConnection) {
            sockets[index].channel = WebSocketChannel.connect(Uri.parse(sockets[index].url));
          }
          try{
            bool error = false;
            await sockets[index].channel?.ready.catchError((error) {
              error = true;
              sockets[index].changeChannelConnection(status: false, error: error.toString());
              sockets[index].changeSocketConnection(  status: false, error: error.toString());
            });
            sockets[index].changeChannelConnection(status: !error);
            // print(1);
          }
          on SocketException catch(error) {
            sockets[index].changeChannelConnection(status: false, error:  error.message);
            sockets[index].changeSocketConnection(  status: false, error: error.toString());
          }
          on WebSocketException catch(error) {
            sockets[index].changeChannelConnection(status: false, error:  error.message);
            sockets[index].changeSocketConnection(  status: false, error: error.toString());
          }
          on WebSocketChannelException catch(error) {
            sockets[index].changeChannelConnection(status: false, error:  error.message);
            sockets[index].changeSocketConnection(  status: false, error: error.toString());
          }
        }).then((_) {
          if ( sockets[index].hasChannelConnection ) {
            if( !sockets[index].hasSocketConnection ) {
              if(sockets[index].channel != null) {
                try{
                  sockets[index].socket = sockets[index].channel?.stream.listen((message) {
                    try{
                      sockets[index].function.call(message);
                    }catch (error) {
                      sockets[index].changeSocketConnection(  status: false, error: error.toString());
                      sockets[index].changeChannelConnection( status: false, error: error.toString());
                    }
                  });
                  sockets[index].changeSocketConnection(status: true);
                }
                on SocketException catch(error) {
                  sockets[index].changeChannelConnection( status: false, error: error.message);
                  sockets[index].changeSocketConnection(  status: false, error: error.toString());
                }
                on WebSocketException catch(error) {
                  sockets[index].changeChannelConnection( status: false, error: error.message);
                  sockets[index].changeSocketConnection(  status: false, error: error.toString());
                }
                on WebSocketChannelException catch(error) {
                  sockets[index].changeChannelConnection( status: false, error: error.message);
                }
                catch (error) {
                  sockets[index].changeChannelConnection( status: false, error: error.toString());
                  sockets[index].changeSocketConnection(  status: false, error: error.toString());
                }
              }
              sockets[index].socket?.onError((error) { sockets[index].changeSocketConnection(status: false, error: error.toString()); });
              sockets[index].socket?.onDone(()   { sockets[index].changeSocketConnection(status: false); });
            }
          }
        });
      });
    }
  }

  closeAll(){
    for (NSocketData data in sockets){
      data.closeChannel();
      data.closeSocket();
      data.closeTimer();
    }
  }
}
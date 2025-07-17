import 'dart:async';
import 'dart:io';





class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  //Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  /*void initialise() async {
    ConnectivityResult result = (await connectivity.checkConnectivity()) as ConnectivityResult;
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result as ConnectivityResult);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }
*/
  void disposeStream() => controller.close();
}
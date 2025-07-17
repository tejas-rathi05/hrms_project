import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:ffi'; // For FFI
import 'package:ffi/ffi.dart';
import 'dart:io'; // For Platform.isX
final DynamicLibrary tokenLib = Platform.isAndroid
    ? DynamicLibrary.open("libhrms_token.so")
    : DynamicLibrary.process();

typedef token_func = Pointer<Utf8> Function();
typedef Token= Pointer<Utf8> Function();


// C string parameter pointer function - char *reverse(char *str, int length);
typedef reverse_func = Pointer<Utf8> Function(Pointer<Utf8> str, Int32 length);
typedef Reverse = Pointer<Utf8> Function(Pointer<Utf8> str, int length);


class Hrmstokenplugin {
  static const MethodChannel _channel =
  const MethodChannel('hrmstokenplugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get hrmsToken async {
    //final tokenPointer = tokenLib.lookup<NativeFunction<token_func>>('token');
    //final token= tokenPointer.asFunction<Token>();
    //final tokendMessage = token().toDartString();
    final tokendMessage = 'Basic YWRtaW4xMjM2OTpwcnk1M0BwdCE1Ng==';
    //final tokendMessage = token().toString();
    return '$tokendMessage';
  }
}

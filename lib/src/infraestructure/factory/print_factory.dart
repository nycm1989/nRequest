import 'dart:io' show Platform;
import 'dart:convert' show json;
import 'package:flutter/foundation.dart' show Uint8List, kDebugMode, kIsWeb;
import 'package:n_request/n_request.dart' show RequestType, ResponseData;
import 'package:n_request/src/domain/enums/status_type.dart' show StatusType;
import 'package:n_request/src/domain/enums/status_color.dart' show StatusColor;


class PrintFactory{
  static void printStatus (String url, ResponseData response) {
    if(kDebugMode){
      if([ StatusType.clientError, StatusType.serverError ].contains(response.status.type)) {
        if (kIsWeb){
          print('[${response.status.code}] ${ _typeData(response.type, true) } $url → status: ${response.status.type.name}');
          if(response.status.error.isNotEmpty) print(response.status.error);
        } else if (Platform.isMacOS || Platform.isIOS || Platform.isLinux) {
          print('[${response.status.code}] ${ _typeData(response.type, true) } $url → status: ${response.status.type.name}');
          if(response.status.error.isNotEmpty) print(response.status.error);
        } else {
          print('${ _coloredMessage(StatusColor.red, "[${response.status.code}]") } ${ _typeData(response.type, true) } $url → status: ${ _coloredMessage(_getStatusColor(response.status.type), response.status.type.name) } ${_getStatusIcon(response.status.type)}');
          if(response.status.error.isNotEmpty) print(_coloredMessage(_getStatusColor(response.status.type), response.status.error));
        }
      } else {
        if (kIsWeb){
          print('[${response.status.code}] ${ _typeData(response.type, false) } $url → status: ${"${response.status.type.name}, ${response.status.description}"}');
        } else if (Platform.isMacOS || Platform.isIOS || Platform.isLinux) {
          print('[${response.status.code}] ${ _typeData(response.type, false) } $url → status: ${"${response.status.type.name}, ${response.status.description}"}');
        } else {
          print('${ _coloredMessage(_getStatusColor(response.status.type), "[${response.status.code}]") } ${ _typeData(response.type, true) } $url → status: ${ _coloredMessage(_getStatusColor(response.status.type), "${response.status.type.name}, ${response.status.description}")} ${_getStatusIcon(response.status.type)}' );
        }
      }
    }
  }

 static  String _coloredMessage(StatusColor mc, String m) => "${
    mc == StatusColor.black   ? '\x1b[30m' :
    mc == StatusColor.red     ? '\x1b[31m' :
    mc == StatusColor.green   ? '\x1b[32m' :
    mc == StatusColor.yellow  ? '\x1b[33m' :
    mc == StatusColor.blue    ? '\x1b[34m' :
    mc == StatusColor.magenta ? '\x1b[35m' :
    mc == StatusColor.cyan    ? '\x1b[36m' :
    mc == StatusColor.white   ? '\x1b[37m' :
    '\x1B[0m'
  }$m\x1B[0m";

  static StatusColor _getStatusColor (StatusType type) =>
  type == StatusType.successful   ? StatusColor.blue   :
  type == StatusType.unsuccessful ? StatusColor.yellow :
  type == StatusType.information  ? StatusColor.green  :
  type == StatusType.redirection  ? StatusColor.cyan   :
  StatusColor.red;

  static String _getStatusIcon(StatusType type) =>
  type == StatusType.information   ? '💬' :
  type == StatusType.successful    ? '👍' :
  type == StatusType.unsuccessful  ? '👎' :
  type == StatusType.redirection   ? '♻️' :
  type == StatusType.clientError   ? '⚠️' :
  type == StatusType.serverError   ? '☢️' :
  type == StatusType.exception     ? '❌' :
  '';

  static String _typeData(RequestType type, bool icons) =>
  type == RequestType.get       ? "GET ––--–-→ ${icons ? "💬" : ""}" :
  type == RequestType.post      ? "POST –--–-→ ${icons ? "💾" : ""}" :
  type == RequestType.put       ? "PUT ––--–-→ ${icons ? "📩" : ""}" :
  type == RequestType.put       ? "PATCH –-–-→ ${icons ? "📩" : ""}" :
  type == RequestType.delete    ? "DELETE ---→ ${icons ? "🗑️" : ""}" :
  type == RequestType.download  ? "DOWNLOAD -→ ${icons ? "🗑️" : ""}" :
  "";

  static void printUrl(final String url) =>
  kDebugMode ? print(" URL: $url") : null;

  static void printHeaders(final Map<String, String> headers) =>
  kDebugMode ? print("- Headers: ${json.encode(headers)}") : null;

  static void printBody(final dynamic body) =>
  kDebugMode ? print("- Body: ${json.encode(body)}") : null;

  static void printResponse(final dynamic response) =>
  kDebugMode ? print("- Response: ${(response is Uint8List) ? response : json.encode(response)}") : null;

}
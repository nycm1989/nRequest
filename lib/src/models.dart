import 'dart:convert' show json;
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:n_request/src/enums.dart' show RequestType, StatusColor, StatusType;

class ResponseData{
  String      url;
  RequestType type;
  StatusData  status;
  dynamic     body;

  ResponseData({
    this.url    = "",
    this.type   = RequestType.get,
    this.status = const StatusData(),
    this.body,
  });

  void printStatus () {
    if(kDebugMode){
      if([ StatusType.clientError, StatusType.serverError ].contains(status.type)) {
        if (kIsWeb){
          if(kDebugMode) print('[${status.code}] ${ _typeData(type, true) } $url → status: ${status.type.name}');
          if(kDebugMode) print(status.error);
        } else if (Platform.isMacOS || Platform.isIOS || Platform.isLinux) {
          if(kDebugMode) print('[${status.code}] ${ _typeData(type, true) } $url → status: ${status.type.name}');
          if(kDebugMode) print(status.error);
        } else {
          if(kDebugMode) print('${ _coloredMessage(StatusColor.yellow, "[${status.code}]") } ${ _typeData(type, true) } $url → status: ${ _coloredMessage(_getStatusColor(status.type), status.type.name) } ${_getStatusIcon(status.type)}');
          if(kDebugMode) print(_coloredMessage(_getStatusColor(status.type), status.error));
        }
      } else {
        if (kIsWeb){
          if(kDebugMode) print('[${status.code}] ${ _typeData(type, false) } $url → status: ${"${status.type.name}, ${status.description}"}');
        } else if (Platform.isMacOS || Platform.isIOS || Platform.isLinux) {
          if(kDebugMode) print('[${status.code}] ${ _typeData(type, false) } $url → status: ${"${status.type.name}, ${status.description}"}');
        } else {
          if(kDebugMode) print('${ _coloredMessage(StatusColor.yellow, "[${status.code}]") } ${ _typeData(type, true) } $url → status: ${ _coloredMessage(_getStatusColor(status.type), "${status.type.name}, ${status.description}")} ${_getStatusIcon(status.type)}' );
        }
      }
    }
  }

  String _coloredMessage(StatusColor mc, String m) => "${
  mc == StatusColor.black   ? '\x1b[30m' :
  mc == StatusColor.red     ? '\x1b[31m' :
  mc == StatusColor.green   ? '\x1b[32m' :
  mc == StatusColor.yellow  ? '\x1b[33m' :
  mc == StatusColor.blue    ? '\x1b[34m' :
  mc == StatusColor.magenta ? '\x1b[35m' :
  mc == StatusColor.cyan    ? '\x1b[36m' :
  mc == StatusColor.white   ? '\x1b[37m' :
  '\x1B[0m'}$m\x1B[0m";

  StatusColor _getStatusColor (StatusType type) =>
  type == StatusType.successful   ? StatusColor.blue   :
  type == StatusType.unsuccessful ? StatusColor.yellow :
  type == StatusType.information  ? StatusColor.green  :
  type == StatusType.redirection  ? StatusColor.cyan   :
  StatusColor.red;

  String _getStatusIcon(StatusType type) =>
  status.type == StatusType.information   ? '💬' :
  status.type == StatusType.successful    ? '👍' :
  status.type == StatusType.unsuccessful  ? '👎' :
  status.type == StatusType.redirection   ? '♻️' :
  status.type == StatusType.clientError   ? '⚠️' :
  status.type == StatusType.serverError   ? '☢️' :
  status.type == StatusType.exception     ? '❌' :
  '';

  String _typeData(RequestType type, bool icons) =>
  type == RequestType.get     ? "GET –––→ ${icons ? "💬" : ""}" :
  type == RequestType.post    ? "POST ––→ ${icons ? "📩" : ""}" :
  type == RequestType.put     ? "PUT –––→ ${icons ? "📩" : ""}" :
  type == RequestType.delete  ? "DELETE → ${icons ? "🗑️" : ""}" :
  "";

  void printBody ()=> kDebugMode ? print(json.encode(body)) : null;
}

class StatusData{
  final StatusType type;
  final int        code;
  final String     description;
  final bool       isValid;
  final String     error;

  const StatusData({
    this.type        = StatusType.exception,
    this.code        = 0,
    this.description = "",
    this.isValid     = false,
    this.error       = "",
  });

  String getMessage ({String url = '', bool hasCode = true}) => "${hasCode ? '[$code] ' : ''} $url → status: ${type.name}, $description";
}
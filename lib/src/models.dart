import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:n_request/src/enums.dart';

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
        debugPrint('${ _coloredMessage(StatusColor.yellow, "[${status.code}]") } ${ _typeData(type) } $url → status: ${ _coloredMessage(_getStatusColor(status.type), status.type.name) } ${ _getStatusIcon(status.type) }');
        debugPrint(_coloredMessage(_getStatusColor(status.type), status.error));
      } else {
        debugPrint('${ _coloredMessage(StatusColor.yellow, "[${status.code}]") } ${ _typeData(type) } $url → status: ${ _coloredMessage(_getStatusColor(status.type), "${status.type.name}, ${status.description}") } ${ _getStatusIcon(status.type) }' );
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

  String _typeData(RequestType type) =>
  type == RequestType.get     ? "GET –––→ 💬" :
  type == RequestType.post    ? "POST ––→ 📩" :
  type == RequestType.put     ? "PUT –––→ 📩" :
  type == RequestType.delete  ? "DELETE → 🗑️" :
  "";

  void printBody ()=> kDebugMode ? debugPrint(json.encode(body)) : null;
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
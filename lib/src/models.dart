import 'package:flutter/foundation.dart';
import 'package:n_request/src/enums.dart';

class ResponseData{
  String      url;
  RequestType type;
  StatusData  status;
  dynamic     body;
  bool        isValid;

  ResponseData({
    this.url    = "",
    this.type   = RequestType.get,
    this.status = const StatusData(),
    this.body,
    this.isValid = false,
  });

  void printStatus ()=> kDebugMode
  ? [ StatusType.clientError, StatusType.serverError ].contains(status.type)
    ? debugPrint('${_coloredMessage(StatusColor.yellow, "[${status.code}]")} ${type.name.toUpperCase()} → $url → status: ${_coloredMessage(_getStatusColor(status.type), "${status.type.name}, ${status.description}")} ${_getStatusIcon(status.type)}' )
    : debugPrint('${_coloredMessage(StatusColor.yellow, "[${status.code}]")} ${type.name.toUpperCase()} → $url → status: ${_coloredMessage(_getStatusColor(status.type), status.type.name)} ${_getStatusIcon(status.type)}\n${_coloredMessage(_getStatusColor(status.type), status.description)}')
  : null;

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
  type == StatusType.successful  ? StatusColor.blue   :
  type == StatusType.information ? StatusColor.green  :
  type == StatusType.redirection ? StatusColor.yellow :
  StatusColor.red;

  String _getStatusIcon(StatusType type) =>
  status.type == StatusType.information ? '💬' :
  status.type == StatusType.successful  ? '👍' :
  status.type == StatusType.redirection ? '♻️' :
  status.type == StatusType.clientError ? '⚠️' :
  status.type == StatusType.serverError ? '☢️' :
  status.type == StatusType.exception   ? '❌' :
  '';

  void printBody ()=> kDebugMode ? debugPrint("$body") : null;
}

class StatusData{
  final StatusType type;
  final int        code;
  final String     description;

  const StatusData({
    this.type        = StatusType.exception,
    this.code        = 0,
    this.description = "",
  });

  String getMessage ({String url = '', bool hasCode = true}) => "${hasCode ? '[$code] ' : ''} $url → status: ${type.name}, $description";
}
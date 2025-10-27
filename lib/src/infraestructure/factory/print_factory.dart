import 'dart:io' show Platform;
import 'dart:convert' show json;
import 'package:flutter/foundation.dart' show Uint8List, kDebugMode, kIsWeb;
import 'package:http/http.dart';
import 'package:n_request/n_request.dart' show RequestType, ResponseData;
import 'package:n_request/src/domain/enums/status_type.dart' show StatusType;
import 'package:n_request/src/domain/enums/status_color.dart' show StatusColor;


/// A utility class for printing and formatting debug output for HTTP requests and responses.
///
/// The [PrintFactory] provides static methods to print status, URLs, headers, bodies, and responses
/// for HTTP requests, primarily for debugging purposes. It uses [RequestType] to determine the type of request,
/// [ResponseData] to extract the response and status information, [StatusType] to categorize the status,
/// and [StatusColor] to provide colored output (where supported).
///
/// Methods in this class are typically only active in debug mode ([kDebugMode]).
class PrintFactory{
  /// Prints the status of a request in debug mode.
  ///
  /// Logs detailed status information for the given [url] and [response]. In debug mode, it distinguishes between
  /// error statuses ([StatusType.clientError], [StatusType.serverError]) and successful statuses, printing
  /// colored output and icons on supported platforms (non-web, non-macOS/iOS/Linux), while falling back to
  /// plain text on web and desktop platforms. Error messages are printed if present.
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

  /// Returns a string wrapped in ANSI color codes according to the given [StatusColor].
  /// This is used to colorize terminal output where supported.
  static String _coloredMessage(StatusColor mc, String m) => "${
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

  /// Maps a [StatusType] to its corresponding [StatusColor] for colored output.
  static StatusColor _getStatusColor (StatusType type) =>
    type == StatusType.successful   ? StatusColor.blue   :
    type == StatusType.unsuccessful ? StatusColor.yellow :
    type == StatusType.information  ? StatusColor.green  :
    type == StatusType.redirection  ? StatusColor.cyan   :
    StatusColor.red;

  /// Returns an emoji icon string representing the given [StatusType].
  /// Used for visual distinction of status types in debug output.
  static String _getStatusIcon(StatusType type) =>
    type == StatusType.information   ? '💬' :
    type == StatusType.successful    ? '👍' :
    type == StatusType.unsuccessful  ? '👎' :
    type == StatusType.redirection   ? '♻️' :
    type == StatusType.clientError   ? '⚠️' :
    type == StatusType.serverError   ? '☢️' :
    type == StatusType.exception     ? '❌' :
    '';

  /// Returns a formatted string describing the [RequestType], optionally including an icon.
  /// Used to label requests in debug output.
  static String _typeData(RequestType type, bool icons) =>
    type == RequestType.get       ? "GET ––--–-→ ${icons ? "💬" : ""}" :
    type == RequestType.post      ? "POST –--–-→ ${icons ? "💾" : ""}" :
    type == RequestType.put       ? "PUT ––--–-→ ${icons ? "📩" : ""}" :
    type == RequestType.patch     ? "PATCH –-–-→ ${icons ? "📩" : ""}" :
    type == RequestType.head      ? "HEAD -–-–-→ ${icons ? "🫥" : ""}" :
    type == RequestType.read      ? "READ -–-–-→ ${icons ? "👀" : ""}" :
    type == RequestType.delete    ? "DELETE ---→ ${icons ? "🗑️" : ""}" :
    type == RequestType.download  ? "DOWNLOAD -→ ${icons ? "🗂️" : ""}" :
    "";

  /// Prints the request URL to the console in debug mode.
  static void printUrl(final String url) =>
    kDebugMode ? print("- URL: $url") : null;

  /// Prints the request headers as a JSON string in debug mode.
  static void printHeaders(final Map<String, String> headers) =>
    kDebugMode ? print("- Headers: ${json.encode(headers)}") : null;

  /// Prints the request body as a JSON string in debug mode.
  static void printBody({
    required final dynamic body,
    required final List<MultipartFile> files,
    required final bool formData
  }) {
    if(kDebugMode) {
      try{
        if(formData){
          print("- Body (form-data):");
          for (var entry in body.entries) {
            print("  ${entry.key}=${entry.value}/");
          }
          if (files.isNotEmpty) {
            for (var file in files) {
              print("  ${file.field}=multipart-file/");
            }
          }
        } else if(body is Map<String, dynamic> || body is Map<String, String>){
          print("- Body: ${json.encode(body)}");
        } else {
          print("- Body: uncodable");
        }
      } catch(e) {
        print("- Body: uncodable");
      }
    }
  }

  /// Prints the response body as a JSON string (or raw bytes for [Uint8List]) in debug mode.
  static void printResponse(final dynamic response) =>
    kDebugMode ? print("- Response: ${(response is Uint8List) ? response : json.encode(response)}") : null;

}
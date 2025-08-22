library n_request;

import 'dart:typed_data' show Uint8List;
import 'package:http/http.dart' show MultipartFile;
import 'package:n_request/src/enums.dart' show RequestType;
import 'package:n_request/src/models.dart' show ResponseData;
import 'package:n_request/src/request.dart' show NCustomRequest;

export '/src/enums.dart';
export '/src/models.dart';
export '/src/request.dart';
export '/src/socket.dart';

class NRequest{
  final String                url;
  final Map<String, String>?  headers;
  final Map<String, String>?  token;
  final dynamic               body;
  final List<MultipartFile>   files;
  final Duration              timeout;
  final bool                  silent;
  final bool                  formData;
  final bool                  printUrl;
  final bool                  printHeader;
  final bool                  printBody;
  final bool                  printResponse;
  final Function()?           onStart;
  final Function()?           onFinish;

  NRequest(this.url, {
    this.body,
    this.files         = const [],
    this.timeout       = const Duration(minutes: 5),
    this.silent        = false,
    this.formData      = false,
    this.printUrl      = false,
    this.printHeader   = false,
    this.printBody     = false,
    this.printResponse = false,
    this.headers,
    this.token,
    this.onStart,
    this.onFinish,
  });

  Future<ResponseData> _request(RequestType type) async => await NCustomRequest.make(
    type          : type,
    url           : url,
    headers       : headers,
    body          : body,
    files         : files,
    timeout       : timeout,
    token         : token,
    printUrl      : printUrl,
    silent        : silent,
    printHeader   : printHeader,
    printBody     : printBody,
    printResponse : printResponse,
    onStart       : onStart,
    onFinish      : onFinish,
    formData      : files.isNotEmpty ? true : formData
  ).then((value) => value);

  Future<R> download  <R>(Function(Uint8List? data) onValue) async => await NCustomRequest.download(
    url           : url,
    headers       : headers,
    timeout       : timeout,
    token         : token,
    printHeader   : printHeader,
  ).then((value) => onValue.call(value));

  Future<R> get       <R>(Function(ResponseData response) onValue) async => await _request(RequestType.get   ).then((response) async => await onValue.call(response) );
  Future<R> post      <R>(Function(ResponseData response) onValue) async => await _request(RequestType.post  ).then((response) async => await onValue.call(response) );
  Future<R> put       <R>(Function(ResponseData response) onValue) async => await _request(RequestType.put   ).then((response) async => await onValue.call(response) );
  Future<R> delete    <R>(Function(ResponseData response) onValue) async => await _request(RequestType.delete).then((response) async => await onValue.call(response) );
  Future<ResponseData> type ({required RequestType type}) async => await _request(type);
}
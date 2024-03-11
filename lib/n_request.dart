library n_request;

import 'package:http/http.dart';
import 'package:n_request/src/enums.dart';
import 'package:n_request/src/models.dart';
import 'package:n_request/src/request.dart';

export '/src/enums.dart';
export '/src/models.dart';
export '/src/request.dart';

class NRequest{
  final String                url;
  final Map<String, String>?  headers;
  final Map<String, String>?  token;
  final Map<String, dynamic>  body;
  final List<MultipartFile>   files;
  final Duration              timeout;
  final bool                  printrequestBody;
  final bool                  printResponseBody;

  NRequest(this.url, {
    this.body               = const <String, dynamic>{},
    this.files              = const [],
    this.timeout            = const Duration(minutes: 5),
    this.printrequestBody   = false,
    this.printResponseBody  = false,
    this.headers,
    this.token,
  });

  Future<ResponseData> _request(RequestType type) async => await NCustomRequest.make(
    type              : type,
    url               : url,
    headers           : headers,
    body              : body,
    files             : files,
    timeout           : timeout,
    token             : token,
    printrequestBody  : printrequestBody,
    printResponseBody : printResponseBody,
  ).then((value) => value);

  Future<R> get    <R>(Function(ResponseData response) onValue) async => await _request(RequestType.get   ).then((response) async => await onValue.call(response) );
  Future<R> post   <R>(Function(ResponseData response) onValue) async => await _request(RequestType.post  ).then((response) async => await onValue.call(response) );
  Future<R> put    <R>(Function(ResponseData response) onValue) async => await _request(RequestType.put   ).then((response) async => await onValue.call(response) );
  Future<R> delete <R>(Function(ResponseData response) onValue) async => await _request(RequestType.delete).then((response) async => await onValue.call(response) );
  Future<ResponseData> type ({required RequestType type}) async => await _request(type);
}
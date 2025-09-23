library n_request;

import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/application/request_use_case.dart' show RequestUseCase;
import 'package:n_request/src/domain/models/multipart_file.dart' show MultipartFile;
import 'package:n_request/src/infraestructure/adapters/request_adapter.dart' show RequestAdapter;
import 'package:n_request/src/infraestructure/adapters/form_data_adapter.dart' show FormDataAdapter;

export '/src/socket.dart';
export '/src/domain/enums/request_type.dart';
export '/src/domain/models/response_data.dart';
export '/src/domain/models/multipart_file.dart';

class NRequest<R>{
  final String                url;
  final Map<String, String>?  headers;
  final Map<String, String>?  token;
  final dynamic               body;
  final List<MultipartFile>   files;
  final Duration              timeout;
  final bool                  silent;
  final bool                  formData;
  final bool                  printUrl;
  final bool                  printHeaders;
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
    this.printHeaders   = false,
    this.printBody     = false,
    this.printResponse = false,
    this.headers,
    this.token,
    this.onStart,
    this.onFinish,
  });

  Future<ResponseData> _request(RequestType type) async =>
  await RequestUseCase(
    port: (files.isNotEmpty ? true : formData)
    ? FormDataAdapter()
    : RequestAdapter()
  ).make(
    type          : type,
    url           : url,
    headers       : headers,
    body          : body,
    files         : files,
    timeout       : timeout,
    token         : token,
    printUrl      : printUrl,
    silent        : silent,
    printHeaders  : printHeaders,
    printBody     : printBody,
    printResponse : printResponse,
    onStart       : onStart,
    onFinish      : onFinish,
  ).then((value) => value);


  Future<R> download (Function(ResponseData? response) onValue) async =>
  await _request(RequestType.download).then((response) async =>
    await onValue.call(response)
  );

  Future<R> get (Function(ResponseData response) onValue) async =>
  await _request(RequestType.get).then((response) async =>
    await onValue.call(response)
  );

  Future<R> post (Function(ResponseData response) onValue) async =>
  await _request(RequestType.post).then((response) async =>
    await onValue.call(response)
  );

  Future<R> put (Function(ResponseData response) onValue) async =>
  await _request(RequestType.put).then((response) async =>
    await onValue.call(response)
  );

  Future<R> patch (Function(ResponseData response) onValue) async =>
  await _request(RequestType.patch).then((response) async =>
    await onValue.call(response)
  );

  Future<R> delete (Function(ResponseData response) onValue) async =>
  await _request(RequestType.delete).then((response) async =>
    await onValue.call(response)
  );

  Future<ResponseData> type ({required RequestType type}) async => await _request(type);
}
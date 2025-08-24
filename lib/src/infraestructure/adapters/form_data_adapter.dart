import 'dart:io' show SocketException;
import 'dart:async' show TimeoutException;

import 'package:http/http.dart' show ClientException, MultipartFile, MultipartRequest;
import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/infraestructure/ports/request_port.dart' show RequestPort;
import 'package:n_request/src/infraestructure/factory/response_factory.dart' show ResponseFactory;

class FormDataAdapter implements RequestPort{

  @override
  Future<ResponseData> get({
    required final Map<String, String> headers,
    required final String url,
    required final Duration timeout,
    required final List<MultipartFile> files,
  }) async =>
  await _formData(
    headers : headers,
    url     : url,
    body    : null,
    type    : RequestType.get,
    timeout : timeout,
    files   : files,
  );

  @override
  post({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  }) async =>
  await _formData(
    headers : headers,
    url     : url,
    body    : body,
    type    : RequestType.post,
    timeout : timeout,
    files   : files,
  );

  @override
  put({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  }) async =>
  await _formData(
    headers : headers,
    url     : url,
    body    : body,
    type    : RequestType.put,
    timeout : timeout,
    files   : files,
  );

  @override
  delete({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  }) async =>
  await _formData(
    headers : headers,
    url     : url,
    body    : body,
    type    : RequestType.delete,
    timeout : timeout,
    files   : files,
  );

  @override
  download({required Map<String, String> headers, required String url}) {
    throw UnimplementedError();
  }


  Future<ResponseData> _formData({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final RequestType type,
    required final Duration timeout,
    required final List<MultipartFile> files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    try {
      Map<String, String> data = <String, String>{};
      body.forEach((key, value) => data[key] = value.toString());

      MultipartRequest multipartRequest = MultipartRequest(
        type.name.toUpperCase(),
        Uri.parse(url)
      )
      ..headers.addAll(headers)
      ..fields.addAll(data);

      for (var file in files){ multipartRequest.files.add(file); }

      return await multipartRequest.send().then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : body
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    on ClientException  { return responseFactory.clientException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type); }
  }
}
import 'dart:io' show HttpClient, HttpException, HttpHeaders, SocketException;
import 'dart:async' show TimeoutException;

import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/domain/models/multipart_file.dart' show MultipartFile;
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
  patch({
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
    type    : RequestType.patch,
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
      if (body != null) body.forEach((key, value) => data[key] = value.toString());

      // Generate boundary
      final String boundary = '----nRequestBoundary${DateTime.now().millisecondsSinceEpoch}';

      return await HttpClient().openUrl( type.name.toUpperCase(), Uri.parse(url) ).then((request) async {

        // Set headers
        headers.forEach((key, value) {
          request.headers.set(key, value);
        });

        request.headers.set(HttpHeaders.contentTypeHeader, 'multipart/form-data; boundary=$boundary');

        // Build multipart body
        // Write fields
        for (final entry in data.entries) {
          request.write('--$boundary\r\n');
          request.write('Content-Disposition: form-data; name="${entry.key}"\r\n\r\n');
          request.write('${entry.value}\r\n');
        }

        // Write files
        return await Future(() async{
          for (final file in files) {
            request.write('--$boundary\r\n');
            request.write('Content-Disposition: form-data; name="${file.field}"; filename="${file.filename ?? 'file'}"\r\n');
            request.write('Content-Type: ${file.contentType}\r\n\r\n');
            await file.finalize().fold<List<int>>(<int>[], (a, b) => a..addAll(b)).then((bytes) {
              request.add(bytes);
            }).then((_) { request.write('\r\n'); });
          }
        }).then((_) async {

          request.write('--$boundary--\r\n');

          // Send the request
          return await request.close().timeout(timeout).then((response) async =>
            await responseFactory.make(
              type      : type,
              response  : response,
              url       : url,
              body      : body
            )
          );
        });
      });
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    on HttpException    { return responseFactory.onError(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type); }
  }
}
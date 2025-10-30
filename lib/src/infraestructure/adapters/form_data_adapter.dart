import 'dart:async' show TimeoutException;
import 'dart:io' show SocketException, HandshakeException;
import 'package:http/http.dart' show MultipartFile, MultipartRequest, Response, ClientException;

import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/infraestructure/ports/request_port.dart' show RequestPort;
import 'package:n_request/src/infraestructure/factory/response_factory.dart' show ResponseFactory;


/// [FormDataAdapter] is an implementation of [RequestPort] that handles HTTP requests
/// involving form data and file uploads using multipart/form-data encoding.
///
/// It supports all standard HTTP methods ([RequestType]) and processes file uploads
/// via [MultipartFile]. The responses are built using [ResponseFactory].
///
/// This adapter is typically used internally by the request infrastructure to handle
/// requests that require multipart form data, such as file uploads.
class FormDataAdapter implements RequestPort{

  /// Sends an HTTP GET request with optional headers and multipart files.
  ///
  /// [headers]: HTTP headers to include in the request.
  /// [url]: The target URL.
  /// [timeout]: Timeout duration for the request.
  /// [files]: List of [MultipartFile] to attach to the request.
  ///
  /// Returns a [Future] of [ResponseData].
  @override
  Future<ResponseData> get({
    required final Map<String, String>? headers,
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

  /// Sends an HTTP POST request with body, headers, and multipart files.
  ///
  /// [headers]: HTTP headers to include.
  /// [url]: The target URL.
  /// [body]: The form data fields (as key-value pairs).
  /// [timeout]: Timeout duration.
  /// [files]: List of [MultipartFile] to attach.
  ///
  /// Returns a [Future] of [ResponseData].
  @override
  post({
    required final Map<String, String>? headers,
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

  /// Sends an HTTP PUT request with body, headers, and multipart files.
  ///
  /// [headers]: HTTP headers to include.
  /// [url]: The target URL.
  /// [body]: The form data fields (as key-value pairs).
  /// [timeout]: Timeout duration.
  /// [files]: List of [MultipartFile] to attach.
  ///
  /// Returns a [Future] of [ResponseData].
  @override
  put({
    required final Map<String, String>? headers,
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

  /// Sends an HTTP PATCH request with body, headers, and multipart files.
  ///
  /// [headers]: HTTP headers to include.
  /// [url]: The target URL.
  /// [body]: The form data fields (as key-value pairs).
  /// [timeout]: Timeout duration.
  /// [files]: List of [MultipartFile] to attach.
  ///
  /// Returns a [Future] of [ResponseData].
  @override
  patch({
    required final Map<String, String>? headers,
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

  /// Sends an HTTP DELETE request with body, headers, and multipart files.
  ///
  /// [headers]: HTTP headers to include.
  /// [url]: The target URL.
  /// [body]: The form data fields (as key-value pairs).
  /// [timeout]: Timeout duration.
  /// [files]: List of [MultipartFile] to attach.
  ///
  /// Returns a [Future] of [ResponseData].
  @override
  delete({
    required final Map<String, String>? headers,
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

  /// Sends an HTTP HEAD request with headers and multipart files.
  ///
  /// [headers]: HTTP headers to include.
  /// [url]: The target URL.
  /// [timeout]: Timeout duration.
  /// [files]: List of [MultipartFile] to attach.
  ///
  /// Returns a [Future] of [ResponseData].
  @override
  Future<ResponseData> head({
    required final Map<String, String>? headers,
    required final String url,
    required final Duration timeout,
    required final List<MultipartFile> files,
  }) async =>
  await _formData(
    headers : headers,
    url     : url,
    body    : null,
    type    : RequestType.head,
    timeout : timeout,
    files   : files,
  );

  /// Sends an HTTP READ request with headers and multipart files.
  ///
  /// [headers]: HTTP headers to include.
  /// [url]: The target URL.
  /// [timeout]: Timeout duration.
  /// [files]: List of [MultipartFile] to attach.
  ///
  /// Returns a [Future] of [ResponseData].
  @override
  Future<ResponseData> read({
    required final Map<String, String>? headers,
    required final String url,
    required final Duration timeout,
    required final List<MultipartFile> files,
  }) async =>
  await _formData(
    headers : headers,
    url     : url,
    body    : null,
    type    : RequestType.read,
    timeout : timeout,
    files   : files,
  );

  /// Throws [UnimplementedError] for download requests as file downloads
  /// are not supported by [FormDataAdapter].
  ///
  /// [headers]: HTTP headers to include.
  /// [url]: The target URL.
  @override
  download({required Map<String, String>? headers, required String url}) {
    throw UnimplementedError();
  }

  /// Handles the construction and sending of a multipart/form-data HTTP request.
  ///
  /// [headers]: HTTP headers to include.
  /// [url]: The target URL for the request.
  /// [body]: Form fields to include in the request body (as key-value pairs).
  /// [type]: The [RequestType] (GET, POST, PUT, etc.).
  /// [timeout]: Timeout duration for the request.
  /// [files]: List of [MultipartFile] to attach as files.
  ///
  /// Returns a [Future] of [ResponseData] created by [ResponseFactory].
  ///
  /// ---
  /// Flow summary:
  /// 1. Prepare request body fields from [body] if present.
  /// 2. Build a [http.MultipartRequest] with the specified [RequestType] and [url].
  /// 3. Attach [headers] and form [fields] to the request.
  /// 4. For each [MultipartFile] in [files], read its bytes and add to the request.
  /// 5. Send the request, wait for the response, and process it through [ResponseFactory].
  Future<ResponseData> _formData({
    required final Map<String, String>? headers,
    required final String url,
    required final dynamic body,
    required final RequestType type,
    required final Duration timeout,
    required final List<MultipartFile> files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    try {
      Map<String, String> data = <String, String>{};

      if (body != null) {
        if (body is Map) {
          body.forEach((key, value) => data[key.toString()] = value.toString());
        } else {
          throw ArgumentError('Body must be a Map for multipart/form-data');
        }
      }

      final request = MultipartRequest(type.name.toUpperCase(), Uri.parse(url));
      if(headers != null) request.headers.addAll(headers);
      request.fields.addAll(data);
      if (!request.headers.containsKey('Content-Type')) request.headers['Content-Type'] = 'multipart/form-data';

      for (final file in files) {
        final bytes = await file.finalize().fold<List<int>>(<int>[], (a, b) => a..addAll(b));
        request.files.add(
          MultipartFile.fromBytes(
            file.field,
            bytes,
            filename    : file.filename ?? 'file',
            contentType : file.contentType,
          ),
        );
      }

      return await request.send().timeout(timeout).then((streamedResponse) async =>
        await Response.fromStream(streamedResponse).then((response) async =>
          await responseFactory.make(
            type     : type,
            response : response,
            url      : url,
            body     : body,
          )
        )
      );
    }
    on SocketException    { return responseFactory.socketException  (url: url, type: type); }
    on HandshakeException { return responseFactory.sslException     (url: url, type: type); }
    on TimeoutException   { return responseFactory.timeoutException (url: url, type: type, timeout: timeout); }
    on ClientException    { return responseFactory.clientException  (url: url, type: type); }
    catch (error)         { return responseFactory.onError          (url: url, type: type, error: error); }
  }

}
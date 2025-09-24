library n_request;

import 'package:http/http.dart' show MultipartFile;
import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/application/request_use_case.dart' show RequestUseCase;
import 'package:n_request/src/infraestructure/adapters/request_adapter.dart' show RequestAdapter;
import 'package:n_request/src/infraestructure/adapters/form_data_adapter.dart' show FormDataAdapter;

export 'package:n_request/src/socket.dart';
export 'package:n_request/src/domain/enums/request_type.dart';
export 'package:n_request/src/domain/models/response_data.dart';

/// A configurable HTTP request builder and executor.
///
/// [NRequest] provides a flexible way to prepare and execute HTTP requests, supporting various request types ([RequestType]),
/// headers, tokens, body data, file uploads ([MultipartFile]), and more. It chooses between [RequestAdapter] and [FormDataAdapter]
/// depending on whether files or form data is involved. The result is returned as a [ResponseData] object.
///
/// This class is typically used with [RequestUseCase] to perform HTTP operations, and can be customized with callbacks and logging options.
class NRequest<R>{
  /// The target URL for the HTTP request.
  final String url;

  /// Optional HTTP headers to include in the request.
  final Map<String, String>? headers;

  /// Optional authentication tokens to include in the request.
  final Map<String, String>? token;

  /// The body of the request, which can be any serializable object.
  final dynamic body;

  /// A list of files ([MultipartFile]) to upload with the request.
  final List<MultipartFile> files;

  /// The maximum duration to wait for the request to complete.
  final Duration timeout;

  /// If true, suppresses error messages and logs for a silent request.
  final bool silent;

  /// If true, sends the request as form data ([FormDataAdapter]); otherwise uses [RequestAdapter].
  final bool formData;

  /// If true, prints the request URL for debugging.
  final bool printUrl;

  /// If true, prints the request headers for debugging.
  final bool printHeaders;

  /// If true, prints the request body for debugging.
  final bool printBody;

  /// If true, prints the response for debugging.
  final bool printResponse;

  /// Optional callback executed before the request starts.
  final Function()? onStart;

  /// Optional callback executed after the request finishes.
  final Function()? onFinish;

  /// Constructs a new [NRequest] for the given [url], with optional configuration parameters.
  ///
  /// Use the optional parameters to customize the request's body, files, timeout, headers, tokens, logging, and lifecycle callbacks.
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

  /// Internal method to delegate the HTTP request to [RequestUseCase].
  ///
  /// Chooses [FormDataAdapter] if [files] are provided or [formData] is true; otherwise uses [RequestAdapter].
  /// Returns a [ResponseData] representing the HTTP response.
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


  /// Downloads data using [RequestType.download].
  ///
  /// Invokes the [onValue] callback with the [ResponseData?] from the download operation.
  /// Returns a [Future] of type [R].
  Future<R> download (Function(ResponseData? response) onValue) async =>
    await _request(RequestType.download).then((response) async =>
      await onValue.call(response)
    );

  /// Sends a GET request ([RequestType.get]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the GET operation.
  /// Returns a [Future] of type [R].
  Future<R> get (Function(ResponseData response) onValue) async =>
    await _request(RequestType.get).then((response) async =>
      await onValue.call(response)
    );

  /// Sends a POST request ([RequestType.post]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the POST operation.
  /// Returns a [Future] of type [R].
  Future<R> post (Function(ResponseData response) onValue) async =>
    await _request(RequestType.post).then((response) async =>
      await onValue.call(response)
    );

  /// Sends a PUT request ([RequestType.put]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the PUT operation.
  /// Returns a [Future] of type [R].
  Future<R> put (Function(ResponseData response) onValue) async =>
    await _request(RequestType.put).then((response) async =>
      await onValue.call(response)
    );

  /// Sends a PATCH request ([RequestType.patch]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the PATCH operation.
  /// Returns a [Future] of type [R].
  Future<R> patch (Function(ResponseData response) onValue) async =>
    await _request(RequestType.patch).then((response) async =>
      await onValue.call(response)
    );

  /// Sends a HEAD request ([RequestType.head]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the HEAD operation.
  /// Returns a [Future] of type [R].
  Future<R> head (Function(ResponseData response) onValue) async =>
    await _request(RequestType.head).then((response) async =>
      await onValue.call(response)
    );

  /// Sends a READ request ([RequestType.read]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the READ operation.
  /// Returns a [Future] of type [R].
  Future<R> read (Function(ResponseData response) onValue) async =>
    await _request(RequestType.read).then((response) async =>
      await onValue.call(response)
    );

  /// Sends a DELETE request ([RequestType.delete]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the DELETE operation.
  /// Returns a [Future] of type [R].
  Future<R> delete (Function(ResponseData response) onValue) async =>
    await _request(RequestType.delete).then((response) async =>
      await onValue.call(response)
    );

  /// Sends a request using the specified [type] ([RequestType]).
  ///
  /// Returns the [ResponseData] from the HTTP operation.
  Future<ResponseData> type ({required RequestType type}) async => await _request(type);
}
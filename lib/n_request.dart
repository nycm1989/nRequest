library n_request;

import 'package:http/http.dart' show MultipartFile;
import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/application/request_use_case.dart' show RequestUseCase;
import 'package:n_request/src/application/response_handler.dart' show ResponseHandler;
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
/// A configurable HTTP request builder and executor.
///
/// The [NRequest] class provides a flexible interface for constructing and executing HTTP requests.
/// It supports various HTTP methods, custom headers, authentication tokens, request bodies, file uploads,
/// request/response logging, and lifecycle callbacks. Depending on the presence of files or the [formData] flag,
/// it uses either [RequestAdapter] or [FormDataAdapter] for the underlying request.
///
/// The response is returned as a [ResponseData] object and can be handled with custom callbacks for specific HTTP status codes.
class NRequest<R> {
  late final ResponseHandler<R> _responseHandler;

  /// The target URL for the HTTP request.
  final String url;

  /// Optional HTTP headers to include in the request.
  final Map<String, String>? headers;

  /// Optional authentication tokens to include in the request.
  final Map<String, String>? token;

  /// The request body, which can be any serializable object.
  final dynamic body;

  /// A list of files ([MultipartFile]) to upload with the request.
  final List<MultipartFile> files;

  /// The maximum duration to wait for the request to complete.
  final Duration timeout;

  /// If true, suppresses error messages and logs for a silent request.
  final bool silent;

  /// If true, sends the request as form data ([FormDataAdapter]); otherwise uses [RequestAdapter].
  final bool formData;

  /// If true, prints the request URL for debugging purposes.
  final bool printUrl;

  /// If true, prints the request headers for debugging purposes.
  final bool printHeaders;

  /// If true, prints the request body for debugging purposes.
  final bool printBody;

  /// If true, prints the response for debugging purposes.
  final bool printResponse;

  /// Optional callback executed before the request starts.
  final Function()? onStart;

  /// Optional callback executed after the request finishes.
  final Function()? onFinish;

  /// Creates a new [NRequest] for the specified [url], with optional configuration parameters.
  ///
  /// Use the optional parameters to customize the request's body, files, timeout, headers, tokens, logging, and lifecycle callbacks.
  NRequest({
    required this.url,
    this.body,
    this.files = const [],
    this.timeout = const Duration(minutes: 5),
    this.silent = false,
    this.formData = false,
    this.printUrl = false,
    this.printHeaders = false,
    this.printBody = false,
    this.printResponse = false,
    this.headers,
    this.token,
    this.onStart,
    this.onFinish,
  }) { _responseHandler = ResponseHandler(); }


  /// Executes the HTTP request of the given [type] and returns the [ResponseData].
  ///
  /// Uses [FormDataAdapter] if [files] are provided or [formData] is true; otherwise uses [RequestAdapter].
  /// This method is used internally by the public HTTP method functions.
  Future<ResponseData> _request(RequestType type) async {
    return await RequestUseCase(
      port: (files.isNotEmpty || formData) ? FormDataAdapter() : RequestAdapter(),
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
      formData      : formData,
      printHeaders  : printHeaders,
      printBody     : printBody,
      printResponse : printResponse,
      onStart       : onStart,
      onFinish      : onFinish,
    );
  }


  /// Sends a download request ([RequestType.download]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData?] from the download operation.
  /// Returns a [Future] of type [R].
  Future<R> download(Function(ResponseData? response) onValue) async =>
    await _request(RequestType.download).then((response) {
      _responseHandler.handle(response);
      return onValue.call(response);
    });


  /// Sends a GET request ([RequestType.get]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the GET operation.
  /// Returns a [Future] of type [R].
  Future<R> get(Function(ResponseData response) onValue) async =>
    await _request(RequestType.get).then((response) {
      _responseHandler.handle(response);
      return onValue.call(response);
    });


  /// Sends a POST request ([RequestType.post]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the POST operation.
  /// Returns a [Future] of type [R].
  Future<R> post(Function(ResponseData response) onValue) async =>
    await _request(RequestType.post).then((response) {
      _responseHandler.handle(response);
      return onValue.call(response);
    });


  /// Sends a PUT request ([RequestType.put]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the PUT operation.
  /// Returns a [Future] of type [R].
  Future<R> put(Function(ResponseData response) onValue) async =>
    await _request(RequestType.put).then((response) {
      _responseHandler.handle(response);
      return onValue.call(response);
    });


  /// Sends a PATCH request ([RequestType.patch]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the PATCH operation.
  /// Returns a [Future] of type [R].
  Future<R> patch(Function(ResponseData response) onValue) async =>
    await _request(RequestType.patch).then((response) {
      _responseHandler.handle(response);
      return onValue.call(response);
    });


  /// Sends a HEAD request ([RequestType.head]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the HEAD operation.
  /// Returns a [Future] of type [R].
  Future<R> head(Function(ResponseData response) onValue) async =>
    await _request(RequestType.head).then((response) {
      _responseHandler.handle(response);
      return onValue.call(response);
    });


  /// Sends a READ request ([RequestType.read]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the READ operation.
  /// Returns a [Future] of type [R].
  Future<R> read(Function(ResponseData response) onValue) async =>
    await _request(RequestType.read).then((response) {
      _responseHandler.handle(response);
      return onValue.call(response);
    });


  /// Sends a DELETE request ([RequestType.delete]).
  ///
  /// Invokes the [onValue] callback with the [ResponseData] from the DELETE operation.
  /// Returns a [Future] of type [R].
  Future<R> delete(Function(ResponseData response) onValue) async =>
    await _request(RequestType.delete).then((response) {
      _responseHandler.handle(response);
      return onValue.call(response);
    });


  // --------------------------------------------------------- [CALLBACKS]


  /// Registers a callback for front-end exceptions (status code 0).
  NRequest<R> onFrontEndException(Function(ResponseData response) callback) {
    _responseHandler.onFrontEndException(callback);
    return this;
  }

  /// Registers a callback for HTTP 100 Continue responses.
  NRequest<R> onContinue(Function(ResponseData response) callback) {
    _responseHandler.onContinue(callback);
    return this;
  }

  /// Registers a callback for HTTP 101 Switching Protocols responses.
  NRequest<R> onSwitchingProtocols(Function(ResponseData response) callback) {
    _responseHandler.onSwitchingProtocols(callback);
    return this;
  }

  /// Registers a callback for HTTP 102 Processing responses.
  NRequest<R> onProcessing(Function(ResponseData response) callback) {
    _responseHandler.onProcessing(callback);
    return this;
  }

  /// Registers a callback for HTTP 103 Early Hints responses.
  NRequest<R> onEarlyHints(Function(ResponseData response) callback) {
    _responseHandler.onEarlyHints(callback);
    return this;
  }

  /// Registers a callback for HTTP 200 OK responses.
  NRequest<R> onOK(Function(ResponseData response) callback) {
    _responseHandler.onOK(callback);
    return this;
  }

  /// Registers a callback for HTTP 201 Created responses.
  NRequest<R> onCreated(Function(ResponseData response) callback) {
    _responseHandler.onCreated(callback);
    return this;
  }

  /// Registers a callback for HTTP 202 Accepted responses.
  NRequest<R> onAccepted(Function(ResponseData response) callback) {
    _responseHandler.onAccepted(callback);
    return this;
  }

  /// Registers a callback for HTTP 204 No Content responses.
  NRequest<R> onNoContent(Function(ResponseData response) callback) {
    _responseHandler.onNoContent(callback);
    return this;
  }

  /// Registers a callback for HTTP 203 Non-Authoritative Information responses.
  NRequest<R> onNonAuthoritativeInformation(Function(ResponseData response) callback) {
    _responseHandler.onNonAuthoritativeInformation(callback);
    return this;
  }

  /// Registers a callback for HTTP 205 Reset Content responses.
  NRequest<R> onResetContent(Function(ResponseData response) callback) {
    _responseHandler.onResetContent(callback);
    return this;
  }

  /// Registers a callback for HTTP 206 Partial Content responses.
  NRequest<R> onPartialContent(Function(ResponseData response) callback) {
    _responseHandler.onPartialContent(callback);
    return this;
  }

  /// Registers a callback for HTTP 207 Multi-Status responses.
  NRequest<R> onMultiStatus(Function(ResponseData response) callback) {
    _responseHandler.onMultiStatus(callback);
    return this;
  }

  /// Registers a callback for HTTP 208 Already Reported responses.
  NRequest<R> onAlreadyReported(Function(ResponseData response) callback) {
    _responseHandler.onAlreadyReported(callback);
    return this;
  }

  /// Registers a callback for HTTP 226 IM Used responses.
  NRequest<R> onImUsed(Function(ResponseData response) callback) {
    _responseHandler.onImUsed(callback);
    return this;
  }

  /// Registers a callback for HTTP 300 Multiple Choices responses.
  NRequest<R> onMultipleChoices(Function(ResponseData response) callback) {
    _responseHandler.onMultipleChoices(callback);
    return this;
  }

  /// Registers a callback for HTTP 301 Moved Permanently responses.
  NRequest<R> onMovedPermanently(Function(ResponseData response) callback) {
    _responseHandler.onMovedPermanently(callback);
    return this;
  }

  /// Registers a callback for HTTP 302 Found responses.
  NRequest<R> onFound(Function(ResponseData response) callback) {
    _responseHandler.onFound(callback);
    return this;
  }

  /// Registers a callback for HTTP 303 See Other responses.
  NRequest<R> onSeeOther(Function(ResponseData response) callback) {
    _responseHandler.onSeeOther(callback);
    return this;
  }

  /// Registers a callback for HTTP 304 Not Modified responses.
  NRequest<R> onNotModified(Function(ResponseData response) callback) {
    _responseHandler.onNotModified(callback);
    return this;
  }

  /// Registers a callback for HTTP 305 Use Proxy responses.
  NRequest<R> onUseProxy(Function(ResponseData response) callback) {
    _responseHandler.onUseProxy(callback);
    return this;
  }

  /// Registers a callback for HTTP 306 Unused responses.
  NRequest<R> onUnused(Function(ResponseData response) callback) {
    _responseHandler.onUnused(callback);
    return this;
  }

  /// Registers a callback for HTTP 307 Temporary Redirect responses.
  NRequest<R> onTemporaryRedirect(Function(ResponseData response) callback) {
    _responseHandler.onTemporaryRedirect(callback);
    return this;
  }

  /// Registers a callback for HTTP 308 Permanent Redirect responses.
  NRequest<R> onPermanentRedirect(Function(ResponseData response) callback) {
    _responseHandler.onPermanentRedirect(callback);
    return this;
  }

  /// Registers a callback for HTTP 400 Bad Request responses.
  NRequest<R> onBadRequest(Function(ResponseData response) callback) {
    _responseHandler.onBadRequest(callback);
    return this;
  }

  /// Registers a callback for HTTP 401 Unauthorized responses.
  NRequest<R> onUnauthorized(Function(ResponseData response) callback) {
    _responseHandler.onUnauthorized(callback);
    return this;
  }

  /// Registers a callback for HTTP 402 Payment Required responses.
  NRequest<R> onPaymentRequired(Function(ResponseData response) callback) {
    _responseHandler.onPaymentRequired(callback);
    return this;
  }

  /// Registers a callback for HTTP 403 Forbidden responses.
  NRequest<R> onForbidden(Function(ResponseData response) callback) {
    _responseHandler.onForbidden(callback);
    return this;
  }

  /// Registers a callback for HTTP 404 Not Found responses.
  NRequest<R> onNotFound(Function(ResponseData response) callback) {
    _responseHandler.onNotFound(callback);
    return this;
  }

  /// Registers a callback for HTTP 405 Method Not Allowed responses.
  NRequest<R> onMethodNotAllowed(Function(ResponseData response) callback) {
    _responseHandler.onMethodNotAllowed(callback);
    return this;
  }

  /// Registers a callback for HTTP 406 Not Acceptable responses.
  NRequest<R> onNotAcceptable(Function(ResponseData response) callback) {
    _responseHandler.onNotAcceptable(callback);
    return this;
  }

  /// Registers a callback for HTTP 407 Proxy Authentication Required responses.
  NRequest<R> onProxyAuthenticationRequired(Function(ResponseData response) callback) {
    _responseHandler.onProxyAuthenticationRequired(callback);
    return this;
  }

  /// Registers a callback for HTTP 408 Request Timeout responses.
  NRequest<R> onRequestTimeout(Function(ResponseData response) callback) {
    _responseHandler.onRequestTimeout(callback);
    return this;
  }

  /// Registers a callback for HTTP 409 Conflict responses.
  NRequest<R> onConflict(Function(ResponseData response) callback) {
    _responseHandler.onConflict(callback);
    return this;
  }

  /// Registers a callback for HTTP 410 Gone responses.
  NRequest<R> onGone(Function(ResponseData response) callback) {
    _responseHandler.onGone(callback);
    return this;
  }

  /// Registers a callback for HTTP 411 Length Required responses.
  NRequest<R> onLengthRequired(Function(ResponseData response) callback) {
    _responseHandler.onLengthRequired(callback);
    return this;
  }

  /// Registers a callback for HTTP 412 Precondition Failed responses.
  NRequest<R> onPreconditionFailed(Function(ResponseData response) callback) {
    _responseHandler.onPreconditionFailed(callback);
    return this;
  }

  /// Registers a callback for HTTP 413 Payload Too Large responses.
  NRequest<R> onPayloadTooLarge(Function(ResponseData response) callback) {
    _responseHandler.onPayloadTooLarge(callback);
    return this;
  }

  /// Registers a callback for HTTP 414 URI Too Long responses.
  NRequest<R> onURITooLong(Function(ResponseData response) callback) {
    _responseHandler.onURITooLong(callback);
    return this;
  }

  /// Registers a callback for HTTP 415 Unsupported Media Type responses.
  NRequest<R> onUnsupportedMediaType(Function(ResponseData response) callback) {
    _responseHandler.onUnsupportedMediaType(callback);
    return this;
  }

  /// Registers a callback for HTTP 416 Range Not Satisfiable responses.
  NRequest<R> onRangeNotSatisfiable(Function(ResponseData response) callback) {
    _responseHandler.onRangeNotSatisfiable(callback);
    return this;
  }

  /// Registers a callback for HTTP 417 Expectation Failed responses.
  NRequest<R> onExpectationFailed(Function(ResponseData response) callback) {
    _responseHandler.onExpectationFailed(callback);
    return this;
  }

  /// Registers a callback for HTTP 418 I'm a teapot responses.
  NRequest<R> onImATeapot(Function(ResponseData response) callback) {
    _responseHandler.onImATeapot(callback);
    return this;
  }

  /// Registers a callback for HTTP 421 Misdirected Request responses.
  NRequest<R> onMisdirectedRequest(Function(ResponseData response) callback) {
    _responseHandler.onMisdirectedRequest(callback);
    return this;
  }

  /// Registers a callback for HTTP 422 Unprocessable Content responses.
  NRequest<R> onUnprocessableContent(Function(ResponseData response) callback) {
    _responseHandler.onUnprocessableContent(callback);
    return this;
  }

  /// Registers a callback for HTTP 423 Locked responses.
  NRequest<R> onLocked(Function(ResponseData response) callback) {
    _responseHandler.onLocked(callback);
    return this;
  }

  /// Registers a callback for HTTP 424 Failed Dependency responses.
  NRequest<R> onFailedDependency(Function(ResponseData response) callback) {
    _responseHandler.onFailedDependency(callback);
    return this;
  }

  /// Registers a callback for HTTP 425 Too Early responses.
  NRequest<R> onTooEarly(Function(ResponseData response) callback) {
    _responseHandler.onTooEarly(callback);
    return this;
  }

  /// Registers a callback for HTTP 426 Upgrade Required responses.
  NRequest<R> onUpgradeRequired(Function(ResponseData response) callback) {
    _responseHandler.onUpgradeRequired(callback);
    return this;
  }

  /// Registers a callback for HTTP 428 Precondition Required responses.
  NRequest<R> onPreconditionRequired(Function(ResponseData response) callback) {
    _responseHandler.onPreconditionRequired(callback);
    return this;
  }

  /// Registers a callback for HTTP 429 Too Many Requests responses.
  NRequest<R> onTooManyRequests(Function(ResponseData response) callback) {
    _responseHandler.onTooManyRequests(callback);
    return this;
  }

  /// Registers a callback for HTTP 431 Request Header Fields Too Large responses.
  NRequest<R> onRequestHeaderFieldsTooLarge(Function(ResponseData response) callback) {
    _responseHandler.onRequestHeaderFieldsTooLarge(callback);
    return this;
  }

  /// Registers a callback for HTTP 451 Unavailable For Legal Reasons responses.
  NRequest<R> onUnavailableForLegalReasons(Function(ResponseData response) callback) {
    _responseHandler.onUnavailableForLegalReasons(callback);
    return this;
  }

  /// Registers a callback for HTTP 500 Internal Server Error responses.
  NRequest<R> onInternalServerError(Function(ResponseData response) callback) {
    _responseHandler.onInternalServerError(callback);
    return this;
  }

  /// Registers a callback for HTTP 501 Not Implemented responses.
  NRequest<R> onNotImplemented(Function(ResponseData response) callback) {
    _responseHandler.onNotImplemented(callback);
    return this;
  }

  /// Registers a callback for HTTP 502 Bad Gateway responses.
  NRequest<R> onBadGateway(Function(ResponseData response) callback) {
    _responseHandler.onBadGateway(callback);
    return this;
  }

  /// Registers a callback for HTTP 503 Service Unavailable responses.
  NRequest<R> onServiceUnavailable(Function(ResponseData response) callback) {
    _responseHandler.onServiceUnavailable(callback);
    return this;
  }

  /// Registers a callback for HTTP 504 Gateway Timeout responses.
  NRequest<R> onGatewayTimeout(Function(ResponseData response) callback) {
    _responseHandler.onGatewayTimeout(callback);
    return this;
  }

  /// Registers a callback for HTTP 505 HTTP Version Not Supported responses.
  NRequest<R> onHTTPVersionNotSupported(Function(ResponseData response) callback) {
    _responseHandler.onHTTPVersionNotSupported(callback);
    return this;
  }

  /// Registers a callback for HTTP 506 Variant Also Negotiates responses.
  NRequest<R> onVariantAlsoNegotiates(Function(ResponseData response) callback) {
    _responseHandler.onVariantAlsoNegotiates(callback);
    return this;
  }

  /// Registers a callback for HTTP 507 Insufficient Storage responses.
  NRequest<R> onInsufficientStorage(Function(ResponseData response) callback) {
    _responseHandler.onInsufficientStorage(callback);
    return this;
  }

  /// Registers a callback for HTTP 508 Loop Detected responses.
  NRequest<R> onLoopDetected(Function(ResponseData response) callback) {
    _responseHandler.onLoopDetected(callback);
    return this;
  }

  /// Registers a callback for HTTP 510 Not Extended responses.
  NRequest<R> onNotExtended(Function(ResponseData response) callback) {
    _responseHandler.onNotExtended(callback);
    return this;
  }

  /// Registers a callback for HTTP 511 Network Authentication Required responses.
  NRequest<R> onNetworkAuthenticationRequired(Function(ResponseData response) callback) {
    _responseHandler.onNetworkAuthenticationRequired(callback);
    return this;
  }

  /// Registers a callback for 525 SSL/TLS handshake failed or invalid certificate.
  NRequest<R> onSSLException(Function(ResponseData response) callback) {
    _responseHandler.onSSLException(callback);
    return this;
  }
}
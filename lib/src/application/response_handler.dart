import 'package:n_request/src/domain/models/response_data.dart';

/// Handles HTTP response callbacks based on status codes.
class ResponseHandler<R> {
  final Map<int, Function(ResponseData response)?> _callbacks = {};

  ResponseHandler<R> _register(int code, Function(ResponseData response) callback) {
    _callbacks[code] = callback;
    return this;
  }

  /// Triggered when the status code is 0 - Front-end exception.
  ResponseHandler<R> onFrontEndException(Function(ResponseData response) callback) => _register(0, callback);

  /// Triggered when the status code is 100 - Continue.
  ResponseHandler<R> onContinue(Function(ResponseData response) callback) => _register(100, callback);

  /// Triggered when the status code is 101 - Switching Protocols.
  ResponseHandler<R> onSwitchingProtocols(Function(ResponseData response) callback) => _register(101, callback);

  /// Triggered when the status code is 102 - Processing.
  ResponseHandler<R> onProcessing(Function(ResponseData response) callback) => _register(102, callback);

  /// Triggered when the status code is 103 - Early Hints.
  ResponseHandler<R> onEarlyHints(Function(ResponseData response) callback) => _register(103, callback);

  /// Triggered when the status code is 200 - OK.
  ResponseHandler<R> onOK(Function(ResponseData response) callback) => _register(200, callback);

  /// Triggered when the status code is 201 - Created.
  ResponseHandler<R> onCreated(Function(ResponseData response) callback) => _register(201, callback);

  /// Triggered when the status code is 202 - Accepted.
  ResponseHandler<R> onAccepted(Function(ResponseData response) callback) => _register(202, callback);

  /// Triggered when the status code is 204 - No Content.
  ResponseHandler<R> onNoContent(Function(ResponseData response) callback) => _register(204, callback);

  /// Triggered when the status code is 203 - Non-Authoritative Information.
  ResponseHandler<R> onNonAuthoritativeInformation(Function(ResponseData response) callback) => _register(203, callback);

  /// Triggered when the status code is 205 - Reset Content.
  ResponseHandler<R> onResetContent(Function(ResponseData response) callback) => _register(205, callback);

  /// Triggered when the status code is 206 - Partial Content.
  ResponseHandler<R> onPartialContent(Function(ResponseData response) callback) => _register(206, callback);

  /// Triggered when the status code is 207 - Multi-Status.
  ResponseHandler<R> onMultiStatus(Function(ResponseData response) callback) => _register(207, callback);

  /// Triggered when the status code is 208 - Already Reported.
  ResponseHandler<R> onAlreadyReported(Function(ResponseData response) callback) => _register(208, callback);

  /// Triggered when the status code is 226 - IM Used.
  ResponseHandler<R> onImUsed(Function(ResponseData response) callback) => _register(226, callback);

  /// Triggered when the status code is 300 - Multiple Choices.
  ResponseHandler<R> onMultipleChoices(Function(ResponseData response) callback) => _register(300, callback);

  /// Triggered when the status code is 301 - Moved Permanently.
  ResponseHandler<R> onMovedPermanently(Function(ResponseData response) callback) => _register(301, callback);

  /// Triggered when the status code is 302 - Found.
  ResponseHandler<R> onFound(Function(ResponseData response) callback) => _register(302, callback);

  /// Triggered when the status code is 303 - See Other.
  ResponseHandler<R> onSeeOther(Function(ResponseData response) callback) => _register(303, callback);

  /// Triggered when the status code is 304 - Not Modified.
  ResponseHandler<R> onNotModified(Function(ResponseData response) callback) => _register(304, callback);

  /// Triggered when the status code is 305 - Use Proxy.
  ResponseHandler<R> onUseProxy(Function(ResponseData response) callback) => _register(305, callback);

  /// Triggered when the status code is 306 - Unused (No longer used).
  ResponseHandler<R> onUnused(Function(ResponseData response) callback) => _register(306, callback);

  /// Triggered when the status code is 307 - Temporary Redirect.
  ResponseHandler<R> onTemporaryRedirect(Function(ResponseData response) callback) => _register(307, callback);

  /// Triggered when the status code is 308 - Permanent Redirect.
  ResponseHandler<R> onPermanentRedirect(Function(ResponseData response) callback) => _register(308, callback);

  /// Triggered when the status code is 400 - Bad Request.
  ResponseHandler<R> onBadRequest(Function(ResponseData response) callback) => _register(400, callback);

  /// Triggered when the status code is 401 - Unauthorized.
  ResponseHandler<R> onUnauthorized(Function(ResponseData response) callback) => _register(401, callback);

  /// Triggered when the status code is 402 - Payment Required.
  ResponseHandler<R> onPaymentRequired(Function(ResponseData response) callback) => _register(402, callback);

  /// Triggered when the status code is 403 - Forbidden.
  ResponseHandler<R> onForbidden(Function(ResponseData response) callback) => _register(403, callback);

  /// Triggered when the status code is 404 - Not Found.
  ResponseHandler<R> onNotFound(Function(ResponseData response) callback) => _register(404, callback);

  /// Triggered when the status code is 405 - Method Not Allowed.
  ResponseHandler<R> onMethodNotAllowed(Function(ResponseData response) callback) => _register(405, callback);

  /// Triggered when the status code is 406 - Not Acceptable.
  ResponseHandler<R> onNotAcceptable(Function(ResponseData response) callback) => _register(406, callback);

  /// Triggered when the status code is 407 - Proxy Authentication Required.
  ResponseHandler<R> onProxyAuthenticationRequired(Function(ResponseData response) callback) => _register(407, callback);

  /// Triggered when the status code is 408 - Request Timeout.
  ResponseHandler<R> onRequestTimeout(Function(ResponseData response) callback) => _register(408, callback);

  /// Triggered when the status code is 409 - Conflict.
  ResponseHandler<R> onConflict(Function(ResponseData response) callback) => _register(409, callback);

  /// Triggered when the status code is 410 - Gone.
  ResponseHandler<R> onGone(Function(ResponseData response) callback) => _register(410, callback);

  /// Triggered when the status code is 411 - Length Required.
  ResponseHandler<R> onLengthRequired(Function(ResponseData response) callback) => _register(411, callback);

  /// Triggered when the status code is 412 - Precondition Failed.
  ResponseHandler<R> onPreconditionFailed(Function(ResponseData response) callback) => _register(412, callback);

  /// Triggered when the status code is 413 - Payload Too Large.
  ResponseHandler<R> onPayloadTooLarge(Function(ResponseData response) callback) => _register(413, callback);

  /// Triggered when the status code is 414 - URI Too Long.
  ResponseHandler<R> onURITooLong(Function(ResponseData response) callback) => _register(414, callback);

  /// Triggered when the status code is 415 - Unsupported Media Type.
  ResponseHandler<R> onUnsupportedMediaType(Function(ResponseData response) callback) => _register(415, callback);

  /// Triggered when the status code is 416 - Range Not Satisfiable.
  ResponseHandler<R> onRangeNotSatisfiable(Function(ResponseData response) callback) => _register(416, callback);

  /// Triggered when the status code is 417 - Expectation Failed.
  ResponseHandler<R> onExpectationFailed(Function(ResponseData response) callback) => _register(417, callback);

  /// Triggered when the status code is 418 - I'm a Teapot.
  ResponseHandler<R> onImATeapot(Function(ResponseData response) callback) => _register(418, callback);

  /// Triggered when the status code is 421 - Misdirected Request.
  ResponseHandler<R> onMisdirectedRequest(Function(ResponseData response) callback) => _register(421, callback);

  /// Triggered when the status code is 422 - Unprocessable Content.
  ResponseHandler<R> onUnprocessableContent(Function(ResponseData response) callback) => _register(422, callback);

  /// Triggered when the status code is 423 - Locked.
  ResponseHandler<R> onLocked(Function(ResponseData response) callback) => _register(423, callback);

  /// Triggered when the status code is 424 - Failed Dependency.
  ResponseHandler<R> onFailedDependency(Function(ResponseData response) callback) => _register(424, callback);

  /// Triggered when the status code is 425 - Too Early.
  ResponseHandler<R> onTooEarly(Function(ResponseData response) callback) => _register(425, callback);

  /// Triggered when the status code is 426 - Upgrade Required.
  ResponseHandler<R> onUpgradeRequired(Function(ResponseData response) callback) => _register(426, callback);

  /// Triggered when the status code is 428 - Precondition Required.
  ResponseHandler<R> onPreconditionRequired(Function(ResponseData response) callback) => _register(428, callback);

  /// Triggered when the status code is 429 - Too Many Requests.
  ResponseHandler<R> onTooManyRequests(Function(ResponseData response) callback) => _register(429, callback);

  /// Triggered when the status code is 431 - Request Header Fields Too Large.
  ResponseHandler<R> onRequestHeaderFieldsTooLarge(Function(ResponseData response) callback) => _register(431, callback);

  /// Triggered when the status code is 451 - Unavailable For Legal Reasons.
  ResponseHandler<R> onUnavailableForLegalReasons(Function(ResponseData response) callback) => _register(451, callback);

  /// Triggered when the status code is 500 - Internal Server Error.
  ResponseHandler<R> onInternalServerError(Function(ResponseData response) callback) => _register(500, callback);

  /// Triggered when the status code is 501 - Not Implemented.
  ResponseHandler<R> onNotImplemented(Function(ResponseData response) callback) => _register(501, callback);

  /// Triggered when the status code is 502 - Bad Gateway.
  ResponseHandler<R> onBadGateway(Function(ResponseData response) callback) => _register(502, callback);

  /// Triggered when the status code is 503 - Service Unavailable.
  ResponseHandler<R> onServiceUnavailable(Function(ResponseData response) callback) => _register(503, callback);

  /// Triggered when the status code is 504 - Gateway Timeout.
  ResponseHandler<R> onGatewayTimeout(Function(ResponseData response) callback) => _register(504, callback);

  /// Triggered when the status code is 505 - HTTP Version Not Supported.
  ResponseHandler<R> onHTTPVersionNotSupported(Function(ResponseData response) callback) => _register(505, callback);

  /// Triggered when the status code is 506 - Variant Also Negotiates.
  ResponseHandler<R> onVariantAlsoNegotiates(Function(ResponseData response) callback) => _register(506, callback);

  /// Triggered when the status code is 507 - Insufficient Storage.
  ResponseHandler<R> onInsufficientStorage(Function(ResponseData response) callback) => _register(507, callback);

  /// Triggered when the status code is 508 - Loop Detected.
  ResponseHandler<R> onLoopDetected(Function(ResponseData response) callback) => _register(508, callback);

  /// Triggered when the status code is 510 - Not Extended.
  ResponseHandler<R> onNotExtended(Function(ResponseData response) callback) => _register(510, callback);

  /// Triggered when the status code is 511 - Network Authentication Required.
  ResponseHandler<R> onNetworkAuthenticationRequired(Function(ResponseData response) callback) => _register(511, callback);

  /// Triggered when the status code is 525 - SSL/TLS handshake failed or invalid certificate.
  ResponseHandler<R> onSSLException(Function(ResponseData response) callback) => _register(525, callback);


  /// Executes the callback corresponding to the response status code, if any.
  void handle(ResponseData response) {
    final callback = _callbacks[response.status.code];
    if (callback != null) callback(response);
  }
}
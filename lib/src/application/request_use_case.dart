import 'package:http/http.dart' show MultipartFile;
import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/infraestructure/ports/request_port.dart' show RequestPort;
import 'package:n_request/src/infraestructure/factory/print_factory.dart' show PrintFactory;
import 'package:n_request/src/infraestructure/factory/response_factory.dart' show ResponseFactory;
import 'package:n_request/src/infraestructure/repositories/header_repository.dart' show HeaderRepository;
import 'package:n_request/src/infraestructure/repositories/forbidden_repository.dart' show ForbiddenRepository;

/// The [RequestUseCase] class is responsible for executing HTTP requests using the provided [RequestPort] implementation.
/// It supports multiple HTTP methods defined by [RequestType], and returns a [ResponseData] object.
/// This use case handles request headers via [HeaderRepository], checks forbidden URLs using [ForbiddenRepository],
/// and manages response creation with [ResponseFactory]. It also supports debug printing through [PrintFactory].
class RequestUseCase{
  /// Creates a [RequestUseCase] with the required [RequestPort] implementation.
  RequestUseCase({required this.port});

  final RequestPort port;

  /// Executes an HTTP request of the specified [RequestType].
  ///
  /// Parameters:
  /// - [url]: The URL to send the request to.
  /// - [type]: The HTTP method type (GET, POST, PUT, PATCH, DELETE, DOWNLOAD).
  /// - [onStart]: Optional callback invoked before the request starts.
  /// - [onFinish]: Optional callback invoked after the request finishes.
  /// - [headers]: Optional custom headers to include in the request.
  /// - [token]: Optional token headers to include in the request.
  /// - [files]: Optional list of files to upload (for multipart requests).
  /// - [timeout]: Duration before the request times out (default 5 minutes).
  /// - [body]: Optional request body.
  /// - [silent]: If true, suppresses printing debug information.
  /// - [printUrl]: If true, prints the request URL.
  /// - [printHeaders]: If true, prints the request headers.
  /// - [printBody]: If true, prints the request body.
  /// - [printResponse]: If true, prints the response body.
  ///
  /// Returns a [ResponseData] object representing the HTTP response.
  ///
  /// Uses [ResponseFactory] to handle forbidden URL responses and [PrintFactory] for optional debug printing.
  Future<ResponseData> make({
    required final String       url,
    required final RequestType  type,
    final Function()? onStart,
    final Function()? onFinish,
    final Map<String, String>?  headers,
    final Map<String, String>?  token,
    final List<MultipartFile>   files         = const [],
    final Duration              timeout       = const Duration(minutes: 5),
    final dynamic body,
    required final bool silent,
    required final bool printUrl,
    required final bool printHeaders,
    required final bool printBody,
    required final bool printResponse,
  }) async {
    if(!_isValidUrl(url)) throw FormatException("Invalid URL");
    if(_forbidenChecking(url)) return ResponseFactory().forbidden(url: url, type: type);

    final Map<String, String> _headers =
    headers == null
    ? HeaderRepository().corsHeaders
    : headers;

    if(token   != null) _headers.addAll(token);
    if(onStart != null) onStart.call();

    return await Future<ResponseData>(() async {

      if(type == RequestType.get) {
        return port.get(
          headers : _headers,
          url     : url,
          timeout : timeout,
          files   : files
        );
      }

      else if(type == RequestType.post) {
        return port.post(
          headers : _headers,
          url     : url,
          body    : body,
          timeout : timeout,
          files   : files
        );
      }

      else if(type == RequestType.put) {
        return port.put(
          headers : _headers,
          url     : url,
          body    : body,
          timeout : timeout,
          files   : files
        );
      }

      else if(type == RequestType.patch) {
        return port.patch(
          headers : _headers,
          url     : url,
          body    : body,
          timeout : timeout,
          files   : files
        );
      }

      else if(type == RequestType.delete) {
        return port.delete(
          headers : _headers,
          url     : url,
          body    : body,
          timeout : timeout,
          files   : files
        );
      }

      else if(type == RequestType.head) {
        return port.head(
          headers : _headers,
          url     : url,
          timeout : timeout,
          files   : files
        );
      }

      else if(type == RequestType.read) {
        return port.read(
          headers : _headers,
          url     : url,
          timeout : timeout,
          files   : files
        );
      }

      else {
        return port.download(
          headers : _headers,
          url     : url,
        );
      }

    }).then((response) {
      if(silent) return response;

      PrintFactory.printStatus(url, response);
      if(printUrl)      PrintFactory.printUrl(url);
      if(printHeaders)  PrintFactory.printHeaders(_headers);
      if(printBody)     PrintFactory.printBody(body);
      if(printResponse) PrintFactory.printResponse(response.body);

      return response;
    });

  }

  /// Checks if the given [url] contains any forbidden patterns defined by [ForbiddenRepository].
  static bool _forbidenChecking(String url) => url.contains(ForbiddenRepository().toString());

  /// Validates that the [url] is a well-formed absolute URI with allowed schemes (http, https, ws, wss).
  static bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) return false;
    const allowedSchemes = {'http', 'https', 'ws', 'wss'};
    return allowedSchemes.contains(uri.scheme) && uri.host.isNotEmpty;
  }
}
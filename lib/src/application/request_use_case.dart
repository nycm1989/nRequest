import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/domain/models/multipart_file.dart' show MultipartFile;
import 'package:n_request/src/infraestructure/ports/request_port.dart' show RequestPort;
import 'package:n_request/src/infraestructure/factory/print_factory.dart' show PrintFactory;
import 'package:n_request/src/infraestructure/factory/response_factory.dart' show ResponseFactory;
import 'package:n_request/src/infraestructure/repositories/forbidden_repository.dart' show ForbiddenRepository;
import 'package:n_request/src/infraestructure/repositories/header_repository.dart' show HeaderRepository;

class RequestUseCase{
  final RequestPort port;
  RequestUseCase({required this.port});

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

  static bool _forbidenChecking(String url) => url.contains(ForbiddenRepository().toString());

  static bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) return false;
    const allowedSchemes = {'http', 'https', 'ws', 'wss'};
    return allowedSchemes.contains(uri.scheme) && uri.host.isNotEmpty;
  }
}
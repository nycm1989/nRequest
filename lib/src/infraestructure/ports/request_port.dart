import 'package:http/http.dart' show MultipartFile;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;

abstract class RequestPort {
  Future<ResponseData> get({
    required final Map<String, String> headers,
    required final String url,
    required final Duration timeout,
    required final List<MultipartFile> files,
  });

  Future<ResponseData> post({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  });

  Future<ResponseData> put({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  });

  Future<ResponseData> delete({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  });

  Future<ResponseData> download({
    required final Map<String, String> headers,
    required final String url
  });
}
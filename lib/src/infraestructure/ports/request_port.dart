/// An abstract class defining the contract for HTTP request operations.
///
/// [RequestPort] provides method signatures for various HTTP request types,
/// such as GET, POST, PUT, PATCH, DELETE, HEAD, READ, and DOWNLOAD.
/// Implementations of this class are expected to perform network requests
/// and return [ResponseData] objects representing the server's response.
import 'package:http/http.dart' show MultipartFile;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;

abstract class RequestPort {
  /// Sends an HTTP GET request to the specified [url] with the given [headers].
  ///
  /// The [timeout] parameter specifies the maximum duration to wait for a response.
  /// The optional [files] parameter allows including multipart files in the request.
  /// Returns a [ResponseData] object containing the server's response.
  Future<ResponseData> get ({
    required final Map<String, String> headers,
    required final String url,
    required final Duration timeout,
    required final List<MultipartFile> files,
  });

  /// Sends an HTTP POST request to the specified [url] with the given [headers] and [body].
  ///
  /// The [timeout] parameter specifies the maximum duration to wait for a response.
  /// The optional [files] parameter allows including multipart files in the request.
  /// Returns a [ResponseData] object containing the server's response.
  Future<ResponseData> post ({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  });

  /// Sends an HTTP PUT request to the specified [url] with the given [headers] and [body].
  ///
  /// The [timeout] parameter specifies the maximum duration to wait for a response.
  /// The optional [files] parameter allows including multipart files in the request.
  /// Returns a [ResponseData] object containing the server's response.
  Future<ResponseData> put ({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  });

  /// Sends an HTTP PATCH request to the specified [url] with the given [headers] and [body].
  ///
  /// The [timeout] parameter specifies the maximum duration to wait for a response.
  /// The optional [files] parameter allows including multipart files in the request.
  /// Returns a [ResponseData] object containing the server's response.
  Future<ResponseData> patch ({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  });

  /// Sends an HTTP DELETE request to the specified [url] with the given [headers] and [body].
  ///
  /// The [timeout] parameter specifies the maximum duration to wait for a response.
  /// The optional [files] parameter allows including multipart files in the request.
  /// Returns a [ResponseData] object containing the server's response.
  Future<ResponseData> delete ({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  });

  /// Sends an HTTP HEAD request to the specified [url] with the given [headers].
  ///
  /// The [timeout] parameter specifies the maximum duration to wait for a response.
  /// The optional [files] parameter allows including multipart files in the request.
  /// Returns a [ResponseData] object containing the server's response headers.
  Future<ResponseData> head ({
    required final Map<String, String> headers,
    required final String url,
    required final Duration timeout,
    required final List<MultipartFile> files,
  });

  /// Sends an HTTP READ request to the specified [url] with the given [headers].
  ///
  /// The [timeout] parameter specifies the maximum duration to wait for a response.
  /// The optional [files] parameter allows including multipart files in the request.
  /// Returns a [ResponseData] object containing the server's response.
  Future<ResponseData> read ({
    required final Map<String, String> headers,
    required final String url,
    required final Duration timeout,
    required final List<MultipartFile> files,
  });

  /// Downloads a file from the specified [url] with the given [headers].
  ///
  /// This method is intended for downloading files. Returns a [ResponseData]
  /// object containing the download result or file data.
  Future<ResponseData> download ({
    required final Map<String, String> headers,
    required final String url
  });
}
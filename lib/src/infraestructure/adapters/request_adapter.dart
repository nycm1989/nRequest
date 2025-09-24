import 'dart:async' show TimeoutException;
import 'dart:convert' show json;
import 'package:http/http.dart' as http;

import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/infraestructure/ports/request_port.dart' show RequestPort;
import 'package:n_request/src/infraestructure/factory/response_factory.dart' show ResponseFactory;
import 'package:n_request/src/infraestructure/repositories/header_repository.dart' show HeaderRepository;

/// Adapter class implementing [RequestPort] to handle HTTP requests.
///
/// This class uses the [http] package to perform network operations corresponding
/// to various [RequestType]s. It leverages [ResponseFactory] to construct [ResponseData]
/// objects from HTTP responses. Default headers are augmented with those from [HeaderRepository].
class RequestAdapter implements RequestPort{

  /// Performs an HTTP GET request.
  ///
  /// [headers]: The HTTP headers to include in the request.
  /// [url]: The target URL for the GET request.
  /// [timeout]: Duration to wait before timing out the request.
  /// [files]: List of files (not used in GET).
  ///
  /// Returns a [ResponseData] object representing the response.
  /// Uses [RequestType.get] to indicate the request type.
  @override
  Future<ResponseData> get({
    required final Map<String, String>? headers,
    required final String url,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.get;

    try{
      return await http
      .get(
        Uri.parse(url),
        headers: headers ?? {...HeaderRepository().jsonHeaders, ...HeaderRepository().corsHeaders}
      )
      .timeout(timeout)
      .then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : null
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on http.ClientException { return responseFactory.socketException(url: url, type: type); }
    catch (error) { return responseFactory.onError(url: url, type: type, error: error); }
  }


  /// Performs an HTTP POST request.
  ///
  /// [headers]: The HTTP headers to include in the request.
  /// [url]: The target URL for the POST request.
  /// [body]: The request payload to be sent, which will be JSON encoded.
  /// [timeout]: Duration to wait before timing out the request.
  /// [files]: List of files (not used in POST).
  ///
  /// Returns a [ResponseData] object representing the response.
  /// Uses [RequestType.post] to indicate the request type.
  @override
  Future<ResponseData> post({
    required final Map<String, String>? headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.post;

    try{
      return await http
      .post(
        Uri.parse(url),
        headers : headers ?? {...HeaderRepository().jsonHeaders, ...HeaderRepository().corsHeaders},
        body    : body == null ? null : json.encode(body)
      )
      .timeout(timeout)
      .then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : response.body
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on http.ClientException { return responseFactory.socketException(url: url, type: type); }
    catch (error) { return responseFactory.onError(url: url, type: type, error: error); }
  }


  /// Performs an HTTP PUT request.
  ///
  /// [headers]: The HTTP headers to include in the request.
  /// [url]: The target URL for the PUT request.
  /// [body]: The request payload to be sent, which will be JSON encoded.
  /// [timeout]: Duration to wait before timing out the request.
  /// [files]: List of files (not used in PUT).
  ///
  /// Returns a [ResponseData] object representing the response.
  /// Uses [RequestType.put] to indicate the request type.
  @override
  Future<ResponseData> put({
    required final Map<String, String>? headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.put;

    try {
      return await http
      .put(
        Uri.parse(url),
        headers : headers ?? {...HeaderRepository().jsonHeaders, ...HeaderRepository().corsHeaders},
        body    : body == null ? null : json.encode(body)
      )
      .timeout(timeout)
      .then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : response.body
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on http.ClientException { return responseFactory.socketException(url: url, type: type); }
    catch (error) { return responseFactory.onError(url: url, type: type, error: error); }
  }


  /// Performs an HTTP PATCH request.
  ///
  /// [headers]: The HTTP headers to include in the request.
  /// [url]: The target URL for the PATCH request.
  /// [body]: The request payload to be sent, which will be JSON encoded.
  /// [timeout]: Duration to wait before timing out the request.
  /// [files]: List of files (not used in PATCH).
  ///
  /// Returns a [ResponseData] object representing the response.
  /// Uses [RequestType.patch] to indicate the request type.
  @override
  Future<ResponseData> patch({
    required final Map<String, String>? headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.patch;

    try {
      return await http
      .patch(
        Uri.parse(url),
        headers : headers ?? {...HeaderRepository().jsonHeaders, ...HeaderRepository().corsHeaders},
        body    : body == null ? null : json.encode(body)
      )
      .timeout(timeout)
      .then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : response.body
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on http.ClientException { return responseFactory.socketException(url: url, type: type); }
    catch (error) { return responseFactory.onError(url: url, type: type, error: error); }
  }


  /// Performs an HTTP DELETE request.
  ///
  /// [headers]: The HTTP headers to include in the request.
  /// [url]: The target URL for the DELETE request.
  /// [body]: The request payload to be sent, which will be JSON encoded.
  /// [timeout]: Duration to wait before timing out the request.
  /// [files]: List of files (not used in DELETE).
  ///
  /// Returns a [ResponseData] object representing the response.
  /// Uses [RequestType.delete] to indicate the request type.
  @override
  Future<ResponseData> delete({
    required final Map<String, String>? headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.delete;

    try {
      return await http
      .delete(
        Uri.parse(url),
        headers : headers ?? {...HeaderRepository().jsonHeaders, ...HeaderRepository().corsHeaders},
        body    : body == null ? null : json.encode(body)
      )
      .timeout(timeout)
      .then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : response.body
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on http.ClientException { return responseFactory.socketException(url: url, type: type); }
    catch (error) { return responseFactory.onError(url: url, type: type, error: error); }
  }


  /// Performs an HTTP HEAD request.
  ///
  /// [headers]: The HTTP headers to include in the request.
  /// [url]: The target URL for the HEAD request.
  /// [timeout]: Duration to wait before timing out the request.
  /// [files]: List of files (not used in HEAD).
  ///
  /// Returns a [ResponseData] object representing the response.
  @override
  Future<ResponseData> head({
    required final Map<String, String>? headers,
    required final String url,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.head;

    try{
      return await http
      .head(
        Uri.parse(url),
        headers: headers ?? {...HeaderRepository().jsonHeaders, ...HeaderRepository().corsHeaders}
      )
      .timeout(timeout)
      .then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : null
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on http.ClientException { return responseFactory.socketException(url: url, type: type); }
    catch (error){ return responseFactory.onError(url: url, type: type, error: error); }
  }


  /// Performs an HTTP READ request.
  ///
  /// [headers]: The HTTP headers to include in the request.
  /// [url]: The target URL for the READ request.
  /// [timeout]: Duration to wait before timing out the request.
  /// [files]: List of files (not used in READ).
  ///
  /// Returns a [ResponseData] object representing the response.
  @override
  Future<ResponseData> read({
    required final Map<String, String>? headers,
    required final String url,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.read;

    try{
      return await http
      .get(
        Uri.parse(url),
        headers: headers ?? {...HeaderRepository().jsonHeaders, ...HeaderRepository().corsHeaders}
      )
      .timeout(timeout)
      .then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : null
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on http.ClientException { return responseFactory.socketException(url: url, type: type); }
    catch (error) { return responseFactory.onError(url: url, type: type, error: error); }
  }


  /// Performs a file download via HTTP GET request.
  ///
  /// [headers]: The HTTP headers to include in the request.
  /// [url]: The target URL for the download request.
  ///
  /// Returns a [ResponseData] object containing the downloaded data or error info.
  /// Uses [RequestType.download] to indicate the request type.
  @override
  Future<ResponseData> download({
    required final Map<String, String>? headers,
    required final String url
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.download;

    try{
      return await http
      .get(
        Uri.parse(url),
        headers: headers ?? {...HeaderRepository().jsonHeaders, ...HeaderRepository().corsHeaders}
      )
      .timeout(const Duration(seconds: 30))
      .then((response) async {
        // If the HTTP status code is 200 (OK), return the body bytes if not empty,
        // otherwise return null as the body.
        if(response.statusCode == 200){
          return await responseFactory.make(
            body    : response.bodyBytes.isEmpty ? null : response.bodyBytes,
            type    : type,
            url     : url,
            response: response
          );
        } else {
          // For any other status code, return a response with null body.
          return await responseFactory.make(
            body    : null,
            type    : type,
            url     : url,
            response: response
          );
        }
      });
    }
    on http.ClientException  { return responseFactory.socketException(url: url, type: type); }
    catch (error) { return responseFactory.onError(url: url, type: type, error: error); }
  }

}
import 'dart:convert' show json;
import 'dart:io' show SocketException, HttpClient;
import 'dart:async' show TimeoutException;

import 'package:n_request/src/domain/enums/request_type.dart';
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/infraestructure/factory/response_factory.dart';
import 'package:n_request/src/infraestructure/ports/request_port.dart';
import 'package:n_request/src/infraestructure/repositories/header_repository.dart';

class RequestAdapter implements RequestPort{

  @override
  Future<ResponseData> get({
    required final Map<String, String> headers,
    required final String url,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.get;
    Map<String, String> _headers = headers;
    _headers.addAll(HeaderRepository().jsonHeaders);

    final HttpClient client = HttpClient();
    try{
      return await HttpClient()
      .openUrl('GET', Uri.parse(url))
      .timeout(timeout)
      .then((request) async {
        _headers.forEach((key, value) {
          request.headers.add(key, value);
        });

        return await request.close().then((response) async =>
          await responseFactory.make(
            type      : type,
            response  : response,
            url       : url,
            body      : null
          )
        );

      });
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type); }
    finally             { client.close(); }
  }


  @override
  Future<ResponseData> post({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.post;
    final String _body = json.encode( body );
    Map<String, String> _headers = headers;
    _headers.addAll(HeaderRepository().jsonHeaders);

    final HttpClient client = HttpClient();
    try{
      return await client
      .openUrl(type.name.toUpperCase(), Uri.parse(url))
      .timeout(timeout)
      .then((request) async {
        _headers.forEach((key, value) {
          request.headers.add(key, value);
        });

        request.write(_body);

        return await request
        .close()
        .then((response) async {
          return await responseFactory.make(
            type      : type,
            response  : response,
            url       : url,
            body      : _body
          );
        });
      });
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type); }
    finally             { client.close(); }
  }


  @override
  Future<ResponseData> put({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.put;
    final String _body = json.encode( body );
    Map<String, String> _headers = headers;
    _headers.addAll(HeaderRepository().jsonHeaders);

    final HttpClient client = HttpClient();
    try{

      return await client.openUrl(type.name.toUpperCase(), Uri.parse(url)).timeout(timeout).then((request) async {
        _headers.forEach((key, value) {
          request.headers.add(key, value);
        });
        request.write(_body);

        return await request.close().then((response) async =>
          await responseFactory.make(
            type      : type,
            response  : response,
            url       : url,
            body      : _body
          )
        );
      });
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type); }
    finally             { client.close(); }
  }


  @override
  Future<ResponseData> patch({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.patch;
    final String _body = json.encode( body );
    Map<String, String> _headers = headers;
    _headers.addAll(HeaderRepository().jsonHeaders);

    final HttpClient client = HttpClient();
    try{

      return await client.openUrl(type.name.toUpperCase(), Uri.parse(url)).timeout(timeout).then((request) async {
        _headers.forEach((key, value) {
          request.headers.add(key, value);
        });
        request.write(_body);

        return await request.close().then((response) async =>
          await responseFactory.make(
            type      : type,
            response  : response,
            url       : url,
            body      : _body
          )
        );
      });
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type); }
    finally             { client.close(); }
  }


  @override
  Future<ResponseData> delete({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.delete;
    final String _body = json.encode( body );
    Map<String, String> _headers = headers;
    _headers.addAll(HeaderRepository().jsonHeaders);

    final HttpClient client = HttpClient();
    try{
      return await client.openUrl(type.name.toUpperCase(), Uri.parse(url)).timeout(timeout).then((request) async {
        _headers.forEach((key, value) {
          request.headers.add(key, value);
        });
        request.write(_body);

        return await request.close().then((response) async =>
          await responseFactory.make(
            type      : type,
            response  : response,
            url       : url,
            body      : _body
          )
        );
      });
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type); }
    finally             { client.close(); }
  }


  @override
  Future<ResponseData> download({
    required final Map<String, String> headers,
    required final String url
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.download;

    final HttpClient client = HttpClient();
    try{
      return await client.getUrl(Uri.parse(url)).then((request) async {
        headers.forEach((key, value) {
          request.headers.add(key, value);
        });

        return await request.close().then((response) async {

          if(response.statusCode == 200){
            return await response.fold<List<int>>([], (prev, el) => prev..addAll(el)).then((bytes) async =>
              await responseFactory.make(
                body    : bytes.isEmpty ? null : bytes,
                type    : type,
                url     : url,
                response: response
              )
            );
          } else {
            return await responseFactory.make(
              body    : null,
              type    : type,
              url     : url,
              response: response
            );
          }
        });
      });
    }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type, error: error); }
    finally             { client.close(); }
  }

}
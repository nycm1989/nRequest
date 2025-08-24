import 'dart:convert' show json;
import 'dart:io' show SocketException;
import 'dart:async' show TimeoutException;

import 'package:http/http.dart' show Client, ClientException, MultipartFile, Request;
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
    required final List<MultipartFile> files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.get;
    Map<String, String> _headers = headers;
    _headers.addAll(HeaderRepository().jsonHeaders);

    try{
      return await Client()
      .get( Uri.parse(url), headers : _headers )
      .timeout(timeout)
      .then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : null
        )
      )
      .onError((error, stackTrace) =>
        responseFactory.onError(
          url       : url,
          type      : type,
          error     : error,
          stackTrace: stackTrace
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    on ClientException  { return responseFactory.clientException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type); }
  }


  @override
  Future<ResponseData> post({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.post;
    final String _body = json.encode( body );
    Map<String, String> _headers = headers;
    _headers.addAll(HeaderRepository().jsonHeaders);

    try{
      return await Client()
      .post( Uri.parse(url), headers : _headers, body: _body )
      .timeout(timeout)
      .then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : _body
        )
      )
      .onError((error, stackTrace) =>
        responseFactory.onError(
          url       : url,
          type      : type,
          error     : error,
          stackTrace: stackTrace
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    on ClientException  { return responseFactory.clientException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type); }
  }


  @override
  Future<ResponseData> put({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.put;
    final String _body = json.encode( body );
    Map<String, String> _headers = headers;
    _headers.addAll(HeaderRepository().jsonHeaders);

    try{
      return await Client()
      .put( Uri.parse(url), headers : _headers, body: _body )
      .timeout(timeout)
      .then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : _body
        )
      )
      .onError((error, stackTrace) =>
        responseFactory.onError(
          url       : url,
          type      : type,
          error     : error,
          stackTrace: stackTrace
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    on ClientException  { return responseFactory.clientException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type); }
  }


  @override
  Future<ResponseData> delete({
    required final Map<String, String> headers,
    required final String url,
    required final dynamic body,
    required final Duration timeout,
    required final List<MultipartFile> files,
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.delete;
    final String _body = json.encode( body );
    Map<String, String> _headers = headers;
    _headers.addAll(HeaderRepository().jsonHeaders);

    try{
      return await Client()
      .delete( Uri.parse(url), headers : _headers, body: _body )
      .timeout(timeout)
      .then((response) async =>
        await responseFactory.make(
          type      : type,
          response  : response,
          url       : url,
          body      : _body
        )
      )
      .onError((error, stackTrace) =>
        responseFactory.onError(
          url       : url,
          type      : type,
          error     : error,
          stackTrace: stackTrace
        )
      );
    }
    on TimeoutException { return responseFactory.timeoutException(timeout: timeout, url: url, type: type); }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    on ClientException  { return responseFactory.clientException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type); }
  }


  @override
  Future<ResponseData> download({
    required final Map<String, String> headers,
    required final String url
  }) async {
    final ResponseFactory responseFactory = ResponseFactory();
    final RequestType type = RequestType.download;

    try{
      List<String> list = url.split("://");

      String schema = list.first.toLowerCase();
      list = list.last.split("/");
      String domain = list.first;
      list.remove(domain);
      String path = list.join("/");

      Request request = Request(
        "GET",
        schema.toLowerCase() == 'https'
        ? Uri.https(domain, path, headers)
        : Uri.http(domain, path, headers)
      );

      request.followRedirects = false;
      return await request.send().then((response) async{
        if(response.statusCode == 200){
          try{
            return await response.stream
            .toBytes()
            .then((bytes) async =>
              await responseFactory.make(
                body    : bytes.isEmpty ? null : bytes,
                type    : type,
                url     : url,
                response: response
              )
            )
            .onError((error, stackTrace) {
              return responseFactory.onError(
                url: url,
                type: type,
                error: error,
                stackTrace: stackTrace
              );
            });
          } catch (error) {
            return responseFactory.onError(
              url: url,
              type: type,
              error: error
            ); }
        } else {
          return await responseFactory.make(
            body    : null,
            type    : type,
            url     : url,
            response: response
          );
        }
      });
    }
    on SocketException  { return responseFactory.socketException(url: url, type: type); }
    on ClientException  { return responseFactory.clientException(url: url, type: type); }
    catch (error)       { return responseFactory.onError(url: url, type: type, error: error); }
  }

}
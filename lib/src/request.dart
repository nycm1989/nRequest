import 'dart:io' show SocketException;
import 'dart:async' show Future, FutureExtensions, TimeoutException;
import 'dart:convert' show json, utf8;
import 'package:flutter/foundation.dart' show Uint8List, kDebugMode;
import 'package:http/http.dart' show Client, ClientException, MultipartFile, MultipartRequest, Request, Response, StreamedResponse;
import 'enums.dart' show RequestType;
import 'package:n_request/src/models.dart' show ResponseData, StatusData;
import 'package:n_request/src/status.dart' show statusList;

class NCustomRequest{

  static final Map<String, String> _h = {
    "Access-Control-Allow-Origin"       : "*",
    "Access-Control-Allow-Credentials"  : 'true',
    "Access-Control-Allow-Headers"      : "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale,X-Requested-With, Content-Type, Accept, Access-Control-Request-Method",
    'Access-Control-Allow-Methods'      : 'GET, PUT, POST, DELETE, HEAD, OPTIONS',
    "Allow"                             : "GET, POST, OPTIONS, PUT, DELETE",
    "crossOrigin"                       : "Anonymous"
  };

  static Future<Uint8List?> download({
    required String       url,
    Map<String, String>?  headers,
    Map<String, String>?  token,
    Duration              timeout       = const Duration(minutes: 5),
    bool printUrl     = false,
    bool printHeader  = false,
  }) async {

    Map<String, String> h = headers??_h;
    if(token != null) h.addAll(token);

    try {
        h.addAll({
          "Content-Type": 'application/json',
          "Accept"      : 'application/json',
        });

        if (printHeader) if(kDebugMode) print("Header -> ${json.encode(h)}");

        return Future(() async {
          List<String> list = url.split("://");
          if (list.length <= 1) {
            return null;
          } else {
            if(printUrl) if(kDebugMode) print("Url -> $url");

            String type = list.first.toLowerCase();
            list = list.last.split("/");
            String domain = list.first;
            list.remove(domain);
            String path = list.join("/");

            List<String> _n = list.last.split(".");
            if (_n.length <= 1 && _n.length != 2) {
              return null;
            } else {

              Request request = Request(
                "GET",
                type.toLowerCase() == 'https'
                ? Uri.https(domain, path, headers)
                : Uri.http(domain, path, headers)
              );

              request.followRedirects = false;
              return await request.send().then((value) async{
                if(value.statusCode == 200){
                  try{
                    return await value.stream.toBytes().then((bytes) => bytes.isEmpty ? null : bytes).onError((error, trace) => null);
                  } catch (e) {
                    return null;
                  }
                } else {
                  return null;
                }
              });
            }
          }
        });
    }
    on TimeoutException {
      return null;
    }
    on SocketException {
      return null;
    }
    on ClientException  {
      return null;
    }
    catch (error) {
      return null;
    }
  }

  static Future<ResponseData> make({
    required final String       url,
    required final RequestType  type,
    final Map<String, String>?  headers,
    final Map<String, String>?  token,
    final Map<String, dynamic>  body          = const <String, dynamic>{},
    final List<MultipartFile>   files         = const [],
    final Duration              timeout       = const Duration(minutes: 5),
    required final bool silent,
    required final bool printUrl,
    required final bool printHeader,
    required final bool printBody,
    required final bool printResponse,
    final Function()? onStart,
    final Function()? onFinish,
  }) async {
    if(onStart != null) onStart.call();

    Map<String, String> h = headers??_h;
    if(token != null) h.addAll(token);

    if (printUrl      ) if(kDebugMode) print("Url      -> $url");
    if (printBody     ) if(kDebugMode) print("Body     -> ${json.encode(body)}");

    try {
      if (files.isNotEmpty){

        h.addAll({"Content-Type": 'multipart/form-data'});
        Map<String, String> data = <String, String>{};
        body.forEach((key, value) => data[key] = value.toString());

        MultipartRequest multipartRequest = MultipartRequest( type.name.toUpperCase(), Uri.parse(url) )
        ..headers.addAll(h)
        ..fields.addAll(data);

        for (var file in files){ multipartRequest.files.add(file); }

        if (printHeader   ) if(kDebugMode) print("Header   -> ${json.encode(h)}");

        return await multipartRequest.send().then((sr) async => await _buildResponse(
          type : type,
          sr   : sr,
          url  : url,
          body : body
        )).then((response) async{
          if(onFinish != null) onFinish.call();
          return response;
        });

      } else {
        ResponseData response = ResponseData();
        h.addAll({
          "Content-Type": 'application/json',
          "Accept"      : 'application/json',
        });

        if (printHeader   ) if(kDebugMode) print("Header   -> ${json.encode(h)}");

        return Future(() async {
          if( type == RequestType.get ){
            await Client().get( Uri.parse(url), headers : h ).timeout(timeout).then((r) async =>
              await _buildResponse(
                type : type,
                r    : r,
                url  : url,
                body : body
              ).then((r) => response = r)
            ).onError((error, stackTrace) => _makeError(error, stackTrace, url, type));
          } else if (type == RequestType.post) {
            await Client().post( Uri.parse(url), headers: h, body: json.encode( body ) ).timeout(timeout).then((r) async =>
              await _buildResponse(
                type : type,
                r    : r,
                url  : url,
                body : body
              ).then((r) => response = r)
            ).onError((error, stackTrace) => _makeError(error, stackTrace, url, type));
          } else if (type == RequestType.put) {
            await Client().put( Uri.parse(url), headers: h, body: json.encode( body ) ).timeout(timeout).then((r) async =>
              await _buildResponse(
                type : type,
                r    : r,
                url  : url,
                body : body
              ).then((r) => response = r)
            ).onError((error, stackTrace) => _makeError(error, stackTrace, url, type));
          } else if(type == RequestType.delete) {
            await Client().delete( Uri.parse(url), headers: h, body: json.encode( body ) ).timeout(timeout).then((r) async =>
              await _buildResponse(
                type : type,
                r    : r,
                url  : url,
                body : body
              ).then((r) => response = r)
            ).onError((error, stackTrace) => _makeError(error, stackTrace, url, type));
          } else { response = ResponseData(); }
        }).then((_) {
          if(onFinish != null) onFinish.call();
          if(!silent) response.printStatus();
          if (printResponse ) if(kDebugMode) response.printBody();
          return response;
        });
      }
    }
    on TimeoutException {
      ResponseData response = ResponseData(
        url    : url,
        type   : type,
        status :
        StatusData(
          description : "Request Timeout Exception",
          error       : "Exceeded ${timeout.toString()} waiting time"
        )
      );
      if(!silent) response.printStatus();
      return response;
    }
    on SocketException {
      ResponseData response = ResponseData(
        url    : url,
        type   : type,
        status :
        const StatusData(
          description : "Request Socket Exception",
          error       : "Cant connect to the server"
        )
      );
      if(!silent) response.printStatus();
      return response;
    }
    on ClientException  {
      ResponseData response = ResponseData(
        url    : url,
        type   : type,
        status :
        const StatusData(
          description : "Request Client Exception",
          error       : "Incompatible connection"
        )
      );
      if(!silent) response.printStatus();
      return response;
    }
    catch (error) {
      ResponseData response = ResponseData(
        url    : url,
        type   : type,
        status :
        StatusData(
          description : "Code error",
          error       : "$error"
        )
      );
      if(!silent) response.printStatus();
      return response;
    }
  }

  static Future<ResponseData> _buildResponse({
    required final Map<String, dynamic>  body,
    required final RequestType type,
    required final String url,
    final Response? r,
    final StreamedResponse? sr,
  }) async {

    try{
      if ( r  != null ){
        return ResponseData(
          type    : type,
          status  : statusList.singleWhere((e) => e.code == r.statusCode, orElse: () => const StatusData()),
          body    : r.bodyBytes.isEmpty ? null : json.decode(utf8.decode(r.bodyBytes)),
          url     : url
        );
      } else if ( sr != null ){
        return await sr.stream.bytesToString().then((value) => ResponseData(
          type    : type,
          status  : statusList.singleWhere((e) => e.code == sr.statusCode, orElse: () => const StatusData()),
          body    : value.isEmpty ? null : json.decode(value),
          url     : url
        ));
      } else{
        return ResponseData(
          type    : type,
          url     : url,
          body    : null,
          status  :
          const StatusData(
            description : "Request Exception",
            error       : "There is no response"
          ),
        );
      }
    } catch (error){
      return ResponseData(
        type    : type,
        url     : url,
        body    : null,
        status  :
        StatusData(
          description : "Request Exception",
          error       : error.toString()
        ),
      );
    }
  }

  static _makeError(Object? error, StackTrace stackTrace, String url, RequestType type) {
    if(kDebugMode) print("$error");
    if(kDebugMode) print("$stackTrace");
    return ResponseData( url: url, type: type, status: StatusData( description: "Request Exception", error: error.toString() ) );
  }
}

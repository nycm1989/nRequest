import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:n_request/src/enums.dart' show RequestType;
import 'package:n_request/src/models.dart';
import 'package:n_request/src/status.dart';

class NCustomRequest{

  static final Map<String, String> _h = {
    "Access-Control-Allow-Origin"       : "*",
    "Access-Control-Allow-Credentials"  : 'true',
    "Access-Control-Allow-Headers"      : "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale,X-Requested-With, Content-Type, Accept, Access-Control-Request-Method",
    'Access-Control-Allow-Methods'      : 'GET, PUT, POST, DELETE, HEAD, OPTIONS',
    "Allow"                             : "GET, POST, OPTIONS, PUT, DELETE",
    "crossOrigin"                       : "Anonymous"
  };

  static Future<ResponseData> make({
    required String       url,
    required RequestType  type,
    Map<String, String>?  headers,
    Map<String, String>?  token,
    Map<String, dynamic>  body          = const <String, dynamic>{},
    List<MultipartFile>   files         = const [],
    Duration              timeout       = const Duration(minutes: 5),
    bool                  printHeaders = false,
    bool                  printRequest  = false,
    bool                  printResponse = false,
  }) async {
    if (printRequest) {
      debugPrint("Request body -------------------------- ▼");
      debugPrint(body.toString());
    }

    Map<String, String> h = headers??_h;
    if(token != null) {
      h.addAll(token);
    }

    try {
      if (files.isNotEmpty){
        h.addAll({"Content-Type": 'multipart/form-data'});
        Map<String, String> data = <String, String>{};
        body.forEach((key, value) => data[key] = value.toString());

        MultipartRequest multipartRequest = MultipartRequest( type.name.toUpperCase(), Uri.parse(url) )
        ..headers.addAll(h)
        ..fields.addAll(data);

        for (var file in files){ multipartRequest.files.add(file); }

        if (printHeaders) {
          debugPrint("Headers ------------------------------- ▼");
          debugPrint(h.toString());
        }

        if(printRequest ) debugPrint("$body");
        return await multipartRequest.send().then((sr) async => await _buildResponse(
          type : type,
          sr   : sr,
          url  : url,
          body : body
        ));

      } else {
        ResponseData response = ResponseData();
        h.addAll({
          "Content-Type": 'application/json',
          "Accept"      : 'application/json',
        });

        if (printHeaders) {
          debugPrint("Headers ------------------------------- ▼");
          debugPrint(h.toString());
        }

        return Future(() async {
          if( type == RequestType.get ){
            await Client().get( Uri.parse(url), headers : h ).timeout(timeout).then((r) async =>
              await _buildResponse(
                type : type,
                r    : r,
                url  : url,
                body : body
              ).then((r) => response = r)
            );
          } else if (type == RequestType.post) {
            await Client().post( Uri.parse(url), headers: h, body: json.encode( body ) ).timeout(timeout).then((r) async =>
              await _buildResponse(
                type : type,
                r    : r,
                url  : url,
                body : body
              ).then((r) => response = r)
            );
          } else if (type == RequestType.put) {
            await Client().put( Uri.parse(url), headers: h, body: json.encode( body ) ).timeout(timeout).then((r) async =>
              await _buildResponse(
                type : type,
                r    : r,
                url  : url,
                body : body
              ).then((r) => response = r)
            );
          } else if(type == RequestType.delete) {
            await Client().delete( Uri.parse(url), headers: h, body: json.encode( body ) ).timeout(timeout).then((r) async =>
              await _buildResponse(
                type : type,
                r    : r,
                url  : url,
                body : body
              ).then((r) => response = r)
            );
          } else { response = ResponseData(); }
        }).then((_) {
          response.printStatus();

          if (printResponse) {
            debugPrint("Response ------------------------------ ▼");
            response.printBody();
          }

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
      response.printStatus();
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
      response.printStatus();
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
      response.printStatus();
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
      response.printStatus();
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
}

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:n_request/src/enums.dart' show StatusType, RequestType;
import 'package:n_request/src/models.dart';

class NCustomRequest{

  static final Map<String, String> _h = {
    "Access-Control-Allow-Origin"       : "*",
    "Access-Control-Allow-Credentials"  : 'true',
    "Access-Control-Allow-Headers"      : "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale,X-Requested-With, Content-Type, Accept, Access-Control-Request-Method",
    'Access-Control-Allow-Methods'      : 'GET, PUT, POST, DELETE, HEAD, OPTIONS',
    "Allow"                             : "GET, POST, OPTIONS, PUT, DELETE",
    "crossOrigin"                       : "Anonymous"
  };

  static const List<StatusData> _st = [
    StatusData(type: StatusType.information,  code: 100, description: "Continue"                        ),
    StatusData(type: StatusType.information,  code: 101, description: "Switching Protocols"             ),
    StatusData(type: StatusType.information,  code: 102, description: "Processing"                      ),
    StatusData(type: StatusType.information,  code: 103, description: "Early Hints"                     ),
    StatusData(type: StatusType.successful,   code: 200, description: "OK"                              ),
    StatusData(type: StatusType.successful,   code: 201, description: "Created"                         ),
    StatusData(type: StatusType.successful,   code: 202, description: "Accepted"                        ),
    StatusData(type: StatusType.unsuccessful, code: 203, description: "Non-Authoritative Information"   ),
    StatusData(type: StatusType.unsuccessful, code: 204, description: "No Content"                      ),
    StatusData(type: StatusType.unsuccessful, code: 205, description: "Reset Content"                   ),
    StatusData(type: StatusType.unsuccessful, code: 206, description: "Partial Content"                 ),
    StatusData(type: StatusType.unsuccessful, code: 207, description: "Multi-Status"                    ),
    StatusData(type: StatusType.unsuccessful, code: 208, description: "Already Reported"                ),
    StatusData(type: StatusType.unsuccessful, code: 226, description: "IM Used"                         ),
    StatusData(type: StatusType.redirection,  code: 300, description: "Multiple Choices"                ),
    StatusData(type: StatusType.redirection,  code: 301, description: "Moved Permanently"               ),
    StatusData(type: StatusType.redirection,  code: 302, description: "Found"                           ),
    StatusData(type: StatusType.redirection,  code: 303, description: "See Other"                       ),
    StatusData(type: StatusType.redirection,  code: 304, description: "Not Modified"                    ),
    StatusData(type: StatusType.redirection,  code: 305, description: "Use Proxy"                       ),
    StatusData(type: StatusType.redirection,  code: 306, description: "unused"                          ),
    StatusData(type: StatusType.redirection,  code: 307, description: "Temporary Redirect"              ),
    StatusData(type: StatusType.redirection,  code: 308, description: "Permanent Redirect"              ),
    StatusData(type: StatusType.clientError,  code: 400, description: "Bad Request"                     ),
    StatusData(type: StatusType.clientError,  code: 401, description: "Unauthorized"                    ),
    StatusData(type: StatusType.clientError,  code: 402, description: "Payment Required"                ),
    StatusData(type: StatusType.clientError,  code: 403, description: "Forbidden"                       ),
    StatusData(type: StatusType.clientError,  code: 404, description: "Not Found"                       ),
    StatusData(type: StatusType.clientError,  code: 405, description: "Method Not Allowed"              ),
    StatusData(type: StatusType.clientError,  code: 406, description: "Not Acceptable"                  ),
    StatusData(type: StatusType.clientError,  code: 407, description: "Proxy Authentication Required"   ),
    StatusData(type: StatusType.clientError,  code: 408, description: "Request Timeout"                 ),
    StatusData(type: StatusType.clientError,  code: 409, description: "Conflict"                        ),
    StatusData(type: StatusType.clientError,  code: 410, description: "Gone"                            ),
    StatusData(type: StatusType.clientError,  code: 411, description: "Length Required"                 ),
    StatusData(type: StatusType.clientError,  code: 412, description: "Precondition Failed"             ),
    StatusData(type: StatusType.clientError,  code: 413, description: "Payload Too Large"               ),
    StatusData(type: StatusType.clientError,  code: 414, description: "URI Too Long"                    ),
    StatusData(type: StatusType.clientError,  code: 415, description: "Unsupported Media Type"          ),
    StatusData(type: StatusType.clientError,  code: 416, description: "Range Not Satisfiable"           ),
    StatusData(type: StatusType.clientError,  code: 417, description: "Expectation Failed"              ),
    StatusData(type: StatusType.clientError,  code: 418, description: "I'm a teapot"                    ),
    StatusData(type: StatusType.clientError,  code: 421, description: "Misdirected Request"             ),
    StatusData(type: StatusType.clientError,  code: 422, description: "Unprocessable Content"           ),
    StatusData(type: StatusType.clientError,  code: 423, description: "Locked"                          ),
    StatusData(type: StatusType.clientError,  code: 424, description: "Failed Dependency"               ),
    StatusData(type: StatusType.clientError,  code: 425, description: "Too Early"                       ),
    StatusData(type: StatusType.clientError,  code: 426, description: "Upgrade Required"                ),
    StatusData(type: StatusType.clientError,  code: 428, description: "Precondition Required"           ),
    StatusData(type: StatusType.clientError,  code: 429, description: "Too Many Requests"               ),
    StatusData(type: StatusType.clientError,  code: 431, description: "Request Header Fields Too Large" ),
    StatusData(type: StatusType.clientError,  code: 451, description: "Unavailable For Legal Reasons"   ),
    StatusData(type: StatusType.serverError,  code: 500, description: "Internal Server Error"           ),
    StatusData(type: StatusType.serverError,  code: 501, description: "Not Implemented"                 ),
    StatusData(type: StatusType.serverError,  code: 502, description: "Bad Gateway"                     ),
    StatusData(type: StatusType.serverError,  code: 503, description: "Service Unavailable"             ),
    StatusData(type: StatusType.serverError,  code: 504, description: "Gateway Timeout"                 ),
    StatusData(type: StatusType.serverError,  code: 505, description: "HTTP Version Not Supported"      ),
    StatusData(type: StatusType.serverError,  code: 506, description: "Variant Also Negotiates"         ),
    StatusData(type: StatusType.serverError,  code: 507, description: "Insufficient Storage"            ),
    StatusData(type: StatusType.serverError,  code: 508, description: "Loop Detected"                   ),
    StatusData(type: StatusType.serverError,  code: 510, description: "Not Extended"                    ),
    StatusData(type: StatusType.serverError,  code: 511, description: "Network Authentication Required" ),
  ];

  static Future<ResponseData> make({
    required String       url,
    required RequestType  type,
    Map<String, String>?  headers,
    Map<String, String>?  token,
    Map<String, dynamic>  body          = const <String, dynamic>{},
    List<MultipartFile>   files         = const [],
    Duration              timeout       = const Duration(minutes: 5),
    bool                  printrequestBody  = false,
    bool                  printResponseBody = false,
  }) async {
    Map<String, String> h = headers??_h;
    if(token != null) {
      h.addAll(token);
    }

    ResponseData response = ResponseData(
      url  : url,
      type : type,
    );

    try {
      if (files.isNotEmpty){
        h.addAll({"Content-Type": 'multipart/form-data'});
        Map<String, String> data = <String, String>{};
        body.forEach((key, value) => data[key] = value.toString());

        MultipartRequest multipartRequest = MultipartRequest( type.name.toUpperCase(), Uri.parse(url) )
        ..headers.addAll(h)
        ..fields.addAll(data);

        for (var file in files){ multipartRequest.files.add(file); }

        if(printrequestBody ) debugPrint("$body");
        return await multipartRequest
        .send()
        .then((sr) async => await _response(
          model     : response,
          sr        : sr,
          printBody : printResponseBody,
          url       : url
        ));

      } else {
        h.addAll({
          "Content-Type": 'application/json',
          "Accept"      : 'application/json',
        });
        return
        type == RequestType.get ? await Client()
          .get( Uri.parse(url), headers : h )
          .timeout(timeout)
          .then((r) async => await _response(
            model     : response,
            r         : r,
            printBody : printResponseBody,
            url       : url
          ) ) :
        type == RequestType.post ? await Client()
          .post(
            Uri.parse(url),
            headers : h,
            body    : json.encode( body )
          )
          .timeout(timeout)
          .then((r) async => await _response(
            model     : response,
            r         : r,
            printBody : printResponseBody,
            url       : url
          ) ) :
        type == RequestType.put ? await Client()
          .put(
            Uri.parse(url),
            headers : h,
            body    : json.encode( body )
          )
          .timeout(timeout)
          .then((r) async => await _response(
            model     : response,
            r         : r,
            printBody : printResponseBody,
            url       : url
          ) ) :
        type == RequestType.delete ? await Client()
          .delete(
            Uri.parse(url),
            headers : h,
            body  : json.encode( body )
          )
          .timeout(timeout)
          .then((r) async => await _response(
            model     : response,
            r         : r,
            printBody : printResponseBody,
            url       : url
          ) ) :
        ResponseData() ;
      }
    }
    on TimeoutException {
      StatusData status = const StatusData( description: "Request Timeout Exception" );
      response.status = status;
      debugPrint('${status.getMessage(url: url)} ${response.url}');
      return response;
    }
    on SocketException  {
      StatusData status = const StatusData( description: "Request Socket Exception" );
      response.status = status;
      debugPrint('${status.getMessage(url: url)} ${response.url}');
      return response;
    }
    on ClientException  {
      StatusData status = const StatusData( description: "Request Client Exception" );
      response.status = status;
      debugPrint('${status.getMessage(url: url)} ${response.url}');
      return response;
    }
    catch (error) {
      return _error(response, error);
    }
  }

  static Future<ResponseData> _response({
    required final ResponseData model,
    required final bool printBody,
    required final String url,
    final Response? r,
    final StreamedResponse? sr,
  }) async {
    StatusData status = const StatusData();
    try{
      status = _st.singleWhere((e) => e.code == (r != null ? r.statusCode : sr!.statusCode));
    } catch (error){
      return await _error(model, error);
    }
    try{
      ResponseData data = r != null
      ? ResponseData(
        type    : model.type,
        isValid : status.type == StatusType.successful,
        status  : status,
        body    : r.bodyBytes.isEmpty ? null : json.decode(utf8.decode(r.bodyBytes)),
        url     : url
      )
      : await sr!.stream.bytesToString().then((value) => ResponseData(
        type    : model.type,
        isValid : status.type == StatusType.successful,
        status  : status,
        body    : value.isEmpty ? null : json.decode(value),
        url     : url
      ));
      data.printStatus();
      if (printBody) data.printBody();
      return data;
    } catch (error) {
      return await _error(model, error);
    }
  }

  static Future<ResponseData> _error(final ResponseData response, Object? error) async {
    response
    ..status = StatusData( description: "Request Exception: $error" )
    ..printStatus();
    return response;
  }
}

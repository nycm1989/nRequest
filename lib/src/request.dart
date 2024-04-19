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
    StatusData(type: StatusType.information,  isValid: false, code: 100, description: "Continue"                        ),
    StatusData(type: StatusType.information,  isValid: false, code: 101, description: "Switching Protocols"             ),
    StatusData(type: StatusType.information,  isValid: false, code: 102, description: "Processing"                      ),
    StatusData(type: StatusType.information,  isValid: false, code: 103, description: "Early Hints"                     ),
    StatusData(type: StatusType.successful,   isValid: true,  code: 200, description: "OK"                              ),
    StatusData(type: StatusType.successful,   isValid: true,  code: 201, description: "Created"                         ),
    StatusData(type: StatusType.successful,   isValid: true,  code: 202, description: "Accepted"                        ),
    StatusData(type: StatusType.unsuccessful, isValid: false, code: 204, description: "No Content"                      ),
    StatusData(type: StatusType.unsuccessful, isValid: false, code: 203, description: "Non-Authoritative Information"   ),
    StatusData(type: StatusType.unsuccessful, isValid: false, code: 205, description: "Reset Content"                   ),
    StatusData(type: StatusType.unsuccessful, isValid: false, code: 206, description: "Partial Content"                 ),
    StatusData(type: StatusType.unsuccessful, isValid: false, code: 207, description: "Multi-Status"                    ),
    StatusData(type: StatusType.unsuccessful, isValid: false, code: 208, description: "Already Reported"                ),
    StatusData(type: StatusType.unsuccessful, isValid: false, code: 226, description: "IM Used"                         ),
    StatusData(type: StatusType.redirection,  isValid: false, code: 300, description: "Multiple Choices"                ),
    StatusData(type: StatusType.redirection,  isValid: false, code: 301, description: "Moved Permanently"               ),
    StatusData(type: StatusType.redirection,  isValid: false, code: 302, description: "Found"                           ),
    StatusData(type: StatusType.redirection,  isValid: false, code: 303, description: "See Other"                       ),
    StatusData(type: StatusType.redirection,  isValid: false, code: 304, description: "Not Modified"                    ),
    StatusData(type: StatusType.redirection,  isValid: false, code: 305, description: "Use Proxy"                       ),
    StatusData(type: StatusType.redirection,  isValid: false, code: 306, description: "unused"                          ),
    StatusData(type: StatusType.redirection,  isValid: false, code: 307, description: "Temporary Redirect"              ),
    StatusData(type: StatusType.redirection,  isValid: false, code: 308, description: "Permanent Redirect"              ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 400, description: "Bad Request"                     ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 401, description: "Unauthorized"                    ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 402, description: "Payment Required"                ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 403, description: "Forbidden"                       ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 404, description: "Not Found"                       ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 405, description: "Method Not Allowed"              ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 406, description: "Not Acceptable"                  ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 407, description: "Proxy Authentication Required"   ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 408, description: "Request Timeout"                 ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 409, description: "Conflict"                        ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 410, description: "Gone"                            ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 411, description: "Length Required"                 ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 412, description: "Precondition Failed"             ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 413, description: "Payload Too Large"               ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 414, description: "URI Too Long"                    ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 415, description: "Unsupported Media Type"          ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 416, description: "Range Not Satisfiable"           ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 417, description: "Expectation Failed"              ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 418, description: "I'm a teapot"                    ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 421, description: "Misdirected Request"             ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 422, description: "Unprocessable Content"           ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 423, description: "Locked"                          ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 424, description: "Failed Dependency"               ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 425, description: "Too Early"                       ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 426, description: "Upgrade Required"                ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 428, description: "Precondition Required"           ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 429, description: "Too Many Requests"               ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 431, description: "Request Header Fields Too Large" ),
    StatusData(type: StatusType.clientError,  isValid: false, code: 451, description: "Unavailable For Legal Reasons"   ),
    StatusData(type: StatusType.serverError,  isValid: false, code: 500, description: "Internal Server Error"           ),
    StatusData(type: StatusType.serverError,  isValid: false, code: 501, description: "Not Implemented"                 ),
    StatusData(type: StatusType.serverError,  isValid: false, code: 502, description: "Bad Gateway"                     ),
    StatusData(type: StatusType.serverError,  isValid: false, code: 503, description: "Service Unavailable"             ),
    StatusData(type: StatusType.serverError,  isValid: false, code: 504, description: "Gateway Timeout"                 ),
    StatusData(type: StatusType.serverError,  isValid: false, code: 505, description: "HTTP Version Not Supported"      ),
    StatusData(type: StatusType.serverError,  isValid: false, code: 506, description: "Variant Also Negotiates"         ),
    StatusData(type: StatusType.serverError,  isValid: false, code: 507, description: "Insufficient Storage"            ),
    StatusData(type: StatusType.serverError,  isValid: false, code: 508, description: "Loop Detected"                   ),
    StatusData(type: StatusType.serverError,  isValid: false, code: 510, description: "Not Extended"                    ),
    StatusData(type: StatusType.serverError,  isValid: false, code: 511, description: "Network Authentication Required" ),
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
          model       : response,
          sr          : sr,
          printBody   : printResponseBody,
          url         : url,
          body        : body,
          printRequest: printrequestBody
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
            model       : response,
            r           : r,
            printBody   : printResponseBody,
            url         : url,
            body        : body,
            printRequest: printrequestBody
          ) ) :
        type == RequestType.post ? await Client()
          .post(
            Uri.parse(url),
            headers : h,
            body    : json.encode( body )
          )
          .timeout(timeout)
          .then((r) async => await _response(
            model       : response,
            r           : r,
            printBody   : printResponseBody,
            url         : url,
            body        : body,
            printRequest: printrequestBody
          ) ) :
        type == RequestType.put ? await Client()
          .put(
            Uri.parse(url),
            headers : h,
            body    : json.encode( body )
          )
          .timeout(timeout)
          .then((r) async => await _response(
            model       : response,
            r           : r,
            printBody   : printResponseBody,
            url         : url,
            body        : body,
            printRequest: printrequestBody
          ) ) :
        type == RequestType.delete ? await Client()
          .delete(
            Uri.parse(url),
            headers : h,
            body  : json.encode( body )
          )
          .timeout(timeout)
          .then((r) async => await _response(
            model       : response,
            r           : r,
            printBody   : printResponseBody,
            url         : url,
            body        : body,
            printRequest: printrequestBody
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
    required final Map<String, dynamic>  body,
    required final ResponseData model,
    required final bool printBody,
    required final bool printRequest,
    required final String url,
    final Response? r,
    final StreamedResponse? sr,
  }) async {

    if (printBody) {
      debugPrint("Request body -------------------------- ▼");
      debugPrint(body.toString());
    }
    try{
      if ( r  != null ){

        ResponseData data = ResponseData(
          type    : model.type,
          status  : _st.singleWhere((e) => e.code == r.statusCode, orElse: () => const StatusData()),
          body    : r.bodyBytes.isEmpty ? null : json.decode(utf8.decode(r.bodyBytes)),
          url     : url
        );

        data.printStatus();

        if (printBody) {
          debugPrint("Response ------------------------------ ▼");
          data.printBody();
        }

        return data;

      } else if ( sr != null ){

        ResponseData data = await sr.stream.bytesToString().then((value) => ResponseData(
          type    : model.type,
          status  : _st.singleWhere((e) => e.code == sr.statusCode, orElse: () => const StatusData()),
          body    : value.isEmpty ? null : json.decode(value),
          url     : url
        ));

        data.printStatus();

        if (printBody) {
          debugPrint("Response ------------------------------ ▼");
          data.printBody();
        }

        return data;

      } else{
        return await _error(model, "There is no response");
      }
    } catch (error){
      return await _error(model, error);
    }
  }

  static Future<ResponseData> _error(final ResponseData response, Object? error) async {
    response
    ..status = StatusData( error: "Request Exception: $error" )
    ..printStatus();
    return response;
  }
}

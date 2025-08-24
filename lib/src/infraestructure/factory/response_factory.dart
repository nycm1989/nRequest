import 'dart:async';
import 'dart:convert' show json, utf8;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show Response, StreamedResponse;
import 'package:n_request/src/domain/models/status_data.dart' show StatusData;
import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/infraestructure/repositories/status_repository.dart' show StatusRepository;

class ResponseFactory {
  Future<ResponseData> make({
    required final dynamic      body,
    required final RequestType  type,
    required final String       url,
    required final dynamic      response,
  }) async {

    if(response == null) {
      return ResponseData(
        type    : type,
        url     : url,
        body    : null,
        status  : StatusRepository().getStatus(500)
      );
    }

    try{

      if ( response is Response ) {
        return ResponseData(
          type    : type,
          status  : StatusRepository().getStatus(response.statusCode),
          body    : response.bodyBytes.isEmpty ? null : json.decode(utf8.decode(response.bodyBytes)),
          url     : url
        );
      }
      else if ( response is StreamedResponse ) {
        return await response.stream.bytesToString().then((value) =>
          ResponseData(
            type    : type,
            status  : StatusRepository().getStatus(response.statusCode),
            body    : body is Uint8List ? body : value.isEmpty ? null : json.decode(value),
            url     : url
          )
        );
      }
      else {
        return ResponseData(
          type    : type,
          url     : url,
          status  :
          StatusData(
            description : "Request Exception",
            error       : "There is no response"
          ),
        );
      }
    } catch (error) {
      return onError(
        type    : type,
        url     : url,
        error   : error
      );
    }
  }

  ResponseData forbidden({
    required final String url,
    required final RequestType type
  }) =>
  ResponseData(
    url     : url,
    type    : type,
    status  : StatusRepository().getStatus(403)
  );


  ResponseData timeoutException({
    required final Duration timeout,
    required final String url,
    required final RequestType type
  }) {
    StatusData status = StatusRepository().getStatus(408);
    status.error      = "Exceeded ${timeout.toString()} waiting time";

    return ResponseData(
      url     : url,
      type    : type,
      status  : status
    );
  }

  ResponseData socketException({
    required final String url,
    required final RequestType type
  }) {
    StatusData status   = StatusRepository().getStatus(0);
    status.description  = "Request Socket Exception";
    status.error        = "Cant connect to the server";

    return ResponseData(
      url     : url,
      type    : type,
      status  : status
    );
  }

  ResponseData clientException({
    required final String url,
    required final RequestType type
  }) {
    StatusData status   = StatusRepository().getStatus(0);
    status.description  = "Request Client Exception";
    status.error        = "Incompatible connection";

    return ResponseData(
      url     : url,
      type    : type,
      status  : status
    );
  }

  ResponseData onError({
    final Object? error,
    final StackTrace? stackTrace,
    required final String url,
    required final RequestType type
  }) {
    StatusData status = StatusRepository().getStatus(0);
    status.error      = "$error${stackTrace == null ? "" : "\n$stackTrace"}";

    return ResponseData(
      url     : url,
      type    : type,
      status  : status
    );
  }
}
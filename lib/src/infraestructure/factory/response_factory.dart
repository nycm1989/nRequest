import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:n_request/src/domain/models/status_data.dart' show StatusData;
import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/response_data.dart' show ResponseData;
import 'package:n_request/src/infraestructure/repositories/status_repository.dart' show StatusRepository;

/// Factory class responsible for creating [ResponseData] instances based on various response inputs.
///
/// This class handles the construction of response objects by interpreting raw responses, HTTP client responses,
/// and different error conditions. It utilizes [StatusRepository] to fetch appropriate [StatusData] status codes
/// and messages, and references [RequestType] to handle different request scenarios.
class ResponseFactory {
  /// Constructs a [ResponseData] object from the given response parameters.
  ///
  /// Handles different response types, including [HttpClientResponse], where it decodes the response body accordingly.
  /// When the [type] is [RequestType.download] and a body is present, it returns the body with a 500 status.
  /// If the response is null or not as expected, it returns a [ResponseData] with an error status.
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
      if ( response is HttpClientResponse ) {
        final bytes = await response.fold<List<int>>(<int>[], (a, b) => a..addAll(b));
        return ResponseData(
          type    : type,
          status  : StatusRepository().getStatus(response.statusCode),
          body    : bytes.isEmpty ? null : json.decode(utf8.decode(bytes)),
          url     : url
        );
      } else {
        if(type == RequestType.download && body != null) {
          return ResponseData(
            type    : type,
            url     : url,
            body    : body,
            status  : StatusRepository().getStatus(500),
          );
        } else {
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
      }
    } catch (error) {
      return onError(
        type    : type,
        url     : url,
        error   : error
      );
    }
  }

  /// Returns a [ResponseData] representing a forbidden (403) HTTP status.
  ///
  /// Uses [StatusRepository] to fetch the 403 status and associates it with the provided [url] and [type].
  ResponseData forbidden({
    required final String url,
    required final RequestType type
  }) =>
  ResponseData(
    url     : url,
    type    : type,
    status  : StatusRepository().getStatus(403)
  );


  /// Returns a [ResponseData] representing a timeout (408) HTTP status.
  ///
  /// The [timeout] duration is included in the [StatusData.error] message to indicate how long was exceeded.
  /// Fetches the 408 status from [StatusRepository] and customizes its error description.
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

  /// Returns a [ResponseData] representing a socket exception scenario.
  ///
  /// Fetches a generic status (code 0) from [StatusRepository] and customizes the description and error
  /// to indicate a socket connection failure.
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

  /// Returns a [ResponseData] representing a client exception scenario.
  ///
  /// Uses [StatusRepository] to fetch a generic status (code 0) and sets a description and error
  /// indicating an incompatible connection.
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

  /// Returns a [ResponseData] representing a generic error condition.
  ///
  /// Accepts an [error] object and optional [stackTrace], incorporates them into the [StatusData.error] message,
  /// and fetches a generic status (code 0) from [StatusRepository].
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
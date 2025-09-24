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
        dynamic decodedBody;
        if (bytes.isEmpty) {
          decodedBody = null;
        } else {
          try {
            decodedBody = json.decode(utf8.decode(bytes));
          } catch (_) {
            decodedBody = utf8.decode(bytes);
          }
        }
        return ResponseData(
          type    : type,
          status  : StatusRepository().getStatus(response.statusCode),
          body    : decodedBody,
          url     : url
        );
      } else {
        if(type == RequestType.download && body != null) {
          return ResponseData(
            type    : type,
            url     : url,
            body    : body,
            status  : StatusRepository().getStatus(200),
          );
        } else {
          return ResponseData(
            type    : type,
            url     : url,
            status  : StatusRepository().getStatus(500),
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
  /// Creates a fresh [StatusData] with a descriptive error message
  /// instead of mutating a shared instance.
  ResponseData timeoutException({
    required final Duration timeout,
    required final String url,
    required final RequestType type,
  }) {
    final StatusData base = StatusRepository().getStatus(408);
    final StatusData status = StatusData(
      description: base.description,
      error: "Exceeded ${timeout.toString()} waiting time",
    );

    return ResponseData(
      url: url,
      type: type,
      status: status,
    );
  }

  /// Returns a [ResponseData] representing a socket exception scenario.
  ///
  /// Creates a fresh [StatusData] instead of mutating shared instances.
  ResponseData socketException({
    required final String url,
    required final RequestType type,
  }) {
    final StatusData status = StatusData(
      description: "Request Socket Exception",
      error: "Can't connect to the server",
    );

    return ResponseData(
      url: url,
      type: type,
      status: status,
    );
  }

  /// Returns a [ResponseData] representing a client exception scenario.
  ///
  /// Creates a fresh [StatusData] instead of mutating shared instances.
  ResponseData clientException({
    required final String url,
    required final RequestType type,
  }) {
    final StatusData status = StatusData(
      description: "Request Client Exception",
      error: "Incompatible connection",
    );

    return ResponseData(
      url: url,
      type: type,
      status: status,
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
    final base = StatusRepository().getStatus(0);
    final StatusData status = StatusData(
      description: base.description,
      error: "$error${stackTrace == null ? "" : "\n$stackTrace"}",
    );

    return ResponseData(
      url     : url,
      type    : type,
      status  : status
    );
  }
}
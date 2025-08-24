import 'package:n_request/src/domain/enums/request_type.dart' show RequestType;
import 'package:n_request/src/domain/models/status_data.dart' show StatusData;

class ResponseData{
  String      url;
  RequestType type;
  StatusData  status;
  dynamic     body;

  ResponseData({
    this.url  = "",
    this.type = RequestType.get,
    StatusData? status,
    this.body,
  }) : status = status ?? StatusData();
}
import 'package:n_request/src/domain/enums/status_type.dart' show StatusType;

class StatusData{
  StatusType type;
  int        code;
  bool       isValid;
  String     description;
  String     error;

  StatusData({
    this.type         = StatusType.exception,
    this.code         = 0,
    this.isValid      = false,
    this.description  = "",
    this.error        = "",
  });
}
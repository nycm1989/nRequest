class HeaderRepository {
  Map<String, String> get corsHeaders => {
    "Access-Control-Allow-Origin"       : "*",
    "Access-Control-Allow-Credentials"  : 'true',
    "Access-Control-Allow-Headers"      : "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale,X-Requested-With, Content-Type, Accept, Access-Control-Request-Method",
    'Access-Control-Allow-Methods'      : 'GET, PUT, POST, DELETE, HEAD, OPTIONS',
    "Allow"                             : "GET, POST, OPTIONS, PUT, DELETE",
    "crossOrigin"                       : "Anonymous"
  };

  Map<String, String> get jsonHeaders => {
    "Content-Type"  : 'application/json',
    "Accept"        : 'application/json',
  };
}
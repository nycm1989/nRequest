import 'package:n_request/n_request.dart';

void main() async {
  await NRequest(
    url           : "https://pokeapi.co/api/v2/ability/?limit=20&offset=20",
    headers       : {"testKey": "testValue"},
    body          : {"testBody": "testBody"},
    onStart       : ()=> print("start"),
    onFinish      : ()=> print("finish"),
    files         : [],
    printUrl      : true,
    printHeaders  : true,
    printBody     : true,
    printResponse : true
  )
  .onOK((response) => print("It`s all OK"))
  .onUnauthorized((response) => print("Unauthorized"))
  .get((response) {});
}

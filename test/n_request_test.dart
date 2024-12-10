import 'package:n_request/n_request.dart';

void main() async {
  await NRequest(
    "https://pokeapi.co/api/v2/ability/?limit=20&offset=20",
    headers       : {"testKey": "testValue"},
    body          : {"testBody": "testBody"},
    onStart       : ()=> print("start"),
    onFinish      : ()=> print("finish"),
    printUrl      : true,
    printHeader   : true,
    printBody     : true,
    printResponse : true
  ).get((response) {});
}

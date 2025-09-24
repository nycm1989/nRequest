# Neil's Custom Request

This is a simple helper for HTTP requests

## With this widget, you can:
- Make get, post, put, delete request
- Make a custom request by type
- Manage multipart files
- Change headers
- Single or multiple WebSocket with restarter and error control!
- Donwload any file from https or http

## Terminal preview
```
"GET ––--–-→ 💬 https://example.com/ → status: successful, OK
"POST –--–-→ 💾 https://example.com/ → status: successful, OK
"PUT ––--–-→ 📩 https://example.com/ → status: successful, OK
"PATCH –-–-→ 📩 https://example.com/ → status: successful, OK
"HEAD -–-–-→ 🫥 https://example.com/ → status: successful, OK
"READ -–-–-→ 👀 https://example.com/ → status: successful, OK
"DELETE ---→ 🗑️ https://example.com/ → status: successful, OK
"DOWNLOAD -→ 🗑️ https://example.com/ → status: successful, OK
```


## Example
```dart
await NRequest(
    "http://example.com/post/",
    body  : { "type": 1 },
    files : [ MultipartFile ]
).post((response) {
    if(response.isValid) response.printStatus();
});
```


### Methods
```dart
await NRequest("url").download((Uint8List? data) {});
await NRequest("url").get((ResponseData response) {});
await NRequest("url").post((ResponseData response) {});
await NRequest("url").put((ResponseData response) {});
await NRequest("url").patch((ResponseData response) {});
await NRequest("url").head((ResponseData response) {});
await NRequest("url").read((ResponseData response) {});
await NRequest("url").type(type: RequestType.post).then((ResponseData response) {});
```


### Setters
```dart
url: String // Required string
headers: Map<String, String>?
token: Map<String, String>?
body: Map<String, dynamic>
formData: bool // Changue for multipart request
files: List<MultipartFile>
timeout: Duration
printUrl: bool
printHeader: bool
printBody: bool
printResponse: bool
onStart: Function()
onFinish: Function()
```

### ResponseData Properties
```dart
url: String
type: RequestType
status: StatusData
body: dynamic
```

### StatusData Properties
```dart
type: StatusType
code: int
isValid: bool
description: String
```


### WebSocket
```dart

NSocketData? socketData;
NSocketController? socketController;

socketData = SocketData(
    name      : "Clients socket",
    url       : "ws url",
    function  : (message) => smsFunction(message)
);

// This is a setter and controller if you want to listen conection status
socketData?.addListener(()=> setState(() {}));

socketData?.hasChannelConnection : bool
socketData?.hasSocketConnection : bool


// SUPORT FOR A SINGLE OR MULTIPLE SOCKETS!
socketController = NSocketController.single(socket: socketData)
socketController = NSocketController.group( sockets: [socketData1, socketData2, ...] )

// Start listening; this includes a restarter that attempts to reconnect to the socket
// in case of disconnections or reconnections.
socketController?.listen();

// Always dispose contrllers
@override
void dispose() {
    super.dispose();
    socketData = null;
    socketData?.dispose();
    socketController = null;
    socketController?.closeAll();
}
```
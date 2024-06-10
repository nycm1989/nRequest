# Neil's Custom Request

this is a simple helper project for http request

## With this widget, you can:
- Make get, post, put, delete request
- Make a custom request by type
- Upload multipart files
- Change headers
- New! single or multiple WebSocket with restarter and error control!

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
await NRequest("url").get((response) {});
await NRequest("url").post((response) {});
await NRequest("url").put((response) {});
await NRequest("url").delete((response) {});
await NRequest("url").type(type: RequestType.post).then((response) {});
```


### Setters
```dart
url: String // Required string
headers: Map<String, String>?
token: Map<String, String>?
body: Map<String, dynamic>
files: List<MultipartFile>
timeout: Duration
printRequest: bool
printResponse: bool
```

### ResponseData Properties
```dart
url: String
type: RequestType
status: StatusData
body: dynamic

/// print a colored message, only works in debug mode
printStatus()
```

### StatusData Properties
```dart
type: StatusType
code: int
isValid: bool
description: String

/// get status data message
getMessage(): String
```


### WebSocket
```dart

SocketData? socketData;
SocketController? socketController;

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
socketController = SocketController.single(socket: socketData)
socketController = SocketController.group( sockets: [socketData1, socketData2, ...] )

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
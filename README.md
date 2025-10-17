# Neil's Custom Request (n_request)

`n_request` is a lightweight and easy-to-use HTTP request helper designed to simplify network operations in your Dart and Flutter projects. It addresses common challenges such as making various types of HTTP requests, handling multipart file uploads, managing headers and tokens, and integrating WebSocket connections with automatic reconnection and error handling. Whether you need to perform simple GET requests or manage complex WebSocket communication, `n_request` provides a unified, intuitive API to streamline your network interactions.

## Features
- Perform HTTP requests of various types including GET, POST, PUT, DELETE, PATCH, HEAD, and custom types with ease.
- Upload files seamlessly using multipart requests, supporting single or multiple file uploads.
- Customize headers and tokens for authenticated or specialized requests.
- Configure request timeouts and control logging output for debugging.
- Manage WebSocket connections with built-in automatic reconnection, error handling, and support for single or multiple sockets.
- Download files from HTTP or HTTPS URLs efficiently.

### Terminal preview

The following preview demonstrates how `n_request` displays request status and responses in the terminal, providing clear and concise feedback on each network operation:

```
GET ––--–-→ 💬 https://example.com/ → status: successful, OK 👍
POST –--–-→ 💾 https://example.com/ → status: successful, OK 👍
PUT ––--–-→ 📩 https://example.com/ → status: successful, OK 👍
PATCH –-–-→ 📩 https://example.com/ → status: successful, OK 👍
HEAD -–-–-→ 🫥 https://example.com/ → status: successful, OK 👍
READ -–-–-→ 👀 https://example.com/ → status: successful, OK 👍
DELETE ---→ 🗑️ https://example.com/ → status: successful, OK 👍
DOWNLOAD -→ 🗂️ https://example.com/ → status: successful, OK 👍
```

## Example

The following example demonstrates how to make a POST request with a JSON body and multipart file upload, and handle the response:

```dart
await NRequest(
    url   : "http://example.com/post/",
    body  : { "type": 1 },
    files : [ MultipartFile ]
)
// [1.3.0] New new pre-CRUD methods for each type of response!
.onOk((response) => print("It`s all OK"))
.onUnauthorized((response) => print("TODO: Make logout here!"))
.post((response) {
    if(response.isValid) response.printStatus();
});
```

### Methods

This section lists the available HTTP request methods you can use with `NRequest`:

```dart
await NRequest("url").download((Uint8List? data) {});
await NRequest("url").get((ResponseData response) {});
await NRequest("url").post((ResponseData response) {});
await NRequest("url").put((ResponseData response) {});
await NRequest("url").patch((ResponseData response) {});
await NRequest("url").head((ResponseData response) {});
await NRequest("url").read((ResponseData response) {});
```



### Setters

These properties allow you to configure your HTTP requests according to your needs:

```dart
url: String // Required string
headers: Map<String, String>? // Optional custom headers
token: Map<String, String>? // Optional token headers for authentication
body: Map<String, dynamic> // Request payload
formData: bool // Change to true for multipart/form-data requests
files: List<MultipartFile> // List of files to upload
timeout: Duration // Request timeout duration
printUrl: bool // Enable printing of the request URL
printHeader: bool // Enable printing of request headers
printBody: bool // Enable printing of request body
printResponse: bool // Enable printing of the response
onStart: Function() // Callback when request starts
onFinish: Function() // Callback when request finishes
```

### ResponseData Properties

`ResponseData` represents the response received from an HTTP request. It contains information about the request URL, request type, status, and the response body:

```dart
url: String
type: RequestType
status: StatusData
body: dynamic
```

### StatusData Properties

`StatusData` provides detailed information about the status of an HTTP request, including the status type, HTTP status code, validity, and a description:

```dart
type: StatusType
code: int
isValid: bool
description: String
```

### WebSocket

`n_request` includes support for WebSocket connections, allowing you to manage real-time communication efficiently. The WebSocket support features automatic reconnection, error handling, and the ability to manage single or multiple sockets through controllers.

```dart
NSocketData? socketData;
NSocketController? socketController;

socketData = SocketData(
    name      : "Clients socket",
    url       : "ws url",
    function  : (message) => smsFunction(message)
);

// This is a setter and controller if you want to listen connection status
socketData?.addListener(()=> setState(() {}));

socketData?.hasChannelConnection : bool
socketData?.hasSocketConnection : bool


// SUPPORT FOR A SINGLE OR MULTIPLE SOCKETS!
socketController = NSocketController.single(socket: socketData)
socketController = NSocketController.group( sockets: [socketData1, socketData2, ...] )

// Start listening; this includes a restarter that attempts to reconnect to the socket
// in case of disconnections or reconnections.
socketController?.listen();

// Always dispose controllers
@override
void dispose() {
    super.dispose();
    socketData = null;
    socketData?.dispose();
    socketController = null;
    socketController?.closeAll();
}
```
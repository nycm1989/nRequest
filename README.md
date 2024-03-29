# Neil's Custom Request

this is a simple helper project for http request

## With this widget, you can:
- make get, post, put, delete request
- make a custom request by type
- upload multipart files
- change headers

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
await NRequest("").get((response) {});
await NRequest("").post((response) {});
await NRequest("").put((response) {});
await NRequest("").delete((response) {});
await NRequest("").type(type: RequestType.post).then((response) {});
```


### Setters
```dart
url: String // Required string
headers: Map<String, String>?
token: Map<String, String>?
body: Map<String, dynamic>
files: List<MultipartFile>
timeout: Duration
printrequestBody: bool
printResponseBody: bool
```

### ResponseData Properties
```dart
url: String
type: RequestType
status: StatusData
body: dynamic
isValid: bool

/// print a colored message, only works in debug mode
printStatus()
```

### StatusData Properties
```dart
type: StatusType
code: int
description: String

/// get status data message
getMessage(): String
```
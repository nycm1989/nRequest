import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;

class MultipartFile {
  final String  field;
  final String? filename;
  final String  contentType;
  final Stream<List<int>> _stream;

  MultipartFile({
    required this.field,
    required Stream<List<int>> stream,
    required this.contentType,
    this.filename,
  }) : _stream = stream;

  Stream<List<int>> finalize() => _stream;

  factory MultipartFile.fromBytes(
    String    field,
    List<int> bytes, {
    String?   filename,
    String    contentType = 'application/octet-stream',
  }) =>
  MultipartFile(
    field       : field,
    stream      : Stream.value(Uint8List.fromList(bytes)),
    filename    : filename,
    contentType : contentType,
  );

  factory MultipartFile.fromUint8List(
    String field,
    Uint8List bytes, {
    String? filename,
    String contentType = 'application/octet-stream',
  }) =>
  MultipartFile(
    field       : field,
    stream      : Stream.value(bytes),
    filename    : filename,
    contentType : contentType,
  );

  factory MultipartFile.fromPath(
    String field,
    String filePath, {
    String? filename,
    String contentType = 'application/octet-stream',
  }) =>
  MultipartFile(
    field       : field,
    stream      : File(filePath).openRead(),
    filename    : filename ?? p.basename(filePath),
    contentType : contentType,
  );
}
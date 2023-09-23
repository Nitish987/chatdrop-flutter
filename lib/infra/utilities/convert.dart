import 'dart:convert';
import 'dart:typed_data';

String bytesToString(Uint8List list) {
  return String.fromCharCodes(list);
}

Uint8List stringToBytes(String source) {
  return Uint8List.fromList(source.codeUnits);
}

String bytesToBase64(Uint8List list) {
  return base64.encode(list.toList());
}

Uint8List base64ToBytes(String source) {
  return base64.decode(source);
}


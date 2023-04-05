import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';


class DocumentsDirectory{
  
Future saveTimestamp(text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/timestamp.txt');
  file.writeAsStringSync(text);
}

Future<String> readTimestamp() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  bool exist = await File('${directory.path}/timestamp.txt').exists();
  if (exist) {
    File file = File('${directory.path}/timestamp.txt');
    String text = await file.readAsString();
    return text;
  }
  return "";
}

Future createwelcomeFile(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/launched.txt');
  file.writeAsStringSync(text);
}


Future storeRefferalCode(String referalCode) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/code.txt');
  file.writeAsStringSync(referalCode);
}


Future storeReffererId(String userId) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/userId.txt');
  file.writeAsStringSync(userId);
}

Future<bool> firstLaunch() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  bool exist = await File('${directory.path}/launched.txt').exists();
  return exist;
}

Future<String> readReferralCode() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  bool exist = await File('${directory.path}/code.txt').exists();
  if (exist) {
    File file = File('${directory.path}/code.txt');
    String text = await file.readAsString();
    return text;
  }
  return "";
}


Future<String> readReferrerId() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  bool exist = await File('${directory.path}/userId.txt').exists();
  if (exist) {
    File file = File('${directory.path}/userId.txt');
    String text = await file.readAsString();
    return text;
  }
  return "";
}

Future<String> getFileFromUrl(String url) async {
  var data = await http.get(Uri.parse(url));
  var bytes = data.bodyBytes;
  var dir = await getApplicationDocumentsDirectory();
  File file = File("${dir.path}/mypdf.pdf");
  File urlFile = await file.writeAsBytes(bytes);
  return urlFile.path;
}

Future<String> getFileFromAsset(String filename) async {
  var dir = await getApplicationDocumentsDirectory();
  File file = File("${dir.path}/$filename.pdf");
  final ByteData data = file.readAsBytesSync().buffer.asByteData();
  var bytes = data.buffer.asUint8List();
  File assetFile = await file.writeAsBytes(bytes);
  return assetFile.path;
}

Future<String> preview(String filename) async {
  String path = "";
  if (await Permission.storage.request().isGranted) {
    File file = File(filename);
    final ByteData data = file.readAsBytesSync().buffer.asByteData();
    var bytes = data.buffer.asUint8List();
    File assetFile = await file.writeAsBytes(bytes);
    return path = assetFile.path;
  }
  return path;
}
}

Future saveTimestamp(text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/timestamp.txt');
  file.writeAsStringSync(text);
}

Future<String> readTimestamp() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  bool exist = await File('${directory.path}/timestamp.txt').exists();
  if (exist) {
    File file = File('${directory.path}/timestamp.txt');
    String text = await file.readAsString();
    return text;
  }
  return "";
}

Future createwelcomeFile(String text) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/launched.txt');
  file.writeAsStringSync(text);
}


Future storeRefferalCode(String referalCode) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/code.txt');
  file.writeAsStringSync(referalCode);
}


Future storeReffererId(String userId) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/userId.txt');
  file.writeAsStringSync(userId);
}

Future<bool> firstLaunch() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  bool exist = await File('${directory.path}/launched.txt').exists();
  return exist;
}

Future<String> readReferralCode() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  bool exist = await File('${directory.path}/code.txt').exists();
  if (exist) {
    File file = File('${directory.path}/code.txt');
    String text = await file.readAsString();
    return text;
  }
  return "";
}


Future<String> readReferrerId() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  bool exist = await File('${directory.path}/userId.txt').exists();
  if (exist) {
    File file = File('${directory.path}/userId.txt');
    String text = await file.readAsString();
    return text;
  }
  return "";
}

Future<String> getFileFromUrl(String url) async {
  var data = await http.get(Uri.parse(url));
  var bytes = data.bodyBytes;
  var dir = await getApplicationDocumentsDirectory();
  File file = File("${dir.path}/mypdf.pdf");
  File urlFile = await file.writeAsBytes(bytes);
  return urlFile.path;
}

Future<String> getFileFromAsset(String filename) async {
  var dir = await getApplicationDocumentsDirectory();
  File file = File("${dir.path}/$filename.pdf");
  final ByteData data = file.readAsBytesSync().buffer.asByteData();
  var bytes = data.buffer.asUint8List();
  File assetFile = await file.writeAsBytes(bytes);
  return assetFile.path;
}

Future<String> preview(String filename) async {
  String path = "";
  if (await Permission.storage.request().isGranted) {
    File file = File(filename);
    final ByteData data = file.readAsBytesSync().buffer.asByteData();
    var bytes = data.buffer.asUint8List();
    File assetFile = await file.writeAsBytes(bytes);
    return path = assetFile.path;
  }
  return path;
}

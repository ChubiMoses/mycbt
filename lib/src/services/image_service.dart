import 'dart:io';
import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:image/image.dart' as ImD;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';


Future<String> compressingPhoto(File file) async {
   String postId = Uuid().v4();
  final tDirectory = await getTemporaryDirectory();
  final path = tDirectory.path;
  ImD.Image? mImageFile = ImD.decodeImage(file.readAsBytesSync());
  final compressedImageFile = File('$path/img_$postId.jpg')
    ..writeAsBytesSync(ImD.encodeJpg(mImageFile!, quality: 60));
  return await uploadPhoto(compressedImageFile, postId);
}

Future<String> uploadPhoto(File file, String postId) async {
  UploadTask mStorageUploadTask =
      storageReference.child("Post_$postId.jpg").putFile(file);
  TaskSnapshot storageTaskSnapshot = await mStorageUploadTask;
  String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}


   
  Future uploadPDF(File file) async {
      String postId = Uuid().v4();
      UploadTask  mStorageUploadTask = docsStorageRef.child("MyCBT_$postId.pdf").putFile(file);
      TaskSnapshot storageTaskSnapshot = await mStorageUploadTask;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      return downloadUrl;
 }


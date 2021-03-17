import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

//post file on Firbase storage and return URL
Future<String> uploadFileOnFirebaseStorage(File file) async {
  firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref().child(file.path);
  firebase_storage.TaskSnapshot uploadTask = await ref.putFile(file);
  return await uploadTask.ref.getDownloadURL();
}

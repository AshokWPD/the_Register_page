// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';

// class FirebaseStorageService {
//   final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

//   Future<String> uploadFile(File file, String fileName) async {
//     final ref = _firebaseStorage.ref().child(fileName);
//     final uploadTask = ref.putFile(file);
//     final snapshot = await uploadTask.whenComplete(() => null);
//     final downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   }
// }

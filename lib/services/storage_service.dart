// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class StorageService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _storage = FirebaseFirestore.instance;

//   // adding image to firebase storage
//   Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
//     // creating location to our firebase storage
    
//     Reference ref =
//         _storage.ref().child(childName).child(_auth.currentUser!.uid);
//     if(isPost) {
//       String id = const Uuid().v1();
//       ref = ref.child(id);
//     }

//     // putting in uint8list format -> Upload task like a future but not future
//     UploadTask uploadTask = ref.putData(
//       file
//     );

//     TaskSnapshot snapshot = await uploadTask;
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   }
// }
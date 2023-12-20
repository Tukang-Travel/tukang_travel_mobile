import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<Map<String, dynamic>?> getPedia(String id) async {
  try {
    CollectionReference pedias = FirebaseFirestore.instance.collection('pedias');
    DocumentSnapshot pediaDocument = await pedias.doc(id).get();

    if (pediaDocument.exists) {
      return pediaDocument.data() as Map<String, dynamic>;
    } else {
      print('Pedia not found');
      return null;
    }
  } catch (e) {
    print('Error retrieving pedia data: $e');
    return null;
  }
}

Future<void> insertPediaComment(String id, String comment, String userId) async {
  try {
    await FirebaseFirestore.instance.collection('pedias').doc(id).update({
      'comments': FieldValue.arrayUnion([
        {'comment': comment, 'userid': userId}
      ]),
    });
    print('Comment added successfully!');
  } catch (e) {
    print('Error adding comment: $e');
  }
}

Future<void> insertPediaRate(String id, int rate, String userId) async {
  // kurang 1 kalau user rate untuk ke 2 kalinya, bukan insert tapi rate yang sebelumnya di update
  try {
    List<dynamic> results = await Future.wait([
      getPedia(id)
    ]);

    await FirebaseFirestore.instance.collection('pedias').doc(id).update({
      'rates': FieldValue.arrayUnion([
        {'rate': rate, 'userid': userId}
      ]),
    });
    print('Rate added successfully!');
  } catch (e) {
    print('Error adding rate: $e');
  }
}

Future<void> insertPedia(String userid, String description, List<File> medias, List<String> tags, String title) async {
  Map<String, dynamic> pedia = {
    'userid': userid,
    'description': description,
    'tags': tags,
    'title': title,
  };
  List<String> media_names = [];

  try {
    DocumentReference newPedia = await FirebaseFirestore.instance.collection('pedias').add(pedia);
    // print('Pedia inserted successfully!');

    for(int i = 0; i < medias.length; i++) {
      String url = await uploadImageToFirebase(userid, medias[i], getFileName(medias[i]));
      media_names.add(url);
      // print(getFileName(medias[i]));
      // print(medias[i]);
    }

    await FirebaseFirestore.instance.collection('pedias').doc(newPedia.id).update({
      'medias': media_names
    });

    print('Pedia inserted successfully');
  } catch (e) {
    print('Error inserting pedia: $e');
  }
}

String getFileName(File file) {
  // Get the file path
  String filePath = file.path;

  // Find the last occurrence of the path separator ("/" in Unix-like systems)
  int lastIndex = filePath.lastIndexOf(Platform.pathSeparator);

  // Extract the file name (including the extension) using substring
  String fileName = filePath.substring(lastIndex + 1);

  return fileName;
}

Future<String> uploadImageToFirebase(String userid, File imageFile, String imageName) async {
  try {
    firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref().child("pedias/$userid/$imageName");

    await storageReference.putFile(imageFile);
    String downloadURL = await storageReference.getDownloadURL();

    print("Image uploaded successfully");
    return downloadURL;
  } catch (e) {
    print("Error uploading image: $e");
  }
  return "";
}

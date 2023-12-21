import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tuktraapp/services/user_service.dart';

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
    Reference storageReference = FirebaseStorage.instance.ref().child("pedias/$userid/$imageName");

    await storageReference.putFile(imageFile);
    String downloadURL = await storageReference.getDownloadURL();

    print("Image uploaded successfully");
    return downloadURL;
  } catch (e) {
    print("Error uploading image: $e");
  }
  return "";
}

Future<void> updatePedia(String id, String title, String description, List<dynamic> tags) async {
  try {
    FirebaseFirestore.instance.collection('pedias').doc(id).update({
      'title': title,
      'description': description,
      'tags': tags
    });

    print('Pedia updated successfully');
  } catch (e) {
    print('Error updating pedia: $e');
  }
}

Future<void> deletePedia(String id) async {
  // Replace this with the name of the folder you want to delete
  String folderName = currUser!.uid;

  // Reference to the Firebase Storage
  var storage = FirebaseStorage.instance;

  // Reference to the parent folder
  var parentFolderRef = storage.ref().child('pedias/$folderName');

  // Reference to the folder with the specific name
  var folderRef = parentFolderRef.child(folderName);

  try {
    // List all items in the folder
    var result = await folderRef.listAll();

    // Delete each file in the folder
    await Future.wait(result.items.map((item) => item.delete()));

    // Now, you can delete the empty folder
    await folderRef.delete();

    print('Folder deleted successfully.');
  } catch (e) {
    print('Error deleting folder: $e');
  }

  try {
    FirebaseFirestore.instance.collection('pedias').doc(id).delete(); 
    print('Pedia deleted successfully.');
  } catch (e) {
    print('Error deleting pedia: $e');
  }
}

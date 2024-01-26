import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tuktraapp/services/user_service.dart';

class PediaService {
  UserService userService = UserService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  // Post comment
  Future<String> postComment(
      String pediaId, String text, String uid, String username) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('pedias').doc(pediaId).update({
          'comments': FieldValue.arrayUnion([
            {
              'username': username,
              'userId': uid,
              'comment': text,
              'datePublished': DateTime.now(),
            }
          ])
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<Map<String, dynamic>?> getPedia(String id) async {
    try {
      CollectionReference pedias =
          FirebaseFirestore.instance.collection('pedias');
      DocumentSnapshot pediaDocument = await pedias.doc(id).get();

      if (pediaDocument.exists) {
        return pediaDocument.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> insertPediaComment(
      String id, String comment, String userId, String username) async {
    try {
      await FirebaseFirestore.instance.collection('pedias').doc(id).update({
        'comments': FieldValue.arrayUnion([
          {'username': username,
          'userId': userId,
          'comment': comment,
          'datePublished': DateTime.now(),}
        ]),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rateAnalytics(String id) async {
    _analytics.logEvent(
      name: 'SELECT_ITEM',
      parameters: {'ITEM_ID': id},
    );
  }

  Future<String> insertPediaRate(String id, int rate, String userId) async {
    String res = "Some error occurred";
    try {
      DocumentReference pediaRef =
          FirebaseFirestore.instance.collection('pedias').doc(id);

      DocumentSnapshot pediaSnapshot = await pediaRef.get();
      List<Map<String, dynamic>> rates = List.from(
          (pediaSnapshot.data() as Map<String, dynamic>?)?['rates'] ?? []);

      int userIndex = rates.indexWhere((rate) => rate['userid'] == userId);

      if (userIndex != -1) {
        // User has already rated, update the rate
        rates[userIndex]['rate'] = rate;
      } else {
        // User hasn't rated, add a new rate
        rates.add({'userid': userId, 'rate': rate});
      }

      await pediaRef.update({'rates': rates});

      if (rate > 3) {
        await rateAnalytics(id);
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> insertPedia(String userid, String description, List<File> medias,
      List<String> tags, String title) async {
    Map<String, dynamic> pedia = {
      'userid': userid,
      'description': description,
      'tags': tags,
      'title': title,
      'date': DateTime.now(),
    };
    List<String> mediaNames = [];

    try {
      DocumentReference newPedia =
          await FirebaseFirestore.instance.collection('pedias').add(pedia);

      for (int i = 0; i < medias.length; i++) {
        String url = await uploadImageToFirebase(
            userid, medias[i], getFileName(medias[i]), title);
        mediaNames.add(url);
      }

      await FirebaseFirestore.instance
          .collection('pedias')
          .doc(newPedia.id)
          .update({'medias': mediaNames});

    } catch (e) {
      rethrow;
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

  Future<String> uploadImageToFirebase(
      String userid, File imageFile, String imageName, String title) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child("pedias/$userid/$title/$imageName");

      await storageReference.putFile(imageFile);
      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePedia(
      String id, String title, String description, List<dynamic> tags) async {
    try {
      FirebaseFirestore.instance
          .collection('pedias')
          .doc(id)
          .update({'title': title, 'description': description, 'tags': tags});

    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePedia(String id, String title) async {
    // Replace this with the name of the folder you want to delete
    String folderName = userService.currUser!.uid;

    // Reference to the Firebase Storage
    var storage = FirebaseStorage.instance;

    // Reference to the parent folder
    var folderRef = storage.ref().child('pedias/$folderName/$title');

    try {
      await folderRef.listAll().then((value) {
        for (var element in value.items) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        }
      });

    } catch (e) {
      rethrow;
    }

    try {
      FirebaseFirestore.instance.collection('pedias').doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}

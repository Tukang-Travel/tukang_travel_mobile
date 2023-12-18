import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  } */

  Future<String> likePost(
      String postId, String uid, List<dynamic> likes) async {
    String res = "Some error occurred";
    try {
      if (likes.any((like) => like.containsValue(uid))) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('feeds').doc(postId).update({
          'likes': FieldValue.arrayRemove([
            {'userId': uid}
          ])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('feeds').doc(postId).update({
          'likes': FieldValue.arrayUnion([
            {'userId': uid}
          ])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(
      String feedId, String text, String uid, String username) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore.collection('feeds').doc(feedId).update({
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

  // Delete Post
  Future<String> deleteFeed(String feedId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('feeds').doc(feedId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Update Post
  Future<String> updateFeed(
      String feedId, String newTitle, List<String> newTags) async {
    String res = "Some error occurred";
    try {
      // if the likes list contains the user uid, we need to remove it
      _firestore
          .collection('feeds')
          .doc(feedId)
          .update({'title': newTitle, 'tags': newTags});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

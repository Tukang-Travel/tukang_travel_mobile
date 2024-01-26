import 'package:cloud_firestore/cloud_firestore.dart';

class FeedModel {
  final String feedId;
  final String title;
  final String userId;
  final dynamic content;
  final dynamic likes;
  final dynamic comments;
  final List<dynamic> tags;
  final DateTime datePublished;

  const FeedModel({
    required this.feedId,
    required this.title,
    required this.userId,
    required this.content,
    required this.likes,
    required this.comments,
    required this.tags,
    required this.datePublished,
  });

  static FeedModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return FeedModel(
      feedId: snapshot["FeedId"],
      title: snapshot["title"],
      userId: snapshot["uid"],
      content: snapshot['content'],
      likes: snapshot["likes"],
      comments: snapshot["comments"],
      tags: snapshot["tags"],
      datePublished: snapshot["datePublished"],
    );
  }

  Map<String, dynamic> toJson() => {
        "feedId": feedId,
        "title": title,
        "uid": userId,
        'content': content,
        "likes": likes,
        "comments": comments,
        "tags": tags,
        "datePublished": datePublished,
      };
}

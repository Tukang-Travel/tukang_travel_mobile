import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Future<void> _pullRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Feed"),
        ),
        body: SafeArea(
          child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance.collection('feeds').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  var likedTags = <String>[];
                  for (var doc in snapshot.data!.docs) {
                    var likes = List<Map<String, dynamic>>.from(doc['likes']);
                    if (likes.any((like) =>
                        like['userId'] == UserService().currUser!.uid)) {
                      var tags = List<String>.from(
                          doc['tags'].map((tag) => tag.toLowerCase()));
                      for (var tag in tags) {
                        likedTags.add(tag);
                      }
                    }
                  }

                  // Count the occurrences of each tag in likedTags
                  var tagOccurrences = <String, int>{};
                  for (var tag in likedTags) {
                    tagOccurrences[tag] = (tagOccurrences[tag] ?? 0) + 1;
                  }

                  var feeds = snapshot.data!.docs.map((doc) {
                    var tags = List<String>.from(doc['tags']);
                    var likedTagsCount = tags.fold(
                        0,
                        (count, tag) =>
                            count + (tagOccurrences[tag.toLowerCase()] ?? 0));

                    return {
                      'originalDoc': doc.data(),
                      'likedTagsCount': likedTagsCount,
                    };
                  }).toList();

                  feeds.sort((a, b) {
                    var likedTagsCountA = a['likedTagsCount'] as int;
                    var likedTagsCountB = b['likedTagsCount'] as int;

                    if (likedTagsCountA != likedTagsCountB) {
                      return likedTagsCountB.compareTo(
                          likedTagsCountA); // Sort by likedTagsCount descending
                    }

                    var userLikedFeedA = likedTags.contains(((a['originalDoc']
                            as Map<String, dynamic>?)?['feedId'] as String?) ??
                        '');
                    var userLikedFeedB = likedTags.contains(((b['originalDoc']
                            as Map<String, dynamic>?)?['feedId'] as String?) ??
                        '');

                    if (userLikedFeedA && !userLikedFeedB) {
                      return 1; // Feed A comes after Feed B
                    } else if (!userLikedFeedA && userLikedFeedB) {
                      return -1; // Feed A comes before Feed B
                    }

                    return 0; // Both feeds are either liked or not liked, maintain their order based on tag occurrence
                  });

                  return !snapshot.hasData
                      ? const Center(child: Text('No Feed yet'))
                      : SizedBox.expand(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: feeds.length,
                              itemBuilder: (ctx, index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: PostCard(
                                  snap: feeds[feeds.length - 1 - index]
                                      ['originalDoc'], // Use the sorted feeds
                                ),
                              ),
                            ),
                          ),
                        );
                },
              )),
        ));
  }
}

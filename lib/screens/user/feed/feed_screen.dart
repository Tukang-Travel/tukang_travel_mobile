import 'dart:math';

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
  var userInterestTags = <String>[];

  Future<void> _pullRefresh() async {
    setState(() {
      getPreference();
    });
  }

  @override
  void initState() {
    super.initState();
    getPreference();
  }

  Future<void> getPreference() async {
    userInterestTags = await UserService().getUserPreference();
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
              child: FutureBuilder<List<dynamic>>(
                future: Future.wait([
                  FirebaseFirestore.instance.collection('feeds').get(),
                  FirebaseFirestore.instance.collection('pedias').get(),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.data![0].docs.isNotEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  // Fetch user's interest tags from 'users' collection
                  var likedTags = <String>[];
                  for (var doc in snapshot.data![0].docs) {
                    var likes = List<Map<String, dynamic>>.from(doc['likes']);
                    if (likes.any((like) =>
                        like['userId'] == UserService().currUser!.uid)) {
                      var tags = List<String>.from(
                          doc['tags'].map((tag) => tag.toLowerCase()));
                      likedTags.addAll(tags);
                    }
                  }

                  // Use snapshot.data![1] to reference the "pedia" collection
                  var pediaSnapshot = snapshot.data![1];

                  // Check "pedia" collection for user's rate
                  var pediaDataList =
                      pediaSnapshot.docs.map((doc) => doc.data()).toList();
                  for (var pediaData in pediaDataList) {
                    var rates =
                        List<Map<String, dynamic>>.from(pediaData['rates']);
                    var userRate = rates.firstWhere(
                      (rate) => rate['userid'] == UserService().currUser!.uid,
                      orElse: () => {'rate': 0, 'userId': ''},
                    );

                    if ((userRate['rate'] == 4 || userRate['rate'] == 5)) {
                      // If user's rate is 4 or 5, add "tags" from "pedia" collection
                      var pediaTags = List<String>.from(pediaData['tags']);
                      likedTags.addAll(pediaTags);
                    }
                  }

                  // Count the occurrences of each tag in likedTags
                  var tagOccurrences = <String, int>{};
                  for (var tag in likedTags + userInterestTags) {
                    tagOccurrences[tag] = (tagOccurrences[tag] ?? 0) + 1;
                  }

                  // Sorting logic and creating feeds list
                  var feeds = snapshot.data![0].docs.map((doc) {
                    var tags = List<String>.from(doc['tags']);
                    var likedTagsCount = tags.fold(
                        0,
                        (count, tag) =>
                            count + (tagOccurrences[tag] ?? 0));


                    var likes = List<Map<String, dynamic>>.from(doc['likes']);
                    var userLikedFeed = likes.any((like) =>
                        like['userId'] == UserService().currUser!.uid);

                    return {
                      'originalDoc': doc.data(),
                      'likedTagsCount': likedTagsCount,
                      'userLikedFeed': userLikedFeed,
                    };
                  }).toList();

                  feeds.sort((a, b) {
                    var userLikedFeedA = a['userLikedFeed'] as bool;
                    var userLikedFeedB = b['userLikedFeed'] as bool;

                    if (!userLikedFeedA && userLikedFeedB) {
                      return -1; // Feed A (not liked) comes before Feed B (liked)
                    } else if (userLikedFeedA && !userLikedFeedB) {
                      return 1; // Feed A (liked) comes after Feed B (not liked)
                    }

                    var likedTagsCountA = a['likedTagsCount'] as int;
                    var likedTagsCountB = b['likedTagsCount'] as int;

                    if (likedTagsCountA != likedTagsCountB) {
                      return likedTagsCountB.compareTo(
                          likedTagsCountA); // Sort by likedTagsCount descending
                    }

                    return 0; // Both feeds are either liked or not liked, maintain their order based on tag occurrence
                  });

                  // Displaying feeds in UI

                  return !snapshot.data![0].docs.isNotEmpty
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
                                  snap: feeds[index]
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

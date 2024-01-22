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
      _getPreference();
    });
  }

  @override
  void initState() {
    super.initState();
    _getPreference();
  }

  Future<void> _getPreference() async {
    userInterestTags = await UserService().getUserPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
                  'Feed Perjalanan',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
        ),
        body: SafeArea(
            child: RefreshIndicator(
                onRefresh: _pullRefresh,
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future:
                        FirebaseFirestore.instance.collection('feeds').get(),
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

                      var tagOccurrences = <String, int>{};
                      for (var tag in userInterestTags) {
                        tagOccurrences[tag] = (tagOccurrences[tag] ?? 0) + 1;
                      }

                      var feeds = snapshot.data!.docs.map((doc) {
                        var tags = List<String>.from(doc['tags']);
                        var matchingInterestsCount = tags
                            .where((tag) => userInterestTags.contains(tag))
                            .length;

                        var userLikedFeed = (List<Map<String, dynamic>>.from(
                                doc['likes']))
                            .any((like) =>
                                like['userId'] == UserService().currUser!.uid);

                        return {
                          'originalDoc': doc.data(),
                          'matchingInterestsCount': matchingInterestsCount,
                          'userLikedFeed': userLikedFeed,
                        };
                      }).toList();

                      feeds.sort((a, b) {
                        var userLikedFeedA = a['userLikedFeed'] as bool;
                        var userLikedFeedB = b['userLikedFeed'] as bool;

                        if (userLikedFeedA && !userLikedFeedB) {
                          return 1; // Feed A (not liked) comes after Feed B (liked)
                        } else if (!userLikedFeedA && userLikedFeedB) {
                          return -1; // Feed A (liked) comes before Feed B (not liked)
                        }

                        var matchingInterestsCountA =
                            a['matchingInterestsCount'] as int;
                        var matchingInterestsCountB =
                            b['matchingInterestsCount'] as int;

                        if (matchingInterestsCountA !=
                            matchingInterestsCountB) {
                          return matchingInterestsCountB.compareTo(
                              matchingInterestsCountA); // Sort by matching interests count descending
                        }

                        return 0; // Both feeds are either matched or not matched, maintain their order based on tag occurrence
                      });

                      return !snapshot.hasData
                          ? const Center(child: Text('Belum ada Feed'))
                          : SizedBox.expand(
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: feeds.length,
                                      itemBuilder: (ctx, index) => Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 20.0),
                                            child: PostCard(
                                              snap: feeds[index][
                                                  'originalDoc'], // Use the sorted feeds
                                            ),
                                          ))));
                    }))));
  }
}

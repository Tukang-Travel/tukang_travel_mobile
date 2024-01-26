import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuktraapp/services/recommendation_service.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  var userInterestTags = <String>[];
  RecommendationService recommendationService = RecommendationService();

  Future<void> _pullRefresh() async {
    setState(() {
      _getPreference();
    });
  }

  @override
  void initState() {
    super.initState();
    _getPreference();
    recommendationService.load(context);
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

                      // Create a list of indexed feeds
                      List<Map<String, dynamic>> indexedFeeds = List.generate(
                        snapshot.data!.docs.length,
                        (index) {
                          var doc = snapshot.data!.docs[index];
                          var docId = index.toString(); // Using index as docId
                          var data = doc.data(); // Document data
                          data['docId'] = docId; // Add docId to document data
                          return data;
                        },
                      );

                      // Create a list to hold liked feeds
                      List<Map<String, dynamic>> likedFeeds = [];

                      // Iterate through indexedFeeds to filter liked feeds
                      for (var feedData in indexedFeeds) {
                        List<dynamic> likes =
                            feedData["likes"]; // Change to List<dynamic>

                        // Check if the likes field contains the userId
                        bool containsUserId = likes.any((like) =>
                            like["userId"] == UserService().currUser!.uid);

                        if (containsUserId) {
                          // If the likes field contains the userId, add it to likedFeeds
                          likedFeeds.add(feedData);
                        }
                      }

                      Future<List<int>?> recommendationFuture =
                          recommendationService.recommend(likedFeeds);

                      return FutureBuilder<List<int>?>(
                        future: recommendationFuture,
                        builder: (context, recommendSnapshot) {
                          if (recommendSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          // Check if there are recommendations
                          if (recommendSnapshot.hasData &&
                              recommendSnapshot.data != null) {
                            // Use sorted recommendations to display items
                            List<int> sortedRecommendations =
                                recommendSnapshot.data!;
                            return _buildFeedList(sortedRecommendations,
                                indexedFeeds, likedFeeds);
                          } else {
                            // No recommendations or error occurred
                            return _buildFeedList([], indexedFeeds, likedFeeds);
                          }
                        },
                      );
                    }))));
  }

  Widget _buildFeedList(
    List<int> recommendedItems,
    List<Map<String, dynamic>> feedItems,
    List<Map<String, dynamic>> likedFeeds,
  ) {
    // Combine recommended items with remaining feed items
    List<Map<String, dynamic>> allItems = [];

    // Step 1: Show recommended items first
    allItems.addAll(recommendedItems.map((docId) {
      return feedItems.firstWhere((doc) => doc['docId'] == docId.toString());
    }));

    // Step 2: Sort the remaining feed items by user interest tags and tag occurrences
    List<Map<String, dynamic>> remainingItems = feedItems
        .where((doc) =>
            !recommendedItems.contains(int.parse(doc['docId'] as String)))
        .toList();

    remainingItems.sort((a, b) {
      // Count tags for each item
      Map<String, int> tagCountsA =
          countTags(List<String>.from(a['tags']), userInterestTags);
      Map<String, int> tagCountsB =
          countTags(List<String>.from(b['tags']), userInterestTags);

      // Calculate total occurrences for each item
      int totalOccurrencesA = tagCountsA.values.reduce((a, b) => a + b);
      int totalOccurrencesB = tagCountsB.values.reduce((a, b) => a + b);

      // Check if the items are liked
      bool isLikedA =
          likedFeeds.any((likedItem) => likedItem['docId'] == a['docId']);
      bool isLikedB =
          likedFeeds.any((likedItem) => likedItem['docId'] == b['docId']);

      // Sort by liked status and total occurrences
      if (isLikedA != isLikedB) {
        // Prefer not liked items to show first
        return isLikedA ? 1 : -1;
      } else {
        // Sort by total occurrences in descending order
        return totalOccurrencesB.compareTo(totalOccurrencesA);
      }
    });

    // Step 3: Add sorted remaining feed items to allItems
    allItems.addAll(remainingItems);

    return SizedBox.expand(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: allItems.length,
          itemBuilder: (ctx, index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: PostCard(
              snap: allItems[index],
            ),
          ),
        ),
      ),
    );
  }

// Function to count tags for an item based on user interest tags
  Map<String, int> countTags(List<String> tags, List<String> userInterestTags) {
    Map<String, int> tagCounts = {};

    // Update the tagCounts map with the occurrences of each tag
    for (var tag in tags) {
      tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
    }

    // Iterate through userInterestTags and update the tagCounts map
    for (var tag in userInterestTags) {
      tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
    }

    return tagCounts;
  }
}

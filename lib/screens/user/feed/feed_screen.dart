import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('feeds')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
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

                    return !snapshot.hasData
                        ? const Center(child: Text('No Feed yet'))
                        : SizedBox.expand(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (ctx, index) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: PostCard(
                                      snap: snapshot.data!.docs[index].data(),
                                    ),
                                  ),
                                )));
                  })),
        ));
  }
}

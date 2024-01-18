import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuktraapp/models/user_model.dart';
import 'package:tuktraapp/provider/user_provider.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/screens/user/feed/edit_feed_screen.dart';
import 'package:tuktraapp/services/feed_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:tuktraapp/utils/utils.dart';
import 'package:tuktraapp/widgets/comment_card.dart';
import 'package:tuktraapp/widgets/image_video_slider.dart';
import 'package:tuktraapp/widgets/tags_card.dart';

class FeedDetailScreen extends StatefulWidget {
  const FeedDetailScreen({super.key, required this.feedId});

  final String feedId;

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  final oCcy = NumberFormat("#,##0.00", "en_US");
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String username) async {
    try {
      String res = await FeedService().postComment(
          widget.feedId, commentEditingController.text, uid, username);

      if (res != 'success') {
        if (context.mounted) showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      if (context.mounted) {
        showSnackBar(
          context,
          err.toString(),
        );
      }
    }
  }

  deleteFeed(String feedId, String title) async {
    try {
      await FeedService().deleteFeed(feedId);
      await FeedService().deleteFiles(title);
      if (context.mounted) {
        NavigationUtils.pushRemoveTransition(context, const MainScreen(page: 4));
        Alert.successMessage('Berhasil menghapus feed.', context);
      }
    } catch (err) {
      if (context.mounted) {
        showSnackBar(
          context,
          err.toString(),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    commentEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).user;

    return Scaffold(
        body: SafeArea(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('feeds')
                    .doc(widget.feedId)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 250.0,
                          floating: false,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              background: ImageVideoSlider()
                                  .checkImageVideo(snapshot.data!["content"])),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //JUDUL, JUMLAH LIKE, JUMLAH KOMENTAR, BUTTON EDIT, BUTTON DELETE
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container (
                                              width: 200,
                                              child: AutoSizeText(
                                                snapshot.data!["title"],
                                                maxLines: 10,
                                                style: const TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2,
                                                ),
                                              ),
                                            ),
                                            snapshot.data!["userId"] == user.uid
                                                ? Row(
                                                    children: [
                                                      Card(
                                                        color: Colors.white,
                                                        elevation: 10.0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                                color: const Color(
                                                                    0xffE9E9E9)),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              EditFeedScreen(
                                                                                feedId: widget.feedId,
                                                                                initialTitle: snapshot.data!["title"],
                                                                                initialTags: (snapshot.data!["tags"] as List<dynamic>).cast<String>(),
                                                                              )),
                                                                );
                                                              },
                                                              icon: const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .blue),
                                                            )),
                                                      ),
                                                      Card(
                                                        color: Colors.white,
                                                        elevation: 10.0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                                color: const Color(
                                                                    0xffE9E9E9)),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContextcontext) {
                                                                      return AlertDialog(
                                                                        backgroundColor: Colors.white,
                                                                        title:
                                                                            const Text(
                                                                          'Apakah anda yakin ingin menghapus feed ini?',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            height:
                                                                                1.2,
                                                                          ),
                                                                        ),
                                                                        actions: <Widget>[
                                                                          TextButton(
                                                                            style:
                                                                                TextButton.styleFrom(
                                                                              textStyle: Theme.of(context).textTheme.labelLarge,
                                                                            ),
                                                                            child:
                                                                                const Text('Batal', style: TextStyle(color: Colors.black)),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                          ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(209, 26, 42, 1.0)),
                                                                            child:
                                                                                const Text(
                                                                              'Hapus',
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              deleteFeed(widget.feedId, snapshot.data!["title"]);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                              },
                                                              icon: const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red),
                                                            )),
                                                      )
                                                    ],
                                                  )
                                                : const Row()
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.favorite,
                                              size: 30.0,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 15),
                                            Text(
                                              snapshot.data!["likes"].length
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                height: 1.2,
                                              ),
                                            ),
                                            const SizedBox(width: 50),
                                            const Icon(
                                              Icons.comment_rounded,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 15),
                                            Text(
                                              snapshot.data!["comments"].length
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                height: 1.2,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),

                                    const Divider(
                                      height: 50,
                                      color: Colors.transparent,
                                    ),

                                    //TAGS
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Tags',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                snapshot.data!['tags'].length,
                                            itemBuilder: (ctx, index) =>
                                                TagsCard(
                                              snap: snapshot.data!['tags']
                                                  [index],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Divider(
                                      height: 50,
                                      color: Colors.transparent,
                                    ),

                                    //Komentar
                                    const Text(
                                      'Komentar',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                      ),
                                    ),
                                    const Divider(
                                      height: 20,
                                      color: Colors.transparent,
                                    ),
                                    Container(
                                      height: kToolbarHeight,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          color: const Color(0xffE9E9E9)),
                                      margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 8),
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            backgroundImage: AssetImage(
                                              'asset/images/default_profile.png',
                                            ),
                                            radius: 18,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 8),
                                              child: TextField(
                                                controller:
                                                    commentEditingController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Komentar sebagai ${user.username}',
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => postComment(
                                                user.uid, user.username),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              child: const Text(
                                                'Post',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ];
                    },
                    body: snapshot.data?['comments'].length == 0
                        ? const Center(
                            child: Text('Belum ada komentar'),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!['comments'].length,
                              itemBuilder: (ctx, index) => CommentCard(
                                snap: snapshot.data!['comments'][index],
                              ),
                            )),
                  );
                })));
  }
}

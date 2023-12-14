import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:tuktraapp/models/user_model.dart';
import 'package:tuktraapp/screens/user/feed/feed_detail_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:video_player/video_player.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<dynamic> data = [];
  var posts = <Widget>[];

  Future<dynamic> getData() async {
    posts.clear();
    // Get docs from collection reference

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("feeds").get();

    // Get data from docs and convert map to List

    // data = querySnapshot.docs.map((e) => e.data()).toList();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> feedData = (doc.data() as Map<String, dynamic>);

      // Get the username for the corresponding userId
      String userId = feedData['userId'];
      UserModel? _user = await getUser(userId);
      String username = _user!.username as String;

      // Replace userId with username in the data
      feedData['username'] = username;
      feedData.remove('userId');

      data.add(feedData);
    }

    if (context.mounted) {
      posts.add(buildTitle(context));
    }

    for (var i = 0; i < data.length; i++) {
      print(data[i]);
      if (context.mounted) {
        posts.add(
          buildPostCard(context, data[i]),
        );
      }
    }
    print(posts);
  }

  Future<void> _pullRefresh() async {
    posts.clear();
    setState(() {});
  }

  Future<UserModel?> getUser(String userId) async {
    QuerySnapshot users =
        await FirebaseFirestore.instance.collection("users").get();
    for (var user in users.docs) {
      if (user.get("uid").toString() == userId) {
        return UserModel(user.get("uid"), user.get("name"),
            user.get("username"), user.get("email"), user.get("type"));
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox.expand(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: posts,
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        /* ),
          ],
        ), */
      ),
    );
  }
}

Widget buildTitle(BuildContext context) {
  return Container(
    padding: const EdgeInsetsDirectional.only(top: 20.0),
    margin: const EdgeInsets.only(bottom: 30.0),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'Feeds',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ],
    ),
  );
}

List<String> generateUrl(List<dynamic> files) {
  List<String> url = [];
  for (var file in files) {
    print(file.type);
    print(file.src);
    if (file.type.toString() == "image") {
      url.add(file.src.toString());
    }
  }
  return url;
}

Future<ChewieController> _initializeChewieController(String fileData) async {
  VideoPlayerController videoPlayerController =
      VideoPlayerController.networkUrl(Uri.dataFromString(fileData));

  await videoPlayerController.initialize();

  return ChewieController(
    videoPlayerController: videoPlayerController,
    aspectRatio: 3 / 2,
    autoPlay: true,
    looping: true,
  );
}

Widget checkImageVideo(List<dynamic> file) {
  print('tes -> ${Map<String, String>.from(file[0])["src"]}');
  return Swiper(
    itemCount: file.length,
    itemBuilder: (BuildContext context, int index) {
      if (Map<String, String>.from(file[index])["type"] == "image") {
        return CachedNetworkImage(
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          imageUrl: Map<String, String>.from(file[index])["src"]!,
          fit: BoxFit.fitHeight,
        );
      } else {
        return FutureBuilder<ChewieController>(
          future: _initializeChewieController(file[index]["src"]! as String),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Chewie(controller: snapshot.data!);
            } else {
              // Return a loading indicator or placeholder while waiting
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      }
    },
    autoplay: false,
    loop: false,
    pagination: const SwiperPagination(),
  );
}

Widget buildPostCard(BuildContext context, dynamic data) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.5,
    margin: const EdgeInsets.symmetric(vertical: 20.0),
    child: GestureDetector(
      onTap: () {},
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            '@${data["username"]}',
                            maxLines: 1,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Container(
                        color: Colors.black,
                        constraints: const BoxConstraints.expand(),
                        child: checkImageVideo(data["content"]))),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            height: 20,
                            color: Colors.transparent,
                          ),
                          Row(
                            children: [
                              IconButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 10),
                                  constraints: const BoxConstraints(),
                                  onPressed: () => {},
                                  icon: SvgPicture.asset(
                                    'asset/images/love.svg',
                                    color: Colors.black,
                                    fit: BoxFit.contain,
                                  )),
                              const AutoSizeText(
                                "13 likes",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                          AutoSizeText(
                            data["title"],
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 2,
                          ),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  textStyle: const TextStyle(fontSize: 12),
                                  padding: EdgeInsets.zero),
                              onPressed: () {
                                /*  NavigationUtils.pushTransition(
                                    context,
                                    FeedDetailScreen(
                                        name: data["title"],
                                        location: 'tes',
                                        description: 'desctes',
                                        file: ['https://firebasestorage.googleapis.com/v0/b/tukang-travel.appspot.com/o/destinations%2FFurusato%20Izakaya%2F1646878263479?alt=media&token=822506cd-4c14-4a47-8244-a278e643e44a'],
                                        rating: 4.5,
                                        estimasi: 'tes')); */
                              },
                              child: const Text(
                                'More',
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          )),
    ),
  );
}

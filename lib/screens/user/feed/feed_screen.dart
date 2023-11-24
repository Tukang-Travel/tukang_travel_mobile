import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:tuktraapp/screens/user/feed/feed_detail_screen.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<dynamic>? data;
  var posts = <Widget>[];
  CollectionReference collections =
      FirebaseFirestore.instance.collection("destinations");

  Future<dynamic> getData() async {
    // Get docs from collection reference

    QuerySnapshot querySnapshot = await collections.get();

    // Get data from docs and convert map to List

    // List<FeedModel> response = [
    //   FeedModel(
    //       1,
    //       [
    //         'https://c4.wallpaperflare.com/wallpaper/560/855/635/spy-x-family-anya-forger-hd-wallpaper-preview.jpg'
    //       ],
    //       'stevenwj12',
    //       true)
    // ]; //sementara belum hit api

    data = querySnapshot.docs.map((e) => e.data()).toList();

    posts.add(buildTitle(context));

    for (var i = 0; i < data!.length; i++) {
      posts.add(
        buildPostCard(context, data?[i]),
      );
    }
  }

  Future<void> _pullRefresh() async {
    posts.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: /* Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AutoSizeText(
                    'Pengalaman Wisata',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'PoppinsBold',
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add your button click logic here
                      print('Button Clicked!');
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: const Row(
                      
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.black, // Icon color
                        ),
                        SizedBox(
                            width: 8.0), // Adjust spacing between icon and text
                        Text(
                          'Tambahkan pengalaman wisatamu disini',
                          style: TextStyle(
                            color: Colors.black, // Text color
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child:  */
            RefreshIndicator(
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
          'Feed',
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

List<String> generateUrl(List<dynamic> file) {
  List<String> url = [];
  for (var i = 0; i < file.length; i++) {
    if (file[i].runtimeType.toString() == "String") {
      url.add(file[i].toString());
    }
  }
  return url;
}

Widget checkImageVideo(List<dynamic> file) {
  List<String> url = generateUrl(file);
  return Swiper(
    itemCount: url.length,
    itemBuilder: (BuildContext context, int index) => Image.network(
      url[index],
      fit: BoxFit.cover,
    ),
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
                            data["name"],
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
                          const Divider(
                            height: 5,
                            color: Colors.transparent,
                          ),
                          AutoSizeText(
                            data["location"],
                            maxLines: 1,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
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
                        child: checkImageVideo(data["image"]))),
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
                          // IconButton(
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 0, vertical: 10),
                          //     constraints: const BoxConstraints(),
                          //     onPressed: () => {},
                          //     icon: SvgPicture.asset(
                          //       'assets/images/homescreen/love.svg',
                          //       color: Colors.black,
                          //       fit: BoxFit.contain,
                          //     )),
                          /* postpone (akan di update nanti)
                          AutoSizeText(
                            "13 likes",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                            ),
                          ),*/
                          AutoSizeText(
                            data["description"],
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
                                NavigationUtils.pushTransition(
                                    context,
                                    FeedDetailScreen(
                                        name: data["name"],
                                        location: data["location"],
                                        description: data["description"],
                                        file: generateUrl(data["image"]),
                                        rating: data["rating"],
                                        estimasi: data["estimasi"]));
                              },
                              child: const Text(
                                'Lihat selengkapnya',
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

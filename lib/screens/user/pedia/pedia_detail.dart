import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuktraapp/models/user_model.dart';
import 'package:tuktraapp/provider/user_provider.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/screens/owner/pedia/update_pedia.dart';
import 'package:tuktraapp/services/pedia_service.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:tuktraapp/utils/utils.dart';
import 'package:tuktraapp/widgets/tags_card.dart';

class PediaDetail extends StatefulWidget {
  final String id;
  const PediaDetail({super.key, required this.id});

  @override
  State<PediaDetail> createState() => _PediaDetailState();
}

class _PediaDetailState extends State<PediaDetail> {
  UserService userService = UserService();
  PediaService pediaService = PediaService();
  int rating = 0;
  Map<String, dynamic> pedia = {};
  List<dynamic> medias = [];
  List<dynamic> tags = [];
  List<Map<String, dynamic>> rates = [], comments = [];
  double avgRate = 0;
  bool done = false;
  Map<String, dynamic> userData = {};

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController commentTxt = TextEditingController();

  Future<void> fetch() async {
    done = false;
    rating = 0;
    pedia = {};
    medias = [];
    tags = [];
    rates = [];
    comments = [];
    avgRate = 0;

    List<dynamic> results =
        await Future.wait([pediaService.getPedia(widget.id)]);

    if (results.isNotEmpty) {
      pedia = results[0];
      medias = pedia['medias'];
      tags = pedia['tags'];

      if (pedia.containsKey('rates')) {
        rates = (pedia['rates'] as List).cast<Map<String, dynamic>>();

        for (int i = 0; i < rates.length; i++) {
          try {
            final rateMap = rates[i];
            if (rateMap.containsKey('rate')) {
              avgRate += rateMap['rate'];
            } else {
              if (context.mounted) {
                Alert.alertValidation(
                    'Data struktur rate salah $i: $rateMap', context);
              }
            }
          } catch (e) {
            if (context.mounted) {
              Alert.alertValidation(
                  'Error pada data rate ke [$i]: $e', context);
            }
          }
        }

        if (rates.isNotEmpty) {
          avgRate = (avgRate / rates.length);
        }

        for (int i = 0; i < rates.length; i++) {
          if (rates[i]['userid'] == userService.currUser!.uid) {
            setState(() {
              rating = rates[i]['rate'];
            });
            break;
          }
        }
      }

      if (pedia.containsKey('comments')) {
        if (pedia['comments'] != null) {
          comments = (pedia['comments'] as List).cast<Map<String, dynamic>>();

          for (final comment in comments) {
            final user = await userService.getUser(comment['userid']);
            userData[comment['userid']] = user;
          }
        }
      }
    } else {
      if (context.mounted) {
        Alert.alertValidation(
            "Gagal Mendapatkan data Pedia, Silahkan coba lagi ya.", context);
      }
    }

    setState(() {
      done = true;
    });
  }

  @override
  void initState() {
    fetch();

    super.initState();
  }

  @override
  void dispose() {
    rating = 0;
    pedia = {};
    medias = [];
    tags = [];
    rates = [];
    comments = [];
    avgRate = 0;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    final UserModel user = Provider.of<UserProvider>(context).user;

    if (!done) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 65.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0, // Set the height of the slider
                    enlargeCenterPage:
                        true, // Set to true for the active (center) photo to be larger
                    autoPlay: true, // Set to true for automatic sliding
                    aspectRatio: 16 / 9, // Set the aspect ratio of the images
                    autoPlayCurve: Curves
                        .fastOutSlowIn, // Animation curve for automatic sliding
                    enableInfiniteScroll:
                        true, // Set to false to disable infinite scrolling
                    autoPlayAnimationDuration: const Duration(
                        milliseconds:
                            800), // Duration of automatic sliding animation
                    viewportFraction:
                        0.8, // Fraction of the viewport width each item should occupy
                  ),
                  items: medias.map((m) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        m,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        pedia['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 22.0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        for (var i = 1; i <= 5; i++)
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                rating = i;
                              });

                              await pediaService.insertPediaRate(
                                  widget.id, rating, userService.currUser!.uid);
                              await fetch();
                            },
                            child: Icon(
                              Icons.star,
                              size: 25.0,
                              color: i <= rating
                                  ? const Color.fromARGB(255, 255, 215, 0)
                                  : Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                          text: '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                          ),
                          children: [
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(right: 5.0),
                                child: Icon(
                                  Icons.star,
                                  size: 20.0,
                                  color: Color.fromARGB(255, 255, 215, 0),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: avgRate.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0,
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                child: //TAGS
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: tags.length,
                        itemBuilder: (ctx, index) => TagsCard(
                          snap: tags[index],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                child: Text(
                  pedia['description'],
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          borderRadius: BorderRadius.circular(30.0),
                          color: const Color(0xffE9E9E9)),
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      padding: const EdgeInsets.only(left: 16, right: 8),
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
                              padding:
                                  const EdgeInsets.only(left: 16, right: 8),
                              child: TextField(
                                controller: commentTxt,
                                decoration: InputDecoration(
                                  hintText: 'Komentar sebagai ${user.username}',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.multiline,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (commentTxt.text != '' ||
                                  commentTxt.text.isNotEmpty) {
                                final comment = commentTxt.text;

                                try {
                                  pediaService.insertPediaComment(widget.id,
                                      comment, userService.currUser!.uid);
                                } catch (e) {
                                  if (context.mounted) {
                                    Alert.alertValidation(
                                        "Terjadi Kesalahan, Silahkan Coba Lagi Ya.",
                                        context);
                                  }
                                }

                                setState(() {
                                  commentTxt.text = "";
                                  fetch();
                                });
                              } else {
                                Alert.alertValidation(
                                    'Komentar harus diisi!', context);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: const Text(
                                'Post',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20.0,
                    ),

                    // comment list
                    comments.isEmpty
                        ? const Center(child: Text('Belum ada komentar'))
                        : SizedBox(
                            height: 200.0,
                            width: w,
                            child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                if (comments.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Belum terdapat komentar',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 107, 107, 107)),
                                    ),
                                  );
                                }

                                if (index >= comments.length) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Belum terdapat komentar',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 107, 107, 107)),
                                    ),
                                  );
                                }
                                final comment = comments[index];

                                final user = userData[comment['userid']];

                                return Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10.0),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Image.network(
                                            user['profile'],
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${user['username']}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Text(comment['comment']),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                    const SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 30.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () {
                NavigationUtils.pushRemoveTransition(
                    context, const MainScreen(page: 0));
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tuktraapp/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:tuktraapp/services/pedia_service.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tuktraapp/provider/user_provider.dart';

class PediaDetail extends StatefulWidget {
  final String id;
  const PediaDetail({super.key, required this.id});

  @override
  State<PediaDetail> createState() => _PediaDetailState();
}

class _PediaDetailState extends State<PediaDetail> {
  UserService userService = UserService();
  PediaService pediaService = PediaService();
  final TextEditingController commentEditingController = TextEditingController();
  int rating = 0;
  Map<String, dynamic> pedia = {};
  List<dynamic> medias = [];
  List<dynamic> tags = [];
  List<Map<String, dynamic>>? rates, comments;
  int avgRate = 0;
  bool done = false;
  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController commentTxt = TextEditingController();

  void postComment(String uid, String username) async {
    try {
      String res = await PediaService().postComment(
          widget.id, commentEditingController.text, uid, username);

      if (res != 'success') {
        if (context.mounted) Alert.alertValidation(res, context);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      if (context.mounted) {
        Alert.alertValidation(err.toString(), context);
      }
    }
  }

  Future<void> fetch() async {
    rating = 0;
    pedia = {};
    medias = [];
    tags = [];
    rates = null;
    comments = null;
    avgRate = 0;

    List<dynamic> results = await Future.wait([
      pediaService.getPedia(widget.id)
    ]);

    setState(() {
      pedia = results[0];
      medias = pedia['medias'];
      tags = pedia['tags'];

      if(pedia.containsKey('rates')) {
        rates = (pedia['rates'] as List).cast<Map<String, dynamic>>();

        for(int i = 0; i < rates!.length; i++) {
          avgRate += int.parse(rates![i]['rate'].toString());
        }
        print('Before division: $avgRate');

        avgRate = (avgRate / rates!.length).round();

        print('After division: $avgRate');

        for(int i = 0; i < rates!.length; i++) {
          if(rates?[i]['userid'] == userService.currUser!.uid) {
            setState(() {
              rating = rates?[i]['rate'];
            });
            break;
          }
        }
      }

      if(pedia.containsKey('comments')) {
        comments = (pedia['comments'] as List).cast<Map<String, dynamic>>();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    rating = 0;
    pedia = {};
    medias = [];
    tags = [];
    rates = null;
    comments = null;
    avgRate = 0;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    List<dynamic> results = await Future.wait([
      pediaService.getPedia(widget.id)
    ]);

    setState(() {
      pedia = results[0];
      medias = pedia['medias'];
      tags = pedia['tags'];

      if(pedia.containsKey('rates')) {
        rates = (pedia['rates'] as List).cast<Map<String, dynamic>>();

        for(int i = 0; i < rates!.length; i++) {
          avgRate += int.parse(rates![i]['rate'].toString());
        }
        print('Before division: $avgRate');

        avgRate = (avgRate / rates!.length).round();

        print('After division: $avgRate');

        for(int i = 0; i < rates!.length; i++) {
          if(rates?[i]['userid'] == userService.currUser!.uid) {
            setState(() {
              rating = rates?[i]['rate'];
            });
            break;
          }
        }
      }

      if(pedia.containsKey('comments')) {
        comments = (pedia['comments'] as List).cast<Map<String, dynamic>>();
      }
    });

    setState(() {
      done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final UserModel user = Provider.of<UserProvider>(context).user;

    if(!done) {
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
              Container(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 65.0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0, // Set the height of the slider
                      enlargeCenterPage: true, // Set to true for the active (center) photo to be larger
                      autoPlay: true, // Set to true for automatic sliding
                      aspectRatio: 16/9, // Set the aspect ratio of the images
                      autoPlayCurve: Curves.fastOutSlowIn, // Animation curve for automatic sliding
                      enableInfiniteScroll: true, // Set to false to disable infinite scrolling
                      autoPlayAnimationDuration: Duration(milliseconds: 800), // Duration of automatic sliding animation
                      viewportFraction: 0.8, // Fraction of the viewport width each item should occupy
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 25.0),
                child: Text(
                  pedia['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22.0
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Row(
                  children: [
                    for(var i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          rating = i;
                        });

                        await pediaService.insertPediaRate(widget.id, rating, userService.currUser!.uid);
                        await fetch();
                      },
                      child: Icon(
                        Icons.star,
                        size: 25.0,
                        color: i <= rating ? const Color.fromARGB(255, 255, 215, 0) : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Row(
                  children: [
                    Container(
                      width: 300.0,
                      child: Text(
                        'Label: ${tags.join(', ')}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
                                color:  Color.fromARGB(255, 255, 215, 0),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: '$avgRate',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Text(
                  pedia['description'],
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Komentar',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        )
                      ),

                      // comment list
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          height: 200.0,
                          width: w,
                          child: ListView.builder(
                            itemCount: comments?.length,
                            itemBuilder: (context, index) {
                              if (comments == null) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Belum terdapat komentar',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 107, 107, 107)
                                    ),
                                  ),
                                );
                              }

                              if (index >= comments!.length) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Belum terdapat komentar',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 107, 107, 107)
                                    ),
                                  ),
                                );
                              }
                              final comment = comments?[index];
                      
                              return FutureBuilder(
                                future: userService.getUser(comment?['userid']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator()); // Loading indicator while fetching data
                                  }
                      
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                      
                                  final user = snapshot.data!;
                      
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                      child: Row(
                                        children: [
                                          user.containsKey('profile') ?
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(100.0),
                                            child: Image.network(
                                              user['profile'],
                                              width: 50,
                                              height: 50,
                                            ),
                                          )
                                          :
                                          Image.asset(
                                            'asset/images/default_profile.png',
                                            width: 50,
                                            height: 50,
                                          ),
                                          const SizedBox(width: 10.0,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${user['username']}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              const SizedBox(height: 5.0,),
                                              Text(comment?['comment']),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      
                      const Divider(
                        height: 50,
                        color: Colors.transparent,
                      ),

                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded( // Wrap with Expanded
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: Offset(1, 1),
                                          color: Color.fromARGB(128, 170, 188, 192),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: commentTxt,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      validator: ((value) => value!.isEmpty ? 'Komentar harus diisi' : null),
                                      decoration: InputDecoration(
                                        hintText: 'Ketik komentar mu disini...',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color.fromARGB(128, 170, 188, 192),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color.fromARGB(128, 170, 188, 192),
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                InkWell(
                                  onTap: () async {
                                    final comment = commentTxt.text ?? "";
                                    pediaService.insertPediaComment(widget.id, comment, userService.currUser!.uid);
                                    commentTxt.text = "";

                                    NavigationUtils.pushRemoveTransition(context, PediaDetail(id: widget.id));
                                  },
                                  child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color.fromARGB(217, 82, 114, 255), // Customize the color
                                    ),
                                    child: const Icon(
                                      Icons.send,
                                      color: Colors.white, // Customize the icon color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                      const SizedBox(height: 20.0,)
                    ],
                  ),
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
                NavigationUtils.pushRemoveTransition(context, const MainScreen(page: 1));
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
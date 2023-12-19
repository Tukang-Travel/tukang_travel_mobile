import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/screens/owner/pedia/update_pedia.dart';
import 'package:tuktraapp/services/pedia_service.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class OwnerPediaDetail extends StatefulWidget {
  final String id;
  const OwnerPediaDetail({super.key, required this.id});

  @override
  State<OwnerPediaDetail> createState() => _OwnerPediaDetailState();
}

class _OwnerPediaDetailState extends State<OwnerPediaDetail> {
  int rating = 0;
  Map<String, dynamic> pedia = {};
  List<dynamic> medias = [];
  List<dynamic> tags = [];
  List<Map<String, dynamic>>? rates, comments;
  int avgRate = 0;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController commentTxt = TextEditingController();

  Future<void> fetch() async {
    rating = 0;
    pedia = {};
    medias = [];
    tags = [];
    rates = null;
    comments = null;
    avgRate = 0;

    List<dynamic> results = await Future.wait([
      getPedia(widget.id)
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
          if(rates?[i]['userid'] == currUser!.uid) {
            setState(() {
              rating = rates?[i]['rate'];
            });
            break;
          }
        }

        print('rating: $rating');
      }

      if(pedia.containsKey('comments')) {
        comments = (pedia['comments'] as List).cast<Map<String, dynamic>>();
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await fetch();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

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
                child: Row(
                  children: [
                    Container(
                      width: 200,
                      child: Text(
                        pedia['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22.0
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0)
                            ),
                            backgroundColor: const Color.fromARGB(255, 82,114,255)
                          ),
                          onPressed: () {
                            NavigationUtils.pushRemoveTransition(context, UpdatePedia(id: widget.id));
                          },
                          child: const Icon(Icons.edit),
                        ),
                        const SizedBox(width: 10.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0)
                            ),
                            backgroundColor: Colors.red),
                          onPressed: () {
                            showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Hapus Rencana Keseharian'),
                                  content: Text('Apakah anda yakin untuk menghapus pedia "${pedia['title']}"?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        
                                      },
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ],
                    )
                  ],
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

                        await insertPediaRate(widget.id, rating, currUser!.uid);
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
                      comments == null ?
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Belum terdapat komentar',
                            style: TextStyle(
                              color: Color.fromARGB(255, 107, 107, 107)
                            ),
                          ),
                        )
                        :
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            height: 200.0,
                            width: w,
                            child: ListView.builder(
                              itemCount: comments?.length,
                              itemBuilder: (context, index) {
                                final comment = comments?[index];
                        
                                return FutureBuilder(
                                  future: getUser(comment?['userid']),
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
                      
                      SizedBox(height: 10.0,),

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
                                  onTap: () {
                                    insertPediaComment(widget.id, commentTxt.text, currUser!.uid);
                                    commentTxt.text = "";
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
                NavigationUtils.pushRemoveTransition(context, const MainScreen(page: 0));
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
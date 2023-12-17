import 'package:flutter/material.dart';
import 'package:tuktraapp/services/pedia_service.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/utils/navigation_util.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PediaDetail extends StatefulWidget {
  final String id;
  const PediaDetail({super.key, required this.id});

  @override
  State<PediaDetail> createState() => _PediaDetailState();
}

Map<String, dynamic> pedia = {};
List<dynamic> medias = [];
List<dynamic> tags = [];
List<Map<String, dynamic>>? rates, comments;
int avgRate = 0;

class _PediaDetailState extends State<PediaDetail> {
  
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

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
      }

      if(pedia.containsKey('comments')) {
        comments = (pedia['comments'] as List).cast<Map<String, dynamic>>();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                color: Colors.grey,
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
                child: Text(pedia['description']),
              ),
              Container(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Komentar',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        )
                      ),

                      // comment list
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
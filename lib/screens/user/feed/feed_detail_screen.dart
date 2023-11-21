import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:intl/intl.dart';

class FeedDetailScreen extends StatefulWidget {
  const FeedDetailScreen({super.key});

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class ScreenArguments {
  String name = "";
  String location = "";
  String description = "";
  List<String> file = [];
  double rating = 0.0;
  String estimasi = "0";

  ScreenArguments(this.name, this.location, this.description, this.file,this.rating, this.estimasi);   
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  ScreenArguments? args;
  final oCcy = NumberFormat("#,##0.00", "en_US");

  Widget _customScrollView() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 250.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(args!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  )),
              background: Swiper(
                itemCount: args!.file.length,
                itemBuilder: (BuildContext context, int index) => Image.network(
                  args!.file[index],
                  fit: BoxFit.cover,
                ),
                autoplay: (args!.file.length != 1) ? true : false,
                loop: true,
              )),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildRow1(),
                    const Divider(
                      height: 50,
                      color: Colors.transparent,
                    ),
                    buildDeskripsi(),
                    const Divider(
                      height: 50,
                      color: Colors.transparent,
                    ),
                    buildTourGuide(),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final temp = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    args = temp;
    return Scaffold(
      body: _customScrollView(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: 2))),
          child: buildBottom(),
        ),
      ),
    );
  }

  Widget buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            const AutoSizeText(
              "Estimasi Biaya",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                height: 1.2,
              ),
            ),
            AutoSizeText(
              "Rp ${oCcy.format(int.parse(args!.estimasi))}",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildRow1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AutoSizeText(
              args!.name,
              maxLines: 10,
              style: const TextStyle(
                fontFamily: 'PoppinsBold',
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const Divider(height: 5),
            AutoSizeText(
              args!.location,
              maxLines: 10,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                height: 1.2,
              ),
            ),
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RatingBarIndicator(
                  rating: args!.rating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 30.0,
                ),
                const SizedBox(width: 10,),
                Column(
                  children: [
                    const SizedBox(height: 5,),
                    Text(
                      args!.rating.toString(),
                      style: const TextStyle(
                        fontFamily: 'PoppinsBold',
                        fontSize: 16,
                        color: Color.fromARGB(255, 187, 142, 7),//Color.fromRGBO(239, 90, 38, 1.0),
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ),
        // IconButton(
        //     padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        //     constraints: const BoxConstraints(),
        //     onPressed: () => {},
        //     icon: SvgPicture.asset(
        //       'assets/images/homescreen/love.svg',
        //       color: Colors.black,
        //       fit: BoxFit.contain,
        //     )),
      ],
    );
  }

  Widget buildDeskripsi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AutoSizeText(
          "Deskripsi Singkat",
          style: TextStyle(
            fontFamily: 'PoppinsBold',
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w100,
            height: 1.2,
          ),
        ),
        const Divider(
          color: Colors.black,
        ),
        AutoSizeText(
          args!.description,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget buildTourGuide() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: AutoSizeText(
            "Tour Guide",
            style: TextStyle(
              fontFamily: 'PoppinsBold',
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w100,
              height: 1.2,
            ),
          ),
        ),
        Divider(
          color: Colors.black,
        ),
        Center(
          child: AutoSizeText(
            "Coming Soon",
            style: TextStyle(
              fontFamily: 'PoppinsBold',
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
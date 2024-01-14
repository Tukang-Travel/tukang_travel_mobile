import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/user/pedia/pedia_detail.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class PediaScreen extends StatefulWidget {
  const PediaScreen({super.key});

  @override
  State<PediaScreen> createState() => _PediaScreenState();
}

class _PediaScreenState extends State<PediaScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50.0, bottom: 10.0, left: 5.0),
                child: Text(
                  'Pedia Perjalanan',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              // const Padding(
              //   padding: EdgeInsets.only(bottom: 20.0, left: 5.0),
              //   child: Text(
              //     'Dapatkan informasi tentang tempat wisata disini.',
              //     style: TextStyle(
              //         fontSize: 15.0, color: Color.fromARGB(255, 81, 81, 81)),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('pedias')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No data available');
                    }

                    return Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: h,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var itemData = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            var itemId = snapshot.data!.docs[index].id;
                            return GestureDetector(
                              onTap: () {
                                NavigationUtils.pushRemoveTransition(
                                    context, PediaDetail(id: itemId));
                              },
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0)),
                                        child: Image.network(
                                          itemData['medias'][0],
                                          height: 100,
                                          width: 300,
                                        )),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(itemData['title'],
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17.0)),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            itemData['description'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

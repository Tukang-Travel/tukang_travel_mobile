import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/authentication/login_owner_screen.dart';
import 'package:tuktraapp/screens/owner/pedia/owner_pedia_detail.dart';
import 'package:tuktraapp/screens/owner/profile/edit_owner_profile_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class OwnerProfileMenu {
  late String menuName;
  late Widget menuWidget;
  late IconData menuIcon;

  OwnerProfileMenu({
    required this.menuName,
    required this.menuWidget,
    required this.menuIcon,
  });
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  UserService userService = UserService();

  bool isLoading = false;

  Map<String, dynamic>? user;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    List<dynamic> results = await Future.wait([
      userService.getUser(userService.currUser!.uid),
    ]);

    setState(() {
      user = results[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userService.currUser!.uid)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              top: 16.0,
                              right: 16.0,
                              bottom: 0.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                user?['profile'] == null
                                    ? Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 80.0,
                                            top: 80.0,
                                            right: 80.0,
                                            bottom: 20.0,
                                          ),
                                          child: Image.asset(
                                            'asset/images/default_profile.png',
                                            width: 150,
                                            height: 150,
                                          ),
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 80.0,
                                            top: 80.0,
                                            right: 80.0,
                                            bottom: 20.0,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: Image.network(
                                              user?['profile'],
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                        ),
                                      ),
                                Text(
                                  '${user?['name']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 25.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  '@${user?['username']}',
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    String profile = "";
                                    if (user?['profile'] != null) {
                                      setState(() {
                                        profile = user?['profile'];
                                      });
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditOwnerProfileScreen(
                                          profile: profile,
                                          userId: userService.currUser!.uid,
                                          initialName: snapshot.data!["name"],
                                          initialUsername:
                                              snapshot.data!["username"],
                                          initialEmail: snapshot.data!["email"],
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 82, 114, 255),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 55.0,
                                      vertical: 15.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Ubah Profil',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await userService.logout();
                                    if (context.mounted) {
                                      NavigationUtils.pushRemoveTransition(
                                          context, const LoginOwnerScreen());
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 55.0, vertical: 15.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                  ),
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Keluar ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
                                      ),
                                      children: [
                                        WidgetSpan(
                                            child: Icon(Icons.logout_rounded))
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1.0,
                                ),
                                const Center(
                                  child: Text(
                                    "Pedia",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('pedias')
                        .where('userid', isEqualTo: userService.currUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Text('Terjadi Kesalahan, Mohon Coba Lagi Ya: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('Belum Ada Pedia yang diupload');
                      }

                      return GridView.builder(
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
                                  context, OwnerPediaDetail(id: itemId));
                            },
                            child: Card(
                              color: Colors.white,
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
                                        height: 90,
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
                      );
                    },
                  ),
                ));
          }),
    );
  }
}

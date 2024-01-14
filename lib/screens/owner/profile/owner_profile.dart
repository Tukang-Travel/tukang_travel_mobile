import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/owner/pedia/owner_pedia_detail.dart';
import 'package:tuktraapp/screens/owner/profile/edit_owner_profile_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
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
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        StreamBuilder(
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

            return Column(
              children: [
                Align(
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
                      width: 100,
                      height: 100,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditOwnerProfileScreen(
                          userId: userService.currUser!.uid,
                          initialName: snapshot.data!["name"],
                          initialUsername: snapshot.data!["username"],
                          initialEmail: snapshot.data!["email"],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 82, 114, 255),
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
                          context, const LoginScreen());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 55.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Keluar ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                      children: [WidgetSpan(child: Icon(Icons.logout_rounded))],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 1.0,
                ),
                Padding(
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
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('Belum Ada Pedia yang diupload');
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns in the grid
                          crossAxisSpacing: 8.0, // Spacing between columns
                          mainAxisSpacing: 8.0, // Spacing between rows
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var itemData = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          var itemId = snapshot.data!.docs[index].id;
                          return GestureDetector(
                            onTap: () {
                              NavigationUtils.pushTransition(
                                context,
                                OwnerPediaDetail(id: itemId.toString()),
                              );
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
                                      topRight: Radius.circular(10.0),
                                    ),
                                    child: Image.network(
                                      itemData['medias'][0],
                                      height: 100,
                                      width: 300,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            itemData['title'],
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ],
    )));
  }
}

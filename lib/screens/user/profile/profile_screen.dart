import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
import 'package:tuktraapp/screens/user/feed/feed_detail_screen.dart';
import 'package:tuktraapp/screens/user/profile/edit_profile_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:tuktraapp/widgets/tags_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class ProfileMenu {
  late String menuName;
  late Widget menuWidget;
  late IconData menuIcon;

  ProfileMenu({
    required this.menuName,
    required this.menuWidget,
    required this.menuIcon,
  });
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    bool isTapped = false;
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
                user?['profile'] == null ?
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
                      width: 150,
                      height: 150,
                    ),
                  ),
                )
                :
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 80.0,
                      top: 80.0,
                      right: 80.0,
                      bottom: 20.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
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
                    if(user?['profile'] != null) {
                      setState(() {
                        profile = user?['profile'];
                      });
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          profile: profile,
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
                  height: 40.0,
                ),

                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('feeds')
                        .where('userId', isEqualTo: userService.currUser!.uid)
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
                        return const Text('Belum Ada Feed yang diupload');
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          // Number of columns in the grid
                          crossAxisSpacing: 8.0,
                          // Spacing between columns
                          mainAxisSpacing: 6.0, // Spacing between rows
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var itemData = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;

                          return GestureDetector(
                            onTap: () {
                              NavigationUtils.pushTransition(
                                context,
                                FeedDetailScreen(
                                    feedId: itemData["feedId"].toString()),
                              );
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
                                    child: Image.network(
                                      _getFirstImage(itemData['content']),
                                      height: 220,
                                      width: 220,
                                      fit: BoxFit.cover,
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

  String _getFirstImage(List<dynamic> content) {
    // Filter 'content' to only get the items with 'type' equal to 'image'
    List<Map<String, dynamic>> images = List<Map<String, dynamic>>.from(
      content.where((item) => item['type'] == 'image'),
    );

    // Check if there are any images, if so, return the src of the first image
    if (images.isNotEmpty) {
      return images[0]['src'];
    }

    // If no images found, you can return a placeholder or an empty string
    return 'https://static.vecteezy.com/system/resources/previews/020/765/399/non_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg'; // Replace with your placeholder or an empty string
  }
}

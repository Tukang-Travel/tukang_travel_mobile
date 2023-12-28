import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/user/profile/edit_profile_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  return Scaffold(
    body: Column(
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
                        left: 80.0, top: 80.0, right: 80.0, bottom: 20.0),
                    child: Image.asset(
                      'asset/images/default_profile.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                Text(
                  '${user?['name']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 25.0),
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
                        builder: (context) => EditProfileScreen(
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
                        horizontal: 55.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
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
                  height: 30.0,
                ),
              ],
            );
          },
        ),
      ],
      )
    );
  }
}

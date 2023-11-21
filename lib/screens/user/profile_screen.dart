import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuktraapp/models/login_api_model.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:tuktraapp/provider/user_provider.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
import 'package:tuktraapp/screens/user/edit_preferences_screen.dart';
import 'package:tuktraapp/screens/user/insert_pedia_screen.dart';
import 'package:tuktraapp/screens/user/user_feed_screen.dart';

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
  
  bool isLoading = false;

  void _logoutAuth(type) async {
    Future<bool> out = logout();

    if(type == 'google') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      LoginApiModel.signOut;
    }

    if(await out) {
      setState(() {
        isLoading = false;
      });
    }
    else {
      setState(() {
        isLoading = true;
      });
    }
  }

  final List<ProfileMenu> profile_menus = [
    ProfileMenu(menuName: 'Atur Feed Saya', menuWidget: const UserFeedScreen(), menuIcon: Icons.video_collection_rounded),
    ProfileMenu(menuName: 'Tulis Artikel Baru', menuWidget: const InsertPediaScreen(), menuIcon: Icons.article_rounded),
    ProfileMenu(menuName: 'Atur Preferensimu', menuWidget: const EditPreferencesScreen(), menuIcon: Icons.edit_square),
    ProfileMenu(menuName: 'Keluar', menuWidget: const LoginScreen(), menuIcon: Icons.logout_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 80.0, top: 80.0, right: 80.0, bottom: 20.0),
              child: Image.asset(
                'asset/default_profile.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
          Container(
            child: Text(
              '${user?['username']}',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 25.0
              ),
            ),
          ),
          const SizedBox(height: 10.0,),
          Container(
            child: Text(
              '@${user?['email']}',
            ),
          ),
          const SizedBox(height: 15.0,),
          ElevatedButton(
            onPressed: () {}, 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 82, 114, 255),
              padding: const EdgeInsets.symmetric(horizontal: 55.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
              )
            ),
            child: const Text(
              'Edit Profile', 
              style: TextStyle(
                color: Colors.white
              ),
            )
          ),
          const SizedBox(height: 30.0,),
          Container(
            child: const Text(
              'Konten',
              style: TextStyle(
                color: Color.fromARGB(255, 82, 114, 255),
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 82, 114, 255),
            height: 10.0,
          ),
          const SizedBox(height: 20.0,),
          for(int i = 0; i < profile_menus.length; i++)
            GestureDetector(
              onTap: () {
                if(i == profile_menus.length - 1) {
                  isLoading? 
                    const Center(child: CircularProgressIndicator(),)
                    :
                    _logoutAuth(user?['login_type']);
                }
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => profile_menus[i].menuWidget,
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var fadeAnimation = animation.drive(tween);

                      return FadeTransition(opacity: fadeAnimation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 1000),
                  ),
                  (route) => false,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      profile_menus[i].menuIcon,
                      size: 40.0,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 10.0,),
                    Text(
                      profile_menus[i].menuName,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
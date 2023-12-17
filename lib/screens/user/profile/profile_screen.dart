import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuktraapp/models/login_api_model.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:tuktraapp/provider/user_provider.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
import 'package:tuktraapp/screens/user/edit_preferences_screen.dart';
import 'package:tuktraapp/screens/user/user_feed_screen.dart';
import 'package:tuktraapp/utils/navigation_util.dart';

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
  
  Map<String, dynamic>? user;

  @override
  void didChangeDependencies() async {
    // TODO: implement initState
    super.didChangeDependencies();

    List<dynamic> results = await Future.wait([
      getUser(currUser!.uid),
    ]);
    
    setState(() {
      user = results[0];
    });

    print(user);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 80.0, top: 80.0, right: 80.0, bottom: 20.0),
              child: Image.asset(
                'asset/images/default_profile.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
          Text(
            '${user?['username']}',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 25.0
            ),
          ),
          const SizedBox(height: 10.0,),
          Text(
            '@${user?['email']}',
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
        ],
      ),
    );
  }
}
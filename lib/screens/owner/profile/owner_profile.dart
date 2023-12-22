import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuktraapp/models/login_api_model.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  UserService userService = UserService();
  bool isLoading = false;

  void _logoutAuth(type) async {
    Future<bool> out = userService.logout();

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
      userService.getUser(userService.currUser!.uid),
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
              'Ubah Profil', 
              style: TextStyle(
                color: Colors.white
              ),
            )
          ),
          const SizedBox(height: 15.0,),
          ElevatedButton(
            onPressed: () async {
              await userService.logout();

              NavigationUtils.pushRemoveTransition(context, const LoginScreen());
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 55.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
              )
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
                    child: Icon(Icons.logout_rounded)
                  )
                ]
              )
            ),
          ),
          const SizedBox(height: 30.0,),
        ],
      ),
    );
  }
}
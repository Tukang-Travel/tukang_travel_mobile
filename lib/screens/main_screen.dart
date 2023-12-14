import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuktraapp/screens/owner/pedia/owner_pedia_screen.dart';
import 'package:tuktraapp/screens/owner/profile/owner_profile.dart';
import 'package:tuktraapp/screens/user/planner/planner_screen.dart';
import 'package:tuktraapp/screens/user/feed/feed_screen.dart';
import 'package:tuktraapp/screens/user/home/home_screen.dart';
import 'package:tuktraapp/screens/user/pedia/pedia_screen.dart';
import 'package:tuktraapp/screens/user/profile/profile_screen.dart';
import 'package:tuktraapp/services/user_service.dart';

class MainScreen extends StatefulWidget {
  final int? page;

  const MainScreen({Key? key, required this.page}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int? currScreenCount = 0;
Widget currScreen = const HomeScreen();

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();

    setState(() {
      currScreenCount = widget.page; 

      switch (currScreenCount) {
        case 1:
          currScreen = const PediaScreen();
          break;
        case 2:
          currScreen = const PlannerScreen();
          break;
        case 3:
          currScreen = const ProfileScreen();
          break;
        default:
          currScreen = const FeedScreen();
          break;
      }
    });
  }
  
  Map<String, dynamic>? user;

  final List<Widget> screens = [
    const FeedScreen(),
    const PediaScreen(),
    const HomeScreen(),
    const PlannerScreen(),
    const ProfileScreen(),
  ];

  final List<Widget> ownerScreens = [
    const OwnerPediaScreen(),
    const OwnerProfileScreen()
  ];

  final List<IconData> icons = [
    Icons.home_filled,
    Icons.article_rounded,
    Icons.add_circle,
    Icons.list_rounded,
    Icons.person,
  ];

  final List<IconData> ownerIcons = [
    Icons.home_filled,
    Icons.person,
  ];

  final List<String> menus = ['Home', 'Pedia', '', 'Diary', 'Profile'];
  final List<String> ownerMenus = ['Home', 'Profile'];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    List<dynamic> results = await Future.wait([
      getUser(currUser!.uid),
    ]);
    
    setState(() {
      user = results[0];
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currScreen,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Stack(children: [
          GNav(
            selectedIndex: currScreenCount!,
            // tab button hover color
            tabBorderRadius: 30,
            color: const Color.fromARGB(189, 121, 140, 223),
            gap:
                8, // the tab button gap between icon and text  // unselected icon color
            activeColor: Colors.white, // selected icon and text color
            iconSize:
                24, // tab button icon size // selected tab background color
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 20), // navigation bar padding
            tabBackgroundColor: const Color.fromARGB(255, 82, 114, 255),
            tabs: [
              if (user?['type'] == 'user')
                for (int i = 0; i < screens.length; i++)
                  GButton(
                    icon: icons[i],
                    text: menus[i],
                    onPressed: () {
                      setState(() {
                        currScreen = screens[i];
                        currScreenCount = i;
                      });
                    },
                  ),
              if (user?['type'] == 'owner')
                for (int i = 0; i < ownerScreens.length; i++)
                  GButton(
                    icon: ownerIcons[i],
                    text: ownerMenus[i],
                    onPressed: () {
                      setState(() {
                        currScreen = ownerScreens[i];
                        currScreenCount = i;
                      });
                    },
                  ),
            ],
          ),
        ]),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(top: 50.0, left: 30.0),
      //   child: Align(
      //     alignment: Alignment.bottomCenter,
      //     child: FloatingActionButton(
      //       backgroundColor: const Color.fromARGB(255, 82, 114, 255),
      //       foregroundColor: Colors.white,
      //       onPressed: () {
      //       },
      //       child: const Icon(Icons.add)
      //     ),
      //   ),
      // ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tuktraapp/screens/admin/admin_feed_screen.dart';
import 'package:tuktraapp/screens/admin/admin_home_screen.dart';
import 'package:tuktraapp/screens/admin/admin_pedia_screen.dart';
import 'package:tuktraapp/screens/admin/admin_profile_screen.dart';
import 'package:tuktraapp/screens/user/diary_screen.dart';
import 'package:tuktraapp/screens/user/feed/feed_screen.dart';
import 'package:tuktraapp/screens/user/home_screen.dart';
import 'package:tuktraapp/screens/user/pedia_screen.dart';
import 'package:tuktraapp/screens/user/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currScreenCount = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const PediaScreen(),
    const FeedScreen(),
    const DiaryScreen(),
    const ProfileScreen(),
  ];

  final List<Widget> adminScreens = [
    const AdminHomeScreen(),
    const AdminPediaScreen(),
    const AdminFeedScreen(),
    const AdminProfileScreen(),
  ];

  final List<IconData> icons = [
    Icons.home_filled,
    Icons.article_rounded,
    Icons.video_collection_rounded,
    Icons.list_rounded,
    Icons.person,
  ];

  final List<IconData> adminIcons = [
    Icons.home_filled,
    Icons.article_rounded,
    Icons.video_collection_rounded,
    Icons.person,
  ];

  final List<String> menus = ['Home', 'Pedia', 'Feed', 'Diary', 'Profile'];
  final List<String> adminMenus = ['Home', 'Pedia', 'Feed', 'Profile'];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currScreen = const HomeScreen();

  var user = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket, 
        child: currScreen,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: GNav( // tab button hover color
          tabBorderRadius: 30, 
          color: const Color.fromARGB(189, 121, 140, 223),
          gap: 8, // the tab button gap between icon and text  // unselected icon color
          activeColor: Colors.white, // selected icon and text color
          iconSize: 24, // tab button icon size // selected tab background color
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20), // navigation bar padding
          tabBackgroundColor: const Color.fromARGB(255, 82, 114, 255),
          tabs: [
            if(user)
              for(int i = 0; i < screens.length; i++)
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
            if(!user)
              for(int i = 0; i < adminScreens.length; i++)
                GButton(
                  icon: adminIcons[i], 
                  text: adminMenus[i], 
                  onPressed: () {
                    setState(() {
                      currScreen = adminScreens[i];
                      currScreenCount = i;
                    });
                  },
                ),
          ],
        ),
      ),
    );
  }
}
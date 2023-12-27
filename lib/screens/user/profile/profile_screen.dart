import 'package:flutter/material.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuktraapp/widgets/profile_post_card.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 80.0, top: 80.0, right: 80.0, bottom: 20.0),
                child: Image.asset(
                  'asset/images/default_profile.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            Text(
              '${user?['name']}',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 25.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 82, 114, 255),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                child: const Text(
                  'Ubah Profil',
                  style: TextStyle(color: Colors.white),
                )),
                const SizedBox(
                  width: 15.0,
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
                          horizontal: 40.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  child: RichText(
                      text: const TextSpan(
                          text: 'Keluar ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                          ),
                          children: [WidgetSpan(child: Icon(Icons.logout_rounded))])),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Divider(
              color: Colors.black,
              thickness: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('feeds').snapshots(), 
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.55,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var itemData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                          if(userService.currUser!.uid == itemData['userId']){
                              return !snapshot.hasData
                                ? const Center(child: Text('No Feed yet'))
                                : SizedBox.expand(
                                  child: PostCard(
                                    snap: snapshot.data!.docs[index].data(),
                                  ),
                                );
                          }
                          else {
                            return SizedBox.shrink();
                          }
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
    );
  }
}

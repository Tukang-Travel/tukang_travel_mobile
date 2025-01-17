import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuktraapp/provider/user_provider.dart';
import 'package:tuktraapp/screens/authentication/login_owner_screen.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  UserService userService = UserService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late Future<void> _animationFuture;

  Future<void> _loadUserInfo() async {
    if (userService.currUser == null) {
      // NavigationUtils.pushRemoveTransition(context, const LoginScreen());
    } else {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
      if (context.mounted) {
        NavigationUtils.pushRemoveTransition(
            context,
            const MainScreen(
              page: 0,
            ));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start the animation when the widget is first built
    _animationFuture = _playAnimation().then((value) => _loadUserInfo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _animationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Animation has completed, show the rest of the content
            return _buildContent();
          } else {
            return _buildLoadingIndicator();
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "asset/images/main_bg.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 300,
          left: MediaQuery.of(context).size.width / 2 - 200,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              "asset/images/tuktra_logo.png",
              width: 400,
              height: 400,
            ),
          ),
        ),
        Positioned(
          bottom: 30.0,
          width:
              MediaQuery.of(context).size.width, // Make button row full width
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center buttons horizontally
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(  
                  backgroundColor: Colors.black,
                  elevation: 5,
                  shadowColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0), // Increase horizontal padding
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                onPressed: () {
                  NavigationUtils.pushRemoveTransition(
                      context, const LoginOwnerScreen());
                },
                child: const Text(
                  "Masuk sebagai Owner",
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 82, 114, 255),
                  elevation: 5,
                  shadowColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0), // Increase horizontal padding
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                onPressed: () {
                  NavigationUtils.pushRemoveTransition(
                      context, const LoginScreen());
                },
                child: const Text(
                  "Masuk sebagai User",
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "asset/images/main_bg.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 300,
          left: MediaQuery.of(context).size.width / 2 - 200,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              "asset/images/tuktra_logo.png",
              width: 400,
              height: 400,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 + 50, // Adjust as needed
          left: MediaQuery.of(context).size.width / 2 - 20, // Adjust as needed
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.blue), // Change the color here
          ),
        ),
      ],
    );
  }

  Future<void> _playAnimation() async {
    await _animationController.forward().orCancel;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tuktraapp/provider/user_provider.dart';
import 'package:tuktraapp/screens/welcome_screen.dart';
import 'package:tuktraapp/utils/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Tukang Travel',
        theme: ThemeData(
          primarySwatch: tukangtravelColor,
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}


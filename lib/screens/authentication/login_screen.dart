import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuktraapp/models/api_response_model.dart';
import 'package:tuktraapp/models/login_api_model.dart';
import 'package:tuktraapp/provider/user_provider.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/utils/constant.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/screens/authentication/register_screen.dart';
import 'package:tuktraapp/screens/user/forgot_pass_screen.dart';
import 'package:http/http.dart' as http;
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:tuktraapp/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserService userService = UserService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController usernameTxt = TextEditingController();
  TextEditingController passTxt = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    usernameTxt.dispose();
    passTxt.dispose();
  }

  void _loginAuth() async {
    String apiResponse = await userService.login(usernameTxt.text, passTxt.text);
    if (apiResponse == 'Success') {
      // save user info and redirect to home
      _successfulLogin();
    } else {
      setState(() {
        isLoading = !isLoading;
      });
      if (context.mounted) {
        showSnackBar(context, apiResponse);
      }
    }
  }

  /* didefinisikan variabel dengan tipe data User pada parameter fungsi dibawah */
  void _successfulLogin() async {
    // Set user data using the UserProvider
    // Provider.of<UserProvider>(context, listen: false).setUser(userData);

    await Provider.of<UserProvider>(context, listen: false).refreshUser();

    if (context.mounted) {
      NavigationUtils.pushRemoveTransition(
          context,
          const MainScreen(
            page: 0,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 100.0),
                      width: w,
                      height: 100.0, // one third of the page
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('asset/images/tuktra_logo.png'),
                            fit: BoxFit.cover),
                      )),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 35,
                        ),

                        // username text field
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(1, 1),
                                  color: Color.fromARGB(128, 170, 188, 192),
                                )
                              ]),
                          child: TextFormField(
                              controller: usernameTxt,
                              validator: ((value) => value!.isEmpty
                                  ? 'Username must be filled'
                                  : null),
                              decoration: formInputDecoration(
                                  'Username',
                                  const Icon(
                                    Icons.person_rounded,
                                    color: Color.fromARGB(255, 82, 114, 255),
                                  ))),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        // password textfield
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(1, 1),
                                  color: Color.fromARGB(128, 170, 188, 192),
                                )
                              ]),
                          child: TextFormField(
                              controller: passTxt,
                              validator: ((value) => value!.isEmpty
                                  ? 'Password must be filled'
                                  : null),
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: formInputDecoration(
                                  'Password',
                                  const Icon(
                                    Icons.password_rounded,
                                    color: Color.fromARGB(255, 82, 114, 255),
                                  ))),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Belum punya akun? ',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Buat akunmu ',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 82, 114, 255),
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          NavigationUtils.pushRemoveTransition(context, const RegisterScreen());
                        }
                      ),
                      const TextSpan(
                        text: 'disini.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        )
                      )
                    ]
                  )
                ),
                const SizedBox(height: 15.0,),

                RichText(
                  text: TextSpan(
                      text: 'Lupa kata sandi anda?',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 82, 114, 255),
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          NavigationUtils.pushRemoveTransition(
                              context, const ForgotPasswordScreen());
                        }),
                ),
                const SizedBox(
                  height: 200,
                ),
                // login button
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          ApiResponseModel apiResponse = ApiResponseModel();
                          var googleUser = await LoginApiModel.login();
                          if (googleUser != null) {
                            try {
                              final response = await http.get(
                                Uri.parse(
                                    '$baseURL/exists/${googleUser.email}'),
                                headers: {'Accept': 'application/json'},
                              );

                              switch (response.statusCode) {
                                case 200:
                                  apiResponse.data =
                                      jsonDecode(response.body);
                                  // apiResponse.err = 'case 200';
                                  break;

                                default:
                                  apiResponse.err = other;
                                  // apiResponse.err = 'case other';
                                  break;
                              }
                            } catch (e) {
                              apiResponse.err = serverError;
                            }

                            if (apiResponse.data != null &&
                                (apiResponse.data!
                                        as Map<String, dynamic>)['exist'] !=
                                    null) {
                              bool exists = (apiResponse.data!
                                  as Map<String, dynamic>)['exist'];
                              String uname = googleUser.email.split('@')[0];

                              if (exists) {
                                String apiResponse = await userService.loginGoogle();
                                if (apiResponse == 'Success') {
                                  // save user info and redirect to home
                                  _successfulLogin();
                                } else {
                                  setState(() {
                                    isLoading = !isLoading;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(apiResponse)));
                                }
                              } else {
                                String apiResponse = await userService.registerGoogle();
                                if (apiResponse == 'Success') {
                                  _successfulLogin();
                                } else {
                                  setState(() {
                                    isLoading = !isLoading;
                                  });
                                  context.mounted
                                      ? showSnackBar(context, apiResponse)
                                      : null;
                                }
                              }
                              if (context.mounted) {
                                NavigationUtils.pushRemoveTransition(
                                    context,
                                    const MainScreen(
                                      page: 0,
                                    ));
                              }
                            } else {
                              print('returns null');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 30.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'asset/images/google_logo.webp',
                              width: 24.0,
                              height: 24.0,
                            ),
                            const SizedBox(width: 8.0),
                            const Text(
                              'Google',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                    _loginAuth();
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 82, 114, 255),
                                elevation: 5,
                                shadowColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 55.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 8.0),
                                  Center(
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

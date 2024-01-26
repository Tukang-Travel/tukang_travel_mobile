import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailTxt = TextEditingController();

  @override
  void dispose() {
    emailTxt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 40.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 6.0),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(children: [
                Container(
                    margin: const EdgeInsets.only(top: 100.0),
                    width: w,
                    height: 100.0, // one third of the page
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/images/tuktra_logo.png'),
                          fit: BoxFit.cover),
                    )),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  width: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // email text field
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: emailTxt,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email_rounded,
                              color: Color.fromARGB(255, 82, 114, 255),
                            ),
                            hintText: 'Email',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: w * 0.8,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (emailTxt.text.isEmpty) {
                                  Alert.alertValidation('Email harus diisi!', context);
                                } else if (!RegExp(
                                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                    .hasMatch(emailTxt.text)) {
                                  Alert.alertValidation('Email tidak valid!', context);
                                } else {
                                  // Call the function to send password reset email
                                  String res = await UserService()
                                      .sendForgotEmail(emailTxt.text.trim());

                                  if (res == 'success' && context.mounted) {
                                    NavigationUtils.pushRemoveTransition(
                                        context, const LoginScreen());
                                    Alert.alertValidation('Email sudah terkirim!', context);
                                  } else {
                                    if (context.mounted) {
                                      Alert.alertValidation(res, context);
                                    }
                                  }
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 82, 114, 255),
                              elevation: 5,
                              shadowColor: Colors.black,
                              padding: const EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: const Text(
                              'KIRIM EMAIL RESET',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

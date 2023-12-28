import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:tuktraapp/utils/utils.dart';

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
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email must be filled';
                            } else if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            } else {
                              return null;
                            }
                          },
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
                                // Call the function to send password reset email
                                String res = await UserService()
                                    .sendForgotEmail(emailTxt.text.trim());
                        
                                if (res == 'success' && context.mounted) {
                                  showSnackBar(context, 'Email already sent, if your account existed');
                                  NavigationUtils.pushRemoveTransition(
                                      context, const LoginScreen());
                                } else {
                                  if (context.mounted) {
                                    showSnackBar(context, res);
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
                              'SEND RESET EMAIL',
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

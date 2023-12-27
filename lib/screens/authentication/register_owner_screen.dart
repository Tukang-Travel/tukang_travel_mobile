import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuktraapp/provider/user_provider.dart';
<<<<<<< HEAD
import 'package:tuktraapp/screens/authentication/login_owner_screen.dart';
=======
import 'package:tuktraapp/screens/authentication/register_screen.dart';
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
import 'package:tuktraapp/screens/user/forgot_pass_screen.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
<<<<<<< HEAD
=======
import 'package:tuktraapp/utils/utils.dart';
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8

class RegisterOwnerScreen extends StatefulWidget {
  const RegisterOwnerScreen({super.key});

  @override
<<<<<<< HEAD
  _RegisterOwnerScreenState createState() => _RegisterOwnerScreenState();
=======
  State createState() => _RegisterOwnerScreenState();
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8
}

class _RegisterOwnerScreenState extends State<RegisterOwnerScreen> {
  UserService userService = UserService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameTxt = TextEditingController();
  TextEditingController usernameTxt = TextEditingController();
  TextEditingController emailTxt = TextEditingController();
  TextEditingController passTxt = TextEditingController();
  TextEditingController conTxt = TextEditingController();

  bool isLoading = false;
<<<<<<< HEAD
=======
  bool isGoogle = false;
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8

  @override
  void dispose() {
    super.dispose();
    nameTxt.dispose();
    usernameTxt.dispose();
    emailTxt.dispose();
    passTxt.dispose();
    conTxt.dispose();
  }

  void _successfulLogin() async {
    await Provider.of<UserProvider>(context, listen: false).refreshUser();
    if (context.mounted) {
      NavigationUtils.pushRemoveTransition(
          context,
          const MainScreen(
            page: 0,
          ));
    }
  }

<<<<<<< HEAD
  void _regisAuth() async {
    String apiResponse = await userService.register(
        nameTxt.text, usernameTxt.text, emailTxt.text, passTxt.text, 'owner');
=======
  void _regisAuth(String type) async {
    String apiResponse = await userService.register(
        nameTxt.text, usernameTxt.text, emailTxt.text, passTxt.text, type);
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8
    if (apiResponse == 'Success') {
      _successfulLogin();
    } else {
      setState(() {
        isLoading = !isLoading;
      });
<<<<<<< HEAD
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse)));
=======
      if (context.mounted) {
        showSnackBar(context, apiResponse);
      }
    }
  }

  void _loginGoogleAuth(String type) async {
    String apiResponse = await userService.googleLoginRegister(type);
    if (apiResponse == 'Success') {
      // save user info and redirect to home
      _successfulLogin();
    } else {
      setState(() {
        isGoogle = !isGoogle;
        isLoading = !isLoading;
      });
      if (context.mounted) {
        showSnackBar(context, apiResponse);
      }
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8
    }
  }

  /* fungsi build dari parent class StatefulWidget
    diimplementasikan dengan tampilan yang berbeda pada 
    tiap child class
   */
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
<<<<<<< HEAD
                        margin: const EdgeInsets.only(top:50.0),
=======
                        margin: const EdgeInsets.only(top: 90.0),
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8
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
<<<<<<< HEAD
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
                              child: Text(
                                'Daftar sebagai Owner',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),

=======
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8
                          //name text field
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
                              controller: nameTxt,
                              validator: ((value) => value!.isEmpty
                                  ? 'Name must be filled'
                                  : null),
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person_rounded,
                                    color: Color.fromARGB(255, 82, 114, 255),
                                  ),
                                  hintText: 'Name',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
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
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person_rounded,
                                    color: Color.fromARGB(255, 82, 114, 255),
                                  ),
                                  hintText: 'Username',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          // email text field
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
                              controller: emailTxt,
                              validator: ((value) => value!.isEmpty
                                  ? 'Email must be filled'
                                  : null),
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email_rounded,
                                    color: Color.fromARGB(255, 82, 114, 255),
                                  ),
                                  hintText: 'Email',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(128, 170, 188, 192),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          // password text field
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
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.password_rounded,
                                    color: Color.fromARGB(255, 82, 114, 255),
                                  ),
                                  hintText: 'Password',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          //password confirmation
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
                              controller: conTxt,
                              validator: ((value) {
                                if (value!.isEmpty) {
                                  return 'Confirmation must be filled';
                                } else if (value != passTxt.text) {
                                  return 'Password do not match';
                                } else {
                                  return null;
                                }
                              }),
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.password_rounded,
                                    color: Color.fromARGB(255, 82, 114, 255),
                                  ),
                                  hintText: 'Confirm Password',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(20)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              128, 170, 188, 192),
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Sudah punya akun? ',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                              text: 'Masuk ke akunmu ',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 82, 114, 255),
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  NavigationUtils.pushRemoveTransition(
                                      context, const LoginScreen());
                                }),
                          const TextSpan(
                              text: 'disini.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0,
                              ))
                        ])),
<<<<<<< HEAD
                    const SizedBox(
                      height: 15.0,
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Sudah punya akun owner? ',
=======
                    const Text(
                            'Atau ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                    ),
                    RichText(
                        text: TextSpan(
                            text: 'Bukan pemilik usaha? ',
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                            children: <TextSpan>[
                          TextSpan(
<<<<<<< HEAD
                              text: 'Masuk ke akunmu ',
=======
                              text: 'Registrasi ',
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8
                              style: const TextStyle(
                                color: Color.fromARGB(255, 82, 114, 255),
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  NavigationUtils.pushRemoveTransition(
<<<<<<< HEAD
                                      context, const LoginOwnerScreen());
=======
                                      context, const RegisterScreen());
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8
                                }),
                          const TextSpan(
                              text: 'disini.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0,
                              ))
                        ])),
                    const SizedBox(
                      height: 15.0,
                    ),
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
<<<<<<< HEAD
                      height: 30.0,
                    ),
                    // sign up with google
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: ElevatedButton(
                            onPressed: () {},
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
                                    vertical: 10.0, horizontal: 5.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                        _regisAuth();
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
                                          'DAFTAR',
=======
                      height: 100.0,
                    ),
                    // sign up with google
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isGoogle = true;
                                    isLoading = true;
                                    _loginGoogleAuth('owner');
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 30.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isLoading && isGoogle)
                                      const CircularProgressIndicator()
                                    else
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          ])
                                  ],
                                ),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                      _regisAuth('owner');
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 82, 114, 255),
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 8.0),
                                    if (isLoading && !isGoogle)
                                      const CircularProgressIndicator()
                                    else
                                      const Center(
                                        child: Text(
                                          'REGISTER',
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
<<<<<<< HEAD
                                    ],
                                  ),
                                ),
                              ),
=======
                                  ],
                                ),
                              ),
                            )),
>>>>>>> 8d89a8363820e2fb311401a2ece0d1befb53b0f8
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

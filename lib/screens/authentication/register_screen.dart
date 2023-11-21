import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuktraapp/models/api_response_model.dart';
import 'package:tuktraapp/models/user_model.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/screens/authentication/login_screen.dart';
import 'package:tuktraapp/screens/user/forgot_pass_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({ Key? key }) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController usernameTxt = TextEditingController();
  TextEditingController emailTxt = TextEditingController();
  TextEditingController passTxt = TextEditingController();
  TextEditingController conTxt = TextEditingController();

  bool isLoading = false;

  void _successfulLogin(UserModel user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);

    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var fadeAnimation = animation.drive(tween);

          return FadeTransition(opacity: fadeAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
      (route) => false,
    );
  }

  void _regisAuth(String loginType) async {
    ApiResponseModel apiResponse = await register(usernameTxt.text, emailTxt.text, passTxt.text, conTxt.text, loginType);
    if(apiResponse.err == null) {
      _successfulLogin(apiResponse.data as UserModel);
    }
    else {
      setState(() {
        isLoading = !isLoading;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${apiResponse.err}')));
    }
  }
  
  /* fungsi build dari parent class StatefulWidget
    diimplementasikan dengan tampilan yang berbeda pada 
    tiap child class
   */
  @override
  Widget build(BuildContext context){
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(children: [
          Form(
            key: formKey,
            child: Column(children: [
              Container(
                margin: const EdgeInsets.only(top: 90.0),
                width: w,
                height: 100.0, // one third of the page
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'asset/tuktra_logo.png'
                    ),
                    fit: BoxFit.cover
                  ),
                )
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                width: w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
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
                        ]
                      ),
                      child: TextFormField(
                        controller: usernameTxt,
                        validator: ((value) => value!.isEmpty ? 'Username must be filled' : null),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_rounded, color: Color.fromARGB(255, 82, 114, 255),),
                          hintText: 'Username',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(128, 170, 188, 192),
                              width: 1.0
                            ),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(128, 170, 188, 192),
                            ),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          )
                        ),
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
                        ]
                      ),
                      child: TextFormField(
                        controller: emailTxt,
                        validator: ((value) => value!.isEmpty ? 'Email must be filled' : null),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_rounded, color: Color.fromARGB(255, 82, 114, 255),),
                          hintText: 'Email',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(128, 170, 188, 192),
                              width: 1.0
                            ),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(128, 170, 188, 192),
                            ),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          )
                        ),
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
                        ]
                      ),
                      child: TextFormField(
                        controller: passTxt,
                        validator: ((value) => value!.isEmpty ? 'Password must be filled' : null),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password_rounded, color: Color.fromARGB(255, 82, 114, 255),),
                          hintText: 'Password',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(128, 170, 188, 192),
                              width: 1.0
                            ),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(128, 170, 188, 192),
                              width: 1.5
                            ),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          )
                        ),
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
                        ]
                      ),
                      child: TextFormField(
                        controller: conTxt,
                        validator: ((value) => value!.isEmpty ? 'Confirmation must be filled' : null),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password_rounded, color: Color.fromARGB(255, 82, 114, 255),),
                          hintText: 'Confirm Password',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(128, 170, 188, 192),
                              width: 1.0
                            ),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(128, 170, 188, 192),
                              width: 1.5
                            ),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          )
                        ),
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
                        Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = 0.0;
                              const end = 1.0;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var fadeAnimation = animation.drive(tween);

                              return FadeTransition(opacity: fadeAnimation, child: child);
                            },
                            transitionDuration: const Duration(milliseconds: 1000),
                          ),
                          (route) => false,
                        );
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
                    Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const ForgotPasswordScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = 0.0;
                          const end = 1.0;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var fadeAnimation = animation.drive(tween);

                          return FadeTransition(opacity: fadeAnimation, child: child);
                        },
                        transitionDuration: const Duration(milliseconds: 1000),
                      ),
                      (route) => false,
                    );
                  }
                ),
              ),
              const SizedBox(
                height: 100.0,
              ),
              // sign up with google
              Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'asset/google_logo.webp',
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
                    isLoading? 
                    const Center(child: CircularProgressIndicator(),)
                    :
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if(formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                              _regisAuth('form');
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 82, 114, 255),
                          elevation: 5,
                          shadowColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 55.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 8.0), 
                            Center(
                              child: Text(
                                'REGISTER',
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
            ],),
          ),
        ],),
      )
    );
  }
}
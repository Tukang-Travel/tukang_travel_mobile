import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:tuktraapp/utils/utils.dart';

class EditOwnerProfileScreen extends StatefulWidget {
  const EditOwnerProfileScreen({
    super.key,
    required this.userId,
    required this.initialName,
    required this.initialUsername,
    required this.initialEmail,
  });

  final String userId;
  final String initialName;
  final String initialUsername;
  final String initialEmail;

  @override
  State<EditOwnerProfileScreen> createState() => _EditOwnerProfileScreenState();
}

class _EditOwnerProfileScreenState extends State<EditOwnerProfileScreen> {
  UserService userService = UserService();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameTxt = TextEditingController();
  TextEditingController usernameTxt = TextEditingController();
  TextEditingController emailTxt = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    nameTxt.dispose();
    usernameTxt.dispose();
    emailTxt.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Set initial values for title and tags
    nameTxt.text = widget.initialName;
    usernameTxt.text = widget.initialUsername;
    emailTxt.text = widget.initialEmail;
  }

  // Function to update the feed in Firestore
  void _updateProfile() {
    // Validate the title and tags
    String updatedName = nameTxt.text.trim();
    String updatedUsername = usernameTxt.text.trim();

    if (updatedName.isEmpty) {
      // Show an error message for the empty name
      Alert.alertValidation('Nama harus diisi!', context);
      return;
    }

    if (updatedUsername.isEmpty) {
      // Show an error message for the empty username
      Alert.alertValidation('Username harus diisi!', context);
      return;
    }

    UserService()
        .updateProfile(userService.currUser!.uid, updatedName, updatedUsername);

    // Close the screen
    NavigationUtils.pushRemoveTransition(context, const MainScreen(page: 4));
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          title: const AutoSizeText(
            'Ubah Profil',
            maxLines: 10,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 100,
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
                              enabled: false,
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
                            height: 15,
                          ),

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
                            height: 15,
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
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15.0,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                    _updateProfile(); // Added the function call here
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 180, 82),
                                elevation: 5,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 8.0),
                                  if (isLoading)
                                    const CircularProgressIndicator()
                                  else
                                    const Center(
                                      child: Text(
                                        'UBAH',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
        ));
  }
}

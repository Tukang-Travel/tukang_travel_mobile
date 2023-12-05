import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuktraapp/utils/constant.dart';

class InsertPedia extends StatefulWidget {
  const InsertPedia({super.key});

  @override
  State<InsertPedia> createState() => _InsertPediaState();
}

class _InsertPediaState extends State<InsertPedia> {
  File? _pickedImage;

  List<String> _types = ['Sejarah', 'Cagar Alam', 'Pantai', 'Kuliner', 'Belanja', 'Religi', 'Petualangan', 'Seni & Budaya', 'Kesehatan & Kebugaran', 'Edukasi', 'Keluarga'];
  List<String> _selectedTypes = [];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      try {
        // Check if the picked file is an image (not a video)
        String imagePath = pickedFile.path;
        if (await isImageFile(imagePath)) {
          setState(() {
            _pickedImage = File(imagePath);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile harus berupa gambar!'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        print('Error picking image: $e');
      }
    } else {
      print('No image selected.');
    }
  }

  Future<bool> isImageFile(String filePath) async {
    final imageExtensions = ['jpg', 'jpeg', 'png']; // Add more extensions if needed

    // Check the file extension
    final extension = filePath.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }
  
  TextEditingController titleTxt = TextEditingController();
  TextEditingController descTxt = TextEditingController();
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 70.0, bottom: 10.0, left: 5.0),
                  child: Text(
                    'Unggah Pedia Baru',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0, left: 5.0),
                  child: Text(
                    'Promosikan tempat wisatamu dengan menunggah pedia yang mendeskripsikan usaha wisatamu!',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color.fromARGB(255, 81, 81, 81)
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Judul ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0,
                      ),
                      children: <TextSpan> [
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        )
                      ]
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
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
                    controller: titleTxt,
                    validator: ((value) => value!.isEmpty ? 'Judul harus diisi' : null),
                    decoration: InputDecoration(
                      hintText: 'Judul',
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
                const SizedBox(height: 10.0,),

                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Deskripsi ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0,
                      ),
                      children: <TextSpan> [
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        )
                      ]
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
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
                    maxLines: null,
                    controller: descTxt,
                    validator: ((value) => value!.isEmpty ? 'Judul harus diisi' : null),
                    decoration: InputDecoration(
                      hintText: 'Deskripsikan tempat wisatamu...',
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
                const SizedBox(height: 10.0,),

                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Foto Tempat Wisata ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0,
                      ),
                      children: <TextSpan> [
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        )
                      ]
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    width: 350.0,
                    height: 175.0,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 188, 188, 188),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        'Pilih Foto',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white
                        ),
                      )
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),

                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Tag (Min. 1 Tag dipilih)',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0,
                      ),
                      children: <TextSpan> [
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        )
                      ]
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Container(
                  height: 200.0,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 2.5
                    ),
                    itemCount: _types.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TagCheckbox(
                        text: _types[index],
                        onChanged: (bool? value) {
                          setState(() {
                            if(value == true) _selectedTypes.add(_types[index]);
                            else _selectedTypes.remove(_types[index]);
                          });
                          print(_selectedTypes);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10.0,),
              ],
            ),
          ),
        )
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 80.0, left: 30.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () {
              // Navigator.of(context).pushAndRemoveUntil(
              //   PageRouteBuilder(
              //     pageBuilder: (context, animation, secondaryAnimation) => const MainView(),
              //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
              //       const begin = 0.0;
              //       const end = 1.0;
              //       const curve = Curves.easeInOut;

              //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              //       var fadeAnimation = animation.drive(tween);

              //       return FadeTransition(opacity: fadeAnimation, child: child);
              //     },
              //     transitionDuration: const Duration(milliseconds: 1000),
              //   ),
              //   (route) => false,
              // );
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 6.0),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
      ),
    );
  }
}
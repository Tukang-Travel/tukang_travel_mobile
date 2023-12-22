import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/owner/pedia/owner_pedia_detail.dart';
import 'package:tuktraapp/services/pedia_service.dart';
import 'package:tuktraapp/utils/constant.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';

class UpdatePedia extends StatefulWidget {
  final String id;
  const UpdatePedia({super.key, required this.id});

  @override
  State<UpdatePedia> createState() => _UpdatePediaState();
}

class _UpdatePediaState extends State<UpdatePedia> {
  PediaService pediaService = PediaService();

  Map<String, dynamic> pedia = {};

  List<String> _types = ['Sejarah', 'Cagar Alam', 'Pantai', 'Kuliner', 'Belanja', 'Religi', 'Petualangan', 'Seni & Budaya', 'Kesehatan & Kebugaran', 'Edukasi', 'Keluarga'];
  List<dynamic> _selectedTypes = [];
  List<String> tags = [];
  
  TextEditingController titleTxt = TextEditingController();
  TextEditingController descTxt = TextEditingController();
  bool checked = false, isSet = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    List<dynamic> results = await Future.wait([
      pediaService.getPedia(widget.id)
    ]);

    setState(() {
      pedia = results[0];
    });

    if(!isSet) {
      setState(() {
        isSet = true;
        titleTxt.text = pedia['title'];
        descTxt.text = pedia['description'];
        _selectedTypes = pedia['tags'];
      });
    }

    print(_selectedTypes);
  }
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
                    'Ubah Pedia',
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
                        checked: _selectedTypes.contains(_types[index]) ? true : false,
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

                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      pediaService.updatePedia(widget.id, titleTxt.text, descTxt.text, _selectedTypes);
                      NavigationUtils.pushRemoveTransition(context, OwnerPediaDetail(id: widget.id));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 82, 114, 255)
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      child: Text(
                        'Ubah',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
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
              NavigationUtils.pushRemoveTransition(context, OwnerPediaDetail(id: widget.id));
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
import 'package:flutter/material.dart';
import 'package:tuktraapp/screens/owner/pedia/owner_pedia_detail.dart';
import 'package:tuktraapp/services/pedia_service.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';
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

  List<String> _types = [];
  List<dynamic> _selectedTypes = [];

  @override
  void initState() {
    super.initState();
    getTagsTemplate();
  }

  Future<void> getTagsTemplate() async {
    final List<Map<String, dynamic>> temp =
        await UserService().getPreferencesTemplate();
    setState(() {
      _types = temp.map((e) => e['name'].toString()).toList();
    });
  }

  TextEditingController titleTxt = TextEditingController();
  TextEditingController descTxt = TextEditingController();
  TextEditingController typeTxt = TextEditingController();
  bool checked = false, isSet = false;

  @override
  void dispose() {
    titleTxt.dispose();
    descTxt.dispose();
    typeTxt.dispose();
    checked = false;
    isSet = false;
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    List<dynamic> results =
        await Future.wait([pediaService.getPedia(widget.id)]);

    setState(() {
      pedia = results[0];
    });

    if (!isSet) {
      setState(() {
        isSet = true;
        titleTxt.text = pedia['title'];
        descTxt.text = pedia['description'];
        _selectedTypes = pedia['tags'];
      });
    }
  }

  void _addType(String type) {
    if (type.isNotEmpty && !_selectedTypes.contains(type)) {
      setState(() {
        _selectedTypes.add(type);
        typeTxt.clear();
      });
    }
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
                      fontSize: 15.0, color: Color.fromARGB(255, 81, 81, 81)),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
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
                      children: <TextSpan>[
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        )
                      ]),
                ),
              ),
              const SizedBox(
                height: 10.0,
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
                  controller: titleTxt,
                  decoration: InputDecoration(
                      hintText: 'Judul',
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(128, 170, 188, 192),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(128, 170, 188, 192),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
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
                      children: <TextSpan>[
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        )
                      ]),
                ),
              ),
              const SizedBox(
                height: 10.0,
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
                  maxLines: null,
                  controller: descTxt,
                  decoration: InputDecoration(
                      hintText: 'Deskripsikan tempat wisatamu...',
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(128, 170, 188, 192),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(128, 170, 188, 192),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Tags Terpilih',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Code for selected tags remains the same
                  _selectedTypes.isNotEmpty
                      ? Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _selectedTypes.map((type) {
                            return Chip(
                              label: Text(type),
                              onDeleted: () {
                                setState(() {
                                  _selectedTypes.remove(type);
                                });
                              },
                            );
                          }).toList(),
                        )
                      : const Text('Tidak ada Tag yang terpilih/dimasukkan'),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Rekomendasi Tags',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 250.0,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 2.5),
                      itemCount: _types.length,
                      itemBuilder: (BuildContext context, int index) {
                        final type = _types[index];
                        return TagCheckbox(
                          text: type,
                          checked: false,
                          onChanged: (bool? value) {
                            _addType(type);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Tags',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
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
                      controller: typeTxt,
                      decoration: InputDecoration(
                        hintText: 'Tags',
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(128, 170, 188, 192),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(128, 170, 188, 192),
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _addType(typeTxt.text.trim());
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    if(titleTxt.text.isEmpty) {
                      Alert.alertValidation("Judul harus diisi!", context);
                    }
                    else if(descTxt.text.isEmpty) {
                      Alert.alertValidation("Deskripsi harus diisi!", context);
                    }
                    else if(_selectedTypes.isEmpty) {
                      Alert.alertValidation("Tag harus dipilih!", context);
                    }
                    else {
                      pediaService.updatePedia(
                        widget.id, titleTxt.text, descTxt.text, _selectedTypes);
                      NavigationUtils.pushRemoveTransition(
                        context, OwnerPediaDetail(id: widget.id));
                      Alert.successMessage('Pedia berhasil diperbaharui.', context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 82, 114, 255)),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: Text(
                      'Ubah',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 80.0, left: 30.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () {
              NavigationUtils.pushRemoveTransition(
                  context, OwnerPediaDetail(id: widget.id));
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

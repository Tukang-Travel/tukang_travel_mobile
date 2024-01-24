import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuktraapp/models/user_model.dart';
import 'package:tuktraapp/provider/user_provider.dart';
import 'package:tuktraapp/screens/main_screen.dart';
import 'package:tuktraapp/services/feed_service.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/constant.dart';
import 'package:tuktraapp/utils/navigation_utils.dart';
import 'package:tuktraapp/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadFeedScreen extends StatefulWidget {
  const UploadFeedScreen({super.key});

  @override
  State<UploadFeedScreen> createState() => _UploadFeedScreenState();
}

class _UploadFeedScreenState extends State<UploadFeedScreen> {
  UserService userService = UserService();
  TextEditingController titleController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  List<String> tags = [];
  List<File> files = [];
  String username = '';
  List<String> defaultTags = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getTagsTemplate();
  }

  Future<void> getTagsTemplate() async {
    final List<Map<String, dynamic>> temp =
        await UserService().getPreferencesTemplate();
    setState(() {
      defaultTags = temp.map((e) => e['name'].toString()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).user;
    username = user.username;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const AutoSizeText(
              'Unggah Feed',
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title text field
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
                      controller: titleController,
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
                    height: 16,
                  ),
                  _buildFilePicker(),
                  const SizedBox(height: 16),
                  _buildTagsInput(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
                foregroundColor: Colors.white,
                onPressed: () {
                  insertFeed();
                },
                label: const Text('Buat'),
                backgroundColor: const Color.fromARGB(255, 82, 114, 255)),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildTagsInput() {
    return Column(
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
        tags.isNotEmpty
            ? Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () {
                      _removeTag(tag);
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 2.5),
            itemCount: defaultTags.length,
            itemBuilder: (BuildContext context, int index) {
              final tag = defaultTags[index];
              return TagCheckbox(
                text: tag,
                checked: false,
                onChanged: (bool? value) {
                  _addTag(tag);
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
            controller: tagsController,
            validator: ((value) => value!.isEmpty ? 'Tags harus diisi' : null),
            decoration: InputDecoration(
              hintText: 'Tags',
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(128, 170, 188, 192), width: 1.0),
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(128, 170, 188, 192),
                  ),
                  borderRadius: BorderRadius.circular(20)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _addTag(tagsController.text.trim());
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
              text: 'Foto/Video ',
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
        const SizedBox(height: 16.0),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.05,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              _checkPermissionAndPickFile();
            },
            child: const Text('Pilih Foto/Video'),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1.0,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: files.length,
          itemBuilder: (BuildContext context, int index) {
            String fileExtension =
                files[index].path.split('.').last.toLowerCase();
            if (['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension)) {
              return Image.file(files[index], height: 100, width: 100);
            } else if (['mp4', 'avi', 'mkv', 'mov'].contains(fileExtension)) {
              String fileTitle = files[index].path.split('/').last;

              return Center(
                child: Text(fileTitle,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              );
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _checkPermissionAndPickFile() async {
    
    var statusStorage = await Permission.storage.status;
    var statusPhoto = await Permission.photos.status;

    if (statusStorage.isGranted || statusPhoto.isGranted) {
      // Permission is already granted, proceed to pick file
      _pickFile();
    } else {
      // Permission is not granted, request it
      await Permission.storage.request();
      await Permission.photos.request();
      // Check the permission status again
      statusStorage = await Permission.storage.status;
      statusPhoto = await Permission.photos.status;
      if (statusStorage.isGranted || statusPhoto.isGranted) {
        // Permission granted, proceed to pick file
        _pickFile();
      } else {
        var foto = await Permission.photos.status;
        if (foto.isGranted) {
          _pickFile();
        } else {
          if (context.mounted) {
            Alert.alertValidation('Tidak bisa mengakses Penyimpanan', context);
          }
        }
      }
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'],
    );

    if (result != null) {
      setState(() {
        // Use result.files as a List<File> for multiple files
        files = result.files.map((file) => File(file.path!)).toList();
        // You can handle the list of files as needed
      });
    }
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !tags.contains(tag)) {
      setState(() {
        tags.add(tag);
        tagsController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  Future<void> insertFeed() async {
    // Implement your logic to submit the feed with title and tags
    // You can use the titleController.text and tags list
    // For example, you can print them for now:

    // Validate the title and tags
    String title = titleController.text.trim();
    List<String> updatedTags = tags;

    if (title.isEmpty) {
      Alert.alertValidation("Judul feed harus diisi!", context);
      return;
    }

    if (files.isEmpty) {
      Alert.alertValidation("Harus memilih foto/ video!", context);
      return;
    }

    if (tags.isEmpty) {
      Alert.alertValidation("Setidaknya terdapat 1 tag yang dipilih!", context);
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      // Upload files to Firebase Storage
      List<Map<String, dynamic>> content =
          await FeedService().uploadFiles(title, files);

      // Add feed details to Firestore
      await FeedService().uploadFeed(
          userService.currUser!.uid, username, title, content, updatedTags);

      if (context.mounted) {
        setState(() {
          titleController.clear();
          tagsController.clear();
          tags = [];
          files = [];
          NavigationUtils.pushRemoveTransition(
              context,
              const MainScreen(
                page: 0,
              ));
          Alert.successMessage("Feed berhasil ditambahkan.", context);
          isLoading = false;
        });
      }
    } catch (e) {
      if (context.mounted) {
        Alert.alertValidation(e.toString(), context);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    tagsController.dispose();
    super.dispose();
  }
}

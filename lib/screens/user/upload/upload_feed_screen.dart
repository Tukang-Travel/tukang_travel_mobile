import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuktraapp/models/user_model.dart';
import 'package:tuktraapp/provider/user_provider.dart';
import 'package:tuktraapp/services/feed_service.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/constant.dart';
import 'package:tuktraapp/utils/utils.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'Upload Feed',
          maxLines: 10,
          style: TextStyle(
            fontFamily: 'PoppinsBold',
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
              const Text(
                'Title',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                maxLines: null,
              ),
              const SizedBox(height: 16),
              _buildTagsInput(),
              const SizedBox(height: 16),
              _buildFilePicker(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            _submitFeed();
          },
          label: const Text('Submit'),
          backgroundColor: Colors.grey, // Set the button color to grey
        ),
      ),
    );
  }

  Widget _buildTagsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Selected Tags',
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
            : const Text('No selected Tags'),
        const SizedBox(height: 16.0),
        const Text(
          'Recommended Tags',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          padding: const EdgeInsets.all(10.0),
          height: 140.0,
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
        TextField(
          controller: tagsController,
          decoration: InputDecoration(
            labelText: 'Input Tag',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addTag(tagsController.text.trim());
              },
            ),
          ),
          onSubmitted: (value) {
            _addTag(value.trim());
          },
          maxLines: null,
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected File: ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        if (files.isNotEmpty)
          Column(
            children: files.map((file) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('File: ${file.path.split('/').last}'),
                  ],
                ),
              );
            }).toList(),
          ),
        ElevatedButton(
          onPressed: () {
            _pickFile();
          },
          child: const Text('Pick Files'),
        ),
      ],
    );
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

  Future<void> _submitFeed() async {
    // Implement your logic to submit the feed with title and tags
    // You can use the titleController.text and tags list
    // For example, you can print them for now:

    // Validate the title and tags
    String title = titleController.text.trim();
    List<String> updatedTags = tags;

    if (title.isEmpty) {
      // Show an error message for the empty title
      showSnackBar(context, "Title cannot be empty");
      return;
    }

    if (files.isEmpty) {
      showSnackBar(context, "Files cannot be empty");
      return;
    }

    if (tags.isEmpty) {
      // Show an error message for the empty tags
      showSnackBar(context, "Tags cannot be empty");
      return;
    }

    try {
      // Upload files to Firebase Storage
      List<Map<String, dynamic>> content =
          await FeedService().uploadFiles(title, files);

      // Add feed details to Firestore
      await FeedService().uploadFeed(
          userService.currUser!.uid, username, title, content, updatedTags);

      super.initState();
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    tagsController.dispose();
    super.dispose();
  }
}

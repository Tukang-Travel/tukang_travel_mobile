import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tuktraapp/services/feed_service.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/constant.dart';
import 'package:tuktraapp/utils/utils.dart';

class EditFeedScreen extends StatefulWidget {
  const EditFeedScreen({
    super.key,
    required this.feedId,
    required this.initialTitle,
    required this.initialTags,
  });

  final String feedId;
  final String initialTitle;
  final List<String> initialTags;

  @override
  State<EditFeedScreen> createState() => _EditFeedScreenState();
}

class _EditFeedScreenState extends State<EditFeedScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final List<String> tags = [];
  List<String> defaultTags = [];

  Future<void> getTagsTemplate() async {
    final List<Map<String, dynamic>> temp =
        await UserService().getPreferencesTemplate();
    setState(() {
      defaultTags = temp.map((e) => e['name'].toString()).toList();
    });
  }

  @override
  void initState() {
    super.initState();

    getTagsTemplate();

    // Set initial values for title and tags
    titleController.text = widget.initialTitle;
    tags.addAll(widget.initialTags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'Ubah Feed',
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
              const SizedBox(height: 16.0),
              _buildTagsInput(),
              const SizedBox(height: 16.0),
              // Add more form fields as needed
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Add any additional logic when the button is pressed
            // For example, you might want to show a confirmation dialog.
            _updateFeed();
          },
          label: const Text('Ubah', style: TextStyle(color: Colors.white),),
          backgroundColor: const Color.fromARGB(255, 82, 114, 255),
          elevation: 8.0, // Add shadow
        ),
      ),
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
                      setState(() {
                        tags.remove(tag);
                      });
                    },
                  );
                }).toList(),
              )
            : const Text('Tidak ada Tag yang terpilih/dimasukkan'),
        const SizedBox(
          height: 16.0,
        ),
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
        const SizedBox(
          height: 16.0,
        ),
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

  void _addTag(String tag) {
    if (tag.isNotEmpty && !tags.contains(tag)) {
      setState(() {
        tags.add(tag);
        tagsController.clear();
      });
    }
  }

  // Function to update the feed in Firestore
  void _updateFeed() {
    // Validate the title and tags
    String updatedTitle = titleController.text.trim();
    List<String> updatedTags = tags;

    if (updatedTitle.isEmpty) {
      // Show an error message for the empty title
      Alert.alertValidation('Judul harus diisi!', context);
      return;
    }

    if (updatedTags.isEmpty) {
      // Show an error message for the empty tags
      Alert.alertValidation('Tag harus dipilih!', context);
      return;
    }

    FeedService().updateFeed(widget.feedId, updatedTitle, updatedTags);

    // Close the screen
    Navigator.pop(context);

    Alert.successMessage('Feed berhasil diperbaharui.', context);
  }

  @override
  void dispose() {
    titleController.dispose();
    tagsController.dispose();
    super.dispose();
  }
}

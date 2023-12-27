import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tuktraapp/services/feed_service.dart';
import 'package:tuktraapp/services/user_service.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final List<String> _tags = [];
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
    _titleController.text = widget.initialTitle;
    _tags.addAll(widget.initialTags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'Edit Feed',
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
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                maxLines: null, // Allow multiple lines
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
          label: const Text('Ubah'),
          backgroundColor: Colors.grey,
          elevation: 8.0, // Add shadow
        ),
      ),
    );
  }

  Widget _buildTagsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _tags.map((tag) {
            return Chip(
              label: Text(tag),
              onDeleted: () {
                setState(() {
                  _tags.remove(tag);
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _tagsController,
          decoration: InputDecoration(
            labelText: 'Tags',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addTag(_tagsController.text.trim());
              },
            ),
          ),
          onSubmitted: (value) {
            _addTag(value);
          },
          maxLines: null, // Allow multiple lines
        ),
        const SizedBox(
          height: 15.0,
        ),
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
      ],
    );
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagsController.clear();
      });
    }
  }

  // Function to update the feed in Firestore
  void _updateFeed() {
    // Validate the title and tags
    String updatedTitle = _titleController.text.trim();
    List<String> updatedTags = _tags;

    if (updatedTitle.isEmpty) {
      // Show an error message for the empty title
      showSnackBar(context, "Title cannot be empty");
      return;
    }

    if (updatedTags.isEmpty) {
      // Show an error message for the empty tags
      showSnackBar(context, "Tags cannot be empty");
      return;
    }

    FeedService().updateFeed(widget.feedId, updatedTitle, updatedTags);

    // Close the screen
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:tuktraapp/services/feed_service.dart';
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

  @override
  void initState() {
    super.initState();
    
    // Set initial values for title and tags
    _titleController.text = widget.initialTitle;
    _tags.addAll(widget.initialTags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Feed'),
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
                _addTag();
              },
            ),
          ),
          onSubmitted: (value) {
            _addTag();
          },
          maxLines: null, // Allow multiple lines
        ),
      ],
    );
  }

  void _addTag() {
    String tag = _tagsController.text.trim();
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

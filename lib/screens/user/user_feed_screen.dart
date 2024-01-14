import 'package:flutter/material.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({super.key});

  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authenticated User Feed(s)')),
      body: const Center(child: Text('Authenticated User Feed(s)')),
    );
  }
}

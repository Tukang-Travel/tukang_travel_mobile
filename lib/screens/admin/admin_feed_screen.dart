import 'package:flutter/material.dart';

class AdminFeedScreen extends StatefulWidget {
  const AdminFeedScreen({super.key});

  @override
  State<AdminFeedScreen> createState() => _AdminFeedScreenState();
}

class _AdminFeedScreenState extends State<AdminFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Feed View')),
      body: const Center(child: Text('Admin Feed View')),
    );
  }
}
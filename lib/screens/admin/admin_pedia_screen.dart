
import 'package:flutter/material.dart';

class AdminPediaScreen extends StatefulWidget {
  const AdminPediaScreen({super.key});

  @override
  State<AdminPediaScreen> createState() => _AdminPediaScreenState();
}

class _AdminPediaScreenState extends State<AdminPediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Pedia View')),
      body: const Center(child: Text('Admin Pedia View')),
    );
  }
}
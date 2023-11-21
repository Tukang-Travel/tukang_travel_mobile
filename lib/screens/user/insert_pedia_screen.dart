import 'package:flutter/material.dart';

class InsertPediaScreen extends StatefulWidget {
  const InsertPediaScreen({super.key});

  @override
  State<InsertPediaScreen> createState() => _InsertPediaScreenState();
}

class _InsertPediaScreenState extends State<InsertPediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insert Pedia')),
      body: const Center(child: Text('Insert Pedia')),
    );
  }
}
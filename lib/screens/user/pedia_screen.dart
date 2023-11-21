import 'package:flutter/material.dart';

class PediaScreen extends StatefulWidget {
  const PediaScreen({super.key});

  @override
  State<PediaScreen> createState() => _PediaScreenState();
}

class _PediaScreenState extends State<PediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedia View')),
      body: const Center(child: Text('Pedia View')),
    );
  }
}
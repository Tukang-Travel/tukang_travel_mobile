import 'package:flutter/material.dart';
import 'package:tuktraapp/services/user_service.dart';

class UploadFeed extends StatefulWidget {
  const UploadFeed({super.key});

  @override
  State<UploadFeed> createState() => _UploadFeedState();
}

Future<String> _printToken() async {
  String token = await getToken();

  return token;
}

class _UploadFeedState extends State<UploadFeed> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Feed')),
      body: Column(
        children: [
          const Center(
            child: Text('Home'),
          ),
          Center(
            child: FutureBuilder<String>(
              future: _printToken(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // If the Future is still running, display a loading indicator
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there's an error, display the error message
                  return Text('Error: ${snapshot.error}');
                } else {
                  // If the Future is complete, display the result
                  return Text('Result: ${snapshot.data}');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class TagsCard extends StatelessWidget {
  final String snap;
  const TagsCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.all(20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: const Color(0xFFD9D9D9),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            snap,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w100,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

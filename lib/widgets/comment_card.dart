import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/color.dart';

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> snap;

  const CommentCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: UserService().getUser(snap['userId']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Terjadi Kesalahan, Silahkan Coba Lagi Ya: ${snapshot.error}'));
        } else {
          final urlPhoto = snapshot.data?['profile'] ?? '';
          return Card(
            color: Colors.white,
            elevation: 10.0,
            margin: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: const Color(0xffD9D9D9),
                ),
                color: const Color(0xffD9D9D9),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  urlPhoto.isEmpty
                      ? const CircleAvatar(
                          backgroundImage: AssetImage(
                            'asset/images/default_profile.png',
                          ),
                          radius: 18,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(urlPhoto),
                          radius: 18,
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            snap['username'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          const Divider(
                            height: 5,
                            color: Colors.transparent,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${snap['comment']}',
                                  style: const TextStyle(
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 5,
                            color: Colors.transparent,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              DateFormat.yMMMd().format(
                                snap['datePublished'].toDate(),
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

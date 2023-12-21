import 'package:flutter/material.dart';
import 'package:tuktraapp/provider/user_provider.dart';
import 'package:tuktraapp/screens/user/feed/feed_detail_screen.dart';
import 'package:tuktraapp/services/feed_service.dart';
import 'package:tuktraapp/models/user_model.dart';
import 'package:tuktraapp/utils/color.dart';
import 'package:tuktraapp/utils/navigation_util.dart';
import 'package:tuktraapp/utils/utils.dart';
import 'package:tuktraapp/widgets/image_video_slider.dart';
import 'package:tuktraapp/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).user;

    return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          // boundary needed for web
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: mobileBackgroundColor,
            ),
            color: mobileBackgroundColor,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            children: [
              // HEADER SECTION OF THE POST
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ).copyWith(right: 0),
                margin: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '@${widget.snap['username'].toString()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(),
                  ],
                ),
              ),
              // IMAGE SECTION OF THE POST
              GestureDetector(
                onDoubleTap: () {
                  FeedService().likePost(
                    widget.snap['feedId'].toString(),
                    user.uid,
                    widget.snap['likes'],
                  );
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: ImageVideoSlider()
                            .checkImageVideo(widget.snap['content'])),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        duration: const Duration(
                          milliseconds: 400,
                        ),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // LIKE, COMMENT SECTION OF THE POST
              Row(
                children: <Widget>[
                  LikeAnimation(
                    isAnimating: (widget.snap['likes'] as List<dynamic>)
                        .any((like) => like.containsValue(user.uid)),
                    smallLike: true,
                    child: IconButton(
                      icon: (widget.snap['likes'] as List<dynamic>)
                              .any((like) => like.containsValue(user.uid))
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                            ),
                      onPressed: () => FeedService().likePost(
                        widget.snap['feedId'].toString(),
                        user.uid,
                        widget.snap['likes'],
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                      onPressed: () => NavigationUtils.pushTransition(
                          context, FeedDetailScreen(feedId: widget.snap['feedId'].toString()))),
                ],
              ),
              //DESCRIPTION AND NUMBER OF COMMENTS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w800),
                        child: Text(
                          '${widget.snap['likes'].length} likes',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                            /* TextSpan(
                              text: widget.snap['username'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ), */
                            TextSpan(
                              text: '${widget.snap['title']}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: const Text(
                            'View More',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        onTap: () => NavigationUtils.pushTransition(
                            context, FeedDetailScreen(feedId: widget.snap['feedId'].toString()))),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        DateFormat.yMMMd()
                            .format(widget.snap['datePublished'].toDate()),
                        style: const TextStyle(
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

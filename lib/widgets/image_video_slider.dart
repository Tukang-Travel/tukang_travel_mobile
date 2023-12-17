import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:video_player/video_player.dart';

class ImageVideoSlider {
Future<ChewieController> _initializeChewieController(String fileData) async {
    VideoPlayerController videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(fileData));
    await videoPlayerController.initialize();

    return ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: videoPlayerController.value.aspectRatio,
      autoPlay: true,
      looping: true,
    );
  }

  Widget checkImageVideo(List<dynamic> file) {
    return Swiper(
      itemCount: file.length,
      itemBuilder: (BuildContext context, int index) {
        if (file[index]["type"] == "image") {
          return CachedNetworkImage(
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            imageUrl: file[index]["src"]!,
            fit: BoxFit.fitHeight,
          );
        } else {
          return FutureBuilder<ChewieController>(
            future: _initializeChewieController(file[index]["src"]! as String),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Chewie(controller: snapshot.data!);
              } else {
                // Return a loading indicator or placeholder while waiting
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }
      },
      autoplay: false,
      loop: false,
      pagination: const SwiperPagination(),
    );
  }
}
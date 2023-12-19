import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ImageVideoSlider {
  Future<BetterPlayer> _initializePlayer(String fileData) async {
    // VideoPlayerController videoPlayerController =
    //     VideoPlayerController.networkUrl(Uri.parse(fileData));
    // await videoPlayerController.initialize();

    // return ChewieController(
    //   videoPlayerController: videoPlayerController,z
    //   aspectRatio: videoPlayerController.value.aspectRatio,
    //   autoPlay: true,
    //   looping: true,
    // );
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      fileData,
      cacheConfiguration: const BetterPlayerCacheConfiguration(
        useCache: true,
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 10 * 1024 * 1024,
        maxCacheFileSize: 10 * 1024 * 1024,

        ///Android only option to use cached video between app sessions
        key: "feedVideoCache",
      ),

    );

    BetterPlayerController betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControlsOnInitialize: false,
          enableFullscreen: false,
          enableSubtitles: false,
          enableQualities: false,
          enablePlaybackSpeed: false,
          enableAudioTracks: false,
          enableOverflowMenu: false,
        ),
        autoPlay: true,
        looping: true,
      ),
      betterPlayerDataSource: betterPlayerDataSource,

    );

    betterPlayerController.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {

        betterPlayerController.setOverriddenAspectRatio(
            betterPlayerController.videoPlayerController!.value.aspectRatio);
      }
    });

    return BetterPlayer(
      controller: betterPlayerController,
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
          return FutureBuilder<BetterPlayer>(
            future: _initializePlayer(file[index]["src"]! as String),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data!;
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

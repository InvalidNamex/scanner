// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
//
// class VideoPlayer extends StatefulWidget {
//   const VideoPlayer({Key? key}) : super(key: key);
//   @override
//   State<VideoPlayer> createState() => VideoPlayerState();
// }
//
// class VideoPlayerState extends State<VideoPlayer> {
//   // Create a [Player] to control playback.
//   late final player = Player();
//   // Create a [VideoController] to handle video output from [Player].
//   late final controller = VideoController(player);
//
//   @override
//   void initState() {
//     super.initState();
//     // Play a [Media] or [Playlist].
//     String video = Get.arguments[0];
//     player.open(Media(video));
//   }
//
//   @override
//   void dispose() {
//     player.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.width * 9.0 / 16.0,
//         child: Video(controller: controller),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:scanner/constants.dart';
import 'package:scanner/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends GetView<HomeController> {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String _x = Get.arguments[0];
    homeController.playerController(_x);
    return Scaffold(
        backgroundColor: Colors.black,
        body: WillPopScope(
            onWillPop: () async {
              homeController.videoController!.dispose();
              Get.back();
              return false;
            },
            child: Obx(
              () => homeController.readyToPlay.value
                  ? Center(
                      child: AspectRatio(
                          aspectRatio:
                              homeController.videoController!.value.aspectRatio,
                          child: VideoPlayer(homeController.videoController!)),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            )));
  }
}

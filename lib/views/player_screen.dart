import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/controller/audio_controller.dart';
import 'package:flutter_application_1/model/local_song_modal.dart';
import 'package:flutter_application_1/utils/custom_text_style.dart';
import 'package:flutter_application_1/widgets/my_button.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';

class PlayerScreen extends StatefulWidget {
  final LocalSongModal song;
  final int index;

  const PlayerScreen({super.key, required this.index, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioController audioController = Get.put(AudioController());
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // ✅ Gradient behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80.h,
        title: Text(
          'Now Playing',
          style: myTextStyle24(
            fontWeight: FontWeight.bold,
            fontColor: Colors.white,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.all(4.0.w),
          child: MyButton(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22.sp,
              color: Colors.white,
            ),
            onPress: () => Navigator.pop(context),
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFF9C27B0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🎵 Music Animation
                  Lottie.asset(
                    'assets/animations/Animation - 1748708199066.json',
                    height: 220.h,
                  ),
                  SizedBox(
                    height: 30.h,
                    child: Marquee(
                      blankSpace: 30.w,
                      startPadding: 30.w,
                      velocity: 30,
                      style: myTextStyle18(fontColor: Colors.white),
                      text: widget.song.title.toString().split("/").last,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    widget.song.artist,
                    style: myTextStyle15(fontColor: Colors.white70),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: StreamBuilder<Duration>(
                      stream: audioController.audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration =
                            audioController.audioPlayer.duration ??
                            Duration.zero;
                        return ProgressBar(
                          progress: position,
                          total: duration,
                          progressBarColor: Colors.white,
                          baseBarColor: Colors.white30,
                          thumbColor: Colors.white,
                          timeLabelTextStyle: myTextStyle15(
                            fontColor: Colors.white,
                          ),
                          onSeek: (duration) {
                            audioController.audioPlayer.seek(duration);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyButton(
                        onPress: audioController.previousSong,
                        child: Icon(
                          Icons.skip_previous_rounded,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                      ),
                      MyButton(
                        btnBackGround: Colors.white,
                        child: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 40.sp,
                          color: Color(0xFF7B1FA2),
                        ),
                        onPress: () {
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                          audioController.togglePlayPause();
                        },
                      ),
                      MyButton(
                        onPress: audioController.nextSong,
                        child: Icon(
                          Icons.skip_next_rounded,
                          size: 30.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

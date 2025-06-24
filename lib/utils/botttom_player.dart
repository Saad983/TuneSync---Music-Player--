import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/controller/audio_controller.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/views/player_screen.dart';
import 'package:marquee/marquee.dart';

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioController audioController = Get.find<AudioController>();

    return Obx(() {
      final currentSong = audioController.currentSong;
      if (currentSong == null) return const SizedBox.shrink();

      return GestureDetector(
        onTap: () {
          Get.to(
            () => PlayerScreen(
              index: audioController.currentIndex.value,
              song: currentSong,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(100),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(21.r),
              topRight: Radius.circular(21.r),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                offset: Offset(8, 8),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-8, -8),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
                child: SizedBox(
                  height: 20.h,
                  child: Marquee(
                    text: currentSong.title.split('/').last,
                    blankSpace: 50.w,
                    startPadding: 30.w,
                    velocity: 10,
                  ),
                ),
              ),
              StreamBuilder<Duration>(
                stream: audioController.audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration =
                      audioController.audioPlayer.duration ?? Duration.zero;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ProgressBar(
                      progress: position,
                      total: duration,
                      timeLabelLocation: TimeLabelLocation.none,
                      barHeight: 4.h,
                      baseBarColor: Colors.grey.shade300,
                      progressBarColor: AppColors.primary,
                      thumbColor: AppColors.primary,
                      onSeek: (duration) {
                        audioController.audioPlayer.seek(duration);
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(8.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: audioController.previousSong,
                    ),
                    Obx(
                      () => IconButton(
                        icon: Icon(
                          audioController.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        iconSize: 36.sp,
                        onPressed: audioController.togglePlayPause,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        final nextIndex =
                            audioController.currentIndex.value + 1;
                        if (nextIndex < audioController.songs.value.length) {
                          audioController.playSong(nextIndex);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

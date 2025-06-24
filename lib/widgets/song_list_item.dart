import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter_application_1/controller/audio_controller.dart';
import 'package:flutter_application_1/model/local_song_modal.dart';

import 'package:flutter_application_1/utils/custom_text_style.dart'
    show myTextStyle12, myTextStyle15;
import 'package:flutter_application_1/views/player_screen.dart';
import 'package:flutter_application_1/widgets/my_button.dart';
import 'package:flutter_application_1/widgets/my_container.dart';

class SongListItem extends StatelessWidget {
  final LocalSongModal song;
  final int index;

  const SongListItem({super.key, required this.song, required this.index});

  String _formatDuration(int milliseconds) {
    final minutes = (milliseconds / 60000).floor(); // fix: 60000 not 6000
    final seconds = ((milliseconds % 60000) / 1000).floor();
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final audioController = Get.find<AudioController>();

    return Obx(() {
      final currentIndex = audioController.currentIndex.value;
      final isPlaying = audioController.isPlaying.value;
      final isCurrentSong = currentIndex == index;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        child: MyContainer(
          child: ListTile(
            contentPadding: EdgeInsets.all(12.w),
            leading: Container(
              height: 35.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.music_note, color: Colors.white),
            ),
            title: Text(
              song.title,
              style: myTextStyle15(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              song.artist,
              style: myTextStyle12(fontColor: Colors.black26),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDuration(song.duration),
                  style: myTextStyle12(fontColor: Colors.black26),
                ),
                SizedBox(width: 8.w),
                MyButton(
                  onPress: () {
                    if (isCurrentSong && isPlaying) {
                      audioController.pauseSong();
                    } else if (isCurrentSong && !isPlaying) {
                      audioController.resumeSong();
                    } else {
                      audioController.playSong(index);
                    }
                  },
                  child: Icon(
                    isCurrentSong && isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color:
                        isCurrentSong && isPlaying
                            ? const Color.fromARGB(255, 14, 241, 132)
                            : Colors.black,
                    size: 32.sp,
                  ),
                ),
              ],
            ),
            onTap: () {
              audioController.playSong(index);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(index: index, song: song),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}

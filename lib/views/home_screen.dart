import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter_application_1/controller/audio_controller.dart';

import 'package:flutter_application_1/utils/botttom_player.dart';
import 'package:flutter_application_1/utils/custom_text_style.dart';

import 'package:flutter_application_1/widgets/song_list_item.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioController audioController = Get.put(AudioController());

  Future<void> _checkPermissionAndRequest() async {
    if (Platform.isAndroid) {
      int sdkInt = int.tryParse(Platform.version.split(' ')[0]) ?? 33;
      if (sdkInt >= 33) {
        if (await Permission.audio.request().isGranted) {
          await audioController.loadSongs();
        }
      } else {
        if (await Permission.storage.request().isGranted) {
          await audioController.loadSongs();
        }
      }
    } else {
      await audioController.loadSongs();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermissionAndRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Extend behind AppBar for gradient
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 80.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Tune',
                style: myTextStyle36(
                  fontWeight: FontWeight.bold,
                  fontColor: Colors.white,
                ),
              ),
              TextSpan(
                text: 'Sync',
                style: myTextStyle36(
                  fontColor: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
        child: Obx(() {
          final songs = audioController.songs;
          if (songs.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 8.w,
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.only(
              top: 100.h,
              bottom: 80.h,
            ), // AppBar + BottomPlayer space
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return SongListItem(song: songs[index], index: index);
              },
            ),
          );
        }),
      ),
      bottomSheet: const BottomPlayer(),
    );
  }
}

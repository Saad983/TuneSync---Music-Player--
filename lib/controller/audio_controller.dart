import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_application_1/model/local_song_modal.dart';

class AudioController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  final songs = <LocalSongModal>[].obs;
  final currentIndex = (-1).obs;
  final isPlaying = false.obs;

  LocalSongModal? get currentSong =>
      currentIndex.value != -1 && currentIndex.value < songs.length
          ? songs[currentIndex.value]
          : null;

  @override
  void onInit() {
    super.onInit();
    _setupAudioPlayer();
    loadSongs(); // ✅ Permission pehle main.dart mein ho chuki hogi!
  }

  void _setupAudioPlayer() {
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        nextSong();
      }
    });
  }

  Future<void> loadSongs() async {
    final fetched = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    songs.value =
        fetched
            .map(
              (e) => LocalSongModal(
                id: e.id,
                title: e.title,
                artist: e.artist ?? 'Unknown Artist',
                uri: e.uri ?? '',
                albumArt: e.album ?? '',
                duration: e.duration ?? 0,
              ),
            )
            .toList();
  }

  Future<void> playSong(int index) async {
    if (index < 0 || index >= songs.length) return;

    if (currentIndex.value == index && isPlaying.value) {
      await pauseSong();
      return;
    }

    currentIndex.value = index;
    final song = songs[index];

    await audioPlayer.stop();
    await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri)));
    await audioPlayer.play();
    isPlaying.value = true;
  }

  Future<void> pauseSong() async {
    await audioPlayer.pause();
    isPlaying.value = false;
  }

  Future<void> resumeSong() async {
    await audioPlayer.play();
    isPlaying.value = true;
  }

  Future<void> nextSong() async {
    if (currentIndex.value < songs.length - 1) {
      await playSong(currentIndex.value + 1);
    }
  }

  Future<void> previousSong() async {
    if (currentIndex.value > 0) {
      await playSong(currentIndex.value - 1);
    }
  }

  void togglePlayPause() async {
    if (currentIndex.value == -1) return;
    if (isPlaying.value) {
      await pauseSong();
    } else {
      await resumeSong();
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}

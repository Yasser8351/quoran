import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final audioPlayer = AudioPlayer();
  //AssetsAudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration postion = Duration.zero;
  String url = 'assets/a.mp3';

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.PLAYING);
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() => duration = newDuration);
    });

    audioPlayer.onAudioPositionChanged.listen((newPostion) {
      setState(() => postion = newPostion);
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var result = duration - postion;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Slider(
            min: 0,
            thumbColor: const Color(0xff001614),
            activeColor: const Color.fromARGB(255, 4, 56, 52),
            inactiveColor: const Color.fromARGB(255, 4, 61, 56),
            value: postion.inSeconds.toDouble(),
            max: duration.inSeconds.toDouble(),
            onChanged: ((value) async {
              final position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);
              await audioPlayer.resume();
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(duration.toString()),
              Text(result.toString()),
            ],
          ),
          CircleAvatar(
            radius: 35,
            child: IconButton(
              onPressed: () async {
                if (isPlaying) {
                  await audioPlayer.pause();
                } else {
                  await audioPlayer.play(url, isLocal: true);
                }
              },
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              iconSize: 27,
            ),
          ),
        ],
      ),
    );
  }
}

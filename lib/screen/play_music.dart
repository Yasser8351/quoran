import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../model/music_model.dart';

class PlayMusic extends StatefulWidget {
  const PlayMusic({Key? key}) : super(key: key);

  @override
  _PlayMusicState createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> {
  late AudioPlayer player;
  late AudioCache cache;
  bool isPlaying = false;
  Duration currentPostion = const Duration();
  Duration musicLength = const Duration();
  int index = 0;
  //List<String> mylist = ['a.mp3', 'b.mp3'];

  List<MusicModel> mylist = [
    MusicModel(name: "سورة يس", url: 'yaseen.mp3'),
    MusicModel(name: "سورة الفرقان", url: 'alforgan.mp3'),
  ];
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    index = 0;
    setUp();
    getCurrentPostion();
  }

  setUp() {
    player.onAudioPositionChanged.listen((d) {
      // Give us the current position of the Audio file

      if (currentPostion == musicLength) {
        setState(() => isPlaying = true);
      }

      setState(() {
        currentPostion = d;
      });

      player.onDurationChanged.listen((d) {
        //Returns the duration of the audio file
        setState(() {
          musicLength = d;
        });
      });
    });
  }

  void getCurrentPostion() {
    if (currentPostion == musicLength) {
      setState(() => isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: size.height * .8,
            width: double.infinity,
            alignment: Alignment.center,
            color: const Color(0xff001614),
            child: Image.asset("assets/logo2.jpg"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(mylist[index].name)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('${currentPostion.inSeconds.toDouble()}'),
              SizedBox(
                  width: 300,
                  child: Slider(
                      thumbColor: const Color(0xff001614),
                      inactiveColor: const Color.fromARGB(255, 2, 145, 133),
                      activeColor: const Color.fromARGB(255, 4, 61, 56),
                      value: currentPostion.inSeconds.toDouble(),
                      max: musicLength.inSeconds.toDouble(),
                      onChanged: (val) {
                        seekTo(val.toInt());
                      })),
              Text('${musicLength.inSeconds}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.first_page),
                iconSize: 35,
                onPressed: () {
                  if (index > 0) {
                    setState(() {
                      index--;
                      isPlaying = true;
                      print('$index');
                    });
                    cache.play(mylist[index].url);
                  } else {
                    setState(() {
                      isPlaying = true;
                    });
                    print('$index');
                    cache.play(mylist[index].url);
                  }
                },
              ),
              IconButton(
                onPressed: () {
                  if (isPlaying) {
                    setState(() {
                      isPlaying = false;
                    });
                    stopMusic();
                  } else {
                    setState(() {
                      isPlaying = true;
                    });
                    playMusic(mylist[index].url);
                  }
                },
                icon: isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                // icon: isPlaying
                //     ? const Icon(Icons.pause)
                //     : const Icon(Icons.play_arrow),
                iconSize: 35,
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                iconSize: 35,
                onPressed: () {
                  if (index < mylist.length - 1) {
                    print('$index');
                    setState(() {
                      index = index + 1;
                      isPlaying = true;
                    });
                    print('$index');
                    cache.play(mylist[index].url);
                  } else {
                    setState(() {
                      index = 0;
                      isPlaying = true;
                    });
                    print("$index");
                    cache.play(mylist[index].url);
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  playMusic(String song) {
    // to play the Audio
    cache.play(song);
  }

  stopMusic() {
    // to pause the Audio
    player.pause();
  }

  seekTo(int sec) {
    // To seek the audio to a new position
    player.seek(Duration(seconds: sec));
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }
}

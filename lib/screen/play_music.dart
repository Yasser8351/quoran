import 'dart:developer';

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
  Duration currentPostion = Duration.zero;
  // Duration currentPostion = const Duration();
  //Duration(microseconds: (millis * 1000).toInt())
  Duration musicLength = const Duration();
  int index = 0;
  String name = '';
  int expandedIndex = -1;
  List<MusicModel> mylist = [
    MusicModel(name: "سورة يس", url: 'yaseen.mp3'),
    MusicModel(name: "سورة الفرقان", url: 'alforgan.mp3'),
  ];
  @override
  void initState() {
    super.initState();
    log(isPlaying.toString());
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    index = 0;
    setUp();
    //getCurrentPostion();
  }

  setUp() {
    player.onAudioPositionChanged.listen((d) {
      // Give us the current position of the Audio file

      // if (currentPostion == musicLength) {
      //   setState(() => isPlaying = true);
      // }

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

  String formatTimeCurrentPostion(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String formatTimeEndPostion(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    log("build $name");

    final size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Builder(builder: (context) {
        if (expandedIndex == -1) {
          return const SizedBox();
        } else {
          return Container(
            color: Colors.white,
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("$name edit this")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(formatTimeCurrentPostion(currentPostion)),
                    //Text('${currentPostion.inSeconds.toDouble()}'),
                    SizedBox(
                        width: 250,
                        child: Slider(
                            thumbColor: const Color(0xff001614),
                            inactiveColor:
                                const Color.fromARGB(255, 2, 145, 133),
                            activeColor: const Color.fromARGB(255, 4, 61, 56),
                            value: currentPostion.inSeconds.toDouble(),
                            max: musicLength.inSeconds.toDouble(),
                            onChanged: (val) {
                              seekTo(val.toInt());
                            })),
                    Text(formatTimeEndPostion(musicLength)),
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
                      iconSize: 35,
                    ),
                    IconButton(
                      icon: const Icon(Icons.last_page),
                      iconSize: 35,
                      onPressed: () {
                        if (index < mylist.length - 1) {
                          setState(() {
                            index = index + 1;
                            isPlaying = true;
                          });
                          log(' next $index');
                          cache.play(mylist[index].url);
                        } else {
                          setState(() {
                            index = 0;
                            isPlaying = true;
                          });
                          log(" back $index");
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
      }),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xff001614),
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: size.height * .8,
                width: double.infinity,
                alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: mylist.length,
                  itemBuilder: (context, index) {
                    // return ItemListView(model: mylist[index]);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          name = mylist[index].name;
                          expandedIndex = index;
                          isPlaying = true;
                          playMusic(mylist[index].url);
                        });
                      },
                      //expandedIndex
                      child: Container(
                        color: expandedIndex == index
                            ? Colors.white
                            : const Color(0xff001614),
                        child: ListTile(
                          trailing: Text(
                            name,
                            style: TextStyle(
                              color: expandedIndex != index
                                  ? Colors.white
                                  : const Color(0xff001614),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                //child: Image.asset("assets/logo2.jpg"),
              ),
            ],
          ),
        ),
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

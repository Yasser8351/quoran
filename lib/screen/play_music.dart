import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  Duration musicLength = const Duration();
  Duration formatDurationFrom1 = Duration(milliseconds: 100000);
  Duration formatDurationFrom2 = Duration(milliseconds: 10000);
  Duration duration = Duration.zero;
  int index = 0;
  String name = 'no data';
  int expandedIndex = -1;
  DateTime timeBackPressed = DateTime.now();
  List<MusicModel> mylist = [
    MusicModel(name: "سورة الفاتحة", url: 'alfitiha.mp3'),
    MusicModel(name: "سورة الجن", url: 'algin.mp3'),
    MusicModel(name: "سورة القلم", url: 'alkalam.mp3'),
    MusicModel(name: "سورة الملك", url: 'almolk.mp3'),
    MusicModel(name: "سورة ق", url: 'khaf.mp3'),
    MusicModel(name: "سورة يس", url: 'yaseen.mp3'),
    MusicModel(name: "سورة الفرقان", url: 'alforgan.mp3'),
    MusicModel(name: "ايات من سورة المائدة", url: 'almaida.mp3'),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.subscribeToTopic("test");
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    index = 0;
    setUp();
  }

  setUp() {
    player.onAudioPositionChanged.listen(
      (d) {
        // Give us the current position of the Audio file

        setState(() {
          log("currentPostion $currentPostion");
          currentPostion = d;
        });

        player.onDurationChanged.listen(
          (d) {
            //Returns the duration of the audio file
            setState(() {
              musicLength = d;

              log("musicLength $musicLength");
            });
          },
        );
      },
    );
  }

  String formatTimeCurrentPostion(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    log("formatDurationFrom1   " + formatDurationFrom1.inMinutes.toString());
    log("formatDurationFrom1  " + duration.inMinutes.remainder(60).toString());

    if (formatDurationFrom1.inSeconds > duration.inMinutes.remainder(60)) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    if (formatDurationFrom1.inMinutes > duration.inMinutes.remainder(60)) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String formatTimeEndPostion(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (formatDurationFrom1.inMinutes < duration.inMinutes.remainder(60)) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    if (formatDurationFrom1.inMinutes < duration.inSeconds.remainder(60)) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(children: [
      Align(
          alignment: Alignment.topCenter,
          child: WillPopScope(
            onWillPop: () async {
              setState(() => isPlaying = false);
              stopMusic();
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  SizedBox(width: 7),
                  IconButton(
                    onPressed: () async {
                      await Share.share(
                          "القرآن الكريم كامل بدون انترنت بصوت الشيخ محمد عثمان حاج على \n حمل التطبيق من قوقل بلى \n https://play.google.com/store/apps/details?id=com.quoran.app");
                    },
                    icon: Icon(Icons.share_outlined),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: const Text(
                      "القرآن الكريم كامل بصوت الشيخ محمد عثمان حاج",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(width: 7),
                ],
                backgroundColor: const Color.fromARGB(255, 0, 58, 53),
              ),
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
                              child: Text(name)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(formatTimeCurrentPostion(currentPostion)),
                            SizedBox(
                                width: 250,
                                child: Slider(
                                    min: 0.0,
                                    thumbColor: const Color(0xff001614),
                                    inactiveColor:
                                        const Color.fromARGB(255, 2, 145, 133),
                                    activeColor:
                                        const Color.fromARGB(255, 4, 61, 56),
                                    value: currentPostion.inSeconds.toDouble(),
                                    max: musicLength < currentPostion
                                        ? 1.toDouble()
                                        : musicLength.inSeconds.toDouble(),
                                    //max: 0,
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
                                    expandedIndex = index;
                                    name = mylist[index].name;
                                    isPlaying = true;
                                    print('$index');
                                  });
                                  cache.play(mylist[index].url);
                                } else {
                                  setState(() {
                                    expandedIndex = index;
                                    name = mylist[index].name;
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
                                    expandedIndex = index;
                                    name = mylist[index].name;
                                    isPlaying = true;
                                    log(' next index $index');
                                  });
                                  cache.play(mylist[index].url);
                                } else {
                                  setState(() {
                                    index = 0;
                                    expandedIndex = index;
                                    name = mylist[index].name;
                                    isPlaying = true;
                                    log(" back index $index");
                                  });
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
                  decoration: const BoxDecoration(
                    color: Color(0xff001614),
                    image: DecorationImage(
                      image: AssetImage("assets/image.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  //color: const Color(0xff001614),
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * .01),
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
                                  log("on Tap");
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
                                    : null,
                                child: ListTile(
                                  trailing: expandedIndex == index
                                      ? Icon(
                                          isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: const Color(0xff001614),
                                        )
                                      : SizedBox(width: 24),
                                  title: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      " ${mylist[index].name}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: expandedIndex != index
                                            ? Colors.white
                                            : const Color(0xff001614),
                                      ),
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
            ),
          ))
    ]);
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
    stopMusic();
    player.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    stopMusic();
    player.dispose();
  }
}

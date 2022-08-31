// import 'package:flutter/material.dart';

// import 'screen/play_music.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primaryColor: const Color(0xff001614),
//         // This is the theme of your application.
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const PlayMusic(),
//       // home: const HomeScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'screen/play_file.dart';
import 'screen/play_from_network.dart';
import 'screen/play_music.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const PlayMusic()
        // PlayFromNetwork()
        //AssetAudio()
        // PlayMusic(),
        );
  }
}

class MusicApp extends StatefulWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  List<Widget> myWidget = [
    const PlayMusic(),
    const PlayFromNetwork(),
    const PlayLocalFile()
  ];
  int pageIndex = 0;
  selectPage(int val) {
    setState(() {
      pageIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myWidget[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: selectPage,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note), label: 'Assets'),
          BottomNavigationBarItem(icon: Icon(Icons.vpn_lock), label: 'Network'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'File')
        ],
      ),
    );
  }
}

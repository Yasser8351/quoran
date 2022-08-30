import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   final audioPlayer = AudioPlayer();
    bool isPlaying = false;
    Duration duration = Duration.zero;
    Duration postion = Duration.zero;
    String url = '';


    @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
  @override
  Widget build(BuildContext context) {


   

    return Scaffold(

      body: Column(children: [
        Slider(
          value: postion.inSeconds.toDouble(),
        max:duration.inSeconds.toDouble(), 
         onChanged: ((value) {

        }),
    ),
   
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
    
    
     [
      Text(duration.toString()),
      Text(postion.toString()),
    ],)
       , CircleAvatar(child: IconButton(onPressed: ()async{

        if(isPlaying){
          await audioPlayer.pause();
        }else{
          await audioPlayer.play('')

        }
       }, icon: Icon(isPlaying?Icons.pause :Icons.play_arrow),iconSize: 30,),),

    ],
     
            
    ),
    );
    
  }
}
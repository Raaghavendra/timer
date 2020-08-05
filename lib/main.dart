import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick timer',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Quick Timer'),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initPlayer();
  }
  int currTime = 0, timer1 = 40, timer2 = 60  ;
  bool distimer1 = false, distimer2 = false;
  Timer timer;
  bool song = false;
  bool disStart = false;
  AudioPlayer advancedPlayer = new AudioPlayer();
  AudioCache player =  AudioCache();
  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    player = new AudioCache(fixedPlayer: advancedPlayer);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 30),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 2, 
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child : Text( currTime.toString(),style: TextStyle(
                  color: Colors.deepOrange, fontSize: 200),),
                ),
              ),
            Expanded(
              flex: 1, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      onPressed: distimer1?  null : () => setTimer(timer1),
                      onLongPress: currTime >0? null :() {
                        _showMyDialog().then((onValue) {
                          print(int.parse(onValue));
                          setState(() {
                            timer1 = int.parse(onValue);
                          });
                        });
                        },
                      color: Colors.lightGreen,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "${timer1}s",
                          style: TextStyle (
                            fontSize: 50
                          ),
                        ),
                      ),  
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      onPressed: distimer2?  null : () => setTimer(timer2),
                      onLongPress: currTime >0? null : () {
                        _showMyDialog().then((onValue) {
                          print(int.parse(onValue));
                          setState(() {
                            timer2 = int.parse(onValue);
                          });
                        });
                        },
                      color: Colors.lightGreen,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "${timer2}s",
                          style: TextStyle (
                            fontSize: 50
                          ),
                        ),
                      ),  
                    ),
                  ),
                ],
              ),
            ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: song? null : () {
                  player.play("bsu.mp3");
                  setState(() => song = true);
                  startTimer(true);
                  },
                color: Colors.purple[200],
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Bring Sally Up",
                    style: TextStyle (
                      fontSize: 37
                    ),
                  ),
                ),  
              ),

            Expanded(
              flex: 1, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      onPressed: disStart? null : () => startTimer(false),
                      color: Colors.lightBlue[600],
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Start",
                          style: TextStyle (
                            fontSize: 35
                          ),
                        ),
                      ),  
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      onPressed: resetTimer,
                      color: Colors.red[300],
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Reset",
                          style: TextStyle (
                            fontSize: 35
                          ),
                        ),
                      ),  
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void setTimer(timer) {
    print(timer);
    setState(() {
      currTime = timer;
    });
  }
  void resetTimer() {
    setState(() {
      if (song) {
        advancedPlayer.stop();
        timer.cancel();
        setState(() {
        song = false;
        });
        return;
      }
      currTime = 0;
      disStart = false;
      disStart = false;
      distimer1 = false;
      distimer2 = false;
    });
  }

  void startTimer(bool bsu) {
    bool sound = false;
    setState(() {
      if(bsu) currTime = 0;
      distimer2 = true; distimer1 = true; disStart = true; song = true;
    });
    if (timer != null) timer.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (time) {
      setState(() {
        if (bsu){
          currTime ++;
        }
        else{
          if (currTime > 0) {
            currTime --;
            if (currTime == 1) sound = true;
          }
          else {
            timer.cancel();
            if (sound) FlutterRingtonePlayer.playNotification();
            song = false;
            resetTimer();
          }
        }
      });
    });
  }
  Future<String> _showMyDialog() async {
  TextEditingController tc = TextEditingController();
  return showDialog(
    context: context,
    // barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white60,
        title: Text('Set new timer', textAlign: TextAlign.center ,style: TextStyle( fontSize :25, color: Colors.black),),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(keyboardType: TextInputType.number,controller: tc, textAlign: TextAlign.center, style: TextStyle(fontSize :30, color: Colors.white) ,)
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            child: Text('SET'),
            onPressed: () {
              Navigator.of(context).pop(tc.text.toString());
            },
            color: Colors.lightBlue[600],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          ),
        ],
      );
    },
  );
}
}


import 'dart:io';
import 'package:flutter/services.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speech_to_text/speech_to_text.dart' as spee;
import 'package:flutter_sms/flutter_sms.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  final platform = const MethodChannel('sendSms');

  late String lat;
  late String long;

  late spee.SpeechToText _speech;

  var locationMSG = '';

  bool enable = true;

  bool islisten = false;

  String textspeech = "Speak ";

  Future<Null> sendSms() async {
    String messageContent =
        ">><<Iam in DANGER>><< \n Location:latitude:$lat,longitude:$long ";

    try {
      final String result = await platform.invokeMethod('send',
          <String, dynamic>{"phone": "+919544806485", "msg": messageContent});
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  void _liveLoc() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      setState(() {
        locationMSG = 'latitude:$lat,longitude:$long';
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 60, 59, 59),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 120),
                  child: Center(
                      child: Text(
                    textspeech,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ))),
              // Padding(
              //   padding: const EdgeInsets.all(50),
              //   child: Container(
              //     padding: EdgeInsets.all(80),
              //     margin: EdgeInsets.only(top: 355, left: 10),
              //     child: Image.asset(
              //       "assets/weeli.png",
              //     ),
              //   ),
              // ),
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _cardmenu(
                                    title: 'ALERT',
                                    asset:
                                        'assets/warning-icon-transparent-free-png.webp',
                                    onTap: () {
                                      sendSms();
                                      print('Alert ');
                                    }),
                                _cardmenu(
                                    title: 'SPO2',
                                    asset: 'assets/spo2.png',
                                    onTap: () {
                                      _getcurrentLocation().then((value) {
                                        lat = '${value.latitude}';
                                        long = '${value.longitude}';
                                        setState(() {
                                          locationMSG =
                                              'latitude:$lat, longitude:$long';
                                        });
                                        _liveLoc();
                                      });
                                      print('O2 rate');
                                    },
                                    color: Color.fromARGB(255, 234, 83, 72),
                                    fontcolor: Colors.white),
                              ]),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: AvatarGlow(
                          animate: true,
                          glowColor: Colors.red,
                          endRadius: 70,
                          duration: Duration(milliseconds: 2000),
                          repeatPauseDuration: Duration(milliseconds: 100),
                          repeat: true,
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.all(10),
                                  minimumSize: Size(50, 80),
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          width: 2, color: Colors.redAccent))),
                              child: Icon(
                                Icons.mic,
                                color: Colors.red,
                                size: 40,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: Column(
                          children: [
                            Container(
                              child: ElevatedButton(
                                  onHover: (value) => null,
                                  onPressed: () {
                                    print('moving forward');
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.all(15),
                                      minimumSize: Size(150, 80),
                                      shape: CircleBorder(
                                          side: BorderSide(
                                              width: 5, color: Colors.black))),
                                  child: Image.asset('assets/up arrow.png')),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        print('moving left');
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.all(15),
                                          minimumSize: Size(150, 80),
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  width: 5,
                                                  color: Colors.black))),
                                      child:
                                          Image.asset('assets/arrow-left.png')),
                                ),
                                Container(
                                  child: ElevatedButton(
                                      onHover: (value) => null,
                                      onPressed: () {
                                        print("moving right");
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.all(15),
                                          minimumSize: Size(150, 80),
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  width: 5,
                                                  color: Colors.black))),
                                      child: Image.asset(
                                          'assets/right arrow.png')),
                                ),
                              ],
                            ),
                            Container(
                              child: ElevatedButton(
                                  onPressed: () {
                                    print('reverce');
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.all(15),
                                      minimumSize: Size(150, 80),
                                      shape: CircleBorder(
                                          side: BorderSide(
                                              width: 5, color: Colors.black))),
                                  child: Image.asset('assets/down arrow.png')),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }

  Future<Position> _getcurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("location service is not enabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("location permission is denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("location permission is PERMENENTLY DENIED ");
    }
    return await Geolocator.getCurrentPosition();
  }

  Widget _cardmenu(
      {required String title,
      required asset,
      VoidCallback? onTap,
      Color color = Colors.white,
      Color fontcolor = Colors.grey}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 36),
        width: 156,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24), color: color),
        child: Column(children: [
          Container(
            height: 60,
            width: 60,
            child: Image.asset(
              asset,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: fontcolor,
            ),
          )
        ]),
      ),
    );
  }
}

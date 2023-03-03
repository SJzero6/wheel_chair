import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  bool _isvisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 60, 59, 59),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(50),
                child: Container(
                  margin: EdgeInsets.only(top: 80),
                  child: Image.asset(
                    "assets/weeli.png",
                  ),
                ),
              ),
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
                                      print('Alert');
                                    }),
                                _cardmenu(
                                    title: 'SPO2',
                                    asset: 'assets/spo2.png',
                                    onTap: () {
                                      print('O2 rate');
                                    },
                                    color: Color.fromARGB(255, 234, 83, 72),
                                    fontcolor: Colors.white),
                              ]),
                        ],
                      ),
                      SizedBox(
                        height: 200,
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
                                      onHover: (value) => null,
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
                                  onHover: (value) => null,
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

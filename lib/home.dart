import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_sms/flutter_sms.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final platform = const MethodChannel('sendSms');

  var forwardvoice = ["Move forward", "Forward", "go forward"];
  var leftvoice = ["Move left", "left", "go left", "turn left"];
  var rightvoice = ["Move left", "left", "go left", "turn left"];
  var backwardvoice = ["Move left", "left", "go left", "turn left"];
  var stopvoice = ["stop"];

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  static const url = "a3ic1k7itt4ynl-ats.iot.ap-northeast-1.amazonaws.com";

  static const port = 8883;

  static const clientId = 'WheelC';

  final client = MqttServerClient.withPort(url, clientId, port);

  String o2 = '-';
  String temp = "-";

  @override
  void initState() {
    super.initState();

    _connectMqtt();

    _initSpeech();
  }

  _connectMqtt() {
    newAWSConnect();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  late String lat;
  late String long;

  var locationMSG = '';

  Future<Null> sendSms() async {
    String messageContent =
        ">><<Iam in DANGER>><< \n Location:latitude:$lat,longitude:$long ";

    try {
      final String result = await platform.invokeMethod('send',
          <String, dynamic>{"phone": "+918848737989", "msg": messageContent});
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
                  margin: EdgeInsets.only(bottom: 80),
                  child: Center(
                      child: Text(
                    _speechToText.isListening
                        ? '$_lastWords'
                        : _speechEnabled
                            ? 'Speak'
                            : 'Speech not available',
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
                                    title: 'Temprature\n$temp',
                                    asset: 'assets/images/1090683.png',
                                    onTap: () {
                                      print('Temprature');
                                    }),
                                _cardmenu(
                                    title: 'SPO2\n$o2',
                                    asset: 'assets/images/spo2.png',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: ElevatedButton(
                                onPressed: _speechToText.isNotListening
                                    ? _startListening
                                    : _stopListening,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.all(10),
                                    minimumSize: Size(50, 80),
                                    shape: CircleBorder(
                                        side: BorderSide(
                                            width: 2,
                                            color: Colors.redAccent))),
                                child: Icon(
                                  Icons.mic,
                                  color: Colors.red,
                                  size: 40,
                                )),
                          ),
                          Container(
                            child: ElevatedButton(
                                onPressed: () {
                                  sendSms();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.all(10),
                                    minimumSize: Size(50, 80),
                                    shape: CircleBorder(
                                        side: BorderSide(
                                            width: 2,
                                            color: Colors.redAccent))),
                                child: Icon(
                                  Icons.crisis_alert,
                                  color: Colors.red,
                                  size: 40,
                                )),
                          ),
                        ],
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
                                  onPressed: () {
                                    Forward();
                                    print('moving forward');
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.all(15),
                                      minimumSize: Size(90, 50),
                                      shape: CircleBorder(
                                          side: BorderSide(
                                              width: 5, color: Colors.black))),
                                  child: Image.asset(
                                      'assets/images/up arrow.png')),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Left();
                                        print('moving left');
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.all(15),
                                          minimumSize: Size(90, 50),
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  width: 5,
                                                  color: Colors.black))),
                                      child: Image.asset(
                                          'assets/images/arrow-left.png')),
                                ),
                                Container(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        stop();
                                        print('Stop');
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.all(15),
                                          minimumSize: Size(80, 70),
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  width: 5,
                                                  color: Colors.black))),
                                      child: Icon(
                                        Icons.stop_circle,
                                        color: Colors.red,
                                        size: 40,
                                      )),
                                ),
                                Container(
                                  child: ElevatedButton(
                                      onHover: (value) => null,
                                      onPressed: () {
                                        Right();
                                        print("moving right");
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.all(15),
                                          minimumSize: Size(90, 50),
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  width: 5,
                                                  color: Colors.black))),
                                      child: Image.asset(
                                          'assets/images/right arrow.png')),
                                ),
                              ],
                            ),
                            Container(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Backward();
                                    print('reverce');
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.all(15),
                                      minimumSize: Size(90, 50),
                                      shape: CircleBorder(
                                          side: BorderSide(
                                              width: 5, color: Colors.black))),
                                  child: Image.asset(
                                      'assets/images/down arrow.png')),
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

  newAWSConnect() async {
    client.secure = true;

    client.keepAlivePeriod = 20;

    client.setProtocolV311();

    client.logging(on: true);

    final context = SecurityContext.defaultContext;

    ByteData dev_cert = await rootBundle.load(
        'assets/certi/88f78bb72a173ed5c23cfb3b8f4afa9f96c8308612faa8d4fe7805bc253dd18b-certificate.pem.crt');
    context.useCertificateChainBytes(dev_cert.buffer.asUint8List());

    ByteData authorities =
        await rootBundle.load('assets/certi/AmazonRootCA3.pem');
    context.setClientAuthoritiesBytes(authorities.buffer.asUint8List());

    ByteData keybyte = await rootBundle.load(
        'assets/certi/88f78bb72a173ed5c23cfb3b8f4afa9f96c8308612faa8d4fe7805bc253dd18b-private.pem.key');
    context.usePrivateKeyBytes(keybyte.buffer.asUint8List());
    client.securityContext = context;

    final msg =
        MqttConnectMessage().withClientIdentifier('$clientId').startClean();
    client.connectionMessage = msg;
    try {
      print('MQTT client is connecting to AWS');
      await client.connect();
    } on Exception catch (e) {
      print('MQTT client exception - $e');
      client.disconnect();
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('AWS iot connection succesfully done');

      const topic = 'Underground/pub';
      final maker = MqttClientPayloadBuilder();
      // maker.addString('jermi');
      client.publishMessage(topic, MqttQos.atMostOnce, maker.payload!);

      client.subscribe(topic, MqttQos.atMostOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final rcvmsg = c[0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(rcvmsg.payload.message);
        print(
            'Example::Change notification:: topic is<${c[0].topic}>, payload is <--$pt-->');

        var payloadJson = json.decode(pt);

        setState(() {
          o2 = "${payloadJson["SPO2"]}";
          temp = "${payloadJson["TEMP"]}";
          // print('kozhikallan');
        });
      });
    } else {
      print(
          'ERROR MQTT client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
    }
    return 0;
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
        padding: EdgeInsets.symmetric(vertical: 30),
        width: 156,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24), color: color),
        child: Column(children: [
          Container(
            height: 60,
            width: 70,
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

  void Left() {
    const topic = 'WheelC/sub';
    final make = MqttClientPayloadBuilder();
    make.addString('L');
    client.publishMessage(topic, MqttQos.atLeastOnce, make.payload!);
  }

  void Right() {
    const topic = 'WheelC/sub';
    final make = MqttClientPayloadBuilder();
    make.addString('R');
    client.publishMessage(topic, MqttQos.atLeastOnce, make.payload!);
  }

  void Forward() {
    const topic = 'WheelC/sub';
    final make = MqttClientPayloadBuilder();
    make.addString('F');
    client.publishMessage(topic, MqttQos.atLeastOnce, make.payload!);
  }

  void Backward() {
    const topic = 'WheelC/sub';
    final make = MqttClientPayloadBuilder();
    make.addString('B');
    client.publishMessage(topic, MqttQos.atLeastOnce, make.payload!);
  }

  void stop() {
    const topic = 'WheelC/sub';
    final make = MqttClientPayloadBuilder();
    make.addString('s');
    client.publishMessage(topic, MqttQos.atLeastOnce, make.payload!);
  }
}

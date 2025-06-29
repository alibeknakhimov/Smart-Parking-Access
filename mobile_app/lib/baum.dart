import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

class BaumPage extends StatefulWidget {
  const BaumPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BaumPageState createState() => _BaumPageState();
}

class _BaumPageState extends State<BaumPage> {
  String img = "close";
  int close = 0;
  int open = 240;
  int cur = 0;
  int change = 255;
  int chan = 0;
  bool pise = false;
  final DatabaseReference _testRef = FirebaseDatabase.instance.ref();
  final User? user = Auth().currentUser;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _activate();
  }

  void _activate() {
    _testRef.child('door').onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        img = data.toString();
      });
      if (img == "open") {
        open = 0;
        close = 240;
      }
      if (img == "close") {
        open = 240;
        close = 0;
      }
    });
  }

  void _incrementCounter() {
    _testRef.child("shlagbaum").set({
      'control': 1,
      'user': user?.email ?? 'User email',
    });

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        pise = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double displayHeight = MediaQuery.of(context).size.height;
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Container(
          padding: EdgeInsets.only(
              top: displayHeight / 11.84,
              left: displayWidth / 13.09,
              right: displayWidth / 13.09),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: displayWidth / 3.927,
                      height: displayHeight / 11.0977,
                      child: Image.asset("assets/k.png"),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Container(

                  width: displayWidth,
                  height: displayHeight / 5.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1))
                      ]),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Icon(Icons.arrow_upward,
                          size: (displayHeight / 5.5)/2,
                          color: Color.fromARGB(255, open, open, open)),
                      Expanded(child: Container()),
                      Icon(Icons.arrow_downward,
                          size: (displayHeight / 5.5)/2,
                          color: Color.fromARGB(255, close, close, close)),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  )),
              Expanded(
                child: Container(),
              ),
              Container(
                width: displayWidth,
                height: displayHeight / 8.3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 15, color: Colors.black.withOpacity(0.15))
                    ]),
                child: Row(
                  children: [
                    SizedBox(
                      width: displayWidth / 2.3607,
                      child: const Text(
                        "Шлагбаум",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: pise
                          ? null
                          : () async {
                              print(pise);
                              final hasPermission =
                                  await _handleLocationPermission();
                              if (hasPermission) {
                                Position position =
                                    await Geolocator.getCurrentPosition();
                                if (position.latitude < 43.257 &&
                                    position.latitude > 43.253 &&
                                    position.longitude < 76.945 &&
                                    position.longitude > 76.939) {
                                  setState(() {
                                    pise = true;
                                  });
                                  _incrementCounter();
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        fixedSize:
                            Size(displayWidth / 2.3607, displayHeight / 8.2909),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                      ),
                      child: const Text(
                        "Открыть",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 240, 240, 240),
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        cur = 0;
                        if (cur == 0) {
                          chan = 40;
                          change = 255;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, chan, chan, chan),
                      fixedSize:
                          Size(displayWidth / 2.618, displayHeight / 16.581818),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Center(
                      child: cur == 0
                          ? const Icon(
                              Icons.directions_car_sharp,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.directions_car_sharp,
                              color: Colors.black,
                              size: 30,
                            ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        cur = 1;
                        if (cur == 1) {
                          chan = 255;
                          change = 40;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, change, change, change),
                      fixedSize:
                          Size(displayWidth / 2.618, displayHeight / 16.581818),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Center(
                      child: cur == 1
                          ? const Icon(
                              Icons.motorcycle_sharp,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.motorcycle_sharp,
                              color: Colors.black,
                              size: 30,
                            ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'baum.dart';
import 'settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List pages = [
    const BaumPage(),
    const SettingsPage(),
  ];
  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double displayHeight = MediaQuery.of(context).size.height;
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: pages[currentIndex],
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
            height: displayWidth * .165,
            margin: EdgeInsets.all(displayWidth * .075),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.black.withOpacity(0.1))
                ]),
            child: Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          currentIndex = 0;
                        });
                      },
                      icon: currentIndex == 0
                          ?  Icon(
                        Icons.car_rental,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: (displayWidth * .165)/3
                      )
                          :  Icon(
                        Icons.car_rental,
                        color: Color.fromARGB(255, 220, 220, 220),
                        size: (displayWidth * .165)/3
                      ),
                    ),
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          currentIndex = 1;
                        });
                      },
                      icon: currentIndex == 1
                          ?  Icon(
                        Icons.settings,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: (displayWidth * .165)/3
                      )
                          :  Icon(
                        Icons.settings,
                        color: Color.fromARGB(255, 220, 220, 220),
                        size: (displayWidth * .165)/3
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            )));
  }
}

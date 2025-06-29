import 'dart:async';
import 'dart:io';

import 'package:firebase_admin/firebase_admin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;


void main() async {
  FirebaseDart.setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD0ULeKOXfuUuW65KnW74qU0vQuXUmleUI",
      projectId: "kbtu-4554c",
      messagingSenderId: "417854260659",
      appId: "1:417854260659:web:c0a66cf7ed8f0b4f29b7c6",
      databaseURL: "https://kbtu-4554c-default-rtdb.firebaseio.com",
    ),
  );
  runApp(
    MediaQuery(
      data: MediaQueryData(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final databaseRef = FirebaseDatabase().reference();
  final myController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final excel.Workbook workbook = excel.Workbook();
  final adminApp = FirebaseAdmin.instance.initializeApp(
    AppOptions(
      credential: FirebaseAdmin.instance
          .certFromPath('kbtu-4554c-firebase-adminsdk-log99-e492917432.json'),
      databaseUrl: 'https://kbtu-4554c-default-rtdb.firebaseio.com/',
    ),
  );
  String ds = "";
  int cont = 0;
  String dd = "";
  String dx = "";
  String dax = "";
  String time = "";

  Text absoluteStatus = Text('');
  bool showStatus = false;
  @override
  void initState() {
    super.initState();
    _activate();
    _activ();
  }

  void _activate() {
    databaseRef.child('door').onValue.listen((Event event) {
      final data = event.snapshot.value;
      setState(() {
        dd = data.toString();
        if (dd == "open") {
          getacc();
        }
      });
    });
  }

  void _delayedHideStatus() {
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        showStatus = false;
      });
    });
  }

  void _activ() {
    databaseRef.child('pos_start').onValue.listen((Event event) {
      final dat = event.snapshot.value;
      setState(() {
        dx = dat.toString();
        if (dx == "start") {
          granp();
        }
      });
    });
  }

  Future<void> _registerUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      setState(() {
        showStatus = true;
        absoluteStatus = Text('Пользователь успешно зарегистрирован',
            style: TextStyle(
              color: Colors.green,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ));
      });
      _delayedHideStatus();
    } catch (e) {
      setState(() {
        showStatus = true;
        absoluteStatus = Text('Ошибка при регистрации: $emailController.text',
            style: TextStyle(
              color: Colors.red,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ));
      });
      _delayedHideStatus();
      print('Registration error: $emailController.text');
    }
  }

  Future<void> _deleteUser() async {
    try {
      final userRecord =
          await adminApp.auth().getUserByEmail(emailController.text);

      if (userRecord != null) {
        await adminApp.auth().deleteUser(userRecord.uid);

        setState(() {
          showStatus = true;
          absoluteStatus =
              Text('Пользователь ${emailController.text} успешно удален',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ));
        });
        _delayedHideStatus();
        print('Пользователь ${emailController.text} удален успешно.');
      } else {
        setState(() {
          showStatus = true;
          absoluteStatus =
              Text('Пользователь с email ${emailController.text} не найден.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ));
        });
        _delayedHideStatus();
        print('Пользователь с email ${emailController.text} не найден.');
      }
    } catch (e) {
      setState(() {
        showStatus = true;
        absoluteStatus =
            Text('Пользователь с email ${emailController.text} не найден.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ));
      });
      _delayedHideStatus();
      print('Пользователь с email ${emailController.text} не найден.');
    }
  }

  Future<void> granp() async {
    final snap = await databaseRef.child('car').once();
    dax = snap.value.toString();
    final excel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('G$cont').setText(dax);
    databaseRef.child("car").set("_");
    databaseRef.child("pos_start").set("_");
  }

  Future<void> getacc() async {
    cont++;

    final snapshot = await databaseRef.child('shlagbaum/user').once();

    ds = snapshot.value.toString();

    time = DateTime.now().toString();
    final excel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A$cont').setText(ds);
    sheet.getRangeByName('D$cont').setText(time);
  }

  Future<void> createExcel() async {
    final List<int> bytes = workbook.saveAsStream();
    final String path = (await getApplicationSupportDirectory()).path;
    final String filename = '$path/Output.xlsx';
    final File file = File(filename);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(filename);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        child: Image.asset("assets/k.png"),
                        width: 100,
                        height: 74.7,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    databaseRef.child("shlagbaum/control").set(1);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 50, right: 110),
                    child: Row(children: [
                      Text(
                        "Открыть шлагбаум",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Expanded(child: Container()),
                      Icon(
                        Icons.car_rental,
                        color: Colors.black,
                        size: 32,
                      ),
                    ]),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 255, 255),
                    fixedSize: const Size(1000, 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    databaseRef.child("shlagbaum/control").set(2);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 50, right: 110),
                    child: Row(children: [
                      Text(
                        "Открыть для фуры",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Expanded(child: Container()),
                      Icon(
                        Icons.car_rental,
                        color: Colors.black,
                        size: 32,
                      ),
                    ]),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 255, 255),
                    fixedSize: const Size(1000, 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 70),
                  width: 1000,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        ds,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Expanded(child: Container()),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Expanded(child: Container()),
                      Text(
                        dax,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: createExcel,
                        child: Text(
                          "Скачать Excel",
                          style: TextStyle(
                            fontSize: 23,
                            color: Color.fromARGB(255, 240, 240, 240),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          fixedSize: const Size(250, 100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(top: 25, left: 50),
                  width: 1000,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 253, 253)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w600,
                            fontSize: 23),
                        labelText: "Логин",
                        floatingLabelBehavior: FloatingLabelBehavior.auto),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(top: 25, left: 50),
                  width: 1000,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w600,
                            fontSize: 23),
                        labelText: "Пароль",
                        floatingLabelBehavior: FloatingLabelBehavior.auto),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      width: 450,
                    ),
                    ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        fixedSize: Size(200, 60),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      child: Text(
                        'Зарегистрировать',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(255, 240, 240, 240),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                    ),
                    ElevatedButton(
                      onPressed: _deleteUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        fixedSize: Size(200, 60),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      child: Text(
                        'Удалить',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(255, 240, 240, 240),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                if (showStatus) absoluteStatus,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

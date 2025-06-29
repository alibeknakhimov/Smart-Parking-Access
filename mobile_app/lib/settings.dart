import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final User? user = Auth().currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Container(
          padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 20, top: 10, right: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 15,
                            color: Colors.black.withOpacity(0.14))
                      ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "KBTU",
                            style: TextStyle(
                                fontSize: 27, fontWeight: FontWeight.w600),
                          ),
                          Expanded(child: Container()),
                          const Icon(
                            Icons.person,
                            size: 60,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Text(
                            user?.email ?? 'User email',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ],
                      )
                    ],
                  )),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  fixedSize: Size(MediaQuery.of(context).size.width, 100),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Row(children: [
                  const Text("Выйти из аккаунта",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                  Expanded(child: Container()),
                  const Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                ]),
              )
            ],
          ),
        ));
  }
}

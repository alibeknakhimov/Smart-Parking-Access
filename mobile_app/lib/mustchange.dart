import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

class MustChange extends StatefulWidget {
  const MustChange({
    Key? key,
  }) : super(key: key);

  @override
  State<MustChange> createState() => MustChangeState();
}

class MustChangeState extends State<MustChange> {
  String? errorMessage = '';
  bool isPasswordChanged = false;

  final TextEditingController _controllerCurrentPassword =
      TextEditingController();
  final TextEditingController _controllerNewPassword = TextEditingController();

  Future<void> changePassword() async {
    try {
      final User? user = Auth().currentUser;
      if (user != null) {
        final AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _controllerCurrentPassword.text,
        );
        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(_controllerNewPassword.text);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isPasswordChanged', true);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: title.contains('password'),
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        labelText: title,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: changePassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        fixedSize: const Size(330, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Colors.black,
      ),
      child: const Text(
        'Изменить Пароль',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: const EdgeInsets.only(top: 180, left: 30, right: 30),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 100,
                      height: 74.7,
                      child: Image.asset("assets/k.png"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                "В целях безопасности вам нужно изменить нынешний пароль",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 50),
              _entryField('нынешний пароль', _controllerCurrentPassword),
              const SizedBox(height: 15),
              _entryField('новый пароль', _controllerNewPassword),
              const SizedBox(height: 75),
              _submitButton(),
              if (isPasswordChanged)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Пароль успешно изменен!',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

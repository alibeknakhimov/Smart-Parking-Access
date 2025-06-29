import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';
import 'control.dart';
import 'mustchange.dart';
import 'login_register_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  bool isMustChangePassword = true;

  @override
  Widget build(BuildContext context) {
    _checkPasswordChangedStatus(); // Check the password change status on every build

    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (isMustChangePassword) {
            return const MyHomePage();
          } else {
            return const MustChange();
          }
        } else {
          return const LoginPage();
        }
      },
    );
  }

  Future<void> _checkPasswordChangedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPasswordChanged = prefs.getBool('isPasswordChanged') ?? false;
    setState(() {
      isMustChangePassword = isPasswordChanged;
    });
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class start extends StatefulWidget {
  start({Key? key}) : super(key: key);

  @override
  State<start> createState() => _startState();
}

// ignore: camel_case_types
class _startState extends State<start> {
  String? email;

  pp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email");
    print("Email 1 = $email");
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    pp();

    Timer(
        const Duration(seconds: 4),
        () => email == "" || email == null
            ? Navigator.of(context).pushReplacementNamed("sign_in")
            : Navigator.of(context).pushReplacementNamed("Home"));
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(fit: BoxFit.fill, child: Image.asset('images/logo.jpg'));
  }
}

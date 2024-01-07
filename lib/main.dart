import 'dart:convert';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tajweed/Home.dart';
import 'package:tajweed/achievements.dart';
import 'package:tajweed/contact_us.dart';
import 'package:tajweed/exam2.dart';
import 'package:tajweed/firstgrid.dart';
import 'package:tajweed/forgotpassword.dart';
import 'package:tajweed/matiral.dart';
import 'package:tajweed/profile.dart';
import 'package:tajweed/sign_up.dart';
import 'package:tajweed/sign_in.dart';
import 'package:tajweed/start.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tajweed/suggestions.dart';

import 'ThemeApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(myapp());
}

class myapp extends StatefulWidget {
  myapp({Key? key}) : super(key: key);

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  var email;
  _myappState();
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.green,
        statusBarColor: Colors.green,
        statusBarIconBrightness: Brightness.light));
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            home: start(),
            routes: {
              "Home": (context) => homePage(),
              "sign_up": (context) => sign_up(),
              "sign_in": (context) => sign_in(),
              "ForgetPassword": (context) => ForgetPassword(),
              "ContactUs": (context) => ContactUs(),
              "profile": (context) => profile(),
              "achi": (context) => achievements(),
              "sugg": (context) => suggestions()
            },
          );
        },
      ),
    );
  }
}

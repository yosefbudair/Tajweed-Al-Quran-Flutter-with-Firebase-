import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/components/toggle/gf_toggle.dart';
import 'package:getwidget/types/gf_toggle_type.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ThemeApp.dart';

class drawer extends StatefulWidget {
  const drawer({super.key});

  @override
  State<StatefulWidget> createState() => drawerState();
}

class drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    String? name = FirebaseAuth.instance.currentUser?.displayName;
    String? email = FirebaseAuth.instance.currentUser?.email;
    String? imagep = FirebaseAuth.instance.currentUser?.photoURL;
    var darkThemeProvider = Provider.of<DarkThemeProvider>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);

    if (name == null || name == '') {
      name = "أنت ضيف";
    }
    if (email == null || email == '') {
      email = "ض";
    }

    return Drawer(
        child: Column(
      children: [
        Container(
          width: double.infinity,
          child: DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FirebaseAuth.instance.currentUser?.photoURL == null
                    ? CircleAvatar(
                        maxRadius: 50,
                        minRadius: 40,
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        child: Text(
                          email[0],
                          style: TextStyle(fontSize: 35, color: Colors.white),
                        ),
                      )
                    : CircleAvatar(
                        maxRadius: 50,
                        minRadius: 40,
                        backgroundImage: NetworkImage(imagep!),
                      ),
                Text(name,
                    style: TextStyle(
                        color: Color.fromARGB(255, 166, 166, 166),
                        fontWeight: FontWeight.normal,
                        fontFamily: ""))
              ],
            ),
          ),
        ),
        ListTile(
          title: Text('الصفحة الرئيسية',
              style: Theme.of(context).textTheme.headline1),
          //trailing:: Icon(Icons.person),
          trailing: const Icon(Icons.home),
          onTap: () {
            Navigator.of(context).pushReplacementNamed("Home");
          },
        ),
        ListTile(
          title: Text("الملف الشخصي",
              style: Theme.of(context).textTheme.headline1),
          //trailing:: Icon(Icons.person),
          trailing: const Icon(Icons.person),
          onTap: () async {
            if (email != "ض")
              Navigator.of(context).pushNamed("profile");
            else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("email", "");
              Navigator.of(context).pushReplacementNamed("sign_in");
            }
          },
        ),
        ListTile(
          title:
              Text('الإنجازات', style: Theme.of(context).textTheme.headline1),
          //trailing:: Icon(Icons.person),
          trailing: const Icon(Icons.analytics),
          onTap: () async {
            if (email != "ض")
              Navigator.of(context).pushNamed("achi");
            else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("email", "");
              Navigator.of(context).pushReplacementNamed("sign_in");
            }
          },
        ),
        ListTile(
          title: Text("المظهر الداكن",
              style: Theme.of(context).textTheme.headline1),
          trailing: Switch(
            onChanged: (val) {
              themeChange.darkTheme = val;
            },
            value: themeChange.darkTheme,
          ),
        ),
        ListTile(
          title:
              Text("تواصل معنا", style: Theme.of(context).textTheme.headline1),
          trailing: Icon(Icons.help),
          onTap: () {
            Navigator.of(context).pushNamed("ContactUs");
          },
        ),
        Expanded(
          child: Container(),
        ),
        ListTile(
          title: name == "أنت ضيف"
              ? Text("تسجيل دخول", style: Theme.of(context).textTheme.headline1)
              : Text("تسجيل الخروج",
                  style: Theme.of(context).textTheme.headline1),
          trailing: Icon(Icons.exit_to_app),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("email", "");
            Navigator.of(context).pushReplacementNamed("sign_in");
          },
        )
      ],
    ));
  }
}

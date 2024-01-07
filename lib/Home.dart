import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tajweed/Load.dart';
import 'package:tajweed/QCreat.dart';
import 'package:tajweed/drawer.dart';
import 'package:tajweed/firstgrid.dart';

import 'appbar.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  bool isload = false;

  setUserData() async {
    Questions qus = new Questions();

    String ids;
    CollectionReference user = FirebaseFirestore.instance.collection("Users");
    var docu = await user.where("Email",
        isEqualTo: FirebaseAuth.instance.currentUser?.email);
    await user
        .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        user.add({
          "Email": FirebaseAuth.instance.currentUser?.email,
          "UserName": FirebaseAuth.instance.currentUser?.displayName,
          "ImagePath": FirebaseAuth.instance.currentUser?.photoURL
        });

        docu.get().then((value) {
          value.docs.forEach((element) async {
            ids = element.id.toString();
            await qus.UpdateQforC(ids);
            await qus.SetTitle(ids);

            setState(() {
              isload = true;
            });
          });

          //setUserColl(ids); // use one time to create documents of Collection (Questions) in your data base
        });
      } else {
        setState(() {
          isload = true;
        });
      }
    });
  }

  getemail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (FirebaseAuth.instance.currentUser?.email == null) {
      prefs.setString("email", "0");
    } else {
      prefs.setString("email", "1");
    }

    print("Sign in ${FirebaseAuth.instance.currentUser?.email}");
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    getemail();
    if (FirebaseAuth.instance.currentUser?.email != null &&
        FirebaseAuth.instance.currentUser?.email != "") {
      setUserData();
    } else {
      setState(() {
        isload = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isload
        ? Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBarScreen(title: "الصفحة الرئيسية"),
              endDrawer: drawer(),
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset("images/png_logo_1.png"),
                      ),
                      Center(
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor)))),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => firstgrid(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "الدورة التمهيدية",
                                  style: Theme.of(context).textTheme.headline4,
                                ))),
                      ),
                      Center(
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    // overlayColor:  MaterialStateProperty.all(Theme.of(context).primaryColor),
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor)))),
                                onPressed: null,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      "الدورة المتوسطة",
                                      style: TextStyle(fontSize: 19),
                                    ),
                                    Icon(Icons.lock, size: 30),
                                  ],
                                ))),
                      ),
                      Center(
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    // overlayColor:  MaterialStateProperty.all(Theme.of(context).primaryColor),
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor)))),
                                onPressed: null,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      "الدورة المتقدمة",
                                      style: TextStyle(fontSize: 19),
                                    ),
                                    Icon(Icons.lock, size: 30),
                                  ],
                                ))),
                      ),
                      Center(
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    // overlayColor:  MaterialStateProperty.all(Theme.of(context).primaryColor),
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor)))),
                                onPressed: () {
                                  Navigator.of(context).pushNamed("sugg");
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      "مقترحات تعليمية",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ],
                                ))),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Loadpage();
  }
}

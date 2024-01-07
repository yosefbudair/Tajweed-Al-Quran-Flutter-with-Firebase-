import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tajweed/appbar.dart';
import 'package:tajweed/exam2.dart';

import 'drawer.dart';

class st extends StatefulWidget {
  String title;
  st({super.key, required this.title});

  @override
  State<st> createState() => _stState(title);
}

//---------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------

class _stState extends State<st> {
  String title;
  _stState(this.title);
  var x;

//---------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------

  getid() async {
    String? ids;
    CollectionReference user = FirebaseFirestore.instance.collection("Users");
    var docu = await user.where("Email",
        isEqualTo: FirebaseAuth.instance.currentUser?.email);

    docu.get().then((value) {
      value.docs.forEach((element) async {
        ids = element.id.toString();
        getdata(ids!);
      });
    });
  }
//---------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------

  getdata(String id) async {
    List qu = [];
    DocumentReference docs = await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("Questions")
        .doc(title);

    await docs.get().then((DocumentSnapshot da) {
      if (title != "التقويم الشامل") {
        for (int i = 1; i <= 5; i++) {
          qu.add(da['Q$i']);
        }
      } else {
        for (int i = 1; i <= 25; i++) {
          qu.add(da['Q$i']);
        }
      }
    });
    x = qu;

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => exam2(x: x, title: title),
        ));
  }
//---------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarScreen(title: "الامتحان"),
        endDrawer: drawer(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: FirebaseAuth.instance.currentUser?.email != null &&
                  FirebaseAuth.instance.currentUser?.email != ''
              ? ElevatedButton(
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(30)),
                      overlayColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)))),
                  child: Text("إبدأ الأمتحان",
                      style: Theme.of(context).textTheme.headline4),
                  onPressed: () async {
                    await getid();
                  })
              : Text(
                  'يجب أن تقوم بتسجيل الدخول لبدأ الأمتحان',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 131, 130, 130), fontSize: 18),
                ),
        ),
      ),
    );
  }
}

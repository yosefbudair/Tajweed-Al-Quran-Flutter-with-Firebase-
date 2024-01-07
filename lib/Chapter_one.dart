import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tajweed/Load.dart';
import 'package:tajweed/drawer.dart';
import 'package:tajweed/exam2.dart';
import 'package:tajweed/main.dart';
import 'package:tajweed/matiral.dart';
import 'package:tajweed/st.dart';

import 'appbar.dart';

class Chapter_one extends StatefulWidget {
  List data;
  String title;
  String subtitle;

  Chapter_one({
    Key? key,
    required this.data,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  State<Chapter_one> createState() => _Chapter_oneState(data, title, subtitle);
}

class _Chapter_oneState extends State<Chapter_one> {
  //the data of the grid view (headlines)
  List data;
  String title;
  String subtitle;
  String? email = FirebaseAuth.instance.currentUser?.email;
  _Chapter_oneState(this.data, this.title, this.subtitle);

  Map map = {};

  var arr = [
    'الفصل الاول',
    'الفصل الثاني',
    'الفصل الثالث',
    'الفصل الرابع',
    'الفصل الخامس',
    'التقويم الشامل'
  ];
  bool isload = false;

//---------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------

  Future getdata() async {
    Map s = {};

    var docu = await FirebaseFirestore.instance
        .collection("Users")
        .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email);
    docu.get().then((value) {
      value.docs.forEach((element) async {
        for (int i = 0; i < arr.length; i++) {
          DocumentReference docs = await FirebaseFirestore.instance
              .collection("Users")
              .doc(element.id.toString())
              .collection("Title")
              .doc(arr[i]);

          await docs.get().then((DocumentSnapshot da) async {
            s.addAll({arr[i]: da.data() as Map});
          });
        }
        if (!mounted) {
          return;
        }
        setState(() {
          isload = false;
          map = s;
          isload = true;
        });
      });
    });
  }

//---------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    if (email != null && email != '') {
      getdata();
    }
    map = {};
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        endDrawer: drawer(),

        appBar: AppBarScreen(title: title),
        // drawer: Drawer(),
        body: Column(
          children: [
            Flexible(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(25),
                    child: Stack(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .primaryColor)))),
                          onPressed: isload || email == null || email == ''
                              ? () {
                                  if (data[index]["Title"] == "امتحان") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            st(title: subtitle),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Matiral(
                                            datas: data[index]["material"],
                                            title: data[index]["Title"],
                                            subtitle: subtitle,
                                            isdone: email != null && email != ''
                                                ? map[subtitle]
                                                    [data[index]["Title"]]
                                                : 1),
                                      ),
                                    ).then((value) async {
                                      isload = false;
                                      await getdata();
                                    });
                                  }
                                }
                              : null,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(data[index]["Title"],
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.all(5),
                            child: email != null && email != ''
                                ? isload
                                    ? Icon(
                                        Icons.book,
                                        color: map[subtitle]
                                                    [data[index]["Title"]] ==
                                                1
                                            ? Colors.green
                                            : Colors.grey,
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(
                                            left: 100, bottom: 100),
                                        child: SpinKitCircle(
                                          size: 20,
                                          color: Colors.green,
                                        ),
                                      )
                                : Icon(
                                    Icons.book,
                                    color: Colors.grey,
                                  ))
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

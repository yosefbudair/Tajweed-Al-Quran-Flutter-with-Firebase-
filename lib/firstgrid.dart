import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tajweed/Chapter_one.dart';
import 'package:tajweed/Load.dart';
import 'package:tajweed/appbar.dart';
import 'package:tajweed/drawer.dart';

class firstgrid extends StatefulWidget {
  const firstgrid({super.key});

  @override
  State<firstgrid> createState() => _firstgridState();
}

class _firstgridState extends State<firstgrid> {
  List data = [];
  bool isload = false;
  bool isload2 = false;
  _firstgridState();

  Map map = {};

  var arr = [
    'الفصل الاول',
    'الفصل الثاني',
    'الفصل الثالث',
    'الفصل الرابع',
    'الفصل الخامس',
    'التقويم الشامل'
  ];

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
          isload2 = false;
          map = s;
          isload2 = true;
        });
      });
    });
  }

//---------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    if (FirebaseAuth.instance.currentUser?.email != null &&
        FirebaseAuth.instance.currentUser?.email != '') {
      getdata();
    }

    // Call the loadJSONData function to parse the JSON file
    loadJSONData().then((value) {
      setState(() {
        // Assign the parsed JSON data to the data variable
        isload = false;
        data = value;
        isload = true;
      });
    });
  }

  //the data of the grid view (headlines)

  @override
  Widget build(BuildContext context) {
    return isload
        ? Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBarScreen(title: "الدورة التمهيدية"),
              endDrawer: drawer(),
              body: Column(
                children: [
                  Flexible(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor)))),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Chapter_one(
                                        data: data[index]["materialTitle"],
                                        title: data[index]["title"],
                                        subtitle: data[index]["head"],
                                      ),
                                    ),
                                  ).then((value) async {
                                    isload2 = false;
                                    await getdata();
                                  });
                                  ;
                                },
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(data[index]["head"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6)),
                                      Text(data[index]["title"],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2)
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.all(5),
                                  child: FirebaseAuth.instance.currentUser
                                                  ?.email !=
                                              null &&
                                          FirebaseAuth.instance.currentUser
                                                  ?.email !=
                                              ''
                                      ? isload2
                                          ? Icon(
                                              Icons.book,
                                              color: map[data[index]["head"]]
                                                              .length -
                                                          2 ==
                                                      map[data[index]["head"]]
                                                          ['counter']
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
          )
        : Loadpage();
  }

  Future<List> loadJSONData() async {
    // Load the JSON file from the assets folder
    String jsonString = await rootBundle.loadString('assets/datas.json');
    // Convert the JSON string to a JSON object
    var data = await json.decode(jsonString);

    // Return the parsed data as a list
    return data;
  }
}

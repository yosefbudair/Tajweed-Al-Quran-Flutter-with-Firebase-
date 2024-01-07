import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:tajweed/main.dart";
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:tajweed/drawer.dart';

import 'appbar.dart';

class Matiral extends StatefulWidget {
  List datas;
  String title;
  String subtitle;
  int isdone;
  Matiral(
      {Key? key,
      required this.datas,
      required this.title,
      required this.subtitle,
      required this.isdone})
      : super(key: key);

  @override
  State<Matiral> createState() => _MatiralState(datas, title, subtitle, isdone);
}

//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------
class _MatiralState extends State<Matiral> {
  List datas;
  String title;
  String subtitle;
  int isdone;
  _MatiralState(this.datas, this.title, this.subtitle, this.isdone);
  static late double width;
  static late double height;
  bool _collapse = false;

  updateTitle() async {
    var docu = await FirebaseFirestore.instance
        .collection("Users")
        .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email);

    await docu.get().then((value) {
      value.docs.forEach((element) async {
        DocumentReference docs = FirebaseFirestore.instance
            .collection("Users")
            .doc(element.id.toString())
            .collection("Title")
            .doc(subtitle);

        await docs.get().then((DocumentSnapshot da) async {
          if (da[title] == 0) {
            await docs.update({'counter': da['counter'] + 1});
            await docs.update({title: 1});
          }
        });
      });
    });
  }

  //----------------------------------------------------------------------------------------------
  //----------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        endDrawer: drawer(),
        appBar: AppBarScreen(
          title: "",
        ),
        body: Column(children: [
          Expanded(
            child: ListView.builder(
              itemCount: datas.length,
              itemBuilder: (BuildContext context, int index) {
                if (datas[index].keys.toList().first == "text") {
                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        datas[index]["text"],
                        style: Theme.of(context).textTheme.headline6,
                      ));
                } else if (datas[index].keys.toList().first == "image") {
                  return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Image.asset('images/${datas[index]["image"]}'));
                } else if (datas[index].keys.toList().first == "title") {
                  return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        datas[index]["title"],
                        style: Theme.of(context).textTheme.headline3,
                        textAlign: TextAlign.center,
                      ));
                } else if (datas[index].keys.toList().first == "list") {
                  Map data = datas[index]["list"];
                  return GridMenu(data: data, index: data["items"].length);
                } else if (datas[index].keys.toList().first == "note") {
                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(datas[index]["note"],
                          style: Theme.of(context).textTheme.caption));
                } else
                  return Text("data");
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            height: 50,
            width: 250,
            child: ElevatedButton(
              onPressed: isdone == 0
                  ? () async {
                      await updateTitle();
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 93, 214, 97),
                      Color.fromARGB(255, 38, 86, 39)
                    ]),
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('إنهاء', style: TextStyle(fontSize: 23))],
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class GridMenu extends StatefulWidget {
  Map data;
  int index;
  GridMenu({Key? key, required this.data, required this.index})
      : super(key: key);

  @override
  _GridMenuState createState() => _GridMenuState(data, index);
}

class _GridMenuState extends State<GridMenu> {
  bool _collapse = false;
  int index;
  Map data;
  _GridMenuState(this.data, this.index);

  @override
  Widget build(BuildContext context) {
    // List datas=data["items"];

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _collapse = !_collapse;
          }),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  data["title"],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
                Icon(_collapse
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: _collapse
                      ? Theme.of(context).bottomAppBarColor
                      : Colors.transparent)),
          //  (data["items"].length)>10?400:(data["items"].length)90.0
          duration: Duration(milliseconds: 500),
          margin: EdgeInsets.all(3),
          width: _MatiralState.width,

          height: _collapse
              ? (data["items"].length) > 10
                  ? 500
                  : (data["items"].length) * 85.0
              : 0,

          child: ListView.builder(
              itemCount: data["items"].length,
              itemBuilder: (context, index2) {
                if (data["items"][index2].keys.toList().first == "text") {
                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        data["items"][index2]["text"],
                        style: Theme.of(context).textTheme.headline6,
                      ));
                } else if (data["items"][index2].keys.toList().first ==
                    "image") {
                  return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Image.asset(
                          'images/${data["items"][index2]["image"]}'));
                } else if (data["items"][index2].keys.toList().first ==
                    "title") {
                  return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        data["items"][index2]["title"],
                        style: Theme.of(context).textTheme.headline3,
                      ));
                } else if (data["items"][index2].keys.toList().first ==
                    "note") {
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        data["items"][index2]["note"],
                        style: Theme.of(context).textTheme.headline3,
                      ));
                } else
                  return Text("data");

                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Text(data["items"][index2]["text"]),
                    margin: EdgeInsets.all(16),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

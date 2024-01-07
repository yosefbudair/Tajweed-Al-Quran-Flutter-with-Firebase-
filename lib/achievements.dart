import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tajweed/drawer.dart';

import 'appbar.dart';
import 'matiral.dart';

class achievements extends StatefulWidget {
  const achievements({super.key});

  @override
  State<achievements> createState() => _achievementsState();
}


class _achievementsState extends State<achievements> {
  bool _collapse = false;

  String? emailu = FirebaseAuth.instance.currentUser?.email;

  String? imageurl = FirebaseAuth.instance.currentUser?.photoURL == null
      ? ""
      : FirebaseAuth.instance.currentUser?.photoURL;

  String? username = FirebaseAuth.instance.currentUser?.displayName;

  List arr = [
    'الفصل الاول',
    'الفصل الثاني',
    'الفصل الثالث',
    'الفصل الرابع',
    'الفصل الخامس',
    'التقويم الشامل'
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        endDrawer: drawer(),
        appBar: AppBarScreen(title: "الإنجازات"),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: 200,
                        color: Colors.transparent,
                      ),
                      Container(
                        width: double.infinity,
                        height: 150,
                        child: Image.asset(
                          "images/Background.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Stack(
                          children: [
                            imageurl == ""
                                ? (CircleAvatar(
                                    maxRadius: 65,
                                    minRadius: 50,
                                    backgroundColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    child: Text(
                                      emailu![0].toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 35, color: Colors.white),
                                    ),
                                  ))
                                : (CircleAvatar(
                                    maxRadius: 65,
                                    minRadius: 50,
                                    backgroundImage: NetworkImage(imageurl!),
                                  )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(username!,
                        style: Theme.of(context).textTheme.headline4),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      achievementsgrid(a: arr),
                      Card(
                        color: Theme.of(context).primaryColor,
                        child: GestureDetector(
                          onTap: null,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "الدورة المتوسطة",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                                Icon(Icons.lock)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: Theme.of(context).primaryColor,
                        child: GestureDetector(
                          onTap: null,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "الدورة المتقدمة",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                                Icon(Icons.lock),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class achievementsgrid extends StatefulWidget {
  List a;
  achievementsgrid({Key? key, required this.a}) : super(key: key);

  @override
  _GridMenuState createState() => _GridMenuState(
        a,
      );
}

class _GridMenuState extends State<achievementsgrid> {
  bool _collapse = false;
  List a;
  _GridMenuState(this.a);

  Map map = {};

  List arr = [
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
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    // List datas=data["items"];

    return Column(
      children: [
        Card(
          color: Theme.of(context).primaryColor,
          child: GestureDetector(
            onTap: () => setState(() {
              _collapse = !_collapse;
            }),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    "الدورة التمهيدية",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
                  Icon(_collapse
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ),
        AnimatedContainer(
            padding: EdgeInsets.all(1),
            duration: Duration(milliseconds: 600),
            margin: EdgeInsets.all(3),
            height: _collapse ? (a.length) * 70.0 : 0,
            child: Card(
              color: Theme.of(context).primaryColor,
              //card
              child: ListView.builder(
                itemCount: a.length,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                      padding: EdgeInsets.only(bottom: 20, top: 20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 216, 216, 216)))),
                      duration: Duration(milliseconds: 500),
                      child: ListTile(
                        leading: Container(
                          width: 130,
                          child: Card(
                            color: Theme.of(context).backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "${a[index]}",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        subtitle: isload
                            ? Text(
                                maxLines: 1,
                                a[index] != 'التقويم الشامل'
                                    ? "${map[a[index]]['علامة الامتحان']}\\5"
                                    : "${map[a[index]]['علامة الامتحان']}\\25",
                                style: TextStyle(
                                    color: a[index] != 'التقويم الشامل'
                                        ? map[a[index]]['علامة الامتحان'] >= 3
                                            ? Colors.green
                                            : Colors.red
                                        : map[a[index]]['علامة الامتحان'] >= 13
                                            ? Colors.green
                                            : Colors.red))
                            : SpinKitCircle(
                                size: 15,
                                color: Colors.green,
                              ),
                        title: Text(
                          "علامة الامتحان",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        trailing: Container(
                            width: 100,
                            child: isload
                                ? GFProgressBar(
                                    // leading: Text("\n\n"),
                                    // ignore: sort_child_properties_last
                                    child: Text(
                                        "${((map[arr[index]]['counter'] / (map[arr[index]].length - 2)) * 100).toStringAsFixed(1)}%"),
                                    type: GFProgressType.circular,
                                    radius: 60,
                                    lineHeight: 10,
                                    percentage: map[arr[index]]['counter'] /
                                        (map[arr[index]].length - 2),
                                    backgroundColor:
                                        Color.fromARGB(255, 136, 133, 133),
                                    progressBarColor: Colors.green,
                                  )
                                : SpinKitCircle(
                                    size: 15,
                                    color: Colors.green,
                                  )),
                      ));
                },
              ),
            )),
      ],
    );
  }
}

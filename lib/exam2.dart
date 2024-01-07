import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firstgrid.dart';

class exam2 extends StatefulWidget {
  List x;
  String title;
  exam2({Key? key, required this.x, required this.title}) : super(key: key);

  @override
  State<exam2> createState() => _exam2State(x, title);
}

class _exam2State extends State<exam2> {
  List x;
  String title;
  _exam2State(this.x, this.title);

  bool _isEnabeld = true;
  late PageController _controller;
  int _questionNumber = 1;
  var mark = 0;
  int _qna = 0;

//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------

  updateMark(int num) async {
    var docu = await FirebaseFirestore.instance
        .collection("Users")
        .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email);
    docu.get().then((value) {
      value.docs.forEach((element) async {
        DocumentReference docs = FirebaseFirestore.instance
            .collection("Users")
            .doc(element.id.toString())
            .collection("Title")
            .doc(title);
        if (num == 0) {
          await docs.get().then((DocumentSnapshot da) async {
            await docs.update({'علامة الامتحان': da['علامة الامتحان'] + 1});
          });
        } else {
          await docs.get().then((DocumentSnapshot da) async {
            mark = da['علامة الامتحان'];
          });

          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(score: mark, len: x.length),
            ),
          );
        }
      });
    });
  }

//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------

  updateAnswer(index1, index2) async {
    var docu = await FirebaseFirestore.instance
        .collection("Users")
        .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email);

    docu.get().then((value) {
      value.docs.forEach((element) async {
        DocumentReference docs = FirebaseFirestore.instance
            .collection("Users")
            .doc(element.id.toString())
            .collection("Questions")
            .doc(title);

        await docs.update({'Q${index1 + 1}.UAnswer': index2});
      });
    });

    if (x.length - 1 == index1) {
      docu.get().then((value) {
        value.docs.forEach((element) async {
          DocumentReference docs = FirebaseFirestore.instance
              .collection("Users")
              .doc(element.id.toString())
              .collection("Title")
              .doc(title);

          await docs.update({'امتحان': 1});
          await docs.get().then((DocumentSnapshot da) async {
            await docs.update({'counter': da['counter'] + 1});
          });
        });
      });
    }
  }

  //----------------------------------------------------------------------------------
  //----------------------------------------------------------------------------------

  @override
  initState() {
    super.initState();
    if (x[0]["UAnswer"] != -1) {
      _isEnabeld = false;
    }
    _controller = PageController(initialPage: 0);
  }

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const SizedBox(height: 32),
            Text('سؤال  $_questionNumber \\ ${x.length}'),
            const Divider(thickness: 1, color: Colors.grey),
            Expanded(
                child: PageView.builder(
              controller: _controller,
              itemCount: x.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index1) {
                _isEnabeld = x[index1]["UAnswer"] == -1 ? true : false;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      x[index1]["Qusetion"],
                      style: const TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: ListView.builder(
                        itemCount: x[index1]["Answers"].length,
                        itemBuilder: (context, index2) {
                          return GestureDetector(
                            onTap: _isEnabeld
                                ? () {
                                    _isEnabeld = false;
                                    setState(() {
                                      if (index2 == x[index1]["RightAnswer"]) {
                                        updateMark(0);
                                      }
                                      updateAnswer(index1, index2);
                                      x[index1]["UAnswer"] = index2;
                                    });
                                  }
                                : null,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        x[index1]["Answers"][index2],
                                        softWrap: false,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    x[index1]["UAnswer"] !=
                                                x[index1]["RightAnswer"] &&
                                            index2 == x[index1]["UAnswer"]
                                        ? Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          )
                                        : index2 == x[index1]["RightAnswer"] &&
                                                x[index1]["UAnswer"] != -1
                                            ? Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            : SizedBox.shrink()
                                  ]),
                            ),
                          );
                        },
                      ),
                    ),
                    !_isEnabeld
                        ? ElevatedButton(
                            style: ButtonStyle(
                                // overlayColor:  MaterialStateProperty.all(Theme.of(context).primaryColor),
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).secondaryHeaderColor),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor)))),
                            onPressed: () async {
                              if (x[index1]["UAnswer"] != -1) {
                                _isEnabeld = false;
                              }

                              if (_questionNumber < x.length) {
                                _controller.nextPage(
                                  duration: const Duration(microseconds: 250),
                                  curve: Curves.easeInExpo,
                                );

                                setState(() {
                                  _questionNumber++;
                                  _isEnabeld = true;
                                });
                              } else {
                                await updateMark(1);
                              }
                            },
                            child: _questionNumber < x.length
                                ? Text("الصفحة التالية")
                                : Text("النتيجة"),
                          )
                        : const SizedBox.shrink()
                  ],
                );
              }),
            )),
          ]),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key, required this.score, required this.len})
      : super(key: key);
  final int score;
  final int len;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.bottomRight, children: [
        Center(child: Text("لقد حصلت على $score/${len}")),
        ElevatedButton(
            style: ButtonStyle(
                // overlayColor:  MaterialStateProperty.all(Theme.of(context).primaryColor),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).secondaryHeaderColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor)))),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => firstgrid()),
                (route) => false,
              );
            },
            child: Text("العودة الى القائمة الرئيسية"))
      ]),
    );
  }
}

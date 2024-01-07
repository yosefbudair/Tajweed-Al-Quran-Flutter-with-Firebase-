import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Questions {
  Questions();

  /*setQ() async {
    // this function use one time to create qustions by defult value you should set value

    CollectionReference coll =
        FirebaseFirestore.instance.collection("Questions");

    var arr = [
      'الفصل الاول',
      'الفصل الثاني',
      'الفصل الثالث',
      'الفصل الرابع',
      'الفصل الخامس'
    ];

    Map Da = {};
    for (int i = 1; i <= 10; i++) {
      String s = "Q$i";
      Da.addAll({
        s: {
          "Qusetion": "",
          "Answers": ["", "", "", ""],
          "RightAnswer": -1
        }
      });
    }

    for (int j = 0; j < 5; j++) {
      DocumentReference docs = coll.doc(arr[j]);
      for (int i = 1; i <= 10; i++) {
        String s = "Q$i";

        await docs.update({
          s: {
            "Qusetion": "",
            "Answers": ["", "", "", ""],
            "RightAnswer": -1
          }
        });
      }
    }
  }*/

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

  // ignore: non_constant_identifier_names
  UpdateQforC(String id) async {
    var arr = [
      'الفصل الاول',
      'الفصل الثاني',
      'الفصل الثالث',
      'الفصل الرابع',
      'الفصل الخامس'
    ];
    int f = 1;
    DocumentReference docf = FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("Questions")
        .doc("التقويم الشامل");

    for (int i = 0; i < 5; i++) {
      DocumentReference docs = FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .collection("Questions")
          .doc(arr[i]);

          

      var doce = FirebaseFirestore.instance.collection("Questions").doc(arr[i]);
      List num = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      var rng = Random();
      await doce.get().then((DocumentSnapshot ds) async {
        await docs.set({"Q1": ds["Q1"]});
        if (i == 0) {
          await docf.set({"Q1": ds["Q1"]});
        }
      });
      for (int j = 1; j <= 5; j++) {
        String qu = "Q$j";
        int index = rng.nextInt(num.length);
        String q = "Q${num[index]}";
        Map x;

        await doce.get().then((DocumentSnapshot ds) async {
          x = ds[q];

          await docs.update({qu: x});
        });

        num.remove(num[index]);
      }
      //------------------------------------------------------------------------------------
      //------------------------------------------------------------------------------------

      for (int t = 0; t < 5; t++) {
        String qu = "Q$f";
        f++;
        String q = "Q${num[t]}";
        Map x;

        await doce.get().then((DocumentSnapshot ds) async {
          x = ds[q];

          await docf.update({qu: x});
        });
      }
    }
  }

//--------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------

  SetTitle(String id) async {
    Map arr = {
      'الفصل الاول': [
        'تعريف التجويد',
        'تاريخ التأليف في التجويد',
        'حكم التجويد',
        'أدلة وجوب التجويد',
        'اللحن',
        'مراتب القراءة',
        'فضل تلاوة القرءان',
        'آداب التلاوة',
        'أركان القراءة',
        'التعريف برواية حفص عن عاصم',
        'امتحان',
        'counter'
      ],
      'الفصل الثاني': [
        'معنى الاستعاذة',
        'الصيغة المشهورة للاستعاذة',
        'حكم الاستعاذة',
        'الجهر والإسرار بالاستعاذة',
        'معنى البسملة',
        'حكم البسملة عند افتتاح القراءة',
        'أوجه الاستعاذة والبسملة',
        'امتحان',
        'counter'
      ],
      'الفصل الثالث': [
        'كيفية حدوث الأصوات',
        'مخارج الحروف',
        'المخارج الرئيسة للحروف',
        'ألقاب الحروف',
        'امتحان',
        'counter'
      ],
      'الفصل الرابع': [
        'تعريف الصفات',
        'الصفات ذات الأضداد',
        'الصفات التي لا ضد لها',
        'الصفات القوية والضعيفة',
        'امتحان',
        'counter'
      ],
      'الفصل الخامس': [
        'تعريف التفخيم والترقيق',
        'مراتب التفخيم',
        'الحروف المرققة تارة والمفخمة أخرى',
        'امتحان',
        'counter'
      ],
      'التقويم الشامل': ['امتحان', 'counter']
    };

    for (int i = 0; i < 6; i++) {
      DocumentReference docs = FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .collection("Title")
          .doc(arr.keys.elementAt(i));

      await docs.set({"علامة الامتحان": 0});

      for (int j = 0; j < arr[arr.keys.elementAt(i)].length; j++) {
        await docs.update({arr[arr.keys.elementAt(i)][j]: 0});
      }
    }
  }
}

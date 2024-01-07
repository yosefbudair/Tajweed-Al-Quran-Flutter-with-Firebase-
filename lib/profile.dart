import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tajweed/drawer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import 'appbar.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  TextEditingController? Username = new TextEditingController();
  TextEditingController? Password = new TextEditingController();
  TextEditingController? PasswordC = new TextEditingController();

  String? emailu = FirebaseAuth.instance.currentUser?.email;
  String? imageurl = FirebaseAuth.instance.currentUser?.photoURL == null
      ? ""
      : FirebaseAuth.instance.currentUser?.photoURL;

  String? username = FirebaseAuth.instance.currentUser?.displayName;
  //-------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------
  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    var docu = await FirebaseFirestore.instance
        .collection("Users")
        .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email);

    final storage = FirebaseStorage.instanceFor(
        bucket: "gs://tajweed-app-7b8f4.appspot.com");

    String x;
    if (image?.path != null) {
      x = image?.path ?? "";
    } else {
      x = image?.path ?? "";
    }

    if (x != "") {
      final storageRef = storage.ref().child(path.basename(x));

      await storageRef.putFile(File(x));
      storageRef.getDownloadURL().then((value) {
        setState(() {
          imageurl = value;
          FirebaseAuth.instance.currentUser?.updatePhotoURL(imageurl);

          docu.get().then((value) {
            value.docs.forEach((element) async {
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(element.id.toString())
                  .update({"ImagePath": imageurl});
            });
          });
        });
      });
    }
  }

  //-------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------

  UpdateUn(String? uname) async {
    var docu = await FirebaseFirestore.instance
        .collection("Users")
        .where("Email", isEqualTo: FirebaseAuth.instance.currentUser?.email);

    await FirebaseAuth.instance.currentUser?.updateDisplayName(uname);

    docu.get().then((value) {
      value.docs.forEach((element) async {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(element.id.toString())
            .update({"UserName": uname});
      });
    });
  }

  //-------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        endDrawer: drawer(),
        appBar: AppBarScreen(title: "الملف الشخصي"),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: double.infinity,
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
                          imageurl == ''
                              ? (CircleAvatar(
                                  maxRadius: 65,
                                  minRadius: 50,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    emailu![0].toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 35, color: Colors.green),
                                  ),
                                ))
                              : (CircleAvatar(
                                  maxRadius: 65,
                                  minRadius: 50,
                                  backgroundImage: NetworkImage(imageurl!),
                                )),
                          Positioned(
                            bottom: 0,
                            right: -20,
                            child: MaterialButton(
                              onPressed: () {
                                pickUploadImage();
                              },
                              color: Colors.green,
                              textColor: Colors.white,
                              child: Icon(Icons.add_photo_alternate,
                                  size: 24,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              padding: EdgeInsets.all(5),
                              shape: CircleBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 40,
                ),

                //text name:
                Container(
                  child: ListTile(
                    leading: Text(
                      "إسم المستخدم : ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    title: Text(
                      " $username ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    title: Text('الأسم المستخدم الجديد'),
                                    content: TextFormField(
                                      controller: Username,
                                      maxLength: 20,
                                      decoration: InputDecoration(
                                        hintText: "الأسم المستخدم",
                                        counterText: "",
                                        focusColor: Colors.black,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          child: Text('إلغاء'),
                                          onPressed: () =>
                                              {Navigator.pop(context)}),
                                      TextButton(
                                          child: Text('إحفظ'),
                                          onPressed: () async => {
                                                if (Username!.text != "")
                                                  {
                                                    await UpdateUn(Username!
                                                        .text
                                                        .toString()),
                                                    setState(() => {
                                                          username =
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.displayName
                                                        }),
                                                    Navigator.pop(context)
                                                  }
                                                else
                                                  {
                                                    AwesomeDialog(
                                                        context: context,
                                                        title: "Error",
                                                        customHeader: Icon(
                                                            Icons.info,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    249,
                                                                    185,
                                                                    36),
                                                            size: 100),
                                                        animType: AnimType
                                                            .bottomSlide,
                                                        body: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Text(
                                                                "يرجى ادخال إسم المستخدم")))
                                                      ..show()
                                                  }
                                              })
                                    ],
                                  ),
                                ));
                      },
                      icon: const Icon(
                        Icons.mode_edit_outlined,
                        size: 25,
                        color: Color.fromARGB(255, 115, 115, 115),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                ListTile(
                  leading: Text(
                    "البريد الإلكتروني :",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  title: Text(emailu!,
                      style:
                          TextStyle(fontSize: emailu!.length > 20 ? 12 : 18)),
                ),

                //row has area code and phone number
                SizedBox(
                  height: 10,
                ),

                ListTile(
                  leading: Text(
                    "تغيير كلمة المرور",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  title: Text('تغيير كلمة المرور'),
                                  content: Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: Password,
                                          obscureText: true,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                            hintText: 'كلمة المرور الجديدة',
                                            counterText: "",
                                            focusColor: Colors.black,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: PasswordC,
                                          obscureText: true,
                                          maxLength: 20,
                                          decoration: InputDecoration(
                                            hintText:
                                                'تأكيد كلمة المرور الجديدة',
                                            counterText: "",
                                            focusColor: Colors.black,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        child: Text('إلغاء'),
                                        onPressed: () =>
                                            {Navigator.pop(context)}),
                                    TextButton(
                                        child: Text('إحفظ'),
                                        onPressed: () async => {
                                              if (Password!.text != "" &&
                                                  PasswordC!.text != "")
                                                {
                                                  if (Password!.text ==
                                                      PasswordC!.text)
                                                    {
                                                      if (Password!
                                                              .text.length >=
                                                          6)
                                                        {
                                                          await FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              ?.updatePassword(
                                                                  Password!.text
                                                                      .toString()),
                                                          AwesomeDialog(
                                                              context: context,
                                                              dialogType:
                                                                  DialogType
                                                                      .success,
                                                              dialogBackgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              animType: AnimType
                                                                  .bottomSlide,
                                                              body: Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Text(
                                                                      "تم تفيير كلمة المرور")))
                                                            ..show().then((value) =>
                                                                Navigator.pop(
                                                                    context)),
                                                        }
                                                      else
                                                        {
                                                          AwesomeDialog(
                                                              context: context,
                                                              title: "Error",
                                                              customHeader: Icon(
                                                                  Icons.info,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          249,
                                                                          185,
                                                                          36),
                                                                  size: 100),
                                                              animType: AnimType
                                                                  .bottomSlide,
                                                              body: Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  child: Text(
                                                                      "كلمة المرور الجديدة ضعيفة")))
                                                            ..show()
                                                        }
                                                    }
                                                  else
                                                    {
                                                      AwesomeDialog(
                                                          context: context,
                                                          title: "Error",
                                                          customHeader: Icon(
                                                              Icons.info,
                                                              color:
                                                                  Color.fromARGB(
                                                                      255,
                                                                      249,
                                                                      185,
                                                                      36),
                                                              size: 100),
                                                          animType: AnimType
                                                              .bottomSlide,
                                                          body: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Text(
                                                                  "كلمة المرور و تأكيد كلمة المرور غير متشابهات")))
                                                        ..show()
                                                    }
                                                }
                                              else
                                                {
                                                  AwesomeDialog(
                                                      context: context,
                                                      title: "Error",
                                                      customHeader: Icon(
                                                          Icons.info,
                                                          color: Color.fromARGB(
                                                              255,
                                                              249,
                                                              185,
                                                              36),
                                                          size: 100),
                                                      animType:
                                                          AnimType.bottomSlide,
                                                      body: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Text(
                                                              "يرجى ادخال كلمة المرور الجديدة و تأكيد كلمة المرور الجديدة")))
                                                    ..show()
                                                }
                                            })
                                  ],
                                ),
                              ));
                    },
                    icon: const Icon(
                      Icons.key,
                      size: 25,
                      color: Color.fromARGB(255, 115, 115, 115),
                    ),
                  ),
                ),

                SizedBox(
                  height: 70,
                ),

                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("achi");
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Ink(
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
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Image.asset(
                                "images/achi1.png",
                                width: 30,
                                color: Colors.white,
                              ),
                            ),
                            Text('الإنجازات', style: TextStyle(fontSize: 23))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

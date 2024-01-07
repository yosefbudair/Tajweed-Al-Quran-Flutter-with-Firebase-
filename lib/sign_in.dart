import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tajweed/Load.dart';
import 'package:tajweed/QCreat.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class sign_in extends StatefulWidget {
  const sign_in({super.key});

  @override
  State<sign_in> createState() => sign_inState();
}

class sign_inState extends State<sign_in> {
  var email, pass;
  bool checkboxval = false;
  bool check = false;

  TextEditingController Email = new TextEditingController();
  TextEditingController Password = new TextEditingController();
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  late UserCredential credential;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);
  }

//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //------------------------------------------------------------------------------------------------------------------
  //------------------------------------------------------------------------------------------------------------------

  Sign_in() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();

      try {
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass);

        if (credential.user!.emailVerified == false) {
          final user = FirebaseAuth.instance.currentUser;

          AwesomeDialog(
              dialogType: DialogType.info,
              context: context,
              title: "Verfication",
              body: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "لقد ارسلنا إلى بريدك الإلكروني رابطا يجب عليك الضغط عليه لتحقق من هويتك",
                    textAlign: TextAlign.center,
                  )))
            ..show();

          await user?.sendEmailVerification();
        } else {
          await Navigator.of(context).pushReplacementNamed("Home");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
              dialogType: DialogType.info,
              context: context,
              title: "Verfication",
              body: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "هذا الحساب غير موجود",
                    textAlign: TextAlign.center,
                  )))
            ..show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
              dialogType: DialogType.info,
              context: context,
              title: "Verfication",
              body: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "كلمة المرور غير صحيحة",
                    textAlign: TextAlign.center,
                  )))
            ..show();
        }
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------
  //------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: SingleChildScrollView(
                child: Center(
              child: Form(
                key: formstate,
                child: Column(
                  children: [
                    //SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(alignment: Alignment.topRight, children: [
                        Image(image: AssetImage('images/png_logo_1.png')),
                        Container(
                          child: ElevatedButton(
                              onPressed: () async {
                                UserCredential credential = await FirebaseAuth
                                    .instance
                                    .signInAnonymously();
                                Navigator.of(context)
                                    .pushReplacementNamed("Home");
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  backgroundColor:
                                      Theme.of(context).secondaryHeaderColor),
                              child: Text('تخطي',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))),
                        )
                      ]),
                    ),
                    //logo image

                    //username

                    SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        child: TextFormField(
                          // style: TextStyle(fontSize: 20),
                          controller: Email,
                          onSaved: (val) {
                            email = val;
                          },
                          validator: (val) {
                            if (val == "") {
                              return "مطلوب";
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(val!)) {
                              return 'يرجى ادخال بريد إلكتروني صحيح';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            // prefixIcon: Icon(Icons.person , size: 50,color: Colors.black),
                            hintText: 'البريد الإلكتروني',
                            // hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    //password
                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        child: TextFormField(
                          obscureText: true,
                          controller: Password,
                          onSaved: (val) {
                            pass = val;
                          },
                          validator: (val) {
                            if (val == "") {
                              return "مطلوب";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            // prefixIcon: Icon(Icons.lock , size: 40,color: Colors.black),
                            hintText: 'كلمة المرور',
                            // hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    //rememberme and forgetpassword
                    SizedBox(height: 10),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: InkWell(
                                child: Text('نسيتُ المرور ؟',
                                    style: TextStyle(color: Colors.blue),
                                    textAlign: TextAlign.right),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed("ForgetPassword");
                                },
                              )),
                        ],
                      ),
                    ),

                    //sign_inbutton
                    SizedBox(height: 10),

                    Container(
                      child: ElevatedButton(
                          onPressed: (() async {
                            await Sign_in();
                          }),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).secondaryHeaderColor,
                              shape: StadiumBorder()),
                          child: Text('تسجيل دخول',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20))),
                    ),

                    //sign_in with

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 35),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 1,
                              width: 80,
                              color: Colors.grey,
                            ),
                            InkWell(
                                borderRadius: BorderRadius.circular(25.0),
                                onTap: () async {
                                  UserCredential credential =
                                      await signInWithGoogle();

                                  Navigator.of(context)
                                      .pushReplacementNamed("Home");
                                }, //onTap google icon
                                child: Image.asset(
                                  "images/googleicon.png",
                                  height: 45,
                                )),
                            Container(
                              height: 1,
                              width: 80,
                              color: Colors.grey,
                            ),
                          ]),
                    ),

                    SizedBox(height: 20),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "لا أمتلك حساب ؟  ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          InkWell(
                            onTap: (() {
                              Navigator.of(context).pushNamed("sign_up");
                            }), //onTap Go to Sign in
                            child: Text(
                              "إنشاء حساب",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ),

                    //skipbutton

                    SizedBox(height: 80),
                  ],
                ),
              ),
            ))));
  }
}

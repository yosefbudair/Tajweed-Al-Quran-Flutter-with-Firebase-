import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => ForgetPassword_State();
}

class ForgetPassword_State extends State<ForgetPassword> {
  final GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  TextEditingController email = new TextEditingController();

  RestPassword() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: email.text.trim());

        AwesomeDialog(
            dialogType: DialogType.info,
            context: context,
            title: "تغيير كلمة المرور",
            body: Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "لقد ارسلنا إلى بريدك الإلكروني رابطا يجب عليك الضغط عليه لتغيير كلمة المرور",
                  textAlign: TextAlign.center,
                ))).show();
        Timer(const Duration(seconds: 8),
            () => Navigator.of(context).pushReplacementNamed("sign_in"));
      } on FirebaseAuthException catch (e) {}
    }
  }

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
                  SizedBox(height: 20),

                  //back icon inkwell
                  Container(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      child: Icon(Icons.arrow_back, size: 50),
                      onTap: () {
                        Navigator.of(context).pushNamed("sign_in");
                      },
                    ),
                  ),

                  //text bold black forget password
                  SizedBox(height: 20),

                  Text(
                    "هل نسيت كلمة المرور ؟",
                    style: Theme.of(context).textTheme.headline4,
                  ),

                  //sad face icaon

                  Container(
                    child: Icon(
                      Icons.mood_bad_outlined,
                      size: 200,
                      color: Theme.of(context).bottomAppBarColor,
                    ),
                  ),

                  //text black and bold
                  Container(
                    child: Text(
                      "ادخل عنوان بريدك الإلكتروني",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),

                  Text(
                    "المرتبط بحسابك المنشأ على التطبيق",
                    style: Theme.of(context).textTheme.headline4,
                  ),

                  //text

                  SizedBox(height: 10),

                  Text(
                    "سوف نرسل إلى بريدك الالكتروني رابطاً",
                    style: TextStyle(
                        fontSize: 20,

                        // fontWeight: FontWeight.bold,

                        color: Colors.grey),
                  ),

                  Container(
                    child: Text(
                      "لتغيير كلمة المرور",
                      style: TextStyle(
                          fontSize: 20,

                          // fontWeight: FontWeight.bold,

                          color: Colors.grey),
                    ),
                  ),

                  //text field email
                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: email,
                        validator: (val) {
                          if (val == "") {
                            return "مطلوب";
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).bottomAppBarColor,
                            ),
                          ),
                          hintText: 'ادخل بريدك الإلكتروني',
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //button send

                  SizedBox(height: 40),

                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        await RestPassword();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).bottomAppBarColor,
                          shape: StadiumBorder()),
                      child: Wrap(
                        children: <Widget>[
                          Text('إرسال',
                              style: TextStyle(
                                  color: Theme.of(context).cardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ));
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  bool isChecked = false;
  var uname, email, password, cpassword;
  TextEditingController User_Name = new TextEditingController();
  TextEditingController Email = new TextEditingController();
  TextEditingController Password = new TextEditingController();
  TextEditingController Confirm_Password = new TextEditingController();
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  String service =
      'يرجى قراءة شروط وأحكام الاستخدام هذه بعناية قبل استخدام خدمات هذا التطبيق حيث أن باستخدامك أو زيارتك لهذا التطبيق فإنك تقر وتوافق على هذه الأحكام والشروط التي تسنها. ودخولك إليه ومشاركتك أو تحميل المواد منها يشير إلى موافقتك على الالتزام بتلك الأحكام والشروط ، ويتعين عليك حينها الإشارة إلى القبول والالتزام بتلك الشروط، وإذا لم توافق على أي من هذه الشروط فيرجى التوقف عن استخدام التطبيق فورا وحذفه من جميع الاجهزة التي تستخدمها للتعامل مع التطبيق. شروط الاستخدام: يسمح باستخدام هذا التطبيق لأغراض مشروعة وبطريقة لا تنتهك القانون أو أي من الحقوق أو القيود المفروضة على استخدام من قبل طرف ثالث. خصوصية المستخدم: يتم جمع المعلومات الشخصية الخاصة بالمستخدم عن طريق تسجيل الدخول حيث يتم استخدام هذه المعلومات لغايات رفع كفاءة التطبيق و تسهيل عملية التغذية الراجعة . ويجب العلم أننا لا نبيع أو نأجر بياناتك الشخصية للاخرين. تعطيل الحساب: يتم تعطيل الحساب وحذفه عند رغبة المستخدم بذلك وذلك من خلال التواصل معنا عبر البريد الإلكتروني. المزيد من التفاصيل : للحصول على المزيد من المعلومات تواصل معنا عن طريق : xtajweeedx@gmail.com';
  late UserCredential credential;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  Sign_Up() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();

      try {
        credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        FirebaseAuth.instance.currentUser!.updateDisplayName(uname);

        Navigator.of(context).pushNamed("sign_in");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
              dialogType: DialogType.info,
              context: context,
              title: "Error",
              body: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("كلمة المرور ضعيفة")))
            ..show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("هذا الحساب موجود بالفعل")))
            ..show();
        }
      } catch (e) {}
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
          child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Image.asset(
                    "images/png_logo_1.png",
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Form(
                      key: formstate,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: User_Name, //User_Name
                            textInputAction: TextInputAction.next,
                            maxLength: 20,
                            onSaved: (val) {
                              uname = val;
                            },
                            validator: (val) {
                              if (val == "") {
                                return "مطلوب";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "الأسم المستخدم",
                              focusColor: Colors.black,
                              counterText: "",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          TextFormField(
                            maxLength: 40,
                            controller: Email, //Email
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
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "البريد الألكتروني",
                              focusColor: Colors.black,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            child: TextFormField(
                              maxLength: 30,
                              controller: Password, //Password
                              obscureText: true,
                              onSaved: (val) {
                                password = val;
                              },
                              textInputAction: TextInputAction.next,
                              validator: (val) {
                                if (val == "") {
                                  return "مطلوب";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "كلمة المرور",
                                focusColor: Colors.black,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: TextFormField(
                              maxLength: 30,
                              onSaved: (val) {
                                cpassword = val;
                              },
                              obscureText: true,
                              validator: (text) {
                                if (text == "") {
                                  return "مطلوب";
                                }
                                if (Confirm_Password.text != Password.text) {
                                  return "The Password are not the same ";
                                }
                                return null;
                              },

                              controller: Confirm_Password, //Confirm_Password

                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "تأكيد كلمة المرور",
                                focusColor: Colors.black,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                                Text("أوافق على  "),
                                InkWell(
                                  child: Text(
                                    "الشروط و الأحكام",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: AlertDialog(
                                                title: Text('الشروط و الأحكام'),
                                                content: SingleChildScrollView(
                                                  child: Text(
                                                    service,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      child: Text('لقد فهمت'),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context))
                                                ],
                                              ),
                                            ));
                                    //Check box OnTap
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    disabledBackgroundColor: Colors.grey,
                                    backgroundColor:
                                        Theme.of(context).secondaryHeaderColor,
                                    shape: StadiumBorder(
                                        side: BorderSide(
                                            color: Colors.transparent))),
                                onPressed: isChecked
                                    ? (() async {
                                        await Sign_Up();
                                        //button on pressed  (Check Sign up and continue )
                                      })
                                    : null,
                                child: Text(
                                  "إنشاء حساب",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "أمتلك حساب بالفعل ؟",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                InkWell(
                                  onTap: (() {
                                    Navigator.of(context).pop();
                                  }), //onTap Go to Sign in
                                  child: Text(
                                    "تسجيل",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

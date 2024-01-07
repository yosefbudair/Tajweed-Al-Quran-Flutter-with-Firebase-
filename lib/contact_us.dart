import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tajweed/drawer.dart';

import 'appbar.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => ContactUs_State();
}

class ContactUs_State extends State<ContactUs> {
  final GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController message = new TextEditingController();
  TextEditingController subject = new TextEditingController();

  Future sendEmail() async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    const serviceId = "service_neq2siw";
    const templateId = "template_6lpebiw";
    const userId = "bjSmfeYb4hpviPGvp";
    String name = "${fname.text} ${lname.text}";

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost'
        },
        body: json.encode({
          "service_id": serviceId,
          "template_id": templateId,
          "user_id": userId,
          "template_params": {
            "name": name,
            "message": message.text,
            "user_email": email.text,
            "subject": subject.text
          }
        }));
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        endDrawer: drawer(),
        appBar: AppBarScreen(title: 'تواصل معنا'),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formstate,
              child: Column(
                children: [
                  //image logo

                  Image(
                    image: AssetImage('images/png_logo_1.png'),
                  ),

                  //text name:
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "الإسم",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  //row has textform field first and last name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                          child: TextFormField(
                        controller: fname,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'مطلوب';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          hintText: "الإسم الأول",
                          hintStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                          child: TextFormField(
                        controller: lname,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'مطلوب';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          hintText: "الإسم الأخير",
                          hintStyle: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),

                  //text Email:
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "البريد الإلكتروني",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )),
                  ),

                  //textformfield email

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: email,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'مطلوب';
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return 'يرجى ادخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        hintText: "example@example.com",
                        hintStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  //text phone number
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "الموضوع",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )),
                  ),

                  //textformfield email

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: subject,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'مطلوب';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        hintText: "ادخل الموضوع",
                        hintStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  //row has area code and phone number
                  SizedBox(
                    height: 10,
                  ),

                  //message:

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "الرسالة",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )),
                  ),

                  //large message text form

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: message,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'مطلوب';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(50),
                        hintText: "يرجى , ادخال الرسالة هنا",
                        hintStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  //submit button

                  SizedBox(height: 20),

                  Container(
                    child: ElevatedButton(
                        onPressed: () {
                          if (formstate.currentState!.validate()) {
                            sendEmail();
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                dialogBackgroundColor: Colors.transparent,
                                animType: AnimType.bottomSlide,
                                body: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                        'تم ارسال الرسالة بنجاح سيتم الرد على بريدك الإلكتروني')))
                              ..show().then((value) => Navigator.pop(context));
                          } else {}
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).secondaryHeaderColor,
                            shape: StadiumBorder()),
                        child: Text('إرسال',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

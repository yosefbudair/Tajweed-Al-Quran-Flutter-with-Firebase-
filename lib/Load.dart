import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loadpage extends StatefulWidget {
  const Loadpage({super.key});

  @override
  State<Loadpage> createState() => _LoadpageState();
}

class _LoadpageState extends State<Loadpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SpinKitCircle(
        size: 140,
        color: Colors.green,
      )),
    );
  }
}

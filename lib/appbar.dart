import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarScreen extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  String title;

  AppBarScreen({Key? key, required this.title})
      : preferredSize = const Size.fromHeight(56.0),
        super(key: key);
  late double width;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return AppBar(
        centerTitle: true,
        title: Container(
          child: Text(title, style: Theme.of(context).textTheme.headline4),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Theme.of(context).bottomAppBarColor),
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.green));
  }
}

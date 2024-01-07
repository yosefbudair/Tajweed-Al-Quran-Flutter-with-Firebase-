import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(
          caption: TextStyle(
            fontSize: 20,
            color: Colors.red,
          ),
          headline3: TextStyle(
              fontSize: 25, color: isDarkTheme ? Colors.white : Colors.black),
          bodyText1: TextStyle(
              fontSize: 15, color: isDarkTheme ? Colors.white : Colors.black),
          headline2: TextStyle(
              fontSize: 10, color: isDarkTheme ? Colors.white : Colors.black),
          //home title text
          headline4: TextStyle(
              fontSize: 20, color: isDarkTheme ? Colors.white : Colors.black),
          //drawer text
          headline1: TextStyle(
              fontSize: 17, color: isDarkTheme ? Colors.white : Colors.black),
          headline6: TextStyle(
              fontSize: 16, color: isDarkTheme ? Colors.white : Colors.black)),
      backgroundColor: isDarkTheme
          ? Color.fromARGB(255, 41, 40, 40)
          : Color.fromARGB(255, 245, 245, 245),
      secondaryHeaderColor: Colors.green,
      selectedRowColor:
          isDarkTheme ? Color.fromARGB(255, 85, 83, 83) : Colors.green,
      // primarySwatch: Colors.red,
      primaryColor:
          isDarkTheme ? Color.fromARGB(255, 85, 83, 83) : Colors.white,

      // indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      // buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),

      // hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),

      // highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      // hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      shadowColor: isDarkTheme ? Colors.white : Colors.black,
      // focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      // disabledColor: Colors.grey,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      // canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      bottomAppBarColor: isDarkTheme
          ? Color.fromARGB(255, 255, 255, 255)
          : Color.fromARGB(255, 43, 43, 43),
      // buttonTheme: Theme.of(context).buttonTheme.copyWith(
      //     colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor:
              isDarkTheme ? Colors.white : Color.fromARGB(255, 44, 44, 44)),
    );
  }
}

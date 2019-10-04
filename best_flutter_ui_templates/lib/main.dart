import 'dart:io';
import 'package:best_flutter_ui_templates/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:best_flutter_ui_templates/OpenWallet/home.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Screens/loader.dart';
import 'package:best_flutter_ui_templates/OpenWallet/Screens/newLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_progress_dialog/flutter_progress_dialog.dart';
void main() {
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(new MyApp()));
  // runApp(new MyApp());
}
class MyApp extends StatefulWidget{
  @override
  _appState createState() => new _appState();
}

class _appState extends State<MyApp> {
  int state = 1;//1=loader 2= login 3 = main
  _checkState() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    var ppk = prefs.getString("privateKey");
    if(ppk ==""||ppk==null){
      setState(() {
        state =2;
      });
    }
    else{
      setState(() {
        state =3;
      });
    }
  }
  @override
  void initState(){
    _checkState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return ProgressDialog(
      child: MaterialApp(
        title: 'Flutter UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.iOS,
        ),
        home:  state==1?whiteLoader():(state==2?newLogin():Home()),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

import 'package:flutter/material.dart';
import 'package:flutter_app/SplashPage.dart';
import 'package:flutter_app/test.dart';

void main() => runApp(new MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        accentColor: Color.fromARGB(255, 239, 96, 62),
      ),
      home:SplashPage(), //启动页
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vb_notice_reader/view/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'VB Notice Board',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.cyanAccent,
            elevation: 16,
            actionsIconTheme: IconThemeData(
              color: Colors.teal,
            ),
          ),
          cardTheme: CardTheme(
            color: Colors.cyanAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                24,
              ),
              side: BorderSide(
                style: BorderStyle.solid,
                color: Colors.white,
                width: 0.3,
              ),
            ),
            elevation: 10,
            margin: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 4,
              right: 4,
            ),
          ),
          dialogTheme: DialogTheme(
            elevation: 16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                36,
              ),
              side: BorderSide(
                style: BorderStyle.solid,
                color: Colors.tealAccent,
                width: 0.1,
              ),
            ),
          ),
        ),
        home: MyHome(),
      );
}

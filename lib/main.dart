import "package:agri_com/screens/landing_page.dart";
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(color: Colors.black),
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Color(0xFFFF1E00)),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF1E00)))),
          iconTheme: IconThemeData(color: Color(0xFFFF1E00)),
          accentColor: Color(0xFFFF1E00),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(primary: Colors.black))),
      home: LandingPage(),
    );
  }
}

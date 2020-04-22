/// @author Yao Miao
/// crete data: April 01 2020
/// version 3.0
/// the entrance of the app

import 'package:flutter/material.dart';
import 'signin_page.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Hyper Garage Sale',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInPage()
      //home: new BrowsePosts()
    );
  }

}



















import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
//import 'package:connectivity/connectivity.dart';

class CustomSplashScreen extends StatefulWidget {
  final int seconds;
  final dynamic home;
  final Widget errorSplash;
  final Widget loadingSplash;
  final Color backgroundColor;

  CustomSplashScreen(
      {@required this.backgroundColor,
      @required this.seconds,
      @required this.loadingSplash,
      @required this.home,
      @required this.errorSplash});

  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  @override
  void initState() {
    super.initState();

    initConnectivity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> initConnectivity() async {
    Timer(Duration(seconds: widget.seconds), () {
      if (widget.home is String) {
        return Navigator.of(context).pushReplacementNamed(widget.home);
      } else if (widget.home is Widget) {
        return Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => widget.home));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: widget.backgroundColor, body: widget.loadingSplash),
    );
  }
}

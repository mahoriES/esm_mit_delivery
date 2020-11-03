import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String message;
  EmptyView({this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/clipart.png',
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 50.toHeight,
          ),
          Text(
            message ?? " ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontFamily: "Avenir",
              fontStyle: FontStyle.normal,
              fontSize: 20.toFont,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

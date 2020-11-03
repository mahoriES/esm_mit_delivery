import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image.asset(
          'assets/images/indicator.gif',
          height: 75.toHeight,
          width: 75.toWidth,
        ),
      ),
    );
  }
}

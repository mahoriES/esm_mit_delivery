import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';

class ConfirmActionDialogue extends StatelessWidget {
  final String message;
  final Function onConfirm;
  final Function onCancel;

  ConfirmActionDialogue({
    @required this.message,
    @required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.toWidth,
          vertical: 20.toHeight,
        ),
        margin: EdgeInsets.symmetric(horizontal: 50.toWidth),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              message ?? '',
              style: TextStyle(
                fontSize: 12.toFont,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40.toHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onCancel != null) onCancel();
                  },
                  color: Theme.of(context).errorColor,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  color: AppColors.icColors,
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

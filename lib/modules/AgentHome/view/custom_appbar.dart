import 'package:easy_localization/easy_localization.dart';
import 'package:esamudaayapp/utilities/colors.dart';
import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  final String name;
  final Function onEdit;
  CustomAppbar({
    this.name,
    this.onEdit,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarColor,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.toWidth),
          child: InkWell(
            onTap: onEdit,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 18.toFont,
                ),
                SizedBox(width: 5.toWidth),
                Text(
                  tr("screen_account.Edit"),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: "CircularStd-Book",
                    fontStyle: FontStyle.normal,
                    fontSize: 15.toFont,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size(
          double.infinity,
          (150.toHeight - AppBar().preferredSize.height),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.toHeight),
            Container(
              width: 50.toHeight,
              height: 50.toHeight,
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 30.toFont,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16.toHeight),
              child: Text(
                name ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 16.toFont,
                ),
              ),
            ),
            SizedBox(height: 20.toHeight),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 150.toHeight);
}

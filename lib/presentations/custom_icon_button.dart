import 'package:esamudaayapp/themes/custom_theme.dart';
import 'package:esamudaayapp/utilities/sizeconfig.dart';
import 'package:flutter/material.dart';

// A custom icon button which contains an icon and some text in a row.
// color and onTap values should be passed accordingly.
// If not passed , color = CustomTheme.of(context).colors.textColor

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  final Color color;
  const CustomIconButton({
    @required this.icon,
    @required this.text,
    @required this.onTap,
    this.color,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 20.toHeight,
                horizontal: 4.toWidth,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Icon(
                      icon,
                      color: color ?? CustomTheme.of(context).colors.textColor,
                    ),
                  ),
                  SizedBox(width: 8.toWidth),
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        text,
                        style: CustomTheme.of(context)
                            .textStyles
                            .sectionHeading2
                            .copyWith(
                                color: color ??
                                    CustomTheme.of(context).colors.textColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

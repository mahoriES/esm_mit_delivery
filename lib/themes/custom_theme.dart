import 'package:flutter/material.dart';

part 'package:esamudaayapp/themes/theme_constants.dart';
part 'package:esamudaayapp/themes/theme_data.dart';

// For now, we are using the theme data from consumer app only.
// Later we will modify this as per the requirement.

/*

To Create a new Theme =>

  1.  Add a new Value in enum THEME_TYPES. e.g. enum THEME_TYPES { LIGHT , DARK }

  2.  Create a new color class extending AppThemeColors. e.g. DarkThemeColors
  class DarkThemeColors with AppThemeColors {
    @override
    Color get primaryColor => const Color()
    ....
    @override
    Brightness get brightness => Brightness.dark;
  }


To update theme =>
  CustomTheme.instanceOf(buildContext).changeTheme(key);

To access theme data =>

  for colors and text styles :
  color : CustomTheme.of(context).colors.primaryColor;
  style : CustomTheme.of(context).textStyles.headline6;
  otherwise
  appBarTheme : Theme.of(context).appBarTheme.

*/

class _CustomThemeInheritedWidget extends InheritedWidget {
  final _CustomThemeState data;

  _CustomThemeInheritedWidget({
    this.data,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomThemeInheritedWidget oldWidget) {
    return true;
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final THEME_TYPES initialThemeType;

  const CustomTheme({
    Key key,
    this.initialThemeType,
    @required this.child,
  }) : super(key: key);

  @override
  _CustomThemeState createState() => new _CustomThemeState();

  // method to access the theme data
  static _CustomThemeData of(BuildContext context) {
    _CustomThemeInheritedWidget inherited = (context
        .dependOnInheritedWidgetOfExactType<_CustomThemeInheritedWidget>());
    return inherited.data.theme;
  }

  // method to update the theme data
  static _CustomThemeState instanceOf(BuildContext context) {
    _CustomThemeInheritedWidget inherited = (context
        .dependOnInheritedWidgetOfExactType<_CustomThemeInheritedWidget>());
    return inherited.data;
  }
}

class _CustomThemeState extends State<CustomTheme> {
  _CustomThemeData _theme;
  _CustomThemeData get theme => _theme;

  @override
  void initState() {
    _theme = _CustomThemeData(widget.initialThemeType);
    super.initState();
  }

  void changeTheme(THEME_TYPES themeType) {
    setState(() {
      _theme = _CustomThemeData(themeType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _CustomThemeInheritedWidget(
      data: this,
      child: widget.child,
    );
  }
}

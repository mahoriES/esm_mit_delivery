part of 'package:esamudaayapp/themes/custom_theme.dart';

// Add a new value here for each new theme.
enum THEME_TYPES { LIGHT }

class _CustomThemeData {
  // Creating custom colorScheme and textTheme
  // so that , we can use more meaningful names for colors and textstyles defined in theme data.
  // also we can avoid overriding the old screen's style variables while using dynamic values for new screens.
  _AppThemeColors colors;
  _AppTextStyles textStyles;
  ThemeData themeData;

  _CustomThemeData(THEME_TYPES themeTypes) {
    // for now there is only one theme that's why passed the LightThemeColors direclty.
    // otherwise check the themeTypes and pass the AppThemeColors accordingly.
    colors = _LightThemeColors();

    // pass the above color in AppTextStyles to get respective textTheme.
    textStyles = _AppTextStyles(colors);

    // defining text theme so that some styles can be defined globally . e.g. appBarTheme, cardTheme etc.
    themeData = ThemeData(
      brightness: colors.brightness,
      scaffoldBackgroundColor: colors.backgroundColor,
      primaryColor: colors.primaryColor,
      appBarTheme: AppBarTheme(
        color: colors.backgroundColor,
        iconTheme: IconThemeData(
          color: colors.primaryColor,
        ),
      ),
    );
  }
}

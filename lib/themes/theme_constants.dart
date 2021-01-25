part of 'package:esamudaayapp/themes/custom_theme.dart';

// class contains all the colors needed throughout the app.
// add more colors here if needed and also override new colors in extended classes.

abstract class _AppThemeColors {
  Color get primaryColor;
  Color get secondaryColor;
  Color get placeHolderColor;
  Color get backgroundColor;
  Color get positiveColor;
  Color get textColor;
  Color get textColorDarker;
  Color get disabledAreaColor;
  Color get warningColor;
  Color get shadowColor;
  Color get storeCoreColor;
  Color get shadowColor16;
  Color get categoryTileTextUnderlay;
  Color get dividerColor;
  Color get storeInfoColor;
  Brightness get brightness;
}

// define all the font families used throughout the app.
class _AppFontFamily {
  static const String archivo = "Archivo";
  //static const String avenir = "Avenir";
  static const String lato = "Lato";
}

// text styles should be similar in all themes except the text color.
// pass significant AppThemeColors to get respective text styles.

///Removed the [.toFont] method calls. They were leading to different sizes for my
///devices. Compared to other elements, fonts were smaller and weren't coming out well.
///If this still leads to noticeable issues on devices, then we'll find an optimum solution

class _AppTextStyles {
  final _AppThemeColors themeColors;
  _AppTextStyles(this.themeColors);

  TextStyle get merchantCardTitle => TextStyle(
        color: themeColors.primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        fontFamily: _AppFontFamily.archivo,
      );

  TextStyle get topTileTitle => TextStyle(
        color: themeColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        fontFamily: _AppFontFamily.archivo,
        height: 1.1,
      );

  TextStyle get sectionHeading1 => TextStyle(
        color: themeColors.primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: _AppFontFamily.archivo,
      );

  TextStyle get sectionHeading1Regular => sectionHeading1.copyWith(
        color: themeColors.textColor,
        fontWeight: FontWeight.w400,
      );

  TextStyle get sectionHeading2 => TextStyle(
        color: themeColors.textColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: _AppFontFamily.lato,
        height: 1.18,
      );

  TextStyle get sectionHeading2Secondary => sectionHeading2.copyWith(
        color: themeColors.secondaryColor,
      );

  TextStyle get sectionHeading2Primary =>
      sectionHeading2.copyWith(color: themeColors.primaryColor);

  TextStyle get sectionHeading3 => TextStyle(
        color: themeColors.backgroundColor,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: _AppFontFamily.lato,
        height: 1.2,
      );

  TextStyle get cardTitle => TextStyle(
        color: themeColors.textColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: _AppFontFamily.lato,
        height: 1.21,
      );

  TextStyle get cardTitleFaded => cardTitle.copyWith(
        color: themeColors.disabledAreaColor,
      );

  TextStyle get cardTitleSecondary => cardTitle.copyWith(
        color: themeColors.secondaryColor,
      );

  TextStyle get cardTitlePrimary => cardTitle.copyWith(
        color: themeColors.primaryColor,
      );

  TextStyle get body1 => TextStyle(
        color: themeColors.textColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: _AppFontFamily.lato,
        height: 1.25,
      );

  TextStyle get body1Faded => body1.copyWith(
        color: themeColors.disabledAreaColor,
      );

  TextStyle get body1FadedWithDottedUnderline => body1.copyWith(
        // As there is no option available to give space between underline and text,
        // this is a hack to add some space for the same.
        shadows: [
          Shadow(
            color: themeColors.disabledAreaColor,
            offset: Offset(0, -4),
          )
        ],
        color: Colors.transparent,
        decoration: TextDecoration.underline,
        decorationColor: themeColors.disabledAreaColor,
        decorationThickness: 2,
        decorationStyle: TextDecorationStyle.dashed,
      );
  TextStyle get buttonText2 => TextStyle(
        color: themeColors.primaryColor,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        fontFamily: _AppFontFamily.lato,
        height: 1.2,
      );

  TextStyle get body2 => TextStyle(
        color: themeColors.textColorDarker,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        fontFamily: _AppFontFamily.lato,
        height: 1.2,
      );

  TextStyle get body2Faded => body2.copyWith(
        color: themeColors.disabledAreaColor,
      );

  TextStyle get body2Secondary => body2.copyWith(
        color: themeColors.warningColor,
        fontWeight: FontWeight.bold,
      );

  TextStyle get body2BoldPrimary => body2.copyWith(
        color: themeColors.primaryColor,
        fontWeight: FontWeight.w600,
      );

  TextStyle get bottomMenu => TextStyle(
        color: themeColors.primaryColor,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        fontFamily: _AppFontFamily.lato,
        height: 1.2,
      );
}

// extension to get colors for light theme.
class _LightThemeColors with _AppThemeColors {
  @override
  Color get primaryColor => _brandViolet;
  @override
  Color get secondaryColor => _brandPink;
  @override
  Color get positiveColor => _positiveGreen;
  @override
  Color get textColor => _darkBlack;
  @override
  Color get textColorDarker => _pureBlack;
  @override
  Color get disabledAreaColor => _darkGrey;
  @override
  Color get placeHolderColor => _lightGrey;
  @override
  Color get backgroundColor => _pureWhite;
  @override
  Color get warningColor => _brandOrange;
  @override
  Color get storeCoreColor => _brandOrange;
  @override
  Color get shadowColor => const Color(0x0d242424);
  @override
  Color get dividerColor => const Color(0xFFe8e8e8);
  @override
  Color get storeInfoColor => const Color(0xffdd1d94);

  ///16 here refers to opacity which is 16%
  @override
  Color get shadowColor16 => const Color(0x29242424);

  Color get _brandViolet => const Color(0xFF5f3a9f);

  Color get _brandPink => const Color(0xFFe1517d);

  Color get _positiveGreen => const Color(0xFF2ac10f);

  Color get _darkBlack => const Color(0xFF363636);

  Color get _pureBlack => const Color(0xFF000000);

  Color get _darkGrey => const Color(0xFF969696);

  Color get _lightGrey => const Color(0xFFe4e4e4);

  Color get _pureWhite => const Color(0xFFFFFFFF);

  Color get _brandOrange => const Color(0xFFfb7452);

  @override
  Color get categoryTileTextUnderlay => const Color(0xffe6ffffff);

  @override
  Brightness get brightness => Brightness.light;
}

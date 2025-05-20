// lib/my_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  // --- LIGHT MODE COLORS ---
  static const Color lightPrimary = Color(0xFF6F4E37);
  static const Color lightSecondary = Color(0xFFA67F5B);
  static const Color lightTertiary = Color(0xFFD9B18C);
  static const Color lightAlternate = Color(0xFF4A3525);
  static const Color lightPrimaryText = Color(0xFF000000);
  static const Color lightSecondaryText = Color(0xFF666666);
  static const Color lightPrimaryBackground = Color(0xFFF6F2ED);
  static const Color lightSecondaryBackground = Color(0xFFEAE2DB);
  static const Color lightAccent1 = Color(0xFFFFB84D);
  static const Color lightAccent2 = Color(0xFFFFA6A5); // Revisar si es #ffa6ab5
  static const Color lightAccent3 = Color(0xFFFFB366);
  static const Color lightAccent4 = Color(0xFFFF8633);
  static const Color lightSuccess = Color(0xFF66CC66);
  static const Color lightError = Color(0xFFFF6666);
  static const Color lightWarning = Color(0xFFFFCC66);
  static const Color lightInfo = Color(0xFF66CCFF);

  // --- DARK MODE COLORS ---
  static const Color darkPrimary = Color(0xFF503A29);
  static const Color darkSecondary = Color(0xFF7D6F41);
  static const Color darkTertiary = Color(0xFFB09073);
  static const Color darkAlternate = Color(0xFF3A281D);
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFFCCCCCC);
  static const Color darkPrimaryBackground = Color(0xFF1A120D);
  static const Color darkSecondaryBackground = Color(0xFF201510);
  static const Color darkAccent1 = Color(0xFFFFAD33);
  static const Color darkAccent2 = Color(0xFFFFC7A5);
  static const Color darkAccent3 = Color(0xFFFF944D);
  static const Color darkAccent4 = Color(0xFFFF741A);
  static const Color darkSuccess = Color(0xFF55B355);
  static const Color darkError = Color(0xFFFF5555);
  static const Color darkWarning = Color(0xFFFFBE55);
  static const Color darkInfo = Color(0xFF59B3FF);

  // TextTheme helper
  static _TextTheme get textTheme => _TextTheme();
  static _TextTheme get darkTextTheme => _TextTheme(isDark: true);


  static ThemeData get lightThemeData {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: lightSecondaryBackground,
      colorScheme: ColorScheme.light(
        primary: lightPrimary,
        secondary: lightAccent2, 
        surface: lightSecondaryBackground,
        background: lightPrimaryBackground, 
        error: lightError,
        onPrimary: lightPrimaryText,                        
        onSecondary: lightPrimaryText, 
        onSurface: lightPrimaryText,   
        onBackground: lightPrimaryText,
        onError: Colors.white, 
        tertiary: lightTertiary,
        outline: lightSecondaryText, 
      ),
      textTheme: GoogleFonts.readexProTextTheme( 
        TextTheme(
          headlineMedium: textTheme.headlineMedium,
          titleSmall: textTheme.titleSmall,
          bodyMedium: textTheme.bodyMedium,
          labelLarge: textTheme.labelLarge,
        ).apply(bodyColor: lightPrimaryText, displayColor: lightPrimaryText), 
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightPrimary,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white), 
        titleTextStyle: textTheme.headlineMedium.copyWith(color: Colors.white), 
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white, 
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), 
          textStyle: textTheme.titleSmall.copyWith(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 3,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSecondaryBackground, 
        hintStyle: textTheme.labelLarge.copyWith(color: lightSecondaryText),
        labelStyle: textTheme.labelLarge.copyWith(color: lightPrimaryText), 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightAlternate, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightAlternate, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightPrimary, width: 2),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: lightPrimary,
        inactiveTrackColor: lightAlternate,
        thumbColor: lightPrimary,
        overlayColor: lightPrimary.withAlpha(20),
        valueIndicatorColor: lightPrimary,
        valueIndicatorTextStyle: TextStyle(color: Colors.white),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: lightSecondaryBackground,
        titleTextStyle: textTheme.headlineMedium.copyWith(color: lightPrimaryText),
        contentTextStyle: textTheme.bodyMedium.copyWith(color: lightPrimaryText),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightSecondaryBackground,
          hintStyle: textTheme.labelLarge.copyWith(color: lightSecondaryText),
        ),
        textStyle: textTheme.labelLarge.copyWith(color: lightPrimaryText), 
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(lightPrimaryBackground), 
        )
      ),
    );
  }

 static ThemeData get darkThemeData {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimary,
      scaffoldBackgroundColor: darkSecondaryBackground,
      colorScheme: ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkAccent2,
        surface: darkSecondaryBackground,
        background: darkPrimaryBackground,
        error: darkError,
        onPrimary: darkPrimaryText, 
        onSecondary: darkPrimaryText, 
        onSurface: darkPrimaryText,   
        onBackground: darkPrimaryText, 
        onError: darkPrimaryText, 
        tertiary: darkTertiary,
        outline: darkSecondaryText,
      ),
      textTheme: GoogleFonts.readexProTextTheme(
        TextTheme(
          headlineMedium: darkTextTheme.headlineMedium,
          titleSmall: darkTextTheme.titleSmall,
          bodyMedium: darkTextTheme.bodyMedium,
          labelLarge: darkTextTheme.labelLarge,
        ).apply(bodyColor: darkPrimaryText, displayColor: darkPrimaryText),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkPrimary,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkPrimaryText),
        titleTextStyle: darkTextTheme.headlineMedium.copyWith(color: darkPrimaryText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkPrimaryText,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: darkTextTheme.titleSmall.copyWith(color: darkPrimaryText),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 3,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSecondaryBackground,
        hintStyle: darkTextTheme.labelLarge.copyWith(color: darkSecondaryText),
        labelStyle: darkTextTheme.labelLarge.copyWith(color: darkPrimaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkAlternate, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkAlternate, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkPrimary, width: 2),
        ),
      ),
       sliderTheme: SliderThemeData(
        activeTrackColor: darkPrimary,
        inactiveTrackColor: darkAlternate,
        thumbColor: darkPrimary,
        overlayColor: darkPrimary.withAlpha(20),
        valueIndicatorColor: darkPrimary,
        valueIndicatorTextStyle: TextStyle(color: darkPrimaryText),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: darkSecondaryBackground,
        titleTextStyle: darkTextTheme.headlineMedium.copyWith(color: darkPrimaryText),
        contentTextStyle: darkTextTheme.bodyMedium.copyWith(color: darkPrimaryText),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkSecondaryBackground,
           hintStyle: darkTextTheme.labelLarge.copyWith(color: darkSecondaryText),
        ),
        textStyle: darkTextTheme.labelLarge.copyWith(color: darkPrimaryText),
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(darkPrimaryBackground),
        )
      ),
    );
  }
}


class _TextTheme {
  final bool isDark;
  _TextTheme({this.isDark = false});
  Color get _primaryTextColor => isDark ? MyTheme.darkPrimaryText : MyTheme.lightPrimaryText;
  Color get _secondaryTextColor => isDark ? MyTheme.darkSecondaryText : MyTheme.lightSecondaryText;
  Color get _alternateColor => isDark ? MyTheme.darkAlternate : MyTheme.lightAlternate;
  TextStyle get headlineMedium => GoogleFonts.outfit(
        color: _primaryTextColor,
        fontWeight: FontWeight.bold,
        fontSize: 28,
      );
  TextStyle get titleSmall => GoogleFonts.readexPro(
        color: _primaryTextColor,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      );
  TextStyle get bodyMedium => GoogleFonts.readexPro(
        color: _primaryTextColor,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
  TextStyle get labelLarge => GoogleFonts.readexPro(
        color: _primaryTextColor,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );

}
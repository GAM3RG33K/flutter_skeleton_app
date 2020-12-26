import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

// TODO: Add any theme related methods or helper properties here
// changing colors here will be reflected in the entire app

/// NOTE: Change made in here will only reflect if the whole app is rebuild. Use Flutter Hot-Restart for those changes

const Color _accentColor = Color(0xFF6D61F1);

const Color _backgroundColorLight = Color(0xFFFFFFFF);

const Color _cardColorLight = Color(0xFFF8F8FA);

const Color _textColorLight = Color(0xFF1D2226);

const Color _backgroundColorDark = Color(0xFF19172D);

const Color _cardColorDark = Color(0xFF201F2F);

const Color _textColorDark = Color(0xFFFFFFFF);

/// This class is utility class used for theme related properties and functions.
/// This class is responsible for providing theme to the Material app of this widget.
///
/// Any changes required in the app's theme should be done in this class.
class ThemeUtils {
  // TODO: change value of this flag to change app theme to dark
  /// Flag that is used to determine if the app is using the dark theme
  /// or light theme
  static bool isDarkTheme = false;

  // TODO: light theme data, any changes made here will be reflected in light theme of the app
  /// Light theme implementation
  static ThemeData _themeLight = ThemeData(
    brightness: Brightness.light,
    accentColor: _accentColor,
    canvasColor: _backgroundColorLight,
    hintColor: _cardColorLight,
    cardColor: _cardColorLight,
    fontFamily: 'SFProDisplay',
    textTheme: TextTheme(
      subtitle2: TextStyle(
        fontSize: 16.0,
      ),
      headline4: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
    ).apply(displayColor: _textColorLight, bodyColor: _textColorLight),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _cardColorLight,
      focusColor: _cardColorLight,
      border: buildOutlineInputBorder(color: _cardColorLight),
      focusedBorder: buildOutlineInputBorder(color: _cardColorLight),
      enabledBorder: buildOutlineInputBorder(color: _cardColorLight),
    ),
  );

  // TODO: dark theme data, any changes made here will be reflected in dark theme of the app
  /// Dark theme implementation
  static ThemeData _themeDark = ThemeData(
    brightness: Brightness.dark,
    accentColor: _accentColor,
    canvasColor: _backgroundColorDark,
    hintColor: _cardColorDark,
    cardColor: _cardColorDark,
    fontFamily: 'SF Pro Display',
    textTheme: TextTheme(
      subtitle2: TextStyle(
        fontSize: 16.0,
      ),
      headline4: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
    ).apply(displayColor: _textColorDark, bodyColor: _textColorDark),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _cardColorDark,
      focusColor: _cardColorDark,
      border: buildOutlineInputBorder(color: Colors.transparent),
      focusedBorder: buildOutlineInputBorder(color: Colors.transparent),
      enabledBorder: buildOutlineInputBorder(color: Colors.transparent),
    ),
  );

  // TODO: Input field related styles, changes made here, will reflect in all input fields in the app
  static OutlineInputBorder buildOutlineInputBorder({
    double width = 2.0,
    Color color = _accentColor,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: width,
        color: color,
      ),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  static BoxDecoration get boxDecoration {
    return BoxDecoration(
      color: ThemeUtils.cardColor,
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  static Brightness get brightness =>
      isDarkTheme ? Brightness.dark : Brightness.light;

  static ThemeData get theme => isDarkTheme ? _themeDark : _themeLight;

  static Color get backgroundColor =>
      isDarkTheme ? _backgroundColorDark : _backgroundColorLight;

  static Color get cardColor => isDarkTheme ? _cardColorDark : _cardColorLight;

  static Color get textColor => isDarkTheme ? _textColorDark : _textColorLight;

  static get accentColor => _accentColor;

  /// Method which trigger the theme change from/to Light and Dark themes in the app
  static switchTheme(BuildContext context) {
    isDarkTheme = !isDarkTheme;

    final dynamicThemeState = DynamicTheme.of(context);
    if (dynamicThemeState == null) return;
    dynamicThemeState.setThemeData(theme);

    // TODO: Add code here to execute after theme has changed
  }
}

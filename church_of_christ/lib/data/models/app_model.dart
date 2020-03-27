import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:church_of_christ/util/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Themes { light, dark, black, monokai, system }
enum ImageQuality { low, medium, high }


class AppModel with ChangeNotifier {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  // Light, dark & OLED themes
  static final List<ThemeData> _themes = [
    ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimaryColor,
      accentColor: lightAccentColor,
    ),
    ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      accentColor: darkAccentColor,
      canvasColor: darkCanvasColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkCardColor,
      dividerColor: darkDividerColor,
      dialogBackgroundColor: darkCardColor,
    ),
    ThemeData(
      brightness: Brightness.dark,
      primaryColor: blackPrimaryColor,
      accentColor: blackAccentColor,
      canvasColor: blackBackgroundColor,
      scaffoldBackgroundColor: blackBackgroundColor,
      cardColor: blackCardColor,
      dividerColor: blackDividerColor,
      dialogBackgroundColor: darkCardColor,
    ),
    ThemeData(
      accentColor: const Color(0xFF66D9EF),
      brightness: Brightness.dark,
      canvasColor: const Color(0xFF272822),
      cardColor: const Color(0xFF272822),
      cursorColor: const Color(0xFF66D9EF),
      errorColor: const Color(0xFF90274A),
      fontFamily: 'OpenSans',
      highlightColor: const Color(0xFFAE81FF),
      hintColor: const Color(0xFFAE81FF),
      indicatorColor: const Color(0xFFAE81FF),
      primaryColor: const Color(0xFFF92672),
      primaryColorBrightness: Brightness.dark,
      toggleableActiveColor: const Color(0xFF065CBE),
    )
  ];

  ImageQuality _imageQuality = ImageQuality.medium;

  get imageQuality => _imageQuality;

  set imageQuality(ImageQuality imageQuality) {
    _imageQuality = imageQuality;
    notifyListeners();
  }

  FlutterLocalNotificationsPlugin get notifications => _notifications;

  Themes _theme = Themes.light;

  ThemeData _themeData = _themes[1];

  get theme => _theme;

  set theme(Themes theme) {
    if (theme != null) {
      _theme = theme;
      themeData = theme;
      notifyListeners();
    }
  }

  get themeData => _themeData;

  set themeData(Themes theme) {
    if (theme != Themes.system) _themeData = _themes[theme.index];
    notifyListeners();
  }

  /// Returns the app's theme depending on the device's settings
  ThemeData requestTheme(Brightness fallback) => theme == Themes.system
      ? fallback == Brightness.dark ? _themes[1] : _themes[0]
      : themeData;

  /// Method that initializes the [AppModel] itself.
  Future init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Loads the theme
    try {
      theme = Themes.values[prefs.getInt('theme')];
    } catch (e) {
      await prefs.setInt('theme', 1);
    }

    // Loads image quality
    //for now disabled
    /*try {
      imageQuality = ImageQuality.values[prefs.getInt('quality')];
    } catch (e) {
      prefs.setInt('quality', 1);
    }*/

    // Inits notifications system
    /*notifications.initialize(InitializationSettings(
      AndroidInitializationSettings('notification_launch'),
      IOSInitializationSettings(),
    ));
    */
    notifyListeners();
  }

}
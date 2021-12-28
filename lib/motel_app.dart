import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:new_motel/common/common.dart';
import 'package:new_motel/constants/shared_preferences_keys.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/models/enum.dart';
import 'package:new_motel/modules/bottom_tab/bottom_tab_screen.dart';
import 'package:new_motel/modules/login/login_screen.dart';
import 'package:new_motel/modules/splash/introductionScreen.dart';
import 'package:new_motel/modules/splash/splashScreen.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/routes/routes.dart';
import 'package:provider/provider.dart';

BuildContext? applicationcontext;

class MotelApp extends StatefulWidget {

  final String initialRoute;
MotelApp({required this.initialRoute});
  @override
  _MotelAppState createState() => _MotelAppState();
}

class _MotelAppState extends State<MotelApp> {
  bool _isLoggedIn = false;


   isLogged() async {
    try {
      final  token = await SharedPreferencesKeys().getTokenData(key: 'token');
      if(token!=null){
        setState(() {
          _isLoggedIn = true;
        });
      }
    } catch (e) {
      _isLoggedIn=false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
isLogged();
super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Consumer<ThemeProvider>(
      builder: (_, provider, child) {
        final ThemeData _theme = provider.themeData;
        return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'), // English
            const Locale('fr'), //French
            const Locale('ja'), // Japanises
            const Locale('ar'), //Arebic
          ],
          navigatorKey: navigatorKey,
          title: 'Tawelty',
          debugShowCheckedModeBanner: false,
          theme: _theme,
          routes: _buildRoutes(),
          initialRoute: widget.initialRoute,
          builder: (BuildContext context,Widget? child) {
            _setFirstTimeSomeData(context, _theme);
              return Directionality(
                textDirection:
                context.read<ThemeProvider>().languageType == LanguageType.ar
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Builder(
                  builder: (BuildContext context) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor: MediaQuery.of(context).size.width > 360
                            ? 1.0
                            : MediaQuery.of(context).size.width >= 340
                            ? 0.9
                            : 0.8,
                      ),
                      child: child ?? SizedBox(),
                    );
                  },
                ),
              );
          },
        );
      },
    );
  }

// when this application open every time on that time we check and update some theme data
  void _setFirstTimeSomeData(BuildContext context, ThemeData theme) {
    applicationcontext = context;
    _setStatusBarNavigationBarTheme(theme);
    //we call some theme basic data set in app like color, font, theme mode, language
    context
        .read<ThemeProvider>()
        .checkAndSetThemeMode(MediaQuery.of(context).platformBrightness);
    context.read<ThemeProvider>().checkAndSetColorType();
    context.read<ThemeProvider>().checkAndSetFonType();
    context.read<ThemeProvider>().checkAndSetLanguage();
  }

  void _setStatusBarNavigationBarTheme(ThemeData themeData) {
    final brightness = !kIsWeb && Platform.isAndroid
        ? themeData.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light
        : themeData.brightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness,
      statusBarBrightness: brightness,
      systemNavigationBarColor: themeData.scaffoldBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: brightness,
    ));
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      RoutesName.Splash: (BuildContext context) => SplashScreen(),
      RoutesName.IntroductionScreen: (BuildContext context) =>
          IntroductionScreen(),
      RoutesName.Home: (BuildContext context) => BottomTabScreen(),
      RoutesName.Login: (BuildContext context) => LoginScreen(),
    };
  }


}

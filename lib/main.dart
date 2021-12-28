import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_motel/constants/shared_preferences_keys.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/motel_app.dart';
import 'package:new_motel/routes/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final  token = await SharedPreferencesKeys().getTokenData(key: 'token');
  await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(_setAllProviders(token)));
}



 Widget _setAllProviders(token) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(
          state: AppTheme.getThemeData,
        ),
      ),
    ],
    child: MotelApp(initialRoute: token!=null?RoutesName.Home:RoutesName.Splash,),
  );
}

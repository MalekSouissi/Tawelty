import 'package:flutter/material.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/models/enum.dart';
import 'package:new_motel/motel_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeys {
  setStringData({required String key, required String text}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, text);
  }

  setIntData({required String key, required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, id);
  }

  setTokenData({required String key, required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, token);
  }



//   _setBoolData({required String key, required bool text}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(key, text);
//   }

  Future<String?> getStringData({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<int?> getIntData({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
  Future<String?> getTokenData({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

   removeTokenData({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }



//   Future<bool?> _getBoolData({required String key}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(key);
//   }

  Future<ThemeModeType> getThemeMode() async {
    int? index = await getIntData(key: 'ThemeModeType');
    if (index != null) {
      return ThemeModeType.values[index];
    } else {
      return ThemeModeType.system;
    }
  }

  Future setThemeMode(ThemeModeType type) async {
    await setIntData(key: 'ThemeModeType', id: type.index);
  }

  Future<FontFamilyType> getFontType() async {
    int? index = await getIntData(key: 'FontType');
    if (index != null) {
      return FontFamilyType.values[index];
    } else {
      return FontFamilyType.WorkSans; // Default we set work span font
    }
  }

  Future setFontType(FontFamilyType type) async {
    await setIntData(key: 'FontType', id: type.index);
  }

  Future<ColorType> getColorType() async {
    int? index = await getIntData(key: 'ColorType');
    if (index != null) {
      return ColorType.values[index];
    } else {
      return ColorType.DarkBlue; // Default we set Verdigris
    }
  }

  Future setColorType(ColorType type) async {
    await setIntData(key: 'ColorType', id: type.index);
  }

  Future<LanguageType> getLanguageType() async {
    int? index = await getIntData(key: 'Languagetype');
    if (index != null) {
      return LanguageType.values[index];
    } else {
      if (applicationcontext != null) {
        LanguageType type = LanguageType.en;
        final Locale myLocale = Localizations.localeOf(applicationcontext!);
        if (myLocale.languageCode != '' && myLocale.languageCode.length == 2) {
          for (var item in LanguageType.values.toList()) {
            if (myLocale.languageCode == item.toString().split(".")[1]) {
              type = item;
            }
          }
        }
        return type;
      } else {
        return LanguageType.en; // Default we set english
      }
    }
  }

  Future setLanguageType(LanguageType language) async {
    await setIntData(key: 'Languagetype', id: language.index);
  }
}

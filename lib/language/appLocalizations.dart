import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_motel/common/common.dart' as common;
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/models/enum.dart';
import 'package:new_motel/motel_app.dart';
import 'package:provider/provider.dart';

class AppLocalizations {
  final BuildContext context;

  AppLocalizations(this.context);

  // call this method only firstTime when open app You can see splash_screen.dart
  static Future<void> init(BuildContext context) async {
    final List<Map<String, String>> allTexts = [];

    List<dynamic> jsonData = json.decode(
      await DefaultAssetBundle.of(context)
          .loadString('packages/new_motel/language/lang/language_text.json'),
    );

    jsonData.forEach((value) {
      if (value is Map && value['text_id'] != null) {
        Map<String, String> texts = {};
        texts['text_id'] = value['text_id'] ?? '';
        texts['en'] = value['en'] ?? '';
        texts['fr'] = value['fr'] ?? '';
        texts['ar'] = value['ar'] ?? '';
        texts['ja'] = value['ja'] ?? '';
        allTexts.add(texts);
      }
    });
    common.allTexts = allTexts;
  }

  String of(String textId) {
    LanguageType _languageType = applicationcontext == null
        ? LanguageType.en
        : applicationcontext!.read<ThemeProvider>().languageType;
    final Locale myLocale = Localizations.localeOf(context);
    if (myLocale.languageCode != '' && myLocale.languageCode.length == 2) {
      if (common.allTexts != null && common.allTexts!.isNotEmpty) {
        String newtext = '';
        final index = common.allTexts!
            .indexWhere((element) => element['text_id'] == textId);
        if (index != -1) {
          newtext = common.allTexts![index]
                  [_languageType.toString().split(".")[1]] ??
              '';
          if (newtext != '') return newtext;
        }
        return '#Text is Empty#';
      } else {
        return '#Language is Empty#';
      }
    } else {
      return '#LanguageCode Not Match#';
    }
  }
}

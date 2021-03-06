import 'package:flutter/material.dart';
import 'package:new_motel/constants/localfiles.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoadText = false;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        _loadAppLocalizations()); // call after first frame receiver so we have context
    super.initState();
  }

  Future<void> _loadAppLocalizations() async {
    try {
      //load all text json file to allLanguageTextData(in common file)
      await AppLocalizations.init(context);
      setState(() {
        isLoadText = true;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeProvider>(context);
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              foregroundDecoration: !appTheme.isLightMode
                  ? BoxDecoration(
                      color: Theme.of(context).backgroundColor.withOpacity(0.2))
                  : null,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(Localfiles.splashbg, fit: BoxFit.cover),
            ),
            Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
                Center(
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: Color(0xFFAF8F61),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(Localfiles.appIcon),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Divider(
                    thickness: 1,
                    endIndent: 125,
                    indent: 125,
                    color: AppTheme.whiteColor.withOpacity(0.5),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                AnimatedOpacity(
                  opacity: isLoadText ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 420),
                  child: Text(
                    AppLocalizations(context).of("best_hotel_deals"),
                    textAlign: TextAlign.left,
                    style: TextStyles(context).getRegularStyle().copyWith(),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(),
                ),
                AnimatedOpacity(
                  opacity: isLoadText ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 680),
                  child: CommonButton(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.only(
                        left: 100, right: 100, bottom: 8, top: 8),
                    buttonText: AppLocalizations(context).of("get_started"),

                    onTap: () {
                      NavigationServices(context).gotoIntroductionScreen();
                    },
                  ),
                ),
                AnimatedOpacity(
                  opacity: isLoadText ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 1200),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: 35 + MediaQuery.of(context).padding.bottom,
                        top: 16),
                    child: Text(
                      AppLocalizations(context).of("already_have_account"),
                      textAlign: TextAlign.left,
                      style: TextStyles(context).getDescriptionStyle().copyWith(
                            color: AppTheme.whiteColor,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

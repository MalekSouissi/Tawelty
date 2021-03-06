import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/home_screen/home_screen.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/modules/bottom_tab/components/tab_button_UI.dart';
import 'package:new_motel/modules/my_events/event_screen.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:provider/provider.dart';
import '../explore/home_explore.dart';
import '../myTrips/my_trips_screen.dart';
import '../profile/profile_screen.dart';

class BottomTabScreen extends StatefulWidget {
  @override
  _BottomTabScreenState createState() => _BottomTabScreenState();
}

class _BottomTabScreenState extends State<BottomTabScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isFirstTime = true;
  Widget _indexView = Container();
  BottomBarType bottomBarType = BottomBarType.Home;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _indexView = Container();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _startLoadScreen());
    super.initState();
  }

  Future _startLoadScreen() async {
    await Future.delayed(const Duration(milliseconds: 480));
    setState(() {
      _isFirstTime = false;
      _indexView = HomePage(animationController: _animationController,);
    });
    _animationController..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, provider, child) => Container(
        child: Scaffold(
          bottomNavigationBar: Container(
              height: 60 + MediaQuery.of(context).padding.bottom,
              child: getBottomBarUI(bottomBarType)),
          body: _isFirstTime
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : _indexView,
        ),
      ),
    );
  }

  void tabClick(BottomBarType tabType) {
    if (tabType != bottomBarType) {
      bottomBarType = tabType;
      _animationController.reverse().then((f) {
        if (tabType == BottomBarType.Home) {
          setState(() {
            _indexView = HomePage(animationController: _animationController,);
          });
        } else if (tabType == BottomBarType.Explore) {
          setState(() {
            _indexView = HomeExploreScreen(
              animationController: _animationController,
            );
          });
        } else if (tabType == BottomBarType.Trips) {
          setState(() {
            _indexView = MyTripsScreen(
              animationController: _animationController,
            );
          });
        }
        else if (tabType == BottomBarType.Share) {
          setState(() {
            _indexView = MyTripsScreen(
              animationController: _animationController,
            );
          });
        } else if (tabType == BottomBarType.Events) {
          setState(() {
            _indexView = MyEventsScreen(
              animationController: _animationController,
            );
          });
        } else if (tabType == BottomBarType.Profile) {

        } else if (tabType == BottomBarType.Gifts) {
          setState(() {
            _indexView = MyEventsScreen(
              animationController: _animationController,
            );
          });

        }
        else if (tabType == BottomBarType.Profile) {
          setState(() {
            _indexView = ProfileScreen();
          });
        }
      });
    }
  }

  Widget getBottomBarUI(BottomBarType tabType) {
    return CommonCard(
      color: AppTheme.backgroundColor,
      radius: 0,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              TabButtonUI(
                icon: Icons.home_max_outlined,
                isSelected: tabType == BottomBarType.Home,
                text: AppLocalizations(context).of("homescreen"),
                onTap: () {
                  tabClick(BottomBarType.Home);
                },
              ),
              TabButtonUI(
                icon: MdiIcons.homeOutline,
                isSelected: tabType == BottomBarType.Explore,
                text: AppLocalizations(context).of("explore"),
                onTap: () {
                  tabClick(BottomBarType.Explore);
                },
              ),
              TabButtonUI(
                icon: MdiIcons.shareVariantOutline,
                isSelected: tabType == BottomBarType.Share,
                text: AppLocalizations(context).of("Share"),
                onTap: () {
                  tabClick(BottomBarType.Explore);
                },
              ),

              TabButtonUI(
                icon: MdiIcons.calendarStar,
                isSelected: tabType == BottomBarType.Events,
                text: AppLocalizations(context).of("events"),
                onTap: () {
                  tabClick(BottomBarType.Events);
                },
              ),
              TabButtonUI(
                icon: MdiIcons.heartOutline,
                isSelected: tabType == BottomBarType.Trips,
                text: AppLocalizations(context).of("trips"),
                onTap: () {
                  tabClick(BottomBarType.Trips);
                },
              ),
              TabButtonUI(
                icon: MdiIcons.giftOutline,
                isSelected: tabType == BottomBarType.Gifts,
                text: AppLocalizations(context).of("Gifts"),
                onTap: () {
                  tabClick(BottomBarType.Trips);
                },
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }
}

enum BottomBarType { Home,Explore,Share, Events,Trips,Gifts, Profile }

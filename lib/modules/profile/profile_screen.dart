import 'package:flutter/material.dart';
import 'package:new_motel/constants/localfiles.dart';
import 'package:new_motel/constants/shared_preferences_keys.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/models/user.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/services/user.services.dart';
import 'package:new_motel/widgets/bottom_top_move_animation_view.dart';
import 'package:provider/provider.dart';
import '../../models/setting_list_data.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({Key? key,})
      : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin{
  List<SettingsListData> userSettingsList = SettingsListData.userSettingsList;
  String url='';
  String fname='';
  String lname='';
  String email='';
  bool show=false;
  UserServices userServices=UserServices();
  bool _isLoading= false;
  late var user;

  // fetchUser()async{
  //   fname=(await SharedPreferencesKeys().getStringData(key: 'fname'))!;
  //   lname=await SharedPreferencesKeys().getStringData(key: 'lname') as String;
  //   email=(await SharedPreferencesKeys().getStringData(key: 'email'))!;
  //   url= await SharedPreferencesKeys().getStringData(key: 'pdp') as String;
  //   setState(() {
  //     show=true;
  //   });
  //
  //
  //
  //
  //   setState(() {
  //     _isLoading=true;
  //   });
  //
  // }

  late AnimationController _animationController;

  fetchUserDetails()async{

    await SharedPreferencesKeys().getIntData(key: 'id').then((value) async {
      user = await userServices.getUserProfile(67.toString());

    });

    setState(() {
      _isLoading=true;
    });
  }


  @override
  void initState() {
   // fetchUser();
   // fetchUserDetails();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeProvider>(
        builder: (context, provider, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Container(child: appBar()),
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(0.0),
                itemCount: userSettingsList.length,
                itemBuilder: (context, index) {
                  return Material(
                    child: InkWell(
                      onTap: () async {
                        //setting screen view
                        if (index == 5) {
                          NavigationServices(context).gotoSettingsScreen();

                          //   setState(() {});
                        }
                        //help center screen view

                        if (index == 3) {
                          NavigationServices(context).gotoHeplCenterScreen();
                        }
                        //Chage password  screen view

                        if (index == 0) {
                          NavigationServices(context)
                              .gotoChangepasswordScreen();
                        }
                        //Invite friend  screen view

                        if (index == 1) {
                          NavigationServices(context).gotoInviteFriend();
                        }
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      AppLocalizations(context).of(
                                        userSettingsList[index].titleTxt,
                                      ),
                                      style: TextStyles(context)
                                          .getRegularStyle()
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Container(
                                    child: Icon(
                                        userSettingsList[index].iconData,
                                        color: AppTheme.secondaryTextColor
                                            .withOpacity(0.7)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Divider(
                              height: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return Material(
      child: InkWell(
        onTap: () {
          NavigationServices(context).gotoEditProfile(user);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations(context).of("amanda_text"),
                      style: new TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      AppLocalizations(context).of("view_edit"),
                      style: new TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 24, top: 16, bottom: 16, left: 24),
              child: Container(
                width: 70,
                height: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  child:show?Image.network(url,fit: BoxFit.cover,):Image.asset(Localfiles.userImage),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

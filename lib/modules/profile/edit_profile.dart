import 'package:flutter/material.dart';
import 'package:new_motel/constants/localfiles.dart';
import 'package:new_motel/constants/shared_preferences_keys.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/user.dart';
import 'package:new_motel/modules/profile/editProfileDialog.dart';
import 'package:new_motel/services/user.services.dart';
import 'package:new_motel/widgets/common_appbar_view.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:new_motel/widgets/remove_focuse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/setting_list_data.dart';

class EditProfile extends StatefulWidget {


  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var user;
  String url='';
  String fname='';
  String lname='';
  String email='';
  bool show=false;
String status='';
bool isInCall=false;
TextEditingController textEditingController=TextEditingController();
  fetchUser()async{
    fname=(await SharedPreferencesKeys().getStringData(key: 'fname'))!;
    lname=await SharedPreferencesKeys().getStringData(key: 'lname') as String;
    email=(await SharedPreferencesKeys().getStringData(key: 'email'))!;
    url= await SharedPreferencesKeys().getStringData(key: 'pdp') as String;
    setState(() {
      show=true;
    });
  }

  @override
  void initState() {
   // _getUserInfo();

 //  fetchUser();
    // TODO: implement initState
    super.initState();

  }

// getUserStatus(){
//   switch(status) {
//     case 0: {
//       // statements;
//      status= 'standard';
//     }
// break;
//     case 1: {
//       //statements;
//       status='silver';
//     }
//     break;
//     case 1: {
//       //statements;
//       status='gold';
//     }
//     break;
//
//     default: {
//       //statements;
//     }
//     break;
//
//   }
//   return status;
// }

  @override
  Widget build(BuildContext context) {
    List<SettingsListData> userInfoList = [
      SettingsListData(
        titleTxt: '',
        subTxt: "",
      ),
      SettingsListData(
        titleTxt: 'username_text',
        subTxt: "Amanda Jane",
      ),
      SettingsListData(
        titleTxt: 'mail_text',
        subTxt: "amanda@gmail.com",
      ),
      SettingsListData(
        titleTxt: 'phone',
        subTxt: "+65 1122334455",
      ),
      SettingsListData(
        titleTxt: 'date_of_birth',
        subTxt: "20, Aug, 1990",
      ),
      SettingsListData(
        titleTxt: 'address_text',
        subTxt: "123 Royal Street, New York",
      ),
      SettingsListData(
        titleTxt: 'status',
        subTxt: "123 Royal Street, New York",
      ),
    ];
    return Container(
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        body: RemoveFocuse(
          onClick: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CommonAppbarView(
                iconData: Icons.arrow_back,
                titleText: AppLocalizations(context).of("edit_profile"),
                onBackClick: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      bottom: 16 + MediaQuery.of(context).padding.bottom),
                  itemCount: userInfoList.length,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? getProfileUI()
                        : InkWell(
                            onTap: () {
_showEditDialog(userInfoList[index].subTxt, userInfoList[index].titleTxt, false);
                            },
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, bottom: 16, top: 16),
                                          child: Text(
                                            AppLocalizations(context).of(
                                                userInfoList[index].titleTxt),
                                            style: TextStyles(context)
                                                .getDescriptionStyle()
                                                .copyWith(
                                                  fontSize: 16,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16.0, bottom: 16, top: 16),
                                        child: Container(
                                          child: Text(
                                            userInfoList[index].subTxt,
                                            style: TextStyles(context)
                                                .getRegularStyle()
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16.0, bottom: 16, top: 16),
                                        child: Container(
                                          child: Icon(Icons.edit),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Divider(
                                    height: 1,
                                  ),
                                )
                              ],
                            ),
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getProfileUI() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 130,
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.of(context).dividerColor,
                        blurRadius: 8,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                    child: show?Image.network(url,fit: BoxFit.cover,):Image.asset(Localfiles.userImage),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: CommonCard(
                    color: AppTheme.primaryColor,
                    radius: 36,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).backgroundColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _showEditDialog(String hint, String oldtext, bool obscure) {
    return showDialog(
      context: context,
      builder: (ctx) =>
          EditProfileDialog(hint, oldtext, textEditingController, obscure, () {
            setState(() {
              isInCall = true;
            });

           // EditUserDetails();
          }
          ),
    );
  }

  EditUserDetails(key,user)async{

    await SharedPreferencesKeys().getIntData(key: 'id').then((value) async {
      user = await UserServices().updateUser(value.toString(),key,user);

    });

    setState(() {
      isInCall=true;
    });
  }

}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_motel/constants/shared_preferences_keys.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FacebookTwitterButtonView extends StatefulWidget {
  @override
  State<FacebookTwitterButtonView> createState() =>
      _FacebookTwitterButtonViewState();
}

class _FacebookTwitterButtonViewState extends State<FacebookTwitterButtonView> {
  bool isLoggedIn = false;
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _email;
  String? _imageUrl;
  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  Future<void> _updateLoginInfo() async {
    final plugin = FacebookLogin();
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String firstName = '';
    String lastName = '';
    String? email;
    String? imageUrl;

    if (token != null) {
      profile = await plugin.getUserProfile();
      firstName = profile!.firstName.toString();
      firstName = profile!.lastName.toString();
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 500);
      SharedPreferencesKeys().setTokenData(key: 'token', token: token.token);
      SharedPreferencesKeys().setStringData(key: 'fname', text: firstName);
      SharedPreferencesKeys().setStringData(key: 'lname', text: lastName);
      SharedPreferencesKeys()
          .setStringData(key: 'email', text: email.toString());
      SharedPreferencesKeys()
          .setStringData(key: 'pdp', text: imageUrl.toString());
      postData(token.token)
          .then((value) => NavigationServices(context).gotoTabScreen());
    }

    setState(() {
      _token = token;
      _profile = profile;
      _email = email;
      _imageUrl = imageUrl;
    });

    // print(_token);
    print(_profile);
    // print(_email);
    print(_imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return _fTButtonUI();
  }

  Widget _fTButtonUI() {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 30,
          ),
          Expanded(
              child: GestureDetector(
            onTap: (() => initiateFacebookLogin()),
            child: Container(
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0XFF4267B2),
                ),
                child: Icon(FontAwesomeIcons.facebookF,
                    size: 35, color: Colors.white)),
          )),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: GestureDetector(
                child: Container(
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0XFFdd4b39),
              ),
              child: Icon(FontAwesomeIcons.googlePlusG,
                  size: 35, color: Colors.white),
            )),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0XFF0077b5),
                ),
                child: Icon(FontAwesomeIcons.linkedinIn,
                    size: 35, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  Widget _buttonTextUI({required Icon icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        icon,
        SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
        ),
      ],
    );
  }

  void loginFacebook() async {
    final facebookLogin = FacebookAuth;
    const FACEBOOK_PERMISSIONS = ['public_profile', 'email'];
    final facebookLoginResult = await FacebookAuthPlatform.instance
        .login(permissions: FACEBOOK_PERMISSIONS)
        .then((value) async {
      print(value.accessToken!.token);
      final token = value.accessToken!.token;

      /// for profile details also use the below code
      final graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
      final profile = json.decode(graphResponse.body);
      print(profile);
      postData(value.accessToken!.token).then((value) async {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', value['token']);
        SharedPreferences localStorage1 = await SharedPreferences.getInstance();
        localStorage1.setInt(
            'id', json.decode(value['userData']['id'].toString()));
        print(value['userData']['id']);
        // Navigator.push(
        //     context,
        //     new MaterialPageRoute(
        //         builder: (context) => BottomTabScreen()));
      });
    });

    /*
    from profile you will get the below params
    {
     "name": "Iiro Krankka",
     "first_name": "Iiro",
     "last_name": "Krankka",
     "email": "iiro.krankka\u0040gmail.com",
     "id": "<user id here>"
    }
   */
  }

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancel:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.success:
        print("LoggedIn");
        onLoginStatusChanged(true);
        _updateLoginInfo();
        break;
    }
  }

  Future postData(token) async {
    var data = {
      'access_token': token,
    };
    final response = await http.post(
        Uri.parse('http://37.187.198.241:3000/oauth/facebook'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception('exception occured!!!!!!');
    }
  }
}

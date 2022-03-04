import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_motel/api/api.dart';
import 'package:new_motel/constants/shared_preferences_keys.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/modules/login/facebook_twitter_button_view.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/utils/validator.dart';
import 'package:new_motel/widgets/common_appbar_view.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:new_motel/widgets/common_intro_button_blue.dart';
import 'package:new_motel/widgets/common_text_field_view.dart';
import 'package:new_motel/widgets/remove_focuse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();
  String _errorPassword = '';
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String token = '';
  int userId = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              titleText: AppLocalizations(context).of("login"),
              onBackClick: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: FacebookTwitterButtonView(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 15),
                      child: Text(
                        AppLocalizations(context).of("log_with mail"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                    CommonTextFieldView(
                      controller: _emailController,
                      errorText: _errorEmail,
                      titleText: AppLocalizations(context).of("your_mail"),
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 16),
                      hintText:
                          AppLocalizations(context).of("enter_your_email"),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (String txt) {},
                    ),
                    CommonTextFieldView(
                      titleText: AppLocalizations(context).of("password"),
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      hintText: AppLocalizations(context).of("enter_password"),
                      isObscureText: true,
                      onChanged: (String txt) {},
                      errorText: _errorPassword,
                      controller: _passwordController,
                    ),
                    _forgotYourPasswordUI(),
                    CommonIntroButtonBlue(
                      padding:
                          EdgeInsets.only(left: 115, right: 115, bottom: 16),
                      buttonText: AppLocalizations(context).of("login"),
                      onTap: () {
                        if (_allValidation()) {
                          _login();
                          // NavigationServices(context).gotoTabScreen();
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _forgotYourPasswordUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 16, bottom: 15, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            onTap: () {
              NavigationServices(context).gotoForgotPassword();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations(context).of("forgot_your_Password"),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.redErrorColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'email': _emailController.text,
      'password': _passwordController.text,
      //'phone' : phoneController.text,
    };
    print(_emailController.text);
    print(_passwordController.text);

    var res = await CallApi().postData(data, 'users/login');
    // var body = json.decode(res.body);
    print(res.body);
    var body = jsonDecode(res.body.toString());
    print(body);
    //if(body['status']==200){
    if (body['token'] != null) {
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('token', body['token']);
      SharedPreferencesKeys().setTokenData(key: 'token', token: body['token']);
      token = body['token'];
      _getProfile();
      print(body);
      NavigationServices(context).gotoTabScreen();
    } else {
      print(body);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body.toString()),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  showError(msg) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Done'),
              content: Text(msg.toString()),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  void _getProfile() async {
    var res = await CallApi().getProfile('users/profile', token);
    var body = json.decode(res.body);
    SharedPreferences localStorage1 = await SharedPreferences.getInstance();
    localStorage1.setInt('id', json.decode(body['id'].toString()));
    SharedPreferencesKeys().setIntData(key: 'id', id: body['id']);
    print(body['id']);
    userId = body['id'];
    // username=body['username'];
    print(userId);
    // print(body);
  }

  bool _allValidation() {
    bool isValid = true;
    if (_emailController.text.trim().isEmpty) {
      _errorEmail = AppLocalizations(context).of('email_cannot_empty');
      isValid = false;
    } else if (!Validator.validateEmail(_emailController.text.trim())) {
      _errorEmail = AppLocalizations(context).of('enter_valid_email');
      isValid = false;
    } else {
      _errorEmail = '';
    }

    if (_passwordController.text.trim().isEmpty) {
      _errorPassword = AppLocalizations(context).of('password_cannot_empty');
      isValid = false;
    } else if (_passwordController.text.trim().length < 6) {
      _errorPassword = AppLocalizations(context).of('valid_password');
      isValid = false;
    } else {
      _errorPassword = '';
    }
    setState(() {});
    return isValid;
  }
}

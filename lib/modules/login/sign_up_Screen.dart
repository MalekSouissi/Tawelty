import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:new_motel/api/api.dart';
import 'package:new_motel/constants/shared_preferences_keys.dart';
import 'package:new_motel/constants/text_styles.dart';
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

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();
  String _errorPassword = '';
  TextEditingController _passwordController = TextEditingController();
  String _errorFName = '';
  TextEditingController _fnameController = TextEditingController();
  String _errorLName = '';
  TextEditingController _lnameController = TextEditingController();
  bool _isLoading = false;
  String token = '';
  int userId = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: RemoveFocuse(
          onClick: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _appBar(),
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
                        controller: _fnameController,
                        errorText: _errorFName,
                        padding: const EdgeInsets.only(
                            bottom: 16, left: 24, right: 24),
                        titleText: AppLocalizations(context).of("first_name"),
                        hintText:
                            AppLocalizations(context).of("enter_first_name"),
                        keyboardType: TextInputType.name,
                        onChanged: (String txt) {},
                      ),
                      CommonTextFieldView(
                        controller: _lnameController,
                        errorText: _errorLName,
                        padding: const EdgeInsets.only(
                            bottom: 16, left: 24, right: 24),
                        titleText: AppLocalizations(context).of("last_name"),
                        hintText:
                            AppLocalizations(context).of("enter_last_name"),
                        keyboardType: TextInputType.name,
                        onChanged: (String txt) {},
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
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 24),
                        hintText:
                            AppLocalizations(context).of('enter_password'),
                        isObscureText: true,
                        onChanged: (String txt) {},
                        errorText: _errorPassword,
                        controller: _passwordController,
                      ),
                      CommonIntroButtonBlue(
                        padding:
                            EdgeInsets.only(left: 110, right: 110, bottom: 8),
                        buttonText: AppLocalizations(context).of("sign_up"),
                        onTap: () {
                          if (_allValidation()) _handleLogin();
                          //NavigationServices(context).gotoTabScreen();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations(context).of("terms_agreed"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppLocalizations(context)
                                .of("already_have_account"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            onTap: () {
                              NavigationServices(context).gotoLoginScreen();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                AppLocalizations(context).of("login"),
                                style: TextStyles(context)
                                    .getRegularStyle()
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 24,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return CommonAppbarView(
      iconData: Icons.arrow_back,
      titleText: AppLocalizations(context).of("sign_up"),
      onBackClick: () {
        Navigator.pop(context);
      },
    );
  }

  bool _allValidation() {
    bool isValid = true;

    if (_fnameController.text.trim().isEmpty) {
      _errorFName = AppLocalizations(context).of('first_name_cannot_empty');
      isValid = false;
    } else {
      _errorFName = '';
    }

    if (_lnameController.text.trim().isEmpty) {
      _errorLName = AppLocalizations(context).of('last_name_cannot_empty');
      isValid = false;
    } else {
      _errorLName = '';
    }

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

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'first_name': _fnameController.text,
      'last_name': _lnameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      //'phone' : phoneController.text,
    };
    print(_fnameController.text);
    print(_emailController.text);
    print(_passwordController.text);

    var res = await CallApi().postData(data, 'users/register');
    var body = json.decode(res.body);
    print(body);
    if (body['token'] != null) {
      // SharedPreferences localStorage = await SharedPreferences.getInstance();
      // localStorage.setString('token', body['token']);
      SharedPreferencesKeys().setTokenData(key: 'token', token: body['token']);
      token = body['token'];
      _getProfile();
      print(body);
      NavigationServices(context).gotoTabScreen();
    } else {
      print(body['error']);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['error'].toString()),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      ));
    }

    //}

    setState(() {
      _isLoading = false;
    });
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
}

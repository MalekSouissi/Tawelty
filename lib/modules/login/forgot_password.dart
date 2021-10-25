import 'package:flutter/material.dart';
import 'package:new_motel/api/api.dart';
import 'package:new_motel/constants/helper.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/utils/validator.dart';
import 'package:new_motel/widgets/common_appbar_view.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:new_motel/widgets/common_text_field_view.dart';
import 'package:new_motel/widgets/remove_focuse.dart';

class ForgotPasswordScreen extends StatefulWidget with Helper {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();

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
              appBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, bottom: 16.0, left: 24, right: 24),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppLocalizations(context)
                                    .of("resend_email_link"),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CommonTextFieldView(
                        controller: _emailController,
                        titleText: AppLocalizations(context).of("your_mail"),
                        errorText: _errorEmail,
                        padding:
                            EdgeInsets.only(left: 24, right: 24, bottom: 24),
                        hintText:
                            AppLocalizations(context).of("enter_your_email"),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String txt) {},
                      ),
                      CommonButton(
                        padding:
                            EdgeInsets.only(left: 24, right: 24, bottom: 16),
                        buttonText: AppLocalizations(context).of("send"),
                        onTap: () {
                          if (_allValidation()){
                            _sendResetPasswordEmail();
                            //Navigator.pop(context);

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
      ),
    );
  }

  Widget appBar() {
    return CommonAppbarView(
      iconData: Icons.arrow_back,
      titleText: AppLocalizations(context).of("forgot_your_Password"),
      onBackClick: () {
        Navigator.pop(context);
      },
    );
  }

  _sendResetPasswordEmail() async {
    print(_emailController.text);
    // if (_formkey.currentState.validate()) {
    //   _formkey.currentState.save();
    await CallApi().forgetPassword(_emailController.text).then((value) {
      showSnackbarMessage(value['message'], value['ok'] ? true : false);
      _emailController.clear();
    });
    //}
  }

  showSnackbarMessage(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: CustomMessageDialog.instance.showMessageDialog(
          context: context, isSuccess: isSuccess, message: message),
      duration: Duration(milliseconds: Styles.instance.snackbarMessageDuration),
    ));
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
    setState(() {});
    return isValid;
  }
}

class CustomMessageDialog {
  static CustomMessageDialog _instance = CustomMessageDialog._initialize();
  static CustomMessageDialog get instance {
    if (_instance == null) _instance = CustomMessageDialog._initialize();
    return _instance;
  }

  Widget showMessageDialog(
      {required BuildContext context, required String message, required bool isSuccess}) {
    return Container(
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Icon(
              isSuccess ? Icons.done : Icons.error_outline,
              color: isSuccess
                  ? Styles.instance.successIconColor
                  : Styles.instance.errorIconColor,
              size: Styles.instance.messageDialogIconSize,
            ),
          ),
          const SizedBox(width: 15),
          Flexible(
            flex: 3,
            child: Text(
              message,
              style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  CustomMessageDialog._initialize();
}

class Styles {
  static Styles _instance = Styles._initialize();
  static Styles get instance {
    if (_instance == null) _instance = Styles._initialize();
    return _instance;
  }

  Styles._initialize();

  TextStyle defaultButtonTextStyle =
      TextStyle(fontSize: 18, color: Colors.white);
  TextStyle defaultTitleStyle =
      TextStyle(fontSize: 18, color: Colors.black, letterSpacing: 1.3);
  Color defaultPrefixIconColor = Colors.white;
  double defaultPrefixIconSize = 32.0;
  Color formPrefixIconColor = Colors.black;
  TextStyle snackbarTitleStyle =
      TextStyle(fontSize: 17, color: Colors.white, letterSpacing: 1.1);

  Color successIconColor = Colors.green;
  Color errorIconColor = Colors.red;
  double messageDialogIconSize = 24;
  int snackbarMessageDuration = 1300;
}

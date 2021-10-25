import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_motel/widgets/common_button.dart';

class FacebookTwitterButtonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _fTButtonUI();
  }

  Widget _fTButtonUI() {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 24,
          ),
          Expanded(
            child: CommonButton(
              padding: EdgeInsets.zero,
              backgroundColor: Color(0x0FF3C5799),
              buttonTextWidget: _buttonTextUI(icon:Icon(FontAwesomeIcons.facebookF ,
                  size: 20, color: Colors.white),text: "Facebook"),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: CommonButton(
              padding: EdgeInsets.zero,
              backgroundColor: Color(0x0FF0077b5 ),
              buttonTextWidget: _buttonTextUI(icon:Icon(FontAwesomeIcons.linkedinIn ,
                  size: 20, color: Colors.white),text: "Linkedin"),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: CommonButton(
              padding: EdgeInsets.zero,
              backgroundColor: Color(0x0FFdb3236 ),
              buttonTextWidget: _buttonTextUI(icon: Icon(FontAwesomeIcons.google,
                  size: 20, color: Colors.white),text: "Google"),
            ),
          ),
          SizedBox(
            width: 24,
          )
        ],
      ),
    );
  }

  Widget _buttonTextUI({required Icon icon,required String text}) {
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
}

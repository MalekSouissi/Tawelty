import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;


class SettingsListData {

  String id;
  String first_name;
  String last_name;
  String email;
  String password;

  String titleTxt;
  String subTxt;
  IconData iconData;
  bool isSelected;

  SettingsListData({
    this.titleTxt = '',
    this.isSelected = false,
    this.subTxt = '',
    this.iconData = Icons.supervised_user_circle,
    this.email = '',
    this.first_name = '',
    this.last_name = '',
    this.password = '',
    this.id = '',

  });

  factory SettingsListData.fromJson(Map<String, dynamic> item) {
    return SettingsListData(

      titleTxt: item['NomResto'],
      subTxt: 'adresse',
      isSelected: true,
      id: item['id'].toString(),
      // description: item['Description'],
      // userId: item['UserId'],
      // //etat: item['etat'],
      // //cuisine: item['cuisine'],
      // temps_ouverture: DateTime.parse(item['temps_ouverture']),
      // temps_fermeture: DateTime.parse(item['temps_fermeture']),
      // createdAt: DateTime.parse(item['createdAt']),
      // updatedAt:
      // item['updatedAt'] != null ? DateTime.parse(item['updatedAt']) : DateTime.parse(item['updatedAt']),
    );
  }

  static const API = 'http://37.187.198.241:3000/';
  static List<SettingsListData> UserProfil=[];

  GetUserProfil(String userId) async {
    final response = await http.get(
        Uri.parse(API + 'users/' + userId));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData;
      //return RestaurantListData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  List<SettingsListData> getCountryListFromJson(Map<String, dynamic> json) {
    List<SettingsListData> countryList = [];
    if (json['countryList'] != null) {
      json['countryList'].forEach((v) {
        SettingsListData data = SettingsListData();
        data.titleTxt = v["name"];
        data.subTxt = v["code"];
        countryList.add(data);
      });
    }
    return countryList;
  }

  static List<SettingsListData> userSettingsList = [
    SettingsListData(
      titleTxt: 'change_password',
      isSelected: false,
      iconData: FontAwesomeIcons.lock,
    ),
    SettingsListData(
      titleTxt: 'invite_friend',
      isSelected: false,
      iconData: FontAwesomeIcons.userFriends,
    ),
    SettingsListData(
      titleTxt: 'credit_coupons',
      isSelected: false,
      iconData: FontAwesomeIcons.gift,
    ),
    SettingsListData(
      titleTxt: 'help_center',
      isSelected: false,
      iconData: FontAwesomeIcons.infoCircle,
    ),
    SettingsListData(
      titleTxt: 'payment_text',
      isSelected: false,
      iconData: FontAwesomeIcons.wallet,
    ),
    SettingsListData(
      titleTxt: 'setting_text',
      isSelected: false,
      iconData: FontAwesomeIcons.cog,
    )
  ];
  static List<SettingsListData> settingsList = [
    SettingsListData(
      titleTxt: 'Notifications',
      isSelected: false,
      iconData: FontAwesomeIcons.solidBell,
    ),
    SettingsListData(
      titleTxt: 'Theme Mode',
      isSelected: false,
      iconData: FontAwesomeIcons.skyatlas,
    ),
    SettingsListData(
      titleTxt: 'Fonts',
      isSelected: false,
      iconData: FontAwesomeIcons.font,
    ),
    SettingsListData(
      titleTxt: 'Color',
      isSelected: false,
      iconData: Icons.color_lens,
    ),
    SettingsListData(
      titleTxt: 'Language',
      isSelected: false,
      iconData: Icons.translate_outlined,
    ),
    SettingsListData(
      titleTxt: 'Country',
      isSelected: false,
      iconData: FontAwesomeIcons.userFriends,
    ),
    SettingsListData(
      titleTxt: 'Currency',
      isSelected: false,
      iconData: FontAwesomeIcons.gift,
    ),
    SettingsListData(
      titleTxt: 'Terms of Services',
      isSelected: false,
      iconData: Icons.keyboard_arrow_right,
    ),
    SettingsListData(
      titleTxt: 'Privacy Policy',
      isSelected: false,
      iconData: Icons.keyboard_arrow_right,
    ),
    SettingsListData(
      titleTxt: 'Give Us Feedbacks',
      isSelected: false,
      iconData: Icons.keyboard_arrow_right,
    ),
    SettingsListData(
      titleTxt: 'Log out',
      isSelected: false,
      iconData: Icons.keyboard_arrow_right,
    )
  ];

  static List<SettingsListData> currencyList = [
    SettingsListData(
      titleTxt: 'Australia Dollar',
      subTxt: "\$ AUD",
    ),
    SettingsListData(
      titleTxt: 'Argentina Peso',
      subTxt: "\$ ARS",
    ),
    SettingsListData(
      titleTxt: 'Indian rupee',
      subTxt: "₹ Rupee",
    ),
    SettingsListData(
      titleTxt: 'United States Dollar',
      subTxt: "\$ USD",
    ),
    SettingsListData(
      titleTxt: 'Chinese Yuan',
      subTxt: "¥ Yuan",
    ),
    SettingsListData(
      titleTxt: 'Belgian Euro',
      subTxt: "€ Euro",
    ),
    SettingsListData(
      titleTxt: 'Brazilian Real',
      subTxt: "R\$ Real",
    ),
    SettingsListData(
      titleTxt: 'Canadian Dollar',
      subTxt: "\$ CAD",
    ),
    SettingsListData(
      titleTxt: 'Cuban Peso',
      subTxt: "₱ PESO",
    ),
    SettingsListData(
      titleTxt: 'French Euro',
      subTxt: "€ Euro",
    ),
    SettingsListData(
      titleTxt: 'Hong Kong Dollar',
      subTxt: "\$ HKD",
    ),
    SettingsListData(
      titleTxt: 'Italian Lira',
      subTxt: "€ Euro",
    ),
    SettingsListData(
      titleTxt: 'New Zealand Dollar',
      subTxt: "\$ NZ",
    ),
  ];

  static List<SettingsListData> helpSearchList = [
    SettingsListData(
      titleTxt: "paying_for_a_reservation",
      subTxt: "",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "How do I ",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "What methods ",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "When am I charged",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "How do I edit",
    ),
    SettingsListData(
      titleTxt: 'trust_and_safety',
      subTxt: "",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "I'm_a_guest_What",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "When am I charged",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "How do I edit",
    ),
    SettingsListData(
      titleTxt: "paying_for_a_reservation",
      subTxt: "",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "How do I ",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "What methods ",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "When am I charged",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "How do I edit",
    ),
    SettingsListData(
      titleTxt: 'trust_and_safety',
      subTxt: "",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "I'm_a_guest_What",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "When am I charged",
    ),
    SettingsListData(
      titleTxt: '',
      subTxt: "How do I edit",
    ),
  ];

  static List<SettingsListData> subHelpList = [
    SettingsListData(titleTxt: "", subTxt: "You can cancel"),
    SettingsListData(
      titleTxt: "",
      subTxt: "GO to Trips and choose yotr trip",
    ),
    SettingsListData(titleTxt: "", subTxt: "You'll be taken to"),
    SettingsListData(titleTxt: "", subTxt: "If you cancel, your "),
    SettingsListData(
      titleTxt: "",
      subTxt: "Give feedback",
      isSelected: true,
    ),
    SettingsListData(
      titleTxt: "Related articles",
      subTxt: "",
    ),
    SettingsListData(
      titleTxt: "",
      subTxt: "Can I change",
    ),
    SettingsListData(
      titleTxt: "",
      subTxt: "HoW do I cancel",
    ),
    SettingsListData(
      titleTxt: "",
      subTxt: "What is the",
    ),
  ];

  static List<SettingsListData> userInfoList = [
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
  ];
}

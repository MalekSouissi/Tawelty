import 'package:flutter/material.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/modules/bottom_tab/bottom_tab_screen.dart';
import 'package:new_motel/modules/hotel_booking/filter_screen/filters_screen.dart';
import 'package:new_motel/modules/hotel_booking/hotel_home_screen.dart';
import 'package:new_motel/modules/hotel_booking/result_filter/result_screen.dart';
import 'package:new_motel/modules/hotel_detailes/hotel_detailes.dart';
import 'package:new_motel/modules/hotel_detailes/reviews_list_screen.dart';
import 'package:new_motel/modules/hotel_detailes/room_booking_screen.dart';
import 'package:new_motel/modules/hotel_detailes/search_screen.dart';
import 'package:new_motel/modules/login/change_password.dart';
import 'package:new_motel/modules/login/forgot_password.dart';
import 'package:new_motel/modules/login/login_screen.dart';
import 'package:new_motel/modules/login/sign_up_Screen.dart';
import 'package:new_motel/modules/profile/country_screen.dart';
import 'package:new_motel/modules/profile/currency_screen.dart';
import 'package:new_motel/modules/profile/edit_profile.dart';
import 'package:new_motel/modules/profile/hepl_center_screen.dart';
import 'package:new_motel/modules/profile/how_do_screen.dart';
import 'package:new_motel/modules/profile/invite_screen.dart';
import 'package:new_motel/modules/profile/settings_screen.dart';
import 'package:new_motel/routes/routes.dart';

class NavigationServices {
  NavigationServices(this.context);

  final BuildContext context;

  Future<dynamic> _pushMaterialPageRoute(Widget widget,
      {bool fullscreenDialog: false}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => widget, fullscreenDialog: fullscreenDialog),
    );
  }

  void gotoSplashScreen() {
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName.Splash, (Route<dynamic> route) => false);
  }

  void gotoIntroductionScreen() {
    Navigator.pushNamedAndRemoveUntil(context, RoutesName.IntroductionScreen,
        (Route<dynamic> route) => false);
  }

  Future<dynamic> gotoLoginScreen() async {
    return await _pushMaterialPageRoute(LoginScreen());
  }

  Future<dynamic> gotoTabScreen() async {
    return await _pushMaterialPageRoute(BottomTabScreen());
  }

  Future<dynamic> gotoSignScreen() async {
    return await _pushMaterialPageRoute(SignUpScreen());
  }

  Future<dynamic> gotoForgotPassword() async {
    return await _pushMaterialPageRoute(ForgotPasswordScreen());
  }

  Future<dynamic> gotoHotelDetailes(RestaurantListData hotelData) async {
    return await _pushMaterialPageRoute(HotelDetailes(
      hotelData: hotelData,
    ));
  }

  Future<dynamic> gotoSearchScreen() async {
    return await _pushMaterialPageRoute(SearchScreen());
  }

  Future<dynamic> gotoHotelHomeScreen() async {
    return await _pushMaterialPageRoute(HotelHomeScreen());
  }

  Future<dynamic> gotoFiltersScreen() async {
    return await _pushMaterialPageRoute(FiltersScreen());
  }

  Future<dynamic> gotoRoomBookingScreen(RestaurantListData hotelData) async {
    return await _pushMaterialPageRoute(
        RoomBookingScreen(hotelData: hotelData));
  }

  Future<dynamic> gotoReviewsListScreen() async {
    return await _pushMaterialPageRoute(ReviewsListScreen());
  }

  Future<dynamic> gotoEditProfile() async {
    return await _pushMaterialPageRoute(EditProfile());
  }

  Future<dynamic> gotoSettingsScreen() async {
    return await _pushMaterialPageRoute(SettingsScreen());
  }

  Future<dynamic> gotoHeplCenterScreen() async {
    return await _pushMaterialPageRoute(HeplCenterScreen());
  }

  Future<dynamic> gotoChangepasswordScreen() async {
    return await _pushMaterialPageRoute(ChangepasswordScreen());
  }

  Future<dynamic> gotoInviteFriend() async {
    return await _pushMaterialPageRoute(InviteFriend());
  }

  Future<dynamic> gotoCurrencyScreen() async {
    return await _pushMaterialPageRoute(CurrencyScreen(),
        fullscreenDialog: true);
  }

  Future<dynamic> gotoCountryScreen() async {
    return await _pushMaterialPageRoute(CountryScreen(),
        fullscreenDialog: true);
  }

  Future<dynamic> gotoHowDoScreen() async {
    return await _pushMaterialPageRoute(HowDoScreen());
  }


//   void gotoHotelDetailesPage(String hotelname) async {
//     await _pushMaterialPageRoute(HotelDetailes(hotelName: hotelname));
//   }
}

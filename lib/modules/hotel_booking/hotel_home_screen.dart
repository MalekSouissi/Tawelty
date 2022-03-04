import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/models/enum.dart';
import 'package:new_motel/modules/hotel_booking/components/filter_bar_UI.dart';
import 'package:new_motel/modules/hotel_booking/components/getLocation.dart';
import 'package:new_motel/modules/hotel_booking/components/map_and_list_view.dart';
import 'package:new_motel/modules/myTrips/hotel_list_view.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:new_motel/widgets/common_search_bar.dart';
import 'package:new_motel/widgets/remove_focuse.dart';
import '../../models/hotel_list_data.dart';
import 'package:provider/provider.dart';

class HotelHomeScreen extends StatefulWidget {
  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController _animationController;
  List<RestaurantListData> hotelList=[];
  List<RestaurantListData> _foundRestaurants=[];
  ScrollController scrollController = new ScrollController();
  int room = 1;
  int ad = 2;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));
  bool _isShowMap = false;
  RestaurantListData restaurantListData=RestaurantListData();
  final searchBarHieght = 158.0;
  final filterBarHieght = 52.0;
  bool showAdress=false;
  List<RestaurantListData> restaurantList = [];
  String value = 'hamamet';
  List<Address> resultAdress = [];
  bool showAddress = false;

  fetchRestaurants()async{
    _foundRestaurants=await RestaurantListData().fetchRestaurants();
   // print(_foundRestaurants);
    _findRestaurantsWithLocation(value);
    setState(() {
      showAdress=true;
    });
  }
  _findRestaurantsWithLocation(value) async {
    for (int i = 0; i < _foundRestaurants.length; i++) {
      if (_foundRestaurants[i].subTxt == null) {
        print(_foundRestaurants[i].titleTxt);
      } else {
        if (_foundRestaurants[i]
            .subTxt
            .toUpperCase()
            .contains(value.substring(0, 4).toUpperCase())) {
          restaurantList.add(_foundRestaurants[i]);
        }
      }
    }
    setState(() {
      _foundRestaurants = restaurantList;
    });
    return _foundRestaurants;
  }
  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    getLocation();

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }
  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);

    getCurrentAddress(position.latitude, position.longitude);
  }
  getCurrentAddress(latitude, longitude) async {
    var address;

    final coordinates = new Coordinates(latitude, longitude);
    resultAdress =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = resultAdress.first;
    if (first != null) {
      address = first.featureName;
      address = " $address, ${first.subLocality}";
      address = " $address, ${first.subLocality}";
      address = " $address, ${first.locality}";
      address = " $address, ${first.countryName}";
      address = " $address, ${first.postalCode}";

      // locationController.text = address;
      print(address);
      print(first.countryName);
      setState(() {
        value = first.countryName.toString();
      });
    }
    return address;
  }

  @override
  void initState() {
    _determinePosition();
    fetchRestaurants();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    scrollController.addListener(() {
      if (scrollController.offset <= 0) {
        _animationController.animateTo(0.0);
      } else if (scrollController.offset > 0.0 &&
          scrollController.offset < searchBarHieght) {
        // we need around searchBarHieght scrolling values in 0.0 to 1.0
        _animationController
            .animateTo((scrollController.offset / searchBarHieght));
      } else {
        _animationController.animateTo(1.0);
      }
    });
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          RemoveFocuse(
            onClick: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: <Widget>[
                _getAppBarUI(),
                _isShowMap
                    ? MapAndListView(
                        hotelList: _foundRestaurants,
                        // searchBarUI: _getSearchBarUI(),
                      )
                    : Expanded(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              color: AppTheme.scaffoldBackgroundColor,
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: _foundRestaurants.length,
                                padding: EdgeInsets.only(
                                  top: 8 + 158 + 52.0,
                                ),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  var count = _foundRestaurants.length > 10
                                      ? 10
                                      : _foundRestaurants.length;
                                  var animation = Tween(begin: 0.0, end: 1.0)
                                      .animate(CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn)));
                                  animationController.forward();
                                  return HotelListView(
                                    callback: () {
                                      NavigationServices(context).gotoHotelDetailes(_foundRestaurants[index]);
                                    },
                                    hotelData: _foundRestaurants[index],
                                    animation: animation,
                                    animationController: animationController,
                                  );
                                },
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (BuildContext context, Widget? child) {
                                return Positioned(
                                  top: -searchBarHieght *
                                      (_animationController.value),
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        child: Column(
                                          children: <Widget>[
                                            //hotel search view
                                            _getSearchBarUI(),
                                            // time date and number of rooms view
                                            //TimeDateView(),
                                            LocationListView(value: value,),
                                          ],
                                        ),
                                      ),
                                      //hotel price & facilitate  & distance
                                      FilterBarUI(resultList: _foundRestaurants,),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _runFilter(String enteredKeyword) {
    List<RestaurantListData> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _foundRestaurants;
    } else {
      results = _foundRestaurants
          .where((restaurant) => restaurant.titleTxt.toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundRestaurants = results;
    });
  }
  Widget _getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 8),
              child: CommonCard(
                color: AppTheme.backgroundColor,
                radius: 36,
                child: CommonSearchBar(
                  onchanged: (String text){
                    _runFilter(text);
                  },
                  enabled: true,
                  ishsow: false,
                  text:  AppLocalizations(context).of("where_are_you_going"),
                ),
              ),
            ),
          ),
          CommonCard(
            color: AppTheme.primaryColor,
            radius: 36,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  NavigationServices(context).gotoSearchScreen();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(MdiIcons.tuneVariant,
                      size: 20, color: AppTheme.backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _getAppBarUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 8, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment:
                context.read<ThemeProvider>().languageType == LanguageType.ar
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                AppLocalizations(context).of("explore"),
                style: TextStyles(context).getTitleStyle(),
              ),
            ),
          ),
          Container(
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        child: Icon(
                            MdiIcons.accountOutline),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

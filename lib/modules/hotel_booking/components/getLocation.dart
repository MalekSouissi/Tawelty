import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_motel/constants/helper.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/models/enum.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/models/room_data.dart';
import 'package:new_motel/modules/hotel_booking/components/calendar_pop_up_view.dart';
import 'package:new_motel/modules/hotel_booking/components/room_pop_up_view.dart';
import 'package:new_motel/motel_app.dart';
import 'package:provider/provider.dart';

class LocationListView extends StatefulWidget {
  String value ;

  LocationListView({required this.value});

  @override
  _LocationListViewState createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  RoomData _roomData = RoomData(1, 2);
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));
  List<RestaurantListData> restaurantList = [];
  LanguageType _languageType = applicationcontext == null
      ? LanguageType.en
      : applicationcontext!.read<ThemeProvider>().languageType;
  List<String> results = [];
  List<RestaurantListData> resultRestaurant = [];
  List finalResults = RestaurantListData().finalList;

  List<String> list = [
    'Nabeul,tunisie',
    'Hamamet Sud,tunisie',
    'Hamamet nord,tunisie',
    'Kelibia,tunisie',
    'Tunis,tunisie',
    'carthage,tunisie',
    'menzah,tunisie',
    'Gammart,tunisie',
    'Nasr,tunisie',
    'Lagoulette,tunisie',
    'Sousse,tunisie',
    'Kantaoui,tunisie',
    'Djerba,tunisie',
    'Monastir,tunisie'
  ];

  // _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   getLocation();
  //
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  // }
  //
  // getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   print(position.latitude);
  //   print(position.longitude);
  //
  //   getCurrentAddress(position.latitude, position.longitude);
  // }
  //
  List<Address> resultAdress = [];
  bool showAddress = false;

  // getCurrentAddress(latitude, longitude) async {
  //   var address;
  //
  //   final coordinates = new Coordinates(latitude, longitude);
  //   resultAdress =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = resultAdress.first;
  //   if (first != null) {
  //     address = first.featureName;
  //     address = " $address, ${first.subLocality}";
  //     address = " $address, ${first.subLocality}";
  //     address = " $address, ${first.locality}";
  //     address = " $address, ${first.countryName}";
  //     address = " $address, ${first.postalCode}";
  //
  //     // locationController.text = address;
  //     print(address);
  //     print(first.countryName);
  //     setState(() {
  //       value = first.countryName.toString();
  //     });
  //   }
  //   return address;
  // }

  fetchRestaurant() async {
    restaurantList = await RestaurantListData().fetchRestaurants();
    setState(() {
      showAddress = true;
    });
  }

  _findRestaurantsWithLocation(value) async {
    for (int i = 0; i < restaurantList.length; i++) {
      if (restaurantList[i].subTxt == null) {
        print(restaurantList[i].titleTxt);
      } else {
        if (restaurantList[i]
            .subTxt
            .toUpperCase()
            .contains(value.substring(0, 4).toUpperCase())) {
          print(restaurantList[i].titleTxt);
          print(restaurantList[i].id);
          results.add(restaurantList[i].id);
          resultRestaurant.add(restaurantList[i]);
        }
      }
    }
    setState(() {
      restaurantList = resultRestaurant;
    });
    print(results);
    return results;
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchRestaurant();
   // _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  MapBoxPlaceSearchWidget(
                                    // height: 50,

                                    popOnSelect: true,
                                    apiKey:
                                        "pk.eyJ1IjoibWFsZWs3NTEiLCJhIjoiY2t1YTh3d3Y4MGVmdzJubXZhbjNuZnE1aiJ9.fOE93kvySi-HSIgEhixglQ",
                                    searchHint: 'Your Hint here',
                                    onSelected: (place) {
                                      list.add(place.text);
                                      setState(() {
                                        widget.value = place.text;
                                        _findRestaurantsWithLocation(widget.value);
                                      });
                                    },
                                    context: context,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: ListView.builder(
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(list[index]),
                                            //leading: new Icon(Icons.share),
                                            onTap: () {
                                              setState(() {
                                                widget.value = list[index];
                                                _findRestaurantsWithLocation(
                                                    widget.value);
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            // "Choose date",
                            style: TextStyles(context)
                                .getDescriptionStyle()
                                .copyWith(fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Icon(MdiIcons.mapMarker),
                              Text(widget.value),
                              Icon(Icons.arrow_drop_down_rounded)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 42,
            color: Colors.grey.withOpacity(0.8),
          ),
          _getDateRoomUi(AppLocalizations(context).of("number_room"),
              Helper.getRoomText(_roomData), () {
            _showPopUp();
          }),
        ],
      ),
    );
  }

  Widget _getDateRoomUi(String title, String subtitle, VoidCallback onTap) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
              onTap: onTap,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      // "Choose date",
                      style: TextStyles(context)
                          .getDescriptionStyle()
                          .copyWith(fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      subtitle,
                      // "${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}",
                      style: TextStyles(context).getRegularStyle(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDemoDialog(BuildContext context) {
    showDialog(
      context: context,
      //custome calendar view
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        maximumDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  void _showPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) => RoomPopupView(
        roomData: _roomData,
        barrierDismissible: true,
        onChnage: (data) {
          setState(() {
            _roomData = data;
          });
        },
      ),
    );
  }
}

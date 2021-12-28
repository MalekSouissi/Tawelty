// import 'package:flutter/material.dart';
// import 'package:new_motel/constants/localfiles.dart';
// import 'package:new_motel/constants/themes.dart';
// import 'package:new_motel/models/hotel_list_data.dart';
// import 'package:new_motel/modules/hotel_booking/map_hotel_view.dart';
// import 'package:new_motel/modules/hotel_booking/components/time_date_view.dart';
// import 'package:new_motel/routes/route_names.dart';
//
// class MapAndListView extends StatelessWidget {
//   final List<RestaurantListData> hotelList;
//   final Widget searchBarUI;
//
//   const MapAndListView(
//       {Key? key, required this.hotelList, required this.searchBarUI})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: StatefulBuilder(
//         builder: (context, state) {
//           return Column(
//             children: <Widget>[
//               searchBarUI,
//               TimeDateView(),
//               Expanded(
//                 child: Stack(
//                   children: <Widget>[
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width,
//                           child: Image.asset(
//                             Localfiles.mapImage,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Container(
//                           height: 80,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Theme.of(context)
//                                     .scaffoldBackgroundColor
//                                     .withOpacity(1.0),
//                                 Theme.of(context)
//                                     .scaffoldBackgroundColor
//                                     .withOpacity(0.4),
//                                 Theme.of(context)
//                                     .scaffoldBackgroundColor
//                                     .withOpacity(0.0),
//                               ],
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                             ),
//                           ),
//                         ),
//                       ] +
//                       getMapPinUI(state) +
//                       [
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           left: 0,
//                           child: Container(
//                             height: 156,
//                             // color: Colors.green,
//                             child: ListView.builder(
//                               itemCount: hotelList.length,
//                               padding:
//                                   EdgeInsets.only(top: 8, bottom: 8, right: 16),
//                               scrollDirection: Axis.horizontal,
//                               itemBuilder: (context, index) {
//                                 return MapHotelListView(
//                                   callback: () {
//                                     NavigationServices(context)
//                                         .gotoRoomBookingScreen(
//                                             hotelList[index]);
//                                   },
//                                   hotelData: hotelList[index],
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   List<Widget> getMapPinUI(Function(void Function()) state) {
//     List<Widget> list = [];
//
//     for (var i = 0; i < hotelList.length; i++) {
//       double? top;
//       double? left;
//       double? right;
//       double? bottom;
//       if (i == 0) {
//         top = 150;
//         left = 50;
//       } else if (i == 1) {
//         top = 50;
//         right = 50;
//       } else if (i == 2) {
//         top = 40;
//         left = 10;
//       } else if (i == 3) {
//         bottom = 260;
//         right = 140;
//       } else if (i == 4) {
//         bottom = 160;
//         right = 20;
//       }
//       list.add(
//         Positioned(
//           top: top,
//           left: left,
//           right: right,
//           bottom: bottom,
//           child: Container(
//             decoration: BoxDecoration(
//               color: hotelList[i].isSelected
//                   ? AppTheme.primaryColor
//                   : AppTheme.backgroundColor,
//               borderRadius: BorderRadius.all(Radius.circular(24.0)),
//               boxShadow: <BoxShadow>[
//                 BoxShadow(
//                   color: AppTheme.secondaryTextColor,
//                   blurRadius: 16,
//                   offset: Offset(4, 4),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.all(Radius.circular(24.0)),
//                 onTap: () {
//                   if (hotelList[i].isSelected == false) {
//                     state(() {
//                       hotelList.forEach((f) {
//                         f.isSelected = false;
//                       });
//                       hotelList[i].isSelected = true;
//                     });
//                   }
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 16, right: 16, top: 8, bottom: 8),
//                   child: Text(
//                     "\$${hotelList[i].perNight}",
//                     style: TextStyle(
//                         color: hotelList[i].isSelected
//                             ? AppTheme.backgroundColor
//                             : AppTheme.primaryColor,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     return list;
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/modules/hotel_booking/components/cityName.dart';
import 'package:new_motel/modules/hotel_booking/map_hotel_view.dart';
import 'package:new_motel/routes/route_names.dart';

class MapAndListView extends StatefulWidget {
  final List<RestaurantListData> hotelList;
  const MapAndListView({
    Key? key,
    required this.hotelList,
  }) : super(key: key);

  @override
  _MapAndListViewState createState() => _MapAndListViewState();
}

class _MapAndListViewState extends State<MapAndListView> {
  GoogleMapController? _controller;
  late BitmapDescriptor customIcon;
  bool isMapCreated = false;
  String? _mapStyle;
  List<Marker> allMarkers = [];
   PageController? _pageController;
   int? prevPage;
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
  bool show = false;
  getCoordinates(var query) async {
    var addresses = [];
    var first;
    var coordinates;
    addresses = await Geocoder.local.findAddressesFromQuery(query);
    first = await addresses.first;
    coordinates=await first.coordinates;
    print("${first.countryName} : ${first.coordinates},${first.featureName}");
    //setState(() {
      show=true;

    // });
    return coordinates ;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMapPin();
    //fetchRestaurants();
    print(widget.hotelList.length);
    widget.hotelList.forEach((element) async {
      Coordinates coordinates = await getCoordinates(element.subTxt);
      allMarkers.add(Marker(

        onTap: ()async{
          await MapsLauncher.launchQuery(
              element.titleTxt);
        },
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
          markerId: MarkerId(element.titleTxt),
          draggable: false,
          infoWindow:
              InfoWindow(title: element.titleTxt, snippet: element.subTxt),
          position: LatLng(coordinates.latitude,coordinates.longitude)));
     // _onScroll(widget.hotelList.indexOf(element));
    });
    // _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
    //   ..addListener(_onScroll());
  }

  void setCustomMapPin() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/image/icon/marker.png');
  }

   _onScroll() {
    if (_pageController!.page!.toInt()!= prevPage) {
      prevPage = _pageController!.page!.toInt();
      moveCamera(prevPage);
    }
  }

  // _coffeeShopList(index) {
  //   return AnimatedBuilder(
  //     animation: _pageController,
  //     builder: (BuildContext context, Widget widget) {
  //       double value = 1;
  //       if (_pageController.position.haveDimensions) {
  //         value = _pageController.page - index;
  //         value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
  //       }
  //       return Center(
  //         child: SizedBox(
  //           height: Curves.easeInOut.transform(value) * 125.0,
  //           width: Curves.easeInOut.transform(value) * 350.0,
  //           child: widget,
  //         ),
  //       );
  //     },
  //     child: Padding(
  //       padding:
  //       const EdgeInsets.only(left: 0.0, right: 8.0, top: 5.0, bottom: 5.0),
  //       child: Container(
  //         height: 140.0,
  //         width: 340.0,
  //         decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(15.0)),
  //             boxShadow: [
  //               BoxShadow(
  //                   blurRadius: 10.0,
  //                   spreadRadius: 2.0,
  //                   color: Colors.white.withOpacity(0.03))
  //             ]),
  //         child: Row(
  //           children: <Widget>[
  //             Material(
  //               color: Colors.transparent,
  //               child: Container(
  //                 height: 140.0,
  //                 width: 110.0,
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(15.0),
  //                         bottomLeft: Radius.circular(15.0)),
  //                     image: DecorationImage(
  //                         image: NetworkImage(hotelLocation[index].thumbNail),
  //                         fit: BoxFit.cover)),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 10.0, top: 10.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Container(
  //                       width: 150.0,
  //                       child: Text(
  //                         hotelLocation[index].shopName,
  //                         style: TextStyle(
  //                             fontFamily: "Sofia",
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.w600,
  //                             fontSize: 17.0),
  //                         overflow: TextOverflow.ellipsis,
  //                       )),
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 8.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         Icon(
  //                           Icons.location_on,
  //                           size: 14.0,
  //                           color: Colors.deepPurpleAccent,
  //                         ),
  //                         Container(
  //                           width: 140.0,
  //                           child: Text(
  //                             hotelLocation[index].address,
  //                             style: TextStyle(
  //                                 color: Colors.black45,
  //                                 fontSize: 14.5,
  //                                 fontFamily: "Sofia",
  //                                 fontWeight: FontWeight.w400),
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 15.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: <Widget>[
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: <Widget>[
  //                             Row(
  //                               children: <Widget>[
  //                                 Icon(
  //                                   Icons.star,
  //                                   color: Colors.deepPurpleAccent,
  //                                   size: 21.0,
  //                                 ),
  //                                 Icon(
  //                                   Icons.star,
  //                                   color: Colors.deepPurpleAccent,
  //                                   size: 21.0,
  //                                 ),
  //                                 Icon(
  //                                   Icons.star,
  //                                   color: Colors.deepPurpleAccent,
  //                                   size: 21.0,
  //                                 ),
  //                                 Icon(
  //                                   Icons.star,
  //                                   color: Colors.deepPurpleAccent,
  //                                   size: 21.0,
  //                                 ),
  //                                 Icon(
  //                                   Icons.star_half,
  //                                   color: Colors.deepPurpleAccent,
  //                                   size: 21.0,
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height*0.85,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(36.8797262, 10.341992399999999), zoom: 9.0),

            // markers: markers,
            onTap: (pos) {
              print(pos);
              Marker m = Marker(
                  markerId: MarkerId('1'), icon: customIcon, position: pos);
              setState(() {
                allMarkers.add(m);
              });
            },
            markers: Set.from(allMarkers),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _controller!.setMapStyle(_mapStyle);
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 156.0,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.hotelList.length,
              itemBuilder: (BuildContext context, int index) {
                return MapHotelListView(
                  callback: () {
                    // NavigationServices(context)
                    //     .gotoRoomBookingScreen(widget.hotelList[index]);

                    moveCamera(index);
                  },
                  hotelData: widget.hotelList[index],
                );
              },
            ),
          ),
        ),

        Positioned(
          top: 0,
          child: Container(
            height: 60.0,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              controller: _pageController,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return CityNameView(
                  callback: () {
                    // NavigationServices(context)
                    //     .gotoRoomBookingScreen(widget.hotelList[index]);

                    moveCamera2(index);
                  },
                  hotelData: list[index],
                );
              },
            ),
          ),
        ),
        // Column(
        //   children: <Widget>[
        //     // Padding(
        //     //   padding: const EdgeInsets.only(top: 0.0),
        //     //   child: Container(
        //     //     height: 75.0,
        //     //     width: double.infinity,
        //     //     decoration: BoxDecoration(
        //     //       color: Colors.white,
        //     //     ),
        //     //     child: Row(
        //     //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     //       crossAxisAlignment: CrossAxisAlignment.center,
        //     //       children: <Widget>[
        //     //         InkWell(
        //     //             onTap: () {
        //     //               Navigator.of(context).pop();
        //     //             },
        //     //             child: Padding(
        //     //               padding: const EdgeInsets.only(top: 20.0, left: 20.0),
        //     //               child: Icon(Icons.arrow_back_ios),
        //     //             )),
        //     //         Padding(
        //     //           padding: const EdgeInsets.only(
        //     //               left: 20.0, right: 20.0, top: 30.0),
        //     //           child: Center(
        //     //             child: Text(
        //     //               "Locations",
        //     //               style: TextStyle(
        //     //                   color: Colors.black,
        //     //                   fontFamily: "Sofia",
        //     //                   fontWeight: FontWeight.w500,
        //     //                   fontSize: 20.0,
        //     //                   letterSpacing: 1.4),
        //     //             ),
        //     //           ),
        //     //         ),
        //     //         Container(
        //     //           width: 43.0,
        //     //         )
        //     //       ],
        //     //     ),
        //     //   ),
        //     // ),
        //     Container(
        //       height: 40.0,
        //       decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //           begin: Alignment.bottomCenter,
        //           end: Alignment.topCenter,
        //           colors: <Color>[
        //             Color(0x00FFFFFF),
        //             Color(0xFFFFFFFF),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  // moveCamera() async {
  //  show? _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //       target: await getCoordinates(widget.hotelList[_pageController!.page!.toInt()].subTxt),
  //       zoom: 20.0,
  //       bearing: 45.0,
  //       tilt: 45.0))):null;
  // }

  moveCamera(index) async {
    var coordinates= await getCoordinates(widget.hotelList[index].subTxt);
    show? _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(coordinates.latitude,coordinates.longitude),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0))):null;
  }

  moveCamera2(index) async {
    var coordinates= await getCoordinates(list[index]);
    show? _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(coordinates.latitude,coordinates.longitude),
        zoom: 10.0,
        bearing: 45.0,
        tilt: 45.0))):null;
  }
}

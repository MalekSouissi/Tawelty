import 'package:flutter/material.dart';
import 'package:new_motel/constants/localfiles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/modules/hotel_booking/map_hotel_view.dart';
import 'package:new_motel/modules/hotel_booking/components/time_date_view.dart';
import 'package:new_motel/routes/route_names.dart';

class MapAndListView extends StatelessWidget {
  final List<RestaurantListData> hotelList;
  final Widget searchBarUI;

  const MapAndListView(
      {Key? key, required this.hotelList, required this.searchBarUI})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StatefulBuilder(
        builder: (context, state) {
          return Column(
            children: <Widget>[
              searchBarUI,
              TimeDateView(),
              Expanded(
                child: Stack(
                  children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            Localfiles.mapImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(1.0),
                                Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.4),
                                Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ] +
                      getMapPinUI(state) +
                      [
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            height: 156,
                            // color: Colors.green,
                            child: ListView.builder(
                              itemCount: hotelList.length,
                              padding:
                                  EdgeInsets.only(top: 8, bottom: 8, right: 16),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return MapHotelListView(
                                  callback: () {
                                    NavigationServices(context)
                                        .gotoRoomBookingScreen(
                                            hotelList[index].titleTxt);
                                  },
                                  hotelData: hotelList[index],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  List<Widget> getMapPinUI(Function(void Function()) state) {
    List<Widget> list = [];

    for (var i = 0; i < hotelList.length; i++) {
      double? top;
      double? left;
      double? right;
      double? bottom;
      if (i == 0) {
        top = 150;
        left = 50;
      } else if (i == 1) {
        top = 50;
        right = 50;
      } else if (i == 2) {
        top = 40;
        left = 10;
      } else if (i == 3) {
        bottom = 260;
        right = 140;
      } else if (i == 4) {
        bottom = 160;
        right = 20;
      }
      list.add(
        Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: Container(
            decoration: BoxDecoration(
              color: hotelList[i].isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppTheme.secondaryTextColor,
                  blurRadius: 16,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                onTap: () {
                  if (hotelList[i].isSelected == false) {
                    state(() {
                      hotelList.forEach((f) {
                        f.isSelected = false;
                      });
                      hotelList[i].isSelected = true;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: Text(
                    "\$${hotelList[i].perNight}",
                    style: TextStyle(
                        color: hotelList[i].isSelected
                            ? AppTheme.backgroundColor
                            : AppTheme.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }
}

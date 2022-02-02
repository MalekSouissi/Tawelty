import 'package:flutter/material.dart';
import 'package:new_motel/modules/myTrips/hotel_list_view_data.dart';
import 'package:new_motel/routes/route_names.dart';
import '../../models/hotel_list_data.dart';

class FinishTripView extends StatefulWidget {
  final AnimationController animationController;

  const FinishTripView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _FinishTripViewState createState() => _FinishTripViewState();
}

class _FinishTripViewState extends State<FinishTripView> {
  var hotelList = [];
bool showAddress=false;

  fetchRestaurant()async{
    hotelList= await RestaurantListData().fetchRestaurants();

    setState(() {
      showAddress = true;
    });
  }


  @override
  void initState() {
    fetchRestaurant();
   // widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showAddress?ListView.builder(
        itemCount: hotelList.length,
        padding: EdgeInsets.only(top: 8, bottom: 16),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var count = hotelList.length > 10 ? 10 : hotelList.length;
          var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController,
              curve: Interval((1 / count) * index, 1.0,
                  curve: Curves.fastOutSlowIn)));
          widget.animationController.forward();
          //Finished hotel data list and UI View
          return HotelListViewData(
            callback: () {
              NavigationServices(context).gotoHotelDetailes(hotelList[index]);
            },
            hotelData: hotelList[index],
            animation: animation,
            animationController: widget.animationController,
            isShowDate: (index % 2) != 0,
          );
        },
      ):Container(),
    );
  }
}

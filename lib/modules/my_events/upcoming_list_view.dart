import 'package:flutter/material.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/modules/my_events/hotel_list_view.dart';
import 'package:new_motel/routes/route_names.dart';

class UpcomingListView extends StatefulWidget {
  final AnimationController animationController;

  const UpcomingListView({Key? key, required this.animationController})
      : super(key: key);
  @override
  _UpcomingListViewState createState() => _UpcomingListViewState();
}

class _UpcomingListViewState extends State<UpcomingListView> {
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
    widget.animationController.forward();
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
          //Upcoming UI view and hotel list
          return HotelListView(
            callback: () {
              NavigationServices(context).gotoEventScreen(hotelList[index]);
            },
            hotelData: hotelList[index],
            animation: animation,
            animationController: widget.animationController,
            isShowDate: true,
          );
        },
      ):Container(),
    );
  }
}

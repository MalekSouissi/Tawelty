import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_motel/modules/myTrips/hotel_list_view_page.dart';
import 'package:new_motel/routes/route_names.dart';
import '../../models/hotel_list_data.dart';
import 'package:http/http.dart' as http;

class FavoritesListView extends StatefulWidget {
  final AnimationController animationController;

  const FavoritesListView({Key? key, required this.animationController})
      : super(key: key);
  @override
  _FavoritesListViewState createState() => _FavoritesListViewState();
}

class _FavoritesListViewState extends State<FavoritesListView> {
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
      child: showAddress?buildListView(hotelList, widget.animationController):Container()
    );
  }
}

buildListView(List hotelList,animationController){
  return ListView.builder(
    itemCount: hotelList.length,
    padding: EdgeInsets.only(top: 8, bottom: 8),
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      var count = hotelList.length > 10 ? 10 : hotelList.length;
      var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: animationController,
          curve: Interval((1 / count) * index, 1.0,
              curve: Curves.fastOutSlowIn)));
      animationController.forward();
      //Favorites hotel data list and UI View
      return HotelListViewPage(
        callback: () {
          NavigationServices(context).gotoHotelDetailes(hotelList[index]);
        },
        hotelData: hotelList[index],
        animation: animation,
        animationController: animationController,
      );
    },
  );
}
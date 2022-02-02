import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_motel/constants/helper.dart';
import 'package:new_motel/models/favorite.dart';
import 'package:new_motel/modules/myTrips/hotel_list_view_page.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/services/favorite.services.dart';
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
  final hotelList = [];
  List<Favorite> favoriteList = [];
  bool showAddress = false;
  FavoriteServices favoriteServices = FavoriteServices();
  Helper helper = Helper();

  fetchFavorites() async {
    setState(() {
      showAddress = false;
    });
    await FavoriteServices().getListFavorites().then((value) {
      favoriteList = value;
      value.forEach((element) async {
        RestaurantListData restaurantListData = await RestaurantListData()
            .fetchRestaurant(element.restaurantId.toString());
        print(restaurantListData.titleTxt);
        hotelList.add(restaurantListData);
      });
    });
    setState(() {
      showAddress = true;
    });
  }

  @override
  void initState() {
    //fetchRestaurant();
    fetchFavorites();
    widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: showAddress
            ? buildListView(hotelList, widget.animationController)
            : CircularProgressIndicator());
  }

  buildListView(List hotelList, animationController) {
    return ListView.builder(
      itemCount: hotelList.length,
      padding: EdgeInsets.only(top: 8, bottom: 8),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        var count = favoriteList.length > 10 ? 10 : favoriteList.length;
        var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve: Interval((1 / count) * index, 1.0,
                curve: Curves.fastOutSlowIn)));
        animationController.forward();
        //Favorites hotel data list and UI View
        return GestureDetector(
          onLongPress: () {
            _deleteReview(favoriteList[index].id);
          },
          child: HotelListViewPage(
            callback: () {
              NavigationServices(context).gotoHotelDetailes(hotelList[index]);
            },
            hotelData: hotelList[index],
            animation: animation,
            animationController: animationController,
          ),
        );
      },
    );
  }

  void _deleteReview(id) async {
    bool isOk = await helper.showCommonPopup(
      "Are you sure?",
      "You want to Delete this restaurant from favorites ?",
      context,
      barrierDismissible: true,
      isYesOrNoPopup: true,
    );
    if (isOk) {
      delete(id);
    }
  }

  delete(ID) async {
    await favoriteServices
        .deleteFavorite(ID.toString())
        .then((value) => fetchFavorites());
    setState(() {
      showAddress = true;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/modules/myTrips/hotel_list_view_data.dart';
import 'package:new_motel/routes/route_names.dart';

class ResultPageView extends StatefulWidget {
final List resultList;
ResultPageView({required this.resultList});
  @override
  _ResultPageViewState createState() => _ResultPageViewState();
}

class _ResultPageViewState extends State<ResultPageView> with TickerProviderStateMixin {
  List<RestaurantListData> hotelList = [];
  List<RestaurantListData> showResult = [];
  bool showAddress=false;
  late AnimationController _animationController;

  fetchRestaurant()async{
    hotelList= await RestaurantListData().fetchRestaurants();
    hotelList.forEach((element) {
      widget.resultList.forEach((result) {
        if(element.id==result){
          showResult.add(element);
        }
      });
    });
    setState(() {

      showAddress = true;
    });
  }


  @override
  void initState() {
    print(widget.resultList.length);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 400),vsync: this);
    fetchRestaurant();
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: showAddress?ListView.builder(
          itemCount: showResult.length,
          padding: EdgeInsets.only(top: 8, bottom: 16),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            var count = showResult.length > 10 ? 10 : showResult.length;
            var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: _animationController,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn)));
            _animationController.forward();
            //Finished hotel data list and UI View
            return HotelListViewData(
              callback: () {
                NavigationServices(context)
                    .gotoRoomBookingScreen(showResult[index].titleTxt);
              },
              hotelData: showResult[index],
              animation: animation,
              animationController: _animationController,
              isShowDate: (index % 2) != 0,
            );
          },
        ):Text('fuck me'),
      ),
    );
  }
}

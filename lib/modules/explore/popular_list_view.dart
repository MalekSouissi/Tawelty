import 'package:flutter/material.dart';
import 'package:new_motel/modules/my_events/hotel_list_view.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:new_motel/widgets/bottom_top_move_animation_view.dart';
import '../../models/hotel_list_data.dart';
import 'category_view.dart';

class PopularListView extends StatefulWidget {
  final RestaurantListData hotelData;
  final Function(int) callBack;
  final AnimationController animationController;
  const PopularListView(
      {Key? key, required this.callBack, required this.animationController, required this.hotelData})
      : super(key: key);
  @override
  _PopularListViewState createState() => _PopularListViewState();
}

class _PopularListViewState extends State<PopularListView>
    with TickerProviderStateMixin {
  var popularList = RestaurantListData.popularList;
  AnimationController? animationController;


  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomTopMoveAnimationView(
      animationController: animationController!,
      child: Container(
        height: 180,
        width: double.infinity,
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 24, left: 8),
                itemCount: popularList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var count = popularList.length > 10 ? 10 : popularList.length;
                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController!,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn)));
                  animationController?.forward();
                  //Population animation photo and text view
                  return CategoryView(
                    popularList: popularList[index],
                    animation: animation,
                    animationController: animationController!,
                    callback: () {
                      NavigationServices(context)
                          .gotoEventScreen(widget.hotelData);
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}




class RelatedListView extends StatefulWidget {
  final RestaurantListData hotelData;
  final Function(int) callBack;
  final AnimationController animationController;
  const RelatedListView(
      {Key? key, required this.callBack, required this.animationController, required this.hotelData})
      : super(key: key);
  @override
  _RelatedListViewState createState() => _RelatedListViewState();
}

class _RelatedListViewState extends State<RelatedListView>
    with TickerProviderStateMixin {
  var popularList = RestaurantListData.popularList;
  AnimationController? animationController;


  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomTopMoveAnimationView(
      animationController: animationController!,
      child: Container(
        height: 180,
        width: double.infinity,
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            } else {
              return Container(
                height: 200,
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 24, left: 8),
                  itemCount: popularList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var count = popularList.length > 10 ? 10 : popularList.length;
                    var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController!,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn)));
                    animationController?.forward();
                    //Population animation photo and text view
                    return HotelListView(
                      hotelData: popularList[index],
                      animation: animation,
                      animationController: animationController!,
                      callback: () {
                        NavigationServices(context)
                            .gotoEventScreen(widget.hotelData);
                      },
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

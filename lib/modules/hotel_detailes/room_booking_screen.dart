import 'package:flutter/material.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/modules/hotel_detailes/room_book_view.dart';
import '../../models/hotel_list_data.dart';

class RoomBookingScreen extends StatefulWidget {
  final RestaurantListData hotelData;

  const RoomBookingScreen({Key? key, required this.hotelData})
      : super(key: key);
  @override
  _RoomBookingScreenState createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen>
    with TickerProviderStateMixin {
  List<RestaurantListData> romeList = RestaurantListData.romeList;
  late AnimationController animationController;
// RestaurantListData restaurantListdata = RestaurantListData();

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          getAppBarUI(),
          Expanded(
            child: RoomeBookView(restaurantId: widget.hotelData.id,),
            /*ListView.builder(
              padding: EdgeInsets.all(0.0),
              itemCount: romeList.length,
              itemBuilder: (context, index) {
                var count = romeList.length > 10 ? 10 : romeList.length;
                var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn)));
                animationController.forward();
                //room book view and room data
                return RoomeBookView(
                  *//*roomData: romeList[index],
                  animation: animation,
                  animationController: animationController,*//*
                );
              },
            )*/
          ),
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    // return Container(
    //   decoration: BoxDecoration(
    //     color: AppTheme.scaffoldBackgroundColor,
    //     boxShadow: <BoxShadow>[
    //       BoxShadow(
    //           color: Theme.of(context).dividerColor,
    //           offset: Offset(0, 2),
    //           blurRadius: 8.0),
    //     ],
    //   ),
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          right: 16,
          bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          //   Container(
          // alignment: Alignment.centerLeft,
          // width: AppBar().preferredSize.height,
          // height: AppBar().preferredSize.height,
          // child:
          Material(
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
          //   ),
          Expanded(
            child: Center(
              child: Text(
                widget.hotelData.titleTxt,
                style: TextStyles(context).getTitleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          //   Container(
          //     width: AppBar().preferredSize.height,
          //     height: AppBar().preferredSize.height,
          //     child:
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.favorite_border),
              ),
            ),
          ),
          //   )
        ],
      ),
    );
    // );
  }
}

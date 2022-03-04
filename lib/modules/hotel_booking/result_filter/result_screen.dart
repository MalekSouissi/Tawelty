import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/models/enum.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/modules/hotel_booking/components/map_and_list_view.dart';
import 'package:new_motel/modules/myTrips/hotel_list_view_data.dart';
import 'package:new_motel/routes/route_names.dart';
import 'package:provider/src/provider.dart';

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
  bool _isShowMap = false;

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
      body: Column(
        children: [
          _getAppBarUI(),
          _isShowMap? MapAndListView(
            hotelList: showResult,
            // searchBarUI: _getSearchBarUI(),
          ):Expanded(
            child: Container(
             // height: 1000,
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
                      NavigationServices(context).gotoHotelDetailes(showResult[index]);
                    },
                    hotelData: showResult[index],
                    animation: animation,
                    animationController: _animationController,
                    isShowDate: (index % 2) != 0,
                  );
                },
              ):Container(),
            ),
          ),
        ],
      ),
    );
  }
  Widget _getAppBarUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 8, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment:
            context.read<ThemeProvider>().languageType == LanguageType.ar
                ? Alignment.centerRight
                : Alignment.centerLeft,
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Material(
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
          ),
          Expanded(
            child: Center(
              child: Text(
                'Search Result',
                style: TextStyles(context).getTitleStyle(),
              ),
            ),
          ),
          Container(
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
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
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {
                      setState(() {
                        _isShowMap = !_isShowMap;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(_isShowMap
                          ? Icons.sort
                          : FontAwesomeIcons.mapMarkedAlt),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

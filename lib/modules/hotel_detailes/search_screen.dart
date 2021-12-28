import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/popular_filter_list.dart';
import 'package:new_motel/modules/hotel_detailes/search_view.dart';
import 'package:new_motel/widgets/common_appbar_view.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:new_motel/widgets/common_search_bar.dart';
import 'package:new_motel/widgets/remove_focuse.dart';
import 'package:translator/translator.dart';
import '../../models/hotel_list_data.dart';
import 'search_type_list.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  List<RestaurantListData> lastsSearchesList = [];

  late AnimationController animationController;
  final translator = GoogleTranslator();
  bool show=false;
  List finalList=[];
  List<FilterListData> typeList=[];
  List<RestaurantListData> _foundRestaurants=[];
  List<RestaurantListData> hotelTypeList = RestaurantListData.hotelTypeList;

  @override
  void initState() {
    fetchRestaurant();
    fetchTypes();
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  bool showAddress=false;

  fetchRestaurant()async{
    lastsSearchesList= await RestaurantListData().fetchRestaurants();
    _foundRestaurants=lastsSearchesList;
    setState(() {

      showAddress = true;
    });
  }


  fetchTypes()async{
    typeList=await FilterListData().fetchTypes();
    print(typeList);
    setState(() {
      show=true;
    });
  }

  searchByFilter(String text)async{
    var translation = await translator
        .translate(text, from: 'en', to: 'fr');
    print(translation.toString());
    List<RestaurantListData> results=[];
    var restaurant;
    if (text != '') {
      //finalList.clear();
      typeList.forEach((element) {
        if(element.type.toLowerCase().contains(translation.text.substring(0, 4).toLowerCase())){
          setState((){
            finalList.add(element.restaurantId);
             restaurant=lastsSearchesList.where((restaurant) => restaurant.id==element.restaurantId);
          });
          results.add(restaurant.first);
        }
      });

      setState(() {
        _foundRestaurants=results;
      });
      // results = _foundRestaurants
      //     .where((restaurant) => restaurant.id == element.
      print(finalList);
      print(_foundRestaurants);

    } else {
      setState(() {

        print(finalList.length);
        //finalList.clear();
        //resultList.addAll(finalList);
      });
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: RemoveFocuse(
        onClick: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CommonAppbarView(
              iconData: Icons.close,
              onBackClick: () {
                Navigator.pop(context);
              },
              titleText: AppLocalizations(context).of("search_hotel"),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 16, bottom: 16),
                          child: CommonCard(
                            color: AppTheme.backgroundColor,
                            radius: 36,
                            child: CommonSearchBar(
                              onchanged: (String text){
                                _runFilter(text);
                              },
                              iconData: FontAwesomeIcons.search,
                              enabled: true,
                              text: AppLocalizations(context)
                                  .of("where_are_you_going"),
                            ),
                          ),
                        ),
                        //SearchTypeListView(),
                    typeListUI(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  AppLocalizations(context).of("Result")+'('+finalList.length.toString()+')',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  onTap: () {
                                    setState(() {
                                      _foundRestaurants.clear();
                                      finalList.clear();
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          AppLocalizations(context)
                                              .of("clear_all"),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ] +
                      getPList() +
                      [
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 16,
                        )
                      ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _runFilter(String enteredKeyword) {
    List<RestaurantListData> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _foundRestaurants;
    } else {
      results = _foundRestaurants
          .where((restaurant) => restaurant.titleTxt.toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundRestaurants = results;
    });
  }
  List<Widget> getPList() {
    List<Widget> noList = [];
    var cout = 0;
    final columCount = 2;
    for (var i = 0; i < _foundRestaurants.length / columCount; i++) {
      List<Widget> listUI = [];
      for (var i = 0; i < columCount; i++) {
        try {
          final date = _foundRestaurants[cout];
          var animation = Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / _foundRestaurants.length) * cout, 1.0,
                  curve: Curves.fastOutSlowIn),
            ),
          );
          animationController.forward();
          listUI.add(Expanded(
            child: SerchView(
              hotelInfo: date,
              animation: animation,
              animationController: animationController,
            ),
          ));
          cout += 1;
        } catch (e) {
        }
      }
      showAddress?noList.add(
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: listUI,
          ),
        ),
      ):Container();
    }
    return noList;
  }


  Widget typeListUI(){
    return Container(
      height: 114,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 0, right: 16, left: 16),
        itemCount: hotelTypeList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var count = hotelTypeList.length;
          var animation = Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / count) * index, 1.0,
                  curve: Curves.fastOutSlowIn),
            ),
          );
          animationController.forward();
          return AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation,
                child: new Transform(
                  transform: new Matrix4.translationValues(
                      50 * (1.0 - animation.value), 0.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8, top: 0),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Theme.of(context).dividerColor,
                                    blurRadius: 8,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                    hotelTypeList[index].imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                                highlightColor: Colors.transparent,
                                splashColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.4),
                                onTap: () {
                                  searchByFilter(hotelTypeList[index].titleTxt);
                                  setState(() {
                                    hotelTypeList[index].isSelected =
                                    !hotelTypeList[index].isSelected;
                                  });
                                },
                                child: Opacity(
                                  opacity: hotelTypeList[index].isSelected
                                      ? 1.0
                                      : 0.0,
                                  child: CommonCard(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4),
                                    radius: 48,
                                    //   Container(
                                    //     width: 80,
                                    //     height: 80,
                                    //     decoration: BoxDecoration(
                                    //       shape: BoxShape.circle,
                                    //       color: Theme.of(context)
                                    //           .primaryColor
                                    //           .withOpacity(0.4),
                                    //     ),
                                    child: SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.check,
                                          color:
                                          Theme.of(context).backgroundColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            AppLocalizations(context)
                                .of(hotelTypeList[index].titleTxt),
                            maxLines: 2,
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

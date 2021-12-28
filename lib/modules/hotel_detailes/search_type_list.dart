import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/popular_filter_list.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:translator/translator.dart';
import '../../models/hotel_list_data.dart';

class SearchTypeListView extends StatefulWidget {
  @override
  _SearchTypeListViewState createState() => _SearchTypeListViewState();
}

class _SearchTypeListViewState extends State<SearchTypeListView>
    with TickerProviderStateMixin {
  List<RestaurantListData> hotelTypeList = RestaurantListData.hotelTypeList;
  List<FilterListData> typeList=[];
  final translator = GoogleTranslator();
  late AnimationController animationController;
  bool show=false;
  List finalList=[];
  @override
  void initState() {
    fetchTypes();
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
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
    if (text != '') {
      //finalList.clear();
      typeList.forEach((element) {
        if(element.type.toLowerCase().contains(translation.text.substring(0, 4).toLowerCase())){
          setState(() {
            finalList.add(element.restaurantId);
          });
        }
      });
      print(finalList);
      setState(() {
        RestaurantListData().finalList=finalList;
      });
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

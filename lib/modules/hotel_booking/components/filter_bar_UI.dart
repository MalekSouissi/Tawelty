import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/modules/my_events/common_card.dart';
import 'package:new_motel/routes/route_names.dart';

class FilterBarUI extends StatefulWidget {
  final List resultList;
  FilterBarUI({required this.resultList});
  @override
  State<FilterBarUI> createState() => _FilterBarUIState();
}

class _FilterBarUIState extends State<FilterBarUI> {
  RestaurantListData restaurantListData = RestaurantListData();
  List<RestaurantListData> finalList = [];
  List resultList = [];
  bool _isShowMap = false;

  fetchRestaurants() async {
    finalList = await restaurantListData.fetchRestaurants();
    print(finalList.length);
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchRestaurants();
    resultList = RestaurantListData().finalList;
    print(resultList.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.scaffoldBackgroundColor,
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.resultList.length.toString(),
                    style: TextStyles(context).getBoldStyle().copyWith(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      AppLocalizations(context).of("hotel_found"),
                      style: TextStyles(context).getBoldStyle().copyWith(fontSize: 18),
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
                          ? MdiIcons.formatListBulletedSquare
                          : MdiIcons.map,color: AppTheme.primaryColor,size: 24,),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Divider(
              height: 1,
            ),
          )
        ],
      ),
    );
  }
}

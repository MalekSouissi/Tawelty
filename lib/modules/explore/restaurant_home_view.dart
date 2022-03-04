import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_motel/constants/helper.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/modules/hotel_booking/components/restaurant_carousel.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:new_motel/widgets/list_cell_animation_view.dart';

class RestaurantListView extends StatelessWidget {
  final bool isShowDate;
  final VoidCallback callback;
  final RestaurantListData hotelData;
  final AnimationController animationController;
  final Animation<double> animation;

  const RestaurantListView(
      {Key? key,
      required this.hotelData,
      required this.animationController,
      required this.animation,
      required this.callback,
      this.isShowDate: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListCellAnimationView(
      animation: animation,
      animationController: animationController,
      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.5,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              child: Stack(
                children: <Widget>[
                  Container(
                    height:MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.width*0.7,
                    child: ProfilePicture(
                      restaurantId: hotelData.id,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    left: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        onTap: () {
                          try {
                            callback();
                          } catch (e) {}
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          shape: BoxShape.circle),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.favorite_border,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height*0.05,
              left: (MediaQuery.of(context).size.width*0.7-MediaQuery.of(context).size.width*0.5)/3,
              child: CommonCard(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16,top:8,bottom: 8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          hotelData.titleTxt,
                          textAlign: TextAlign.left,
                          style: TextStyles(context)
                              .getBoldStyle()
                              .copyWith(fontSize: 18),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          hotelData.subTxt,
                          style: TextStyles(context)
                              .getBoldStyle().copyWith(fontSize: 12,),
                        ),
                        Helper.ratingStar(),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.mapMarkerAlt,
                                  size: 12,
                                  color: Theme.of(context)
                                      .primaryColor,
                                ),
                                Text(
                                  "${hotelData.dist.toStringAsFixed(1)}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles(context)
                                      .getDescriptionStyle(),
                                ),
                                Text(
                                  AppLocalizations(context)
                                      .of("km_to_city"),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles(context)
                                      .getDescriptionStyle(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  MdiIcons.heartOutline,
                                  size: 14,
                                  color: Theme.of(context)
                                      .primaryColor,
                                ),
                                Text(
                                  "1250",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles(context)
                                      .getBoldStyle().copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

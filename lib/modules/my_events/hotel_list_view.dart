import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/modules/my_events/restaurant_carousel.dart';
import 'package:new_motel/widgets/list_cell_animation_view.dart';

import 'common_card.dart';

class HotelListView extends StatefulWidget {
  final bool isShowDate;
  final VoidCallback callback;
  final RestaurantListData hotelData;
  final AnimationController animationController;
  final Animation<double> animation;

  const HotelListView(
      {Key? key,
      required this.hotelData,
      required this.animationController,
      required this.animation,
      required this.callback,
      this.isShowDate: false})
      : super(key: key);

  @override
  State<HotelListView> createState() => _HotelListViewState();
}

class _HotelListViewState extends State<HotelListView> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return ListCellAnimationView(
      animation: widget.animation,
      animationController: widget.animationController,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
        child: Column(
          children: <Widget>[
            //code
            CommonCard(
              color: AppTheme.backgroundColor,
              radius: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        AspectRatio(
                            aspectRatio: 2,
                            child: ProfilePicture(
                              restaurantId: widget.hotelData.id,
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, top: 8, bottom: 5, right: 8),
                                  child: Column(

                                    children: <Widget>[
                                     /* Text(
                                        widget.hotelData.titleTxt,
                                        textAlign: TextAlign.left,
                                        style: TextStyles(context)
                                            .getBoldStyle()
                                            .copyWith(fontSize: 22),
                                      ),*/
                                      infos(
                                        widget: widget,
                                        icon: FontAwesomeIcons.calendar,
                                        text: "24-26 January 2022",
                                      ),
                                      SizedBox(height: 4,),
                                      infos(
                                        widget: widget,
                                        icon: FontAwesomeIcons.clock,
                                        text: "4PM-11PM",
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 145,
                      right: 0,
                      bottom: 0,
                      left: 15,
                      child: Text(
                          widget.hotelData.titleTxt,
                          textAlign: TextAlign.left,
                          style: TextStyles(context)
                              .getBoldStyle()
                              .copyWith(fontSize: 22 , color: AppTheme.whiteColor),),
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
                            Radius.circular(16.0),
                          ),
                          onTap: () {
                            try {
                              widget.callback();
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
                            onTap: () {
                              setState(() {
                                isFav = !isFav;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ),
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
}

class infos extends StatelessWidget {
  final IconData icon;
  final String text;

  const infos({
    Key? key,
    required this.widget,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final HotelListView widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Icon(
                icon,
                size: 15,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                " " + text,
                overflow: TextOverflow.ellipsis,
                style: TextStyles(context).getDescriptionStyle(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/models/hotel_list_data.dart';

class CategoryView extends StatelessWidget {
  final Function callback;
  final RestaurantListData popularList;
  final AnimationController animationController;
  final Animation<double> animation;

  const CategoryView(
      {Key? key,
        required this.popularList,
        required this.animationController,
        required this.animation,
        required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          callback();
        },
        child: Padding(
          padding:
          const EdgeInsets.only(left: 16, bottom: 24, top: 16, right: 8),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 2,
                  child: Image.asset(
                    popularList.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryTextColor.withOpacity(0.4),
                                AppTheme.primaryTextColor.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      popularList.titleTxt,
                                      style: TextStyles(context)
                                          .getBoldStyle()
                                          .copyWith(
                                        fontSize: 24,
                                        color: AppTheme.whiteColor,
                                      ),
                                    ),
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height /
                                          15,
                                      width:
                                      MediaQuery.of(context).size.height /
                                          15,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Center(
                                        child: Text(
                                          '24\noct',
                                          style: TextStyles(context)
                                              .getRegularStyle()
                                              .copyWith(
                                            fontSize: 15,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InfoCard(
                                      dataIcon: FontAwesomeIcons.clock,
                                      text: "4PM-11PM",
                                    ),
                                    SizedBox(height: 4,),
                                    InfoCard(
                                      dataIcon: FontAwesomeIcons.mapMarkerAlt,
                                      text: "Av Habib Bourguiba",
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {

  final IconData dataIcon;
  final String text;

  const InfoCard({
    this.text : "",
    required this.dataIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(
            dataIcon,
            color:
            AppTheme.whiteColor,
            size: 15,
          ),
          Text(
            " " + text,
            style: TextStyles(context)
                .getRegularStyle()
                .copyWith(
              fontSize: 15.75,
              color: AppTheme.whiteColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

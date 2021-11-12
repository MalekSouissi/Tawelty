import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_motel/constants/helper.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/logic/providers/theme_provider.dart';
import 'package:new_motel/models/enum.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/models/restaurant_files.dart';
import 'package:new_motel/modules/hotel_booking/components/restaurant_carousel.dart';
import 'package:new_motel/widgets/common_card.dart';
import 'package:new_motel/widgets/list_cell_animation_view.dart';
import 'package:provider/provider.dart';

class HotelListViewPage extends StatefulWidget {
  final bool isShowDate;
  final VoidCallback callback;
  final RestaurantListData hotelData;
  final AnimationController animationController;
  final Animation<double> animation;

  const HotelListViewPage(
      {Key? key,
      required this.hotelData,
      required this.animationController,
      required this.animation,
      required this.callback,
      this.isShowDate: false})
      : super(key: key);

  @override
  State<HotelListViewPage> createState() => _HotelListViewPageState();
}

class _HotelListViewPageState extends State<HotelListViewPage> {



  @override
  Widget build(BuildContext context) {
    return ListCellAnimationView(
      animation: widget.animation,
      animationController: widget.animationController,
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
        child: CommonCard(
          color: AppTheme.backgroundColor,
          child: ClipRRect(
            //   borderRadius: BorderRadius.all(Radius.circular(0.0)),
            child: AspectRatio(
              aspectRatio: 2.7,
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      //ProfileCarousel(restaurantId: widget.hotelData.id,),
                      AspectRatio(
                        aspectRatio: 0.90,
                        child:ProfilePicture(restaurantId: widget.hotelData.id,)
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width >= 360
                                  ? 12
                                  : 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.hotelData.titleTxt,
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                style:
                                    TextStyles(context).getBoldStyle().copyWith(
                                          fontSize: 16,
                                        ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.hotelData.subTxt,
                                style: TextStyles(context)
                                    .getDescriptionStyle()
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                              ),
                              // Expanded(
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.end,
                              //     children: <Widget>[
                              //       Column(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.end,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: <Widget>[
                              //           Row(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.center,
                              //             children: <Widget>[
                              //               Icon(
                              //                 FontAwesomeIcons.mapMarkerAlt,
                              //                 size: 12,
                              //                 color: Theme.of(context)
                              //                     .primaryColor,
                              //               ),
                              //               Text(
                              //                 " ${widget.hotelData.dist.toStringAsFixed(1)} ",
                              //                 overflow: TextOverflow.ellipsis,
                              //                 style: TextStyles(context)
                              //                     .getDescriptionStyle()
                              //                     .copyWith(
                              //                       fontSize: 14,
                              //                     ),
                              //               ),
                              //               Expanded(
                              //                 child: Text(
                              //                   AppLocalizations(context)
                              //                       .of("km_to_city"),
                              //                   overflow:
                              //                       TextOverflow.ellipsis,
                              //                   style: TextStyles(context)
                              //                       .getDescriptionStyle()
                              //                       .copyWith(
                              //                         fontSize: 14,
                              //                       ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //           Helper.ratingStar(),
                              //         ],
                              //       ),
                              //       Expanded(
                              //         child: Padding(
                              //           padding:
                              //               const EdgeInsets.only(right: 8),
                              //           child: Column(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.end,
                              //             children: <Widget>[
                              //               Text(
                              //                 "\$${widget.hotelData.perNight}",
                              //                 textAlign: TextAlign.left,
                              //                 style: TextStyles(context)
                              //                     .getBoldStyle()
                              //                     .copyWith(fontSize: 22),
                              //               ),
                              //               Padding(
                              //                 padding: EdgeInsets.only(
                              //                     top: context
                              //                                 .read<
                              //                                     ThemeProvider>()
                              //                                 .languageType ==
                              //                             LanguageType.ar
                              //                         ? 2.0
                              //                         : 0.0),
                              //                 child: Text(
                              //                   AppLocalizations(context)
                              //                       .of("per_night"),
                              //                   style: TextStyles(context)
                              //                       .getDescriptionStyle()
                              //                       .copyWith(
                              //                         fontSize: 14,
                              //                       ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      onTap: () {
                        try {
                          widget.callback();
                        } catch (e) {}
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

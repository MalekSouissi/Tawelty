import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_motel/constants/helper.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/hotel_list_data.dart';
import 'package:new_motel/modules/hotel_booking/components/restaurant_carousel.dart';
import 'package:new_motel/widgets/common_card.dart';

class CityNameView extends StatelessWidget {
  final VoidCallback callback;
  final String hotelData;

  const CityNameView(
      {Key? key, required this.hotelData, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 8, top: 8, bottom: 16),
      child: CommonCard(
        color: AppTheme.scaffoldBackgroundColor,
        radius: 16,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  hotelData,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style:
                  TextStyles(context).getBoldStyle().copyWith(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor:
                Theme.of(context).primaryColor.withOpacity(0.1),
                onTap: () {
                  callback();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

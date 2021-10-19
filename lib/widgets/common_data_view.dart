import 'package:flutter/material.dart';
import 'package:new_motel/constants/text_styles.dart';

class DataView extends StatelessWidget {
  final String? roomdata;

  final String? peopledata;

  const DataView({
    Key? key,
    this.roomdata,
    this.peopledata,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            roomdata!,
            // "${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}",
            style: TextStyles(context).getRegularStyle(),
          ),
          Text("Room"),
          Text("-"),
          Text(
            peopledata!,
            // "${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}",
            style: TextStyles(context).getRegularStyle(),
          ),
          Text("People"),
        ],
      ),
    );
  }
}

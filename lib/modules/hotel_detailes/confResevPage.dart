import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:new_motel/constants/text_styles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/language/appLocalizations.dart';
import 'package:new_motel/models/bookWaitSeat.dart';
import 'package:new_motel/models/table.dart';
import 'package:new_motel/widgets/common_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'download.dart';

class ConfirmPage extends StatefulWidget {
  final List<BookWaitSeat> bookWaitSeat;
  final List<String> demandeSpecial;
  final DateTime startTime;
  final DateTime endTime;
  final String guestName;
  final List<RestaurantTable> Tables;
  final int user;
  final int guestNumber;
  final String restaurantName;

  ConfirmPage(
      {required this.bookWaitSeat,
      required this.startTime,
      required this.endTime,
      required this.guestName,
      required this.demandeSpecial,
      required this.user,
      required this.guestNumber,
      required this.restaurantName,
      required this.Tables});
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _isLoading = false;
  late String randomValue;
  BookWaitSeat bookwaitseat = BookWaitSeat();
  @override
  void initState() {
    // TODO: implement initState
    for (int i = 0; i < widget.bookWaitSeat.length; i++) {
      print(widget.bookWaitSeat[i].id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          getAppBarUI(),
          Padding(
            padding: EdgeInsets.only(top: 55),
            child: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text(DateTime.now().day.toString()+'-'+DateTime.now().month.toString()+'-'+DateTime.now().year.toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: KBeige),),
                  Text(
                    'Table number  ' + widget.Tables[0].id.toString(),
                    style: TextStyles(context).getTitleStyle(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.guestName,
                    style: TextStyles(context).getTitle2Style(),                  ),
                  Text(widget.guestNumber.toString() + ' guests',style: TextStyles(context).getBoldStyle(),),

                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    DateFormat.yMMMd().format(widget.startTime),
                    style: TextStyles(context).getTitle2Style(),
                  ),
                  Text(
                    DateFormat.jm().format(widget.startTime),
                    style: TextStyles(context).getBoldStyle(),                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: QrImage(
                      foregroundColor: AppTheme.primaryColor,
                      data: widget.guestName +
                          'reservation date :' +
                          widget.bookWaitSeat[0].debut.toString(),
                      version: QrVersions.auto,
                      size: 175,
                      gapless: false,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  CommonButton(
                    padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                    buttonText:
                        AppLocalizations(context).of("confirm_reservation"),
                    onTap: () {
                      _buildListBWStoDB();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FileDownload(
                                    random: randomValue,
                                    platform: TargetPlatform.android,
                                  )));
                      print('taped');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _addBWS() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   final List<BookWaitSeat> item =[
  //     BookWaitSeat(
  //     restaurantId: widget.bookWaitSeat[0].restaurantId,
  //     id: widget.bookWaitSeat[0].id,
  //     // ids: widget.bookWaitSeat.ids,
  //     debut: widget.startTime,
  //     fin: widget.endTime,
  //     confResv: '0',
  //     cancResv: '0',
  //     guestName: widget.guestName,
  //   )];
  //   final result = await bwsService.addBWS(item);
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
  Widget getAppBarUI() {
    // return Container(
    //   decoration: BoxDecoration(
    //     color: AppTheme.scaffoldBackgroundColor,
    //     boxShadow: <BoxShadow>[
    //       BoxShadow(
    //           color: Theme.of(context).dividerColor,
    //           offset: Offset(0, 2),
    //           blurRadius: 8.0),
    //     ],
    //   ),
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          right: 16,
          bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          //   Container(
          // alignment: Alignment.centerLeft,
          // width: AppBar().preferredSize.height,
          // height: AppBar().preferredSize.height,
          // child:
          Material(
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
          //   ),
          Expanded(
            child: Center(
              child: Text(
                widget.restaurantName,
                style: TextStyles(context).getTitleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          //   Container(
          //     width: AppBar().preferredSize.height,
          //     height: AppBar().preferredSize.height,
          //     child:
          //   )
        ],
      ),
    );
    // );
  }

  _buildListBWStoDB() async {
    Random random = Random();
    randomValue = random.nextInt(10000).toString();
    print(randomValue);
    final List<BookWaitSeat> item = [];
    for (int i = 0; i < widget.bookWaitSeat.length; i++) {
      item.add(BookWaitSeat(
          userId: widget.user,
          restaurantId: widget.bookWaitSeat[i].restaurantId,
          id: widget.bookWaitSeat[i].id,
          // ids: widget.bookWaitSeat.ids,
          debut: widget.startTime,
          fin: widget.endTime,
          confResv: '0',
          cancResv: '0',
          guestName: widget.guestName,
          random: randomValue,
          //  other: widget.demandeSpecial.toString(),
          ids: 1,
          etat: 1,
          updatedAt: widget.startTime,
          createdAt: widget.endTime));
    }

    final result = await bookwaitseat.addBWS(item);
    //print(jsonDecode(result));
  }
}

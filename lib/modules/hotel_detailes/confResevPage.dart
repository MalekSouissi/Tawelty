import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:new_motel/models/bookWaitSeat.dart';
import 'package:new_motel/models/table.dart';
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

  ConfirmPage(
      {required this.bookWaitSeat,
      required this.startTime,
      required this.endTime,
      required this.guestName,
      required this.demandeSpecial,
      required this.user,
      required this.guestNumber,
      required this.Tables});
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _isLoading = false;
  late String randomValue;
  BookWaitSeat bookwaitseat= BookWaitSeat();
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
      body: Padding(
        padding: EdgeInsets.only(top: 55),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text(DateTime.now().day.toString()+'-'+DateTime.now().month.toString()+'-'+DateTime.now().year.toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: KBeige),),
              Text(
                'Table number  ' + widget.Tables[0].id.toString(),
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF1C3956),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.guestName,
                style: TextStyle(fontSize: 20),
              ),
              Text(widget.guestNumber.toString() + ' guests'),

              SizedBox(
                height: 10,
              ),
              Text(
                DateFormat.yMMMd().format(widget.startTime),
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFAF8F61),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat.jm().format(widget.startTime),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: QrImage(
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFFAF8F61).withOpacity(0.8),
                  child: TextButton(
                      onPressed: () {
                        _buildListBWStoDB();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FileDownload(
                                      random: randomValue, platform: TargetPlatform.android,
                                    )));
                        print('taped');
                      },
                      child: Text(
                        'confirm reservation',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
              ),
            ],
          ),
        ),
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
        other: widget.demandeSpecial.toString(), ids: 1, etat: 1, updatedAt: widget.startTime, createdAt: widget.endTime
      ));
    }

    final result = await bookwaitseat.addBWS(item);
    print(jsonDecode(result));
  }
}

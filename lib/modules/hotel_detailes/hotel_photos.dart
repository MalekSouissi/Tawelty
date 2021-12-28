import 'package:flutter/material.dart';
import 'package:new_motel/constants/localfiles.dart';
import 'package:new_motel/constants/themes.dart';
import 'package:new_motel/models/restaurant_files.dart';
import 'package:new_motel/modules/hotel_booking/components/restaurant_carousel.dart';
import 'package:new_motel/widgets/common_card.dart';

class HotelPhotosList extends StatefulWidget {
  final String restaurantId;
  HotelPhotosList({required this.restaurantId});
  @override
  _HotelPhotosListState createState() => _HotelPhotosListState();
}

class _HotelPhotosListState extends State<HotelPhotosList> {
  List<String> photosList = [
    Localfiles.hotel_room_1,
    Localfiles.hotel_room_2,
    Localfiles.hotel_room_3,
    Localfiles.hotel_room_4,
    Localfiles.hotel_room_5,
    Localfiles.hotel_room_6,
    Localfiles.hotel_room_7,
  ];

  List restaurantFiles=[];

  List fileList = [];
  bool showAddress=false;


  _fetchRestaurantFiles()async{
    setState(() {
      showAddress = true;
    });
    fileList= await File().fetchRestaurantFiles(widget.restaurantId);
    for(int i=0;i<fileList.length;i++){
      restaurantFiles.add(fileList[i].url);
      print(restaurantFiles[i].toString());
    }
    setState(() {
      showAddress = true;
    });
  }

@override
  void initState() {
    // TODO: implement initState
  _fetchRestaurantFiles();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 0, bottom: 8, right: 16, left: 16),
        itemCount: showAddress?restaurantFiles.length:photosList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonCard(
              color: AppTheme.backgroundColor,
              radius: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    showAddress?restaurantFiles[index]:photosList[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:new_motel/constants/localfiles.dart';
import 'package:new_motel/models/restaurant_files.dart';

class ProfileCarousel extends StatefulWidget {
  final String restaurantId;
  ProfileCarousel({this.restaurantId=''});
  @override
  _ProfileCarouselState createState() => _ProfileCarouselState();
}

class _ProfileCarouselState extends State<ProfileCarousel> {
  bool _isLoading = false;

  int _currentIndex=0;

  List<Item1> restaurantFiles=[];
  List cardList=[
    Item1(),
    Item1(),
    Item1(),
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  List<File> fileList = [];
  bool showAddress=false;

  _fetchRestaurantFiles()async{
    setState(() {
      showAddress = true;
    });
    fileList= await File().fetchRestaurantFiles(widget.restaurantId);
    for(int i=0;i<fileList.length;i++){
      restaurantFiles.add(Item1(url: fileList[1].url,));
      print(restaurantFiles[1].toString());
    }
    setState(() {
      showAddress = true;
    });
  }

  @override
  void initState() {
    _fetchRestaurantFiles();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(

        child: SizedBox(
          height: 200,
          width: 100,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: false,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: restaurantFiles.map((card){
              return Builder(
                  builder:(BuildContext context){
                    return Container(
                      // height: MediaQuery.of(context).size.height*0.40,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: card,
                      ),
                    );
                  }
              );
            }).toList(),
          ),
        )
    );
  }

}
class Item1 extends StatelessWidget {
  final String url;
  const Item1({this.url=''});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(url),
    );
  }
}

class ProfilePicture extends StatefulWidget {
  final String restaurantId;
  ProfilePicture({this.restaurantId=''});
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  List<File> fileList = [];
  List<Item1> restaurantFiles=[];

  bool showAddress=false;

  _fetchRestaurantFiles()async{
    setState(() {
      showAddress = true;
    });
    fileList= await File().fetchRestaurantFiles(widget.restaurantId);
    for(int i=0;i<fileList.length;i++){
      restaurantFiles.add(Item1(url: fileList[i].url,));
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
      width: 150,
      child: AspectRatio(
          aspectRatio: 2,
          child:showAddress&&restaurantFiles.isNotEmpty?Image.network(restaurantFiles.first.url,fit: BoxFit.cover,):Image.asset(Localfiles.restau_4,fit: BoxFit.cover,)
      ),
    );
  }
}

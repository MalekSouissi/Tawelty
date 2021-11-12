import 'dart:convert';

import 'package:new_motel/constants/localfiles.dart';
import 'package:new_motel/models/room_data.dart';
import 'package:http/http.dart' as http;

class RestaurantListData {
  String id;
  String imagePath;
  String titleTxt;
  String subTxt;
  DateText? date;
  String dateTxt;
  String roomSizeTxt;
  RoomData? roomData;
  double dist;
  double rating;
  int reviews;
  int perNight;
  bool isSelected;
  PeopleSleeps? peopleSleeps;

  RestaurantListData({
    this.id='',
    this.imagePath = Localfiles.hotel_1,
    this.titleTxt = '',
    this.subTxt = "adresse",
    this.dateTxt = "",
    this.roomSizeTxt = "",
    this.roomData,
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perNight = 180,
    this.isSelected = false,
    this.date,
    this.peopleSleeps,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     //"id":id,
  //     "NomResto": titleTxt,
  //     "description":subTxt,
  //     "adresse":adresse,
  //     "UserId":userId,
  //   };
  // }

  factory RestaurantListData.fromJson(Map<String, dynamic> item) {
    return RestaurantListData(
      imagePath: Localfiles.hotel_1,
      titleTxt: item['NomResto'],
      subTxt: 'adresse',
      dist: 2.0,
      reviews: 80,
      rating: 4.4,
      perNight: 180,
      roomData: RoomData(1, 2),
      isSelected: true,
      date: DateText(1, 5),
      id: item['id'].toString(),
      // description: item['Description'],
      // userId: item['UserId'],
      // //etat: item['etat'],
      // //cuisine: item['cuisine'],
      // temps_ouverture: DateTime.parse(item['temps_ouverture']),
      // temps_fermeture: DateTime.parse(item['temps_fermeture']),
      // createdAt: DateTime.parse(item['createdAt']),
      // updatedAt:
      // item['updatedAt'] != null ? DateTime.parse(item['updatedAt']) : DateTime.parse(item['updatedAt']),
    );
  }



  static const API = 'http://37.187.198.241:3000/';
  static List<RestaurantListData> hotelList=[];
  List finalList=[];

  fetchRestaurants() async {
    final response = await http.get(
    Uri.parse(API + 'restaurants'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final jsonData = json.decode(response.body);
      final floors = <RestaurantListData>[];
      for (var item in jsonData) {
        floors.add(RestaurantListData.fromJson(item));
      }
          print(floors);
      return floors;
      //return RestaurantListData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static List<RestaurantListData> popularList = [
    RestaurantListData(
      imagePath: Localfiles.popular_1,
      titleTxt: 'Paris',
    ),
    RestaurantListData(
      imagePath: Localfiles.popular_2,
      titleTxt: 'Spain',
    ),
    RestaurantListData(
      imagePath: Localfiles.popular_3,
      titleTxt: 'Vernazza',
    ),
    RestaurantListData(
      imagePath: Localfiles.popular_4,
      titleTxt: 'London',
    ),
    RestaurantListData(
      imagePath: Localfiles.popular_5,
      titleTxt: 'Venice',
    ),
    RestaurantListData(
      imagePath: Localfiles.popular_6,
      titleTxt: 'Diamond Head',
    ),
  ];

  static List<RestaurantListData> reviewsList = [
    RestaurantListData(
      imagePath: Localfiles.avatar1,
      titleTxt: 'Alexia Jane',
      subTxt:
          'This is located in a great spot close to shops and bars, very quiet location',
      rating: 8.0,
      dateTxt: '21 May, 2019',
    ),
    RestaurantListData(
      imagePath: Localfiles.avatar3,
      titleTxt: 'Jacky Depp',
      subTxt:
          'Good staff, very comfortable bed, very quiet location, place could do with an update',
      rating: 8.0,
      dateTxt: '21 May, 2019',
    ),
    RestaurantListData(
      imagePath: Localfiles.avatar5,
      titleTxt: 'Alex Carl',
      subTxt:
          'This is located in a great spot close to shops and bars, very quiet location',
      rating: 6.0,
      dateTxt: '21 May, 2019',
    ),
    RestaurantListData(
      imagePath: Localfiles.avatar2,
      titleTxt: 'May June',
      subTxt:
          'Good staff, very comfortable bed, very quiet location, place could do with an update',
      rating: 9.0,
      dateTxt: '21 May, 2019',
    ),
    RestaurantListData(
      imagePath: Localfiles.avatar4,
      titleTxt: 'Lesley Rivas',
      subTxt:
          'This is located in a great spot close to shops and bars, very quiet location',
      rating: 8.0,
      dateTxt: '21 May, 2019',
    ),
    RestaurantListData(
      imagePath: Localfiles.avatar6,
      titleTxt: 'Carlos Lasmar',
      subTxt:
          'Good staff, very comfortable bed, very quiet location, place could do with an update',
      rating: 7.0,
      dateTxt: '21 May, 2019',
    ),
    RestaurantListData(
      imagePath: Localfiles.avatar7,
      titleTxt: 'Oliver Smith',
      subTxt:
          'This is located in a great spot close to shops and bars, very quiet location',
      rating: 9.0,
      dateTxt: '21 May, 2019',
    ),
  ];

  static List<RestaurantListData> romeList = [
    RestaurantListData(
      imagePath:
          'assets/images/room_1.jpg assets/images/room_2.jpg assets/images/room_3.jpg',
      titleTxt: 'Deluxe Room',
      perNight: 180,
      dateTxt: 'Sleeps 3 people',
      roomData: RoomData(2, 2)
    ),
    RestaurantListData(
      imagePath:
          'assets/images/room_4.jpg assets/images/room_5.jpg assets/images/room_6.jpg',
      titleTxt: 'Premium Room',
      perNight: 200,
      dateTxt: 'Sleeps 3 people + 2 children',
       roomData: RoomData(3, 2)
    ),
    RestaurantListData(
      imagePath:
          'assets/images/room_7.jpg assets/images/room_8.jpg assets/images/room_9.jpg',
      titleTxt: 'Queen Room',
      perNight: 240,
      dateTxt: 'Sleeps 4 people + 4 children',
       roomData: RoomData(4, 4)

    ),
    RestaurantListData(
      imagePath:
          'assets/images/room_10.jpg assets/images/room_11.jpg assets/images/room_12.jpg',
      titleTxt: 'King Room',
      perNight: 240,
      dateTxt: 'Sleeps 4 people + 4 children',
       roomData: RoomData(4, 4)

    ),
    RestaurantListData(
      imagePath:
          'assets/images/room_11.jpg assets/images/room_1.jpg assets/images/room_2.jpg',
      titleTxt: 'Hollywood Twin\nRoom',
      perNight: 260,
      dateTxt: 'Sleeps 4 people + 4 children',
       roomData: RoomData(4, 4)

    ),
  ];

  static List<RestaurantListData> hotelTypeList = [
    RestaurantListData(
      imagePath: Localfiles.hotel_Type_1,
      titleTxt: 'hotel_data',
      isSelected: false,
    ),
    RestaurantListData(
      imagePath: Localfiles.hotel_Type_2,
      titleTxt: 'Backpacker_data',
      isSelected: false,
    ),
    RestaurantListData(
      imagePath: Localfiles.hotel_Type_3,
      titleTxt: 'Resort_data',
      isSelected: false,
    ),
    // RestaurantListData(
    //   imagePath: Localfiles.hotel_Type_4,
    //   titleTxt: 'villa_data',
    //   isSelected: false,
    // ),
    RestaurantListData(
      imagePath: Localfiles.hotel_Type_5,
      titleTxt: 'apartment',
      isSelected: false,
    ),
    RestaurantListData(
      imagePath: Localfiles.hotel_Type_6,
      titleTxt: 'guest_house',
      isSelected: false,
    ),
    // RestaurantListData(
    //   imagePath: Localfiles.hotel_Type_7,
    //   titleTxt: 'motel',
    //   isSelected: false,
    // ),
    // RestaurantListData(
    //   imagePath: Localfiles.hotel_Type_8,
    //   titleTxt: 'accommodation',
    //   isSelected: false,
    // ),
    // RestaurantListData(
    //   imagePath: Localfiles.hotel_Type_9,
    //   titleTxt: 'Bed_breakfast',
    //   isSelected: false,
    // ),
  ];
  static List<RestaurantListData> lastsSearchesList = [
    RestaurantListData(
      imagePath: Localfiles.popular_4,
      titleTxt: 'London',
      roomData: RoomData(1, 3),
      date: DateText(12, 22),
      dateTxt: '12 - 22 Dec',
    ),
    RestaurantListData(
      imagePath: Localfiles.popular_1,
      titleTxt: 'Paris',
      roomData: RoomData(1, 3),
      date: DateText(12, 24),
      dateTxt: '12 - 24 Sep',
    ),
    RestaurantListData(
      imagePath: Localfiles.city_3,
      titleTxt: 'New York',
      roomData: RoomData(1, 3),
      date: DateText(20, 22),
      dateTxt: '20 - 22 Sep',
    ),
    RestaurantListData(
      imagePath: Localfiles.city_4,
      titleTxt: 'Tokyo',
      roomData: RoomData(12, 22),
      date: DateText(12, 22),
      dateTxt: '12 - 22 Nov',
    ),
    RestaurantListData(
      imagePath: Localfiles.city_5,
      titleTxt: 'Shanghai',
      roomData: RoomData(10, 15),
      date: DateText(10, 15),
      dateTxt: '10 - 15 Dec',
    ),
    RestaurantListData(
      imagePath: Localfiles.city_6,
      titleTxt: 'Moscow',
      roomData: RoomData(12, 14),
      date: DateText(12, 14),
      dateTxt: '12 - 14 Dec',
    ),
  ];
}

import 'dart:convert';

import 'package:http/http.dart' as http;


class PopularFilterListData {
  String titleTxt;
  bool isSelected;

  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  static List<PopularFilterListData> popularFList = [
    PopularFilterListData(
      titleTxt: 'free_breakfast',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Parking',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'alcohol_text',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'karaoke_text',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'TPE_text',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'pet_friendlly',
      isSelected: false,
    ),
    // PopularFilterListData(
    //   titleTxt: 'reservation_text',
    //   isSelected: false,
    // ),
    PopularFilterListData(
      titleTxt: 'shisha_text',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Free_Wifi',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> cuisineFList = [
    PopularFilterListData(
      titleTxt: 'tunisienne',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'italienne',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'française',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'asiatique',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'mexicaine',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'europeene',
      isSelected: false,
    ),
    // PopularFilterListData(
    //   titleTxt: 'reservation_text',
    //   isSelected: false,
    // ),
    PopularFilterListData(
      titleTxt: 'fruit de mer',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'steak',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> ambianceFList = [
    PopularFilterListData(
      titleTxt: 'Festive_text',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Familiale_text',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'music_text',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Business_text',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> accomodationList = [
    PopularFilterListData(
      titleTxt: 'all_text',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'apartment',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Backpacker_data',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'guest_house',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'hotel_data',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Resort_data',
      isSelected: false,
    ),
  ];
}

class FilterListData{
  String id;
  String type;
  String restaurantId;


  FilterListData(
      {
        this.id='',
        this.type='',
        this.restaurantId=''});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'RestaurantId':restaurantId,
    };
  }
  factory FilterListData.fromJson(Map<String, dynamic> item) {
    return FilterListData(
      id: item['id'].toString(),
      type: item['type']!=null?item['type']:'type',
      restaurantId: item['RestaurantId'].toString(),
    );
  }


  static const API = 'http://37.187.198.241:3000/';
  // static List<FilterListData> ambiances=[];
  // static List<FilterListData> generals=[];
  // static List<FilterListData> cuisines=[];
  // static List<FilterListData> types=[];

  fetchAmbiances() async {
    final response = await http.get(
        Uri.parse(API + 'ambiances'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final jsonData = json.decode(response.body);
      final floors = <FilterListData>[];
      for (var item in jsonData) {
        floors.add(FilterListData.fromJson(item));
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

  fetchCuisines() async {
    final response = await http.get(
        Uri.parse(API + 'cuisines'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final jsonData = json.decode(response.body);
      final floors = <FilterListData>[];
      for (var item in jsonData) {
        floors.add(FilterListData.fromJson(item));
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
  fetchGenerals() async {
    final response = await http.get(
        Uri.parse(API + 'generals'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final jsonData = json.decode(response.body);
      final floors = <FilterListData>[];
      for (var item in jsonData) {
        floors.add(FilterListData.fromJson(item));
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
  fetchtypes() async {
    final response = await http.get(
        Uri.parse(API + 'etablissements'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final jsonData = json.decode(response.body);
      final floors = <FilterListData>[];
      for (var item in jsonData) {
        floors.add(FilterListData.fromJson(item));
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
}

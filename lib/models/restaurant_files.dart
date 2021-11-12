import 'dart:convert';

import 'package:http/http.dart' as http;

class File {
  String id;
  String restaurantId;
  String fileName;
  String url;

  File(
      {
        this.id='',
        this.restaurantId='',
        this.fileName='',
        this.url='',
      });
  Map<String, dynamic> toJson() {
    return {
      'filename': fileName,
      'RestaurantId':restaurantId,
      'url':url,
    };
  }
  factory File.fromJson(Map<String, dynamic> item) {
    return File(
      id: item['id'].toString(),
      fileName: item['filename'],
      url: item['url'],
      restaurantId: item['RestaurantId'].toString(),

    );
  }

  static const API = 'http://37.187.198.241:3000/';


  fetchRestaurantFiles(String id) async {
    final response = await http.get(
        Uri.parse(API + 'file/info/'+id));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final jsonData = json.decode(response.body);
      final floors = <File>[];
      for (var item in jsonData) {
        floors.add(File.fromJson(item));
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
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:new_motel/models/avis.dart';
import 'package:new_motel/models/favorite.dart';

class FavoriteServices{
  Client client = Client();

  static const API = 'http://37.187.198.241:3000/';


  Future getListFavorites() {
    return client
        .get(
      Uri.parse(API + 'favorites'),
    )
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final events = <Favorite>[];
        for (var item in jsonData) {
          events.add(Favorite.fromJson(item));
        }
        print(jsonData);
        return events.toList();
      }
      return 'An error occured1';
    }).catchError((_) => 'An error occured2');
  }
  // Future getRestaurantsListAvis(
  //     String restaurantId) {
  //   return client
  //       .get(
  //     Uri.parse(API + 'restaurants/avis/' + restaurantId),
  //   )
  //       .then((data) {
  //     if (data.statusCode == 200) {
  //       final jsonData = json.decode(data.body);
  //       final events = <Avis>[];
  //       for (var item in jsonData) {
  //         events.add(Avis.fromJson(item));
  //       }
  //       return events;
  //     }
  //     return  'An error occured';
  //   }).catchError((_) => 'An error occured');
  // }
  //
  Future addFavorite(Favorite item) {
    return client
        .post(Uri.parse(API + 'favorite/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return  data.body;
      }
      return  data.body;
    }).catchError((_) =>
    'An error occured2');
  }
  //
  // Future updateAvis(String ID, Avis item) {
  //   return client.put(Uri.parse(API + 'avis/' + ID),  headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   }, body: jsonEncode(item.toJson())).then((data) {
  //     if (data.statusCode == 204) {
  //       return true;
  //     }
  //     return 'An error occured';
  //   })
  //       .catchError((_) =>'An error occured');
  // }
  //
  Future deleteFavorite(String ID) {
    return client.delete(Uri.parse(API + 'favorite/' + ID), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'}).then((data) {
      if (data.statusCode == 204) {
        return  true;
      }
      return 'An error occured';
    })
        .catchError((_) => 'An error occured');
  }
}
// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
// import 'package:new_motel/api/api_Response.dart';
// import 'package:new_motel/models/hotel_list_data.dart';
//
//
// class RestaurantServices{
//
//   static const API = 'http://37.187.198.241:3000/';
//
//   Future<APIResponse<List<RestaurantListData>>> getRestaurantsList() {
//     return http
//         .get(
//       Uri.parse(API + 'restaurants'),
//     )
//         .then((data) {
//       if (data.statusCode == 200) {
//         final jsonData = json.decode(data.body);
//         final floors = <RestaurantListData>[];
//         for (var item in jsonData) {
//           floors.add(RestaurantListData.fromJson(item));
//         }
//         return APIResponse<List<RestaurantListData>>(data: floors);
//       }
//       return APIResponse<List<RestaurantListData>>(
//           error: true, errorMessage: 'An error occured');
//     }).catchError((_) => APIResponse<List<RestaurantListData>>(
//         error: true, errorMessage: 'An error occured'));
//   }
//
//   // Future<APIResponse<List<Event>>> getRestaurantsListEvents(String restaurantId) {
//   //   return http
//   //       .get(
//   //     Uri.parse(API + 'restaurants/evenement/'+ restaurantId),
//   //   )
//   //       .then((data) {
//   //     if (data.statusCode == 200) {
//   //       final jsonData = json.decode(data.body);
//   //       final events = <Event>[];
//   //       for (var item in jsonData) {
//   //         events.add(Event.fromJson(item));
//   //       }
//   //       return APIResponse<List<Event>>(data: events);
//   //     }
//   //     return APIResponse<List<Event>>(
//   //         error: true, errorMessage: 'An error occured');
//   //   }).catchError((_) => APIResponse<List<Event>>(
//   //       error: true, errorMessage: 'An error occured'));
//   // }
//
//   // Future<APIResponse<bool>> createRestaurant(RestaurantListData item) {
//   //   return http
//   //       .post(Uri.parse(API + 'restaurant/AddRestaurant'),
//   //       headers: <String, String>{
//   //         'Content-Type': 'application/json; charset=UTF-8',
//   //       },
//   //       body: jsonEncode(item.toJson()))
//   //       .then((data) {
//   //     if (data.statusCode == 201) {
//   //       return APIResponse<bool>(data: true);
//   //     }
//   //     return APIResponse<bool>(error: true, errorMessage: 'An error occured');
//   //   }).catchError((_) =>
//   //       APIResponse<bool>(error: true, errorMessage: 'An error occured'));
//   // }
//
//   Future<APIResponse<RestaurantListData>> getRestaurant(String restaurantId) {
//     return http
//         .get(
//       Uri.parse(API + 'restaurants/' + restaurantId),
//     )
//         .then((data) {
//       if (data.statusCode == 200) {
//         final jsonData = json.decode(data.body);
//         return APIResponse<RestaurantListData>(data: RestaurantListData.fromJson(jsonData));
//       }
//       return APIResponse<RestaurantListData>(error: true, errorMessage: 'An error occured');
//     }).catchError((_) =>
//         APIResponse<RestaurantListData>(error: true, errorMessage: 'An error occured'));
//   }
//
//
//   Future<APIResponse<RestaurantListData>> getRestaurantcuisine(String restaurantId) {
//
//     return http
//         .get(
//       Uri.parse(API + 'restaurants/cuisine' + restaurantId),
//     )
//         .then((data) {
//       if (data.statusCode == 200) {
//         final jsonData = json.decode(data.body);
//       return APIResponse<RestaurantListData>(data: RestaurantListData.fromJson(jsonData));
//       }
//       return APIResponse<RestaurantListData>(error: true, errorMessage: 'An error occured');
//     }).catchError((_) =>
//         APIResponse<RestaurantListData>(error: true, errorMessage: 'An error occured'));
//   }
//
//   Future<APIResponse<bool>> updateRestaurant(String restoID, RestaurantListData item) {
//     return http.put(Uri.parse(API + 'restaurant/UpdateRestaurant/' + restoID),  headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     }, body: jsonEncode(item)).then((data) {
//       if (data.statusCode == 204) {
//         return APIResponse<bool>(data: true);
//       }
//       return APIResponse<bool>(error: true, errorMessage: 'An error occured');
//     })
//         .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
//   }
//
//   Future<APIResponse<bool>> deleteRestaurant(String restaurantID) {
//     return http.delete(Uri.parse(API + 'restaurants/' + restaurantID), headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8'}).then((data) {
//       if (data.statusCode == 204) {
//         return APIResponse<bool>(data: true);
//       }
//       return APIResponse<bool>(error: true, errorMessage: 'An error occured');
//     })
//         .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
//   }
//
// }

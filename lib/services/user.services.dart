import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_motel/models/user.dart';

class UserServices {
  static const API = 'http://192.168.1.6:3000/';

  Future getUserProfile(String userId) {
    return http
        .get(
      Uri.parse(API + 'users/' + userId),
    )
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        print(jsonData);
        return User.fromJson(jsonData);
      }
      return data.body;
    }).catchError((_) =>
        'An error occured');
  }
  //
  // Future getUserRestauarnt(String userId) {
  //   return http
  //       .get(
  //     Uri.parse(API + 'restaurants/' + userId),
  //   )
  //       .then((data) {
  //     if (data.statusCode == 200) {
  //       final jsonData = json.decode(data.body);
  //       return Restaurant.fromJson(jsonData));
  //     }
  //     return APIResponse<Restaurant>(
  //         error: true, errorMessage: 'An error occured');
  //   }).catchError((_) => APIResponse<Restaurant>(
  //       error: true, errorMessage: 'An error occured'));
  // }
  //
  // Future<APIResponse<BookWaitSeat>> getUserBWS(String userId) {
  //   return http
  //       .get(
  //     Uri.parse(API + 'users/BWS/' + userId),
  //   )
  //       .then((data) {
  //     if (data.statusCode == 200) {
  //       final jsonData = json.decode(data.body);
  //       return APIResponse<BookWaitSeat>(data: BookWaitSeat.fromJson(jsonData));
  //     }
  //     return APIResponse<BookWaitSeat>(
  //         error: true, errorMessage: 'An error occured');
  //   }).catchError((_) => APIResponse<BookWaitSeat>(
  //       error: true, errorMessage: 'An error occured'));
  // }

  Future updateUser(String userID, User item) {
    return http
        .put(Uri.parse(API + 'users/update/' + userID),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(item.toJson()))
        .then((data) {
      if (data.statusCode == 204) {
        return true;
      }
      return 'An error occured';
    }).catchError((_) =>
        'An error occured');
  }

// getProfile(apiUrl,token) async{
//   return await http.get(
//     Uri.parse(API+apiUrl),
//     // Send authorization headers to the backend.
//     headers: {
//       HttpHeaders.authorizationHeader:token,
//     },
//   );
// }
}

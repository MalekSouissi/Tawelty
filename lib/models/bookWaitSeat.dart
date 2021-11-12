
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;

class BookWaitSeat {
  int id;
  int ids;
  String guestName;
  String confResv;
  String cancResv;
  int restaurantId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? debut;
  DateTime? fin;
  int etat;
  int userId;
  String random;
  String other;

  BookWaitSeat(
      {this.id = 0,
      this.etat = 1,
      this.cancResv = '',
      this.confResv = '',
      this.debut,
      this.fin,
      this.ids = 1,
      this.guestName = '',
      this.restaurantId = 1,
      this.createdAt,
      this.other = '',
      this.userId = 1,
      this.random = '',
      this.updatedAt});

  Client client = Client();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ids': ids,
      'confResv': confResv,
      'cancResv': cancResv,
      'etat': etat,
      'debut': debut!.toIso8601String(),
      'fin': fin!.toIso8601String(),
      'RestaurantId': restaurantId,
      'guestName': guestName,
      'UserId': userId,
      'random': random,
      'other': other,
    };
  }

  factory BookWaitSeat.fromJson(Map<String, dynamic> item) {
    return BookWaitSeat(
      id: item['id'],
      ids: item['ids'],
      confResv: item['confResv'],
      etat: item['etat'],
      userId: item['UserId'],
      guestName: item['guestName'],
      restaurantId: item['RestaurantId'],
      debut: DateTime.parse(item['debut']),
      fin: DateTime.parse(item['fin']),
      createdAt: DateTime.parse(item['createdAt']),
      random: item['random'],
      other: item['other'],
      updatedAt: item['updatedAt'] != null
          ? DateTime.parse(item['updatedAt'])
          : DateTime.parse(item['updatedAt']),
      cancResv: '',
    );
  }

  static const API = 'http://37.187.198.241:3000/';
  static List<BookWaitSeat> hotelList = [];
  List finalList = [];

  fetchUserList(String userId) async {
    final response = await http.get(Uri.parse(API + 'users/BWS/' + userId));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final jsonData = json.decode(response.body);
      final floors = <BookWaitSeat>[];
      for (var item in jsonData) {
        floors.add(BookWaitSeat.fromJson(item));
      }
      print(floors);
      return floors;
      //return RestaurantListData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load naarafch');
    }
  }

  fetchRestaurantList(int restaurantId) async {
    final response = await http
        .get(Uri.parse(API + 'BWS/GetALlBookWaitSeat/' + restaurantId.toString()));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final jsonData = json.decode(response.body);
      final floors = <BookWaitSeat>[];
      for (var item in jsonData) {
        floors.add(BookWaitSeat.fromJson(item));
      }
      print(floors);
      return floors;
      //return RestaurantListData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load naarafch 1');
    }
  }

  addBWS(List<BookWaitSeat> item) {
    return client
        .post(Uri.parse(API + 'BWS/CreateBookwaitseatTRUE'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(item.map((i) => i.toJson()).toList()))
        .then((data) {
      if (data.statusCode == 200) {
        return data.body;
      }
    });
  }

  printInvoicePDF(String id) async {
    final response =
        await client.get(Uri.parse('http://37.187.198.241:3000/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load naarafch 2');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;

class ObjReservation {
  int id;
  int ids;
  int guestNb;
  String restaurantId;
  DateTime? debut;
  DateTime? fin;
  int tableNbPx;
  String idReservation;

  ObjReservation({
    this.id = 0,
    this.debut,
    this.fin,
    this.ids = 1,
    this.restaurantId = '1',
    this.idReservation = '',
    this.tableNbPx = 0,
    this.guestNb = 0,
  });

  Client client = Client();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ids': ids,
      'startTime': debut!.toIso8601String(),
      'endTime': fin!.toIso8601String(),
      'RestaurantId': restaurantId,
      'guestnumber': guestNb,
      'tableNbrPx': tableNbPx,
      'id_reservation': idReservation,
    };
  }

  factory ObjReservation.fromJson(Map<String, dynamic> item) {
    return ObjReservation(
      id: item['id'],
      ids: item['ids'],
      tableNbPx: item['tableNbrPx'],
      restaurantId: item['RestaurantId'],
      //debut: DateTime.parse(item['debut']),
      idReservation: item['id_reservation'],
      //fin: DateTime.parse(item['fin']),
    );
  }
}

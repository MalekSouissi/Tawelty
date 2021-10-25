import 'dart:convert';
import 'dart:io';

//import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';


class CallApi {
  final String _url = 'http://37.187.198.241:3000/';
  Client client = Client();

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await client.post(Uri.parse(fullUrl),
        body:jsonEncode(data), headers: _setHeaders());
  }

  Future register(client, item) async {
    final response = await client.post(
        Uri.parse('http://37.187.198.241:3000/users/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(item.toJson()));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('exception occured!!!!!!');
    }
  }

  // Future googleoauth(client, item) async {
  //   final response = await client.post(
  //       Uri.parse('http://37.187.198.241/users/register'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8'
  //       },
  //       body: jsonEncode(item.toJson()));
  //
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('exception occured!!!!!!');
  //   }
  // }

  updateData(data, apiUrl, userId) async {
    var fullUrl = _url + apiUrl + userId;
    return await client.put(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

  // Future register(item) async {
  //   final response =
  //   await client.post(Uri.parse('http://10.0.2.2:3000/users/register'),headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8'},body: jsonEncode(item.toJson()));
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('exception occured!!!!!!');
  //   }
  // }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await client.get(Uri.parse(fullUrl), headers: _setHeaders());
  }

  Future getProfile(apiUrl, token) async {
    return await client.get(
      Uri.parse(_url + apiUrl),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Charset': 'utf-8',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  Future forgetPassword(String mail) async {
    // response = null;
    String body = '{"email" : "$mail"}';
    try {
      //requestState.makeStateBusy();
      final request = await client.post(
          Uri.parse("http://37.187.198.241:3000/forgetPassword" + "/$mail"),
          headers: _setHeaders(),
          body: body);
      if (request.statusCode == 201) {
        print(json.decode(request.body));
        return json.decode(request.body);
      } else {
        return json.decode(request.body);
      }
    } catch (e) {
      return "error";
    }
  }
}

import 'dart:convert';

import '../model/model.dart';
import 'package:http/http.dart' as http;

class UserService{
  final String url = "https://reqres.in/api/users?page=2";
  Future<Datum?> fetchUsers() async{
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonBody = Datum.fromJson(jsonDecode(response.body));
      return jsonBody;
      
      
    }else{
      print("failed => ${response.statusCode}");

    }
    return null;

  }
}
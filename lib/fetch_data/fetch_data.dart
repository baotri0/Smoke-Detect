import 'dart:convert';

import 'package:detect_smoke/firebase_helper/firebase_firestore.dart';
import 'package:http/http.dart' as http;

// Future<Log> fetchAlbum() async {
//   final response = await http
//       .get(Uri.parse('http://192.168.43.26/api/data'));
//
//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     Log _album = Log.fromJson(jsonDecode(response.body));
//     if(_album.value!>400){
//       FirebaseFirestoreHelper.instance.addLog(_album);
//     }
//     return Log.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }
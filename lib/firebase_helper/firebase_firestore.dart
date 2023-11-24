import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detect_smoke/model/warning_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../constaints/constants.dart';
import '../fetch_data/fetch_data.dart';
import '../model/log_model.dart';
import '../model/user_model.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Log>> getLog() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firebaseFirestore.collection("Logs").get();

      List<Log> warningList = querySnapshot.docs
          .map((e) => Log.fromJson1(e.data()))
          .toList();

      return warningList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }



  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
    await _firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return UserModel.fromJson(querySnapshot.data()!);
  }


  void updateTokenFromFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "notificationToken": token,
      });
    }
  }

  //Fetch Data
  // Future<Album> futureAlbum = fetchAlbum();
  // Album album = Album(userId: 22, id: 12, title: "title");
  Future<void> addLog(Log album) async {
    final CollectionReference collection = FirebaseFirestore.instance.collection('Logs');
    Map<String, dynamic> dataMap = {
      'value': album.mq2,
      'Area': album.Area,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await collection.add(dataMap);
  }

}


//Send Notification
Future<void> sendNotificationToAllUsers(List<String?> usersToken,String title, String body) async {
  List<String?> allUserToken = [];
  List<String?> newAllUserToken = [];
  for (var element in usersToken) {
    if(element!=null||element!=""){
      newAllUserToken.add(element);
    }
  }
  allUserToken = newAllUserToken;

  const String serverKey = 'AAAA3-Yu8cE:APA91bG465zT5MtQb9-GARxrRp91aBSFgJpqMaUo9Xjd1l0m8JjwSdBkWCpFw_cz52vFiPZ_yR7hl5ddbMFrS9nlfy7fqKbyh-6xIIS0ETNW_CCOMyTeDtVyOl-iHnhhOLOvHnhwitmY';
  const String firebaseUrl = 'https://fcm.googleapis.com/fcm/send';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final Map<String, dynamic> notification = {
    'title': title,
    'body': body,
  };

  final Map<String, dynamic> requestBody = {
    'notification': notification,
    'priority': 'high',
    'registration_ids': allUserToken,
    // 'registration_ids': [
    //   'dzoyRx2cR-eNYzdI_BoBRb:APA91bF6WKkOyrjEx63cha4d3xBkV0EEQNzm1fB7Q2F87w0tUxzLR6GVwRaVXr-V76zfvVvO6karZC4_IhorpKivSzWH9o7DbCH99MGR2ljE23_zUDbZW49ipFoCK4bRfJKaS7t5Mg3w',
    // ],
  };

  final String encodedBody = jsonEncode(requestBody);

  final http.Response response = await http.post(
    Uri.parse(firebaseUrl),
    headers: headers,
    body: encodedBody,
  );

  if (response.statusCode == 200) {
    print("Notification sent successfully.");
  } else {
    print("Notification sending failed with status: ${response.statusCode}.");
  }
}

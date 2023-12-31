// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detect_smoke/model/warning_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constaints/constants.dart';
import '../firebase_helper/firebase_firestore.dart';
import '../firebase_helper/firebase_storage.dart';
import '../model/log_model.dart';
import '../model/user_model.dart';

class AppProvider with ChangeNotifier {
  //// Cart Work
  UserModel? _userModel;
  late Log _log;
  late Log _log1;

  ////// USer Information
  void getUserInfoFirebase() async {
    _userModel = await FirebaseFirestoreHelper.instance.getUserInformation();
    notifyListeners();
  }


  void updateUserInfoFirebase(
      BuildContext context, UserModel userModel, File? file) async {
    if (file == null) {
      showLoaderDialog(context);

      _userModel = userModel;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    } else {
      showLoaderDialog(context);

      String imageUrl =
      await FirebaseStorageHelper.instance.uploadUserImage(file);
      _userModel = userModel.copyWith(image: imageUrl);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
    showMessage("Successfully updated profile");

    notifyListeners();
  }

  void playSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('warning.mp3'));
  }
  late Timer _timer1;

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget continueButton = TextButton(
      child: Text("Xác nhận"),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
        _timer1.cancel();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      icon: Icon(Icons.warning_outlined),
      title: Text("Cảnh báo"),
      content: Text("Có phát hiện khói thuốc"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Future<List<Log>> fetchLog() async {
    List<Log> dataList = [];

    List<String> serverUrls = [
      "http://192.168.43.100/api/data",
    ];

    for (String url in serverUrls) {
      final response = await http
          .get(Uri.parse(url));
      if (response.statusCode == 200) {
        Log data = Log.fromJson(jsonDecode(response.body));
        dataList.add(data);
      }else{
        print('Failed to load data from $url');
      }
    }
    return dataList;
  }

  UserModel get getUserInformation => _userModel!;
  Future<void> callBackFunc() async {}
}
